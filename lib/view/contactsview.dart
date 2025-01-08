// ignore_for_file: prefer_const_constructors

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:alphabet_list_view/alphabet_list_view.dart';  // Import the package
// import '../controllers/contact_controller.dart';
// import '../model/contact.dart';
// import 'contact_detail.dart';
// import 'dart:async';

// class ContactsView extends StatefulWidget {
//   @override
//   _ContactsViewState createState() => _ContactsViewState();
// }

// class _ContactsViewState extends State<ContactsView> {
//   final ContactController controller = Get.find<ContactController>();
//   late Timer _timer;

//   @override
//   void initState() {
//     super.initState();
//     controller.fetchContacts();
//     _timer = Timer.periodic(Duration(seconds: 5), (timer) {
//       controller.fetchContacts();
//     });
//   }

//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: TextField(
//           onChanged: (value) => controller.updateSearchQuery(value),
//           decoration: InputDecoration(
//             hintText: 'Search contacts...',
//             border: InputBorder.none,
//             hintStyle: TextStyle(color: Colors.white70),
//           ),
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Colors.blue,
//       ),
//       body: Obx(() {
//         final filteredContacts = controller.filteredContacts;

//         if (filteredContacts.isEmpty) {
//           return Center(
//             child: Shimmer.fromColors(
//               baseColor: Colors.grey[300]!,
//               highlightColor: Colors.grey[100]!,
//               child: ListView.builder(
//                 itemCount: 10,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     leading: CircleAvatar(
//                       backgroundColor: Colors.white,
//                     ),
//                     title: Container(
//                       height: 10,
//                       color: Colors.white,
//                     ),
//                     subtitle: Container(
//                       height: 10,
//                       color: Colors.white,
//                     ),
//                   );
//                 },
//               ),
//             ),
//           );
//         }

//         final Map<String, List<Contact>> groupedContacts = {};
//         for (var contact in filteredContacts) {
//           final firstLetter = contact.name[0].toUpperCase();
//           groupedContacts.putIfAbsent(firstLetter, () => []).add(contact);
//         }

//         // Map the grouped contacts to AlphabetListViewItemGroup
//         List<AlphabetListViewItemGroup> itemGroups = groupedContacts.keys.map((letter) {
//           return AlphabetListViewItemGroup(
//             tag: letter,
//             children: groupedContacts[letter]!.map((contact) {
//               return ListTile(
//                 leading: CircleAvatar(child: Text(contact.name[0].toUpperCase())),
//                 title: Text(contact.name),
//                 subtitle: Text(contact.phone),
//                 trailing: IconButton(
//                   icon: Icon(
//                     contact.isFavorite ? Icons.favorite : Icons.favorite_border,
//                     color: contact.isFavorite ? Colors.red : null,
//                   ),
//                   onPressed: () {
//                     controller.toggleFavorite(contact);
//                   },
//                 ),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => ContactDetailView(contact: contact),
//                     ),
//                   );
//                 },
//               );
//             }).toList(),
//           );
//         }).toList();

//         // return AlphabetListView(
//         //   items: itemGroups,options: AlphabetListViewOptions(overlayOptions: OverlayOptions(showOverlay: true),scrollbarOptions: ScrollbarOptions(backgroundColor: Colors.white,),listOptions: ListOptions(backgroundColor: Colors.white, )),
//         // );
//         return AlphabetListView(
//   items: itemGroups,
//   options: AlphabetListViewOptions(
//     overlayOptions: OverlayOptions(showOverlay: true,),  // Show overlay without color
//     scrollbarOptions: ScrollbarOptions(
//       backgroundColor: Colors.white,  // Change the scrollbar color
//     ),
//     listOptions: ListOptions(
//       backgroundColor: Colors.white,  // Change the background color of the list
//     ),
//   ),
// );
//       }),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _showAddDialog(context),
//         child: Icon(Icons.add),
//       ),
//     );
//   }

//   void _showAddDialog(BuildContext context) {
//     final nameController = TextEditingController();
//     final phoneController = TextEditingController();
//     final emailController = TextEditingController();
//     final _formKey = GlobalKey<FormState>();

//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         title: Text(
//           'Add Contact',
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
//         ),
//         content: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   TextFormField(
//                     controller: nameController,
//                     decoration: InputDecoration(
//                       labelText: 'Name',
//                       border: OutlineInputBorder(),
//                       prefixIcon: Icon(Icons.person),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Name is required';
//                       }
//                       return null; // No error
//                     },
//                   ),
//                   SizedBox(height: 12),
//                   TextField(
//                     controller: phoneController,
//                     decoration: InputDecoration(
//                       labelText: 'Phone',
//                       border: OutlineInputBorder(),
//                       prefixIcon: Icon(Icons.phone),
//                     ),
//                   ),
//                   SizedBox(height: 12),
//                   TextField(
//                     controller: emailController,
//                     decoration: InputDecoration(
//                       labelText: 'Email',
//                       border: OutlineInputBorder(),
//                       prefixIcon: Icon(Icons.email),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text(
//               'Cancel',
//               style: TextStyle(color: Colors.red),
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               if (_formKey.currentState?.validate() ?? false) {
//                 final contact = Contact(
//                   id: '',
//                   name: nameController.text,
//                   phone: phoneController.text,
//                   email: emailController.text,
//                   ownerId: controller.authController.firebaseUser.value!.uid,
//                   isFavorite: false,
//                 );
//                 controller.addContact(contact);
//                 Navigator.pop(context);
//               }
//             },
//             child: Text('Add'),
//             style: ElevatedButton.styleFrom(
//               foregroundColor: Colors.white, backgroundColor: Colors.blue,
//               padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:alphabet_list_view/alphabet_list_view.dart';
import 'package:flutter/services.dart'; // Import for TextInputFormatter
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

  @override
  void initState() {
    super.initState();
    controller.fetchContacts();
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      controller.fetchContacts();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
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
        final filteredContacts = controller.filteredContacts;

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

        final Map<String, List<Contact>> groupedContacts = {};
        for (var contact in filteredContacts) {
          final firstLetter = contact.name[0].toUpperCase();
          groupedContacts.putIfAbsent(firstLetter, () => []).add(contact);
        }

        List<AlphabetListViewItemGroup> itemGroups = groupedContacts.keys.map((letter) {
          return AlphabetListViewItemGroup(
            tag: letter,
            children: groupedContacts[letter]!.map((contact) {
              return ListTile(
                leading: CircleAvatar(child: Text(contact.name[0].toUpperCase())),
                title: Text(contact.name),
                subtitle: Text(contact.phone),
                trailing: IconButton(
                  icon: Icon(
                    contact.isFavorite ? Icons.favorite : Icons.favorite_border,
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
                      builder: (context) => ContactDetailView(contact: contact),
                    ),
                  );
                },
              );
            }).toList(),
          );
        }).toList();

        return AlphabetListView(
          items: itemGroups,
          options: AlphabetListViewOptions(
            overlayOptions: OverlayOptions(showOverlay: true),
            scrollbarOptions: ScrollbarOptions(
              backgroundColor: Colors.white,
            ),
            listOptions: ListOptions(
              backgroundColor: Colors.white,
            ),
          ),
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
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
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
                      return null; // No error
                    },
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      labelText: 'Phone',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly, // Only allow numbers
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Phone is required';
                      }
                      if (value.length < 10) {
                        return 'Please enter a valid phone number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      }
                      // Regex for email validation
                      String pattern =
                          r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$";
                      RegExp regex = RegExp(pattern);
                      if (!regex.hasMatch(value)) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
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
              foregroundColor: Colors.white, backgroundColor: Colors.blue,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
