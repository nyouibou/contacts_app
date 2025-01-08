// // ignore_for_file: prefer_const_constructors, no_leading_underscores_for_local_identifiers, prefer_const_literals_to_create_immutables, unnecessary_import, use_super_parameters

// import 'package:flutter/material.dart';
// import '../model/contact.dart';
// import '../controllers/contact_controller.dart';
// import 'package:get/get.dart';

// class AddEditContactPage extends StatelessWidget {
//   final Contact? contact;

//   const AddEditContactPage({Key? key, this.contact}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final ContactController contactController = Get.find<ContactController>();

//     // Controllers for Text Fields
//     TextEditingController nameController =
//         TextEditingController(text: contact?.name ?? '');
//     TextEditingController phoneController =
//         TextEditingController(text: contact?.phone ?? '');
//     TextEditingController emailController =
//         TextEditingController(text: contact?.email ?? '');
//     TextEditingController whatsappController =
//         TextEditingController(text: contact?.whatsapp ?? '');
//     TextEditingController facebookController =
//         TextEditingController(text: contact?.facebook ?? '');
//     TextEditingController instagramController =
//         TextEditingController(text: contact?.instagram ?? '');
//     TextEditingController youtubeController =
//         TextEditingController(text: contact?.youtube ?? '');

//     // Reactive custom fields list
//     RxList<Map<String, dynamic>> customFields = <Map<String, dynamic>>[].obs;

//     // Load custom fields if contact exists
//     if (contact?.customFields != null) {
//       contact!.customFields?.forEach((label, value) {
//         customFields.add({
//           'label': label,
//           'labelController': TextEditingController(text: label),
//           'valueController': TextEditingController(text: value),
//         });
//       });
//     }

//     // Save or update contact
//     void _saveContact() {
//       if (nameController.text.isEmpty || phoneController.text.isEmpty) {
//         Get.snackbar(
//           'Validation Error',
//           'Name and Phone are required fields.',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//         return;
//       }

//       // Collect custom fields
//       Map<String, String> customFieldsMap = Map.fromEntries(
//         customFields.map((field) => MapEntry(
//               field['labelController']!.text,
//               field['valueController']!.text,
//             )),
//       );

//       if (contact == null) {
//         Contact newContact = Contact(
//           id: '',
//           name: nameController.text,
//           phone: phoneController.text,
//           email: emailController.text,
//           ownerId: 'ownerId',
//           customFields: customFieldsMap,
//           whatsapp: whatsappController.text,
//           facebook: facebookController.text,
//           instagram: instagramController.text,
//           youtube: youtubeController.text,
//         );
//         contactController.addContact(newContact);
//         Navigator.pop(context, newContact);
//       } else {
//         contact!.name = nameController.text;
//         contact!.phone = phoneController.text;
//         contact!.email = emailController.text;
//         contact!.customFields = customFieldsMap;
//         contact!.whatsapp = whatsappController.text;
//         contact!.facebook = facebookController.text;
//         contact!.instagram = instagramController.text;
//         contact!.youtube = youtubeController.text;

//         contactController.editContact(
//           contact: contact!,
//           name: nameController.text,
//           phone: phoneController.text,
//           email: emailController.text,
//           customFields: customFieldsMap,
//           whatsapp: whatsappController.text,
//           facebook: facebookController.text,
//           instagram: instagramController.text,
//           youtube: youtubeController.text,
//         );
//         Navigator.pop(context, contact);
//       }
//     }

//     // Add custom field
//     void _addCustomField() {
//       customFields.add({
//         'label': '',
//         'labelController': TextEditingController(),
//         'valueController': TextEditingController(),
//       });
//     }

//     // Remove custom field
//     void _removeCustomField(int index) {
//       customFields.removeAt(index);
//     }

