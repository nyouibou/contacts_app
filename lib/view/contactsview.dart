import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../controllers/contact_controller.dart';
import '../model/contact.dart';
import 'contact_detail.dart';
import 'dart:async';

class ContactsView extends StatefulWidget {
  @override
  _ContactsViewState createState() => _ContactsViewState();
}

class _ContactsViewState extends State<ContactsView> {
  final ContactController controller = Get.find<ContactController>();
  late Timer _timer;
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  final Map<String, double> _letterOffsets = {}; // Store offsets for each letter

  @override
  void initState() {
    super.initState();
    controller.fetchContacts();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      controller.fetchContacts();
    });

    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _timer.cancel();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      if (!_isLoading) {
        _isLoading = true;
        controller.loadMoreContacts();
      }
    }
  }

  void _scrollToLetter(String letter) {
    if (_letterOffsets.containsKey(letter)) {
      final offset = _letterOffsets[letter]!;
      _scrollController.animateTo(
        offset,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: (value) => controller.updateSearchQuery(value),
          decoration: InputDecoration(
            hintText: 'Search contacts...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Obx(() {
        var filteredContacts = controller.filteredContacts ?? [];

        if (filteredContacts.isEmpty) {
          return Center(
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                    ),
                    title: Container(
                      height: 10,
                      color: Colors.white,
                    ),
                    subtitle: Container(
                      height: 10,
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ),
          );
        }

        filteredContacts.sort((a, b) => a.name.compareTo(b.name));

        final Map<String, List<Contact>> grouped = {};
        for (var contact in filteredContacts) {
          final firstLetter = contact.name[0].toUpperCase();
          grouped.putIfAbsent(firstLetter, () => []).add(contact);
        }

        controller.groupedContacts.value = grouped;

        return LayoutBuilder(
          builder: (context, constraints) {
            double currentOffset = 0;
            _letterOffsets.clear();

            return Row(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: grouped.length + (_isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == grouped.length) {
                        return Center(child: CircularProgressIndicator());
                      }

                      final letter = grouped.keys.elementAt(index);
                      final contacts = grouped[letter]!;

                      // Save the offset for each letter
                      _letterOffsets[letter] = currentOffset;
                      currentOffset += 48 + (contacts.length * 72); // Estimate height of each section

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Text(
                              letter,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          ...contacts.map((contact) => ListTile(
                                leading: CircleAvatar(
                                    child: Text(contact.name[0].toUpperCase())),
                                title: Text(contact.name),
                                subtitle: Text(contact.phone),
                                trailing: IconButton(
                                  icon: Icon(
                                    contact.isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: contact.isFavorite ? Colors.red : null,
                                  ),
                                  onPressed: () {
                                    controller.toggleFavorite(contact);
                                  },
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ContactDetailView(contact: contact),
                                    ),
                                  );
                                },
                              )),
                        ],
                      );
                    },
                  ),
                ),
                Container(
                  width: 40,
                  height: double.infinity,
                  color: Colors.grey[200],
                  child: ListView.builder(
                    itemCount: grouped.keys.length,
                    itemBuilder: (context, index) {
                      final letter = grouped.keys.elementAt(index);
                      return GestureDetector(
                        onTap: () => _scrollToLetter(letter),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Center(
                            child: Text(
                              letter,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final emailController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Text(
          'Add Contact',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
        ),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Name is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      labelText: 'Phone',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone),
                    ),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.red),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                final contact = Contact(
                  id: '',
                  name: nameController.text,
                  phone: phoneController.text,
                  email: emailController.text,
                  ownerId: controller.authController.firebaseUser.value!.uid,
                  isFavorite: false,
                );
                controller.addContact(contact);
                Navigator.pop(context);
              }
            },
            child: Text('Add'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
