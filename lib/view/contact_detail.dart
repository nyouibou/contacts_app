// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controllers/auth_controller.dart';
import '../model/contact.dart';
import 'addeditpage.dart';

class OppoFixLauncher {
  static Future<void> launchCustomURL(Uri uri) async {
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        await _launchIntentFallback(uri);
      }
    } catch (e) {
      print('Error launching URL: $e');
      await _launchIntentFallback(uri);
    }
  }

  static Future<void> _launchIntentFallback(Uri uri) async {
    try {
      const platform = MethodChannel('com.example.app/launcher');
      await platform.invokeMethod('launchUrl', {'url': uri.toString()});
    } catch (e) {
      print('Intent fallback failed: $e');
    }
  }

  static Future<void> launchPhone(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);
    await launchCustomURL(uri);
  }

  static Future<void> launchSMS(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'sms', path: phoneNumber);
    await launchCustomURL(uri);
  }

  static Future<void> launchEmail(String email) async {
    final Uri uri = Uri(scheme: 'mailto', path: email);
    await launchCustomURL(uri);
  }

  static Future<void> launchSocialMedia(String url) async {
    final Uri uri = Uri.parse(url);
    await launchCustomURL(uri);
  }
}

class ContactDetailView extends StatefulWidget {
  final Contact contact;

  const ContactDetailView({Key? key, required this.contact}) : super(key: key);

  @override
  _ContactDetailViewState createState() => _ContactDetailViewState();
}

class _ContactDetailViewState extends State<ContactDetailView> {
  late Contact contact;
  final authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    contact = widget.contact;
  }

  Future<void> _saveCustomFieldsToFirebase() async {
    try {
      final customFields = contact.customFields;
      if (customFields != null) {
        await FirebaseFirestore.instance
            .collection('contacts')
            .doc(contact.id) // Ensure this ID matches the document ID in Firestore
            .update({'customFields': customFields});
        print('Custom fields saved to Firebase!');
      }
    } catch (e) {
      _showErrorDialog('Failed to save changes to Firebase: $e');
      print('Error updating Firebase: $e');
    }
  }

  Future<void> _deleteContact() async {
    final role = authController.userRole.value;

    try {
      if (role == 'admin') {
        await FirebaseFirestore.instance
            .collection('contacts')
            .doc(contact.id)
            .delete();
        Get.snackbar('Success', 'Contact deleted successfully!');
        Navigator.pop(context); // Go back to the previous screen
      } else if (role == 'user' && contact.ownerId == authController.firebaseUser.value!.uid) {
        await FirebaseFirestore.instance
            .collection('contacts')
            .doc(contact.id)
            .delete();
        Get.snackbar('Success', 'Contact deleted successfully!');
        Navigator.pop(context); // Go back to the previous screen
      } else {
        Get.snackbar('Permission Denied', 'You can only delete your own contacts.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete contact: $e');
    }
  }

  Future<void> _confirmDeleteContact() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Are you sure?'),
        content: Text('Do you really want to delete this contact?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm != null && confirm) {
      await _deleteContact();
    }
  }

  void _shareContact() {
    String customFields = contact.customFields?.entries
            .map((e) => '${e.key}: ${e.value}')
            .join('\n') ??
        'No custom fields';
    Share.share('Contact Information:\n'
        'Name: ${contact.name}\n'
        'Phone: ${contact.phone}\n'
        'Email: ${contact.email}\n'
        'Custom Fields:\n$customFields');
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact Details"),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: _shareContact,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _confirmDeleteContact, // Call confirmation before delete
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(
                'https://i.pinimg.com/736x/44/98/b6/4498b6ef6034c4402a35ebdb757c9df9.jpg', // Replace with contact image
              ),
            ),
            SizedBox(height: 16),
            Text(
              contact.name,
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: Icon(Icons.phone, color: Colors.green),
                title: Text(contact.phone),
                subtitle: Text('Mobile'),
                trailing: IconButton(
                  icon: Icon(Icons.message, color: Colors.blue),
                  onPressed: () => OppoFixLauncher.launchSMS(contact.phone),
                ),
                onTap: () => OppoFixLauncher.launchPhone(contact.phone),
              ),
            ),
            Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: Icon(Icons.email, color: Colors.red),
                title: Text(contact.email),
                subtitle: Text('Email'),
                onTap: () => OppoFixLauncher.launchEmail(contact.email),
              ),
            ),
            if (contact.whatsapp != null && contact.whatsapp!.isNotEmpty)
              Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: Icon(Icons.chat, color: Colors.green),
                  title: Text('WhatsApp: ${contact.whatsapp}'),
                  subtitle: Text('Chat with ${contact.name}'),
                  onTap: () => OppoFixLauncher.launchSocialMedia('https://wa.me/${contact.whatsapp}'),
                ),
              ),
            if (contact.facebook != null && contact.facebook!.isNotEmpty)
              Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: Icon(Icons.facebook, color: Colors.blue),
                  title: Text('Facebook: ${contact.facebook}'),
                  subtitle: Text('Visit Facebook profile'),
                  onTap: () => OppoFixLauncher.launchSocialMedia('${contact.facebook}'),
                ),
              ),
            if (contact.instagram != null && contact.instagram!.isNotEmpty)
              Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: Icon(Icons.camera_alt, color: Colors.pink),
                  title: Text('Instagram: ${contact.instagram}'),
                  subtitle: Text('Visit Instagram profile'),
                  onTap: () => OppoFixLauncher.launchSocialMedia('https://www.instagram.com/${contact.instagram}'),
                ),
              ),
            if (contact.youtube != null && contact.youtube!.isNotEmpty)
              Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: Icon(Icons.video_call, color: Colors.red),
                  title: Text('YouTube: ${contact.youtube}'),
                  subtitle: Text('Watch YouTube channel'),
                  onTap: () => OppoFixLauncher.launchSocialMedia('https://www.youtube.com/${contact.youtube}'),
                ),
              ),
            if (contact.customFields != null && contact.customFields!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Custom Fields",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    ReorderableListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      onReorder: (oldIndex, newIndex) async {
                        if (newIndex > oldIndex) newIndex -= 1;

                        final entries = contact.customFields!.entries.toList();
                        final movedItem = entries.removeAt(oldIndex);
                        entries.insert(newIndex, movedItem);

                        setState(() {
                          contact.customFields = Map.fromEntries(entries);
                        });

                        await _saveCustomFieldsToFirebase();
                      },
                      children: contact.customFields!.entries.map((entry) {
                        return Card(
                          key: ValueKey(entry.key),
                          elevation: 4,
                          margin: EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            title: Text(entry.key),
                            subtitle: Text(entry.value ?? 'No value'),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final updatedContact = await Navigator.push<Contact>(
            context,
            MaterialPageRoute(
              builder: (context) => AddEditContactPage(contact: contact),
            ),
          );

          if (updatedContact != null) {
            setState(() {
              contact = updatedContact;
            });
          }
        },
        child: Icon(Icons.edit),
      ),
    );
  }
}