//     return Scaffold(backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Text(contact == null ? 'New Contact' : 'Edit Contact'),
//         centerTitle: true,
//         elevation: 0,
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.all(16.0),
//           child: Form(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildCurvedTextField(
//                   controller: nameController,
//                   labelText: 'Full Name',
//                   hintText: 'Enter full name',
//                   icon: Icons.person,
//                 ),
//                 SizedBox(height: 16),
//                 _buildCurvedTextField(
//                   controller: phoneController,
//                   labelText: 'Phone Number',
//                   hintText: 'Enter phone number',
//                   icon: Icons.phone,
//                   keyboardType: TextInputType.phone,
//                 ),
//                 SizedBox(height: 16),
//                 _buildCurvedTextField(
//                   controller: emailController,
//                   labelText: 'Email Address',
//                   hintText: 'Enter email',
//                   icon: Icons.email,
//                   keyboardType: TextInputType.emailAddress,
//                 ),
//                 SizedBox(height: 16),
//                 _buildCurvedTextField(
//                   controller: whatsappController,
//                   labelText: 'WhatsApp',
//                   hintText: 'Enter WhatsApp number',
//                   icon: Icons.chat,
//                 ),
//                 SizedBox(height: 16),
//                 _buildCurvedTextField(
//                   controller: facebookController,
//                   labelText: 'Facebook',
//                   hintText: 'Enter Facebook URL',
//                   icon: Icons.facebook,
//                 ),
//                 SizedBox(height: 16),
//                 _buildCurvedTextField(
//                   controller: instagramController,
//                   labelText: 'Instagram',
//                   hintText: 'Enter Instagram URL',
//                   icon: Icons.camera_alt,
//                 ),
//                 SizedBox(height: 16),
//                 _buildCurvedTextField(
//                   controller: youtubeController,
//                   labelText: 'YouTube',
//                   hintText: 'Enter YouTube URL',
//                   icon: Icons.video_call,
//                 ),
//                 SizedBox(height: 24),
//                 Obx(() {
//                   return Column(
//                     children: customFields.asMap().entries.map((entry) {
//                       int index = entry.key;
//                       var field = entry.value;
//                       return Row(
//                         children: [
//                           Expanded(
//                             child: _buildCurvedTextField(
//                               controller: field['labelController'],
//                               labelText: 'Field Label',
//                               hintText: 'Custom Field Label',
//                             ),
//                           ),
//                           SizedBox(width: 8),
//                           Expanded(
//                             child: _buildCurvedTextField(
//                               controller: field['valueController'],
//                               labelText: 'Field Value',
//                               hintText: 'Custom Field Value',
//                             ),
//                           ),
//                           IconButton(
//                             icon: Icon(Icons.remove_circle, color: Colors.red),
//                             onPressed: () => _removeCustomField(index),
//                           ),
//                         ],
//                       );
//                     }).toList(),
//                   );
//                 }),
//                 SizedBox(height: 10),
//                 TextButton.icon(
//                   onPressed: _addCustomField,
//                   icon: Icon(Icons.add, color: Colors.blue),
//                   label: Text('Add Custom Field'),
//                 ),
//                 SizedBox(height: 24),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     TextButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       child: Text('Cancel', style: TextStyle(color: Colors.red)),
//                     ),
//                     ElevatedButton(
//                       onPressed: _saveContact,
//                       child: Text('Save'),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue,
//                         padding:
//                             EdgeInsets.symmetric(horizontal: 32, vertical: 16),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildCurvedTextField({
//     required TextEditingController controller,
//     required String labelText,
//     required String hintText,
//     IconData? icon,
//     TextInputType keyboardType = TextInputType.text,
//   }) {
//     return TextField(
//       controller: controller,
//       keyboardType: keyboardType,
//       decoration: InputDecoration(
//         hintText: hintText,
//         labelText: labelText,
//         filled: true,
//         fillColor: Colors.white,
//         prefixIcon: icon != null ? Icon(icon, color: Colors.blue) : null,
//         contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(30),
//           borderSide: BorderSide.none,
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(30),
//           borderSide: BorderSide(color: Colors.blue),
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import '../model/contact.dart';
import '../controllers/contact_controller.dart';
import 'package:get/get.dart';

class AddEditContactPage extends StatelessWidget {
  final Contact? contact;

  const AddEditContactPage({Key? key, this.contact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ContactController contactController = Get.find<ContactController>();

    // Controllers for Text Fields
    TextEditingController nameController =
        TextEditingController(text: contact?.name ?? '');
    TextEditingController phoneController =
        TextEditingController(text: contact?.phone ?? '');
    TextEditingController emailController =
        TextEditingController(text: contact?.email ?? '');
    TextEditingController whatsappController =
        TextEditingController(text: contact?.whatsapp ?? '');
    TextEditingController facebookController =
        TextEditingController(text: contact?.facebook ?? '');
    TextEditingController instagramController =
        TextEditingController(text: contact?.instagram ?? '');
    TextEditingController youtubeController =
        TextEditingController(text: contact?.youtube ?? '');

    // FocusNodes for each TextField
    FocusNode nameFocusNode = FocusNode();
    FocusNode phoneFocusNode = FocusNode();
    FocusNode emailFocusNode = FocusNode();
    FocusNode whatsappFocusNode = FocusNode();
    FocusNode facebookFocusNode = FocusNode();
    FocusNode instagramFocusNode = FocusNode();
    FocusNode youtubeFocusNode = FocusNode();

    // Reactive custom fields list
    RxList<Map<String, dynamic>> customFields = <Map<String, dynamic>>[].obs;

    // Load custom fields if contact exists
    if (contact?.customFields != null) {
      contact!.customFields?.forEach((label, value) {
        customFields.add({
          'label': label,
          'labelController': TextEditingController(text: label),
          'valueController': TextEditingController(text: value),
        });
      });
    }

    // Save or update contact
    void _saveContact() {
      if (nameController.text.isEmpty || phoneController.text.isEmpty) {
        Get.snackbar(
          'Validation Error',
          'Name and Phone are required fields.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Collect custom fields
      Map<String, String> customFieldsMap = Map.fromEntries(
        customFields.map((field) => MapEntry(
              field['labelController']!.text,
              field['valueController']!.text,
            )),
      );

      if (contact == null) {
        Contact newContact = Contact(
          id: '',
          name: nameController.text,
          phone: phoneController.text,
          email: emailController.text,
          ownerId: 'ownerId',
          customFields: customFieldsMap,
          whatsapp: whatsappController.text,
          facebook: facebookController.text,
          instagram: instagramController.text,
          youtube: youtubeController.text,
        );
        contactController.addContact(newContact);
        Navigator.pop(context, newContact);
      } else {
        contact!.name = nameController.text;
        contact!.phone = phoneController.text;
        contact!.email = emailController.text;
        contact!.customFields = customFieldsMap;
        contact!.whatsapp = whatsappController.text;
        contact!.facebook = facebookController.text;
        contact!.instagram = instagramController.text;
        contact!.youtube = youtubeController.text;

        contactController.editContact(
          contact: contact!,
          name: nameController.text,
          phone: phoneController.text,
          email: emailController.text,
          customFields: customFieldsMap,
          whatsapp: whatsappController.text,
          facebook: facebookController.text,
          instagram: instagramController.text,
          youtube: youtubeController.text,
        );
        Navigator.pop(context, contact);
      }
    }

    // Add custom field
    void _addCustomField() {
      customFields.add({
        'label': '',
        'labelController': TextEditingController(),
        'valueController': TextEditingController(),
      });
    }

    // Remove custom field
    void _removeCustomField(int index) {
      customFields.removeAt(index);
    }

    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(contact == null ? 'New Contact' : 'Edit Contact'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCurvedTextField(
                  controller: nameController,
                  labelText: 'Full Name',
                  hintText: 'Enter full name',
                  icon: Icons.person,
                  focusNode: nameFocusNode,
                  nextFocusNode: phoneFocusNode,
                ),
                SizedBox(height: 16),
                _buildCurvedTextField(
                  controller: phoneController,
                  labelText: 'Phone Number',
                  hintText: 'Enter phone number',
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  focusNode: phoneFocusNode,
                  nextFocusNode: emailFocusNode,
                ),
                SizedBox(height: 16),
                _buildCurvedTextField(
                  controller: emailController,
                  labelText: 'Email Address',
                  hintText: 'Enter email',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  focusNode: emailFocusNode,
                  nextFocusNode: whatsappFocusNode,
                ),
                SizedBox(height: 16),
                _buildCurvedTextField(
                  controller: whatsappController,
                  labelText: 'WhatsApp',
                  hintText: 'Enter WhatsApp number',
                  icon: Icons.chat,
                  focusNode: whatsappFocusNode,
                  nextFocusNode: facebookFocusNode,
                ),
                SizedBox(height: 16),
                _buildCurvedTextField(
                  controller: facebookController,
                  labelText: 'Facebook',
                  hintText: 'Enter Facebook URL',
                  icon: Icons.facebook,
                  focusNode: facebookFocusNode,
                  nextFocusNode: instagramFocusNode,
                ),
                SizedBox(height: 16),
                _buildCurvedTextField(
                  controller: instagramController,
                  labelText: 'Instagram',
                  hintText: 'Enter Instagram URL',
                  icon: Icons.camera_alt,
                  focusNode: instagramFocusNode,
                  nextFocusNode: youtubeFocusNode,
                ),
                SizedBox(height: 16),
                _buildCurvedTextField(
                  controller: youtubeController,
                  labelText: 'YouTube',
                  hintText: 'Enter YouTube URL',
                  icon: Icons.video_call,
                  focusNode: youtubeFocusNode,
                ),
                SizedBox(height: 24),
                Obx(() {
                  return Column(
                    children: customFields.asMap().entries.map((entry) {
                      int index = entry.key;
                      var field = entry.value;
                      return Row(
                        children: [
                          Expanded(
                            child: _buildCurvedTextField(
                              controller: field['labelController'],
                              labelText: 'Field Label',
                              hintText: 'Custom Field Label', focusNode: null,
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: _buildCurvedTextField(
                              controller: field['valueController'],
                              labelText: 'Field Value',
                              hintText: 'Custom Field Value', focusNode: null,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.remove_circle, color: Colors.red),
                            onPressed: () => _removeCustomField(index),
                          ),
                        ],
                      );
                    }).toList(),
                  );
                }),
                SizedBox(height: 10),
                TextButton.icon(
                  onPressed: _addCustomField,
                  icon: Icon(Icons.add, color: Colors.blue),
                  label: Text('Add Custom Field'),
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancel', style: TextStyle(color: Colors.red)),
                    ),
                    ElevatedButton(
                      onPressed: _saveContact,
                      child: Text('Save'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding:
                            EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurvedTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    IconData? icon,
    TextInputType keyboardType = TextInputType.text,
    FocusNode? focusNode, // Make it nullable
    FocusNode? nextFocusNode,
  }) {
    // If no focusNode is provided, create an empty one
    FocusNode effectiveFocusNode = focusNode ?? FocusNode();

    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      focusNode: effectiveFocusNode,
      onSubmitted: (_) {
        if (nextFocusNode != null) {
          FocusScope.of(effectiveFocusNode.context!).requestFocus(nextFocusNode);
        }
      },
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        filled: true,
        fillColor: Colors.white,
        prefixIcon: icon != null ? Icon(icon, color: Colors.blue) : null,
        contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
    );
  }
}
