// import 'package:get/get.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../model/contact.dart';
// import 'auth_controller.dart';

// class ContactController extends GetxController {
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;
//   final AuthController authController = Get.find<AuthController>();

//   // Reactive variables
//   RxList<Contact> contacts = <Contact>[].obs;
//   RxList<Contact> filteredContacts = <Contact>[].obs;
//   RxString searchQuery = ''.obs;
//   var isFetching = false.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     fetchContacts(); // Automatically fetch contacts on initialization
//   }

//   /// Fetch contacts from Firestore based on user role (admin or user)
//   Future<void> fetchContacts() async {
//     if (isFetching.value) return; // Prevent duplicate fetch calls
//     isFetching.value = true;

//     try {
//       final role = authController.userRole.value;
//       QuerySnapshot<Map<String, dynamic>> snapshot;

//       if (role == 'admin') {
//         // Admins can see all contacts
//         snapshot = await firestore.collection('contacts').get();
//       } else {
//         // Users can see their own contacts and admin-shared contacts
//         snapshot = await firestore
//             .collection('contacts')
//             .where('ownerId', whereIn: [authController.firebaseUser.value!.uid, 'admin'])
//             .get();
//       }

//       // Map Firestore documents to the Contact model
//       contacts.value = snapshot.docs
//           .map((doc) => Contact.fromMap(doc.id, doc.data()))
//           .toList();

//       filterContacts(); // Apply search filters
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to fetch contacts: $e');
//     } finally {
//       isFetching.value = false;
//     }
//   }

//   /// Add a new contact to Firestore
//   Future<void> addContact(Contact contact) async {
//     try {
//       // Determine ownerId based on user role
//       final ownerId = authController.userRole.value == 'admin'
//           ? 'admin'
//           : authController.firebaseUser.value!.uid;

//       // Update the contact's ownerId
//       final updatedContact = contact.copyWith(ownerId: ownerId);

//       // Add the contact to Firestore
//       final docRef = await firestore.collection('contacts').add(updatedContact.toMap());
//       updatedContact.id = docRef.id; // Assign Firestore ID

//       // Add the contact locally
//       contacts.add(updatedContact);
//       filterContacts(); // Update filtered list
//       Get.snackbar('Success', 'Contact added successfully!');
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to add contact: $e');
//     }
//   }

//   /// Edit an existing contact
//   Future<void> editContact({
//     required Contact contact,
//     required String name,
//     required String phone,
//     required String email,
//     Map<String, String>? customFields,
//     required String? whatsapp,
//     required String? facebook,
//     required String? instagram,
//     required String? youtube,
//   }) async {
//     try {
//       // Update the contact fields
//       final updatedContact = contact.copyWith(
//         name: name,
//         phone: phone,
//         email: email,
//         facebook: facebook,
//         whatsapp: whatsapp,
//         instagram: instagram,
//         youtube: youtube,
//         customFields: customFields,
//       );

//       // Update the contact in Firestore
//       await firestore.collection('contacts').doc(contact.id).update(updatedContact.toMap());

//       // Update locally
//       updateContact(updatedContact);
//       Get.snackbar('Success', 'Contact updated successfully!');
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to update contact: $e');
//     }
//   }

//   /// Delete a contact
//   Future<void> deleteContact(Contact contact) async {
//     final role = authController.userRole.value;

//     try {
//       if (role == 'admin' || contact.ownerId == authController.firebaseUser.value!.uid) {
//         // Admins can delete any contact; users can delete their own
//         await firestore.collection('contacts').doc(contact.id).delete();

//         // Remove the contact locally
//         contacts.removeWhere((c) => c.id == contact.id);
//         filterContacts();
//         Get.snackbar('Success', 'Contact deleted successfully!');
//       } else {
//         Get.snackbar('Permission Denied', 'You can only delete your own contacts.');
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to delete contact: $e');
//     }
//   }

//   /// Toggle the favorite status of a contact
//   Future<void> toggleFavorite(Contact contact) async {
//     try {
//       final updatedStatus = !contact.isFavorite;

//       // Update Firestore
//       await firestore.collection('contacts').doc(contact.id).update({
//         'isFavorite': updatedStatus,
//       });

//       // Update locally
//       final index = contacts.indexWhere((c) => c.id == contact.id);
//       if (index != -1) {
//         contacts[index] = contacts[index].copyWith(isFavorite: updatedStatus);
//         filterContacts();
//       }

//       // Notify the user
//       Get.snackbar(
//         'Success',
//         updatedStatus
//             ? '${contact.name} added to favorites!'
//             : '${contact.name} removed from favorites!',
//       );
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to update favorite status: $e');
//     }
//   }

//   /// Filter contacts based on the search query
//   void filterContacts() {
//     if (searchQuery.value.isEmpty) {
//       filteredContacts.value = contacts; // Show all contacts if no query
//     } else {
//       final query = searchQuery.value.toLowerCase();
//       filteredContacts.value = contacts.where((contact) {
//         return contact.name.toLowerCase().contains(query) ||
//             contact.phone.contains(query);
//       }).toList();
//     }
//   }

//   /// Update the search query and filter results
//   void updateSearchQuery(String query) {
//     searchQuery.value = query;
//     filterContacts();
//   }

//   /// Update a contact in the local list
//   void updateContact(Contact updatedContact) {
//     final index = contacts.indexWhere((contact) => contact.id == updatedContact.id);
//     if (index != -1) {
//       contacts[index] = updatedContact; // Update locally
//       filterContacts(); // Re-apply filters
//     }
//   }
// }


// import 'package:get/get.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../model/contact.dart';
// import 'auth_controller.dart';

// class ContactController extends GetxController {
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;
//   final AuthController authController = Get.find<AuthController>();

//   // Reactive variables
//   RxList<Contact> contacts = <Contact>[].obs;
//   RxList<Contact> filteredContacts = <Contact>[].obs;
//   RxString searchQuery = ''.obs;
//   var isFetching = false.obs;
//   var loadingMore = false.obs;
  
//   // Pagination variables
//   DocumentSnapshot? lastVisible; // Last document for pagination
//   final int pageSize = 900; // Number of contacts per page

//   @override
//   void onInit() {
//     super.onInit();
//     fetchContacts(); // Automatically fetch contacts on initialization
//   }

//   /// Fetch the first page of contacts from Firestore
//   Future<void> fetchContacts() async {
//     if (isFetching.value) return; // Prevent duplicate fetch calls
//     isFetching.value = true;

//     try {
//       final role = authController.userRole.value;
//       QuerySnapshot<Map<String, dynamic>> snapshot;

//       if (role == 'admin') {
//         snapshot = await firestore.collection('contacts').limit(pageSize).get();
//       } else {
//         snapshot = await firestore
//             .collection('contacts')
//             .where('ownerId', whereIn: [authController.firebaseUser.value!.uid, 'admin'])
//             .limit(pageSize)
//             .get();
//       }

//       // Map Firestore documents to the Contact model
//       contacts.value = snapshot.docs
//           .map((doc) => Contact.fromMap(doc.id, doc.data()))
//           .toList();

//       // Update last visible document for pagination
//       if (snapshot.docs.isNotEmpty) {
//         lastVisible = snapshot.docs.last;
//       }

//       filterContacts(); // Apply search filters
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to fetch contacts: $e');
//     } finally {
//       isFetching.value = false;
//     }
//   }

//   /// Load more contacts for pagination
//   Future<void> loadMoreContacts() async {
//     if (loadingMore.value || lastVisible == null) return; // Prevent loading if already loading or no more documents

//     loadingMore.value = true;

//     try {
//       final role = authController.userRole.value;
//       QuerySnapshot<Map<String, dynamic>> snapshot;

//       if (role == 'admin') {
//         snapshot = await firestore
//             .collection('contacts')
//             .startAfterDocument(lastVisible!)
//             .limit(pageSize)
//             .get();
//       } else {
//         snapshot = await firestore
//             .collection('contacts')
//             .where('ownerId', whereIn: [authController.firebaseUser.value!.uid, 'admin'])
//             .startAfterDocument(lastVisible!)
//             .limit(pageSize)
//             .get();
//       }

//       // Map Firestore documents to the Contact model and append to existing contacts
//       final newContacts = snapshot.docs
//           .map((doc) => Contact.fromMap(doc.id, doc.data()))
//           .toList();
      
//       contacts.addAll(newContacts);

//       // Update last visible document for next page
//       if (snapshot.docs.isNotEmpty) {
//         lastVisible = snapshot.docs.last;
//       }

//       filterContacts(); // Re-apply filters to the full list
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to load more contacts: $e');
//     } finally {
//       loadingMore.value = false;
//     }
//   }

//   /// Add a new contact to Firestore
//   Future<void> addContact(Contact contact) async {
//     try {
//       final ownerId = authController.userRole.value == 'admin'
//           ? 'admin'
//           : authController.firebaseUser.value!.uid;

//       final updatedContact = contact.copyWith(ownerId: ownerId);
//       final docRef = await firestore.collection('contacts').add(updatedContact.toMap());
//       updatedContact.id = docRef.id;

//       contacts.add(updatedContact);
//       filterContacts(); // Update filtered list
//       Get.snackbar('Success', 'Contact added successfully!');
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to add contact: $e');
//     }
//   }

//   /// Edit an existing contact
//   Future<void> editContact({
//     required Contact contact,
//     required String name,
//     required String phone,
//     required String email,
//     Map<String, String>? customFields,
//     required String? whatsapp,
//     required String? facebook,
//     required String? instagram,
//     required String? youtube,
//   }) async {
//     try {
//       final updatedContact = contact.copyWith(
//         name: name,
//         phone: phone,
//         email: email,
//         facebook: facebook,
//         whatsapp: whatsapp,
//         instagram: instagram,
//         youtube: youtube,
//         customFields: customFields,
//       );

//       await firestore.collection('contacts').doc(contact.id).update(updatedContact.toMap());
//       updateContact(updatedContact);
//       Get.snackbar('Success', 'Contact updated successfully!');
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to update contact: $e');
//     }
//   }

//   /// Delete a contact
//   Future<void> deleteContact(Contact contact) async {
//     final role = authController.userRole.value;

//     try {
//       if (role == 'admin' || contact.ownerId == authController.firebaseUser.value!.uid) {
//         await firestore.collection('contacts').doc(contact.id).delete();
//         contacts.removeWhere((c) => c.id == contact.id);
//         filterContacts();
//         Get.snackbar('Success', 'Contact deleted successfully!');
//       } else {
//         Get.snackbar('Permission Denied', 'You can only delete your own contacts.');
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to delete contact: $e');
//     }
//   }

//   /// Toggle the favorite status of a contact
//   Future<void> toggleFavorite(Contact contact) async {
//     try {
//       final updatedStatus = !contact.isFavorite;

//       await firestore.collection('contacts').doc(contact.id).update({
//         'isFavorite': updatedStatus,
//       });

//       final index = contacts.indexWhere((c) => c.id == contact.id);
//       if (index != -1) {
//         contacts[index] = contacts[index].copyWith(isFavorite: updatedStatus);
//         filterContacts();
//       }

//       Get.snackbar(
//         'Success',
//         updatedStatus
//             ? '${contact.name} added to favorites!'
//             : '${contact.name} removed from favorites!',
//       );
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to update favorite status: $e');
//     }
//   }

//   /// Filter contacts based on the search query
//   void filterContacts() {
//     if (searchQuery.value.isEmpty) {
//       filteredContacts.value = contacts;
//     } else {
//       final query = searchQuery.value.toLowerCase();
//       filteredContacts.value = contacts.where((contact) {
//         return contact.name.toLowerCase().contains(query) ||
//             contact.phone.contains(query);
//       }).toList();
//     }
//   }

//   /// Update the search query and filter results
//   void updateSearchQuery(String query) {
//     searchQuery.value = query;
//     filterContacts();
//   }

//   /// Update a contact in the local list
//   void updateContact(Contact updatedContact) {
//     final index = contacts.indexWhere((contact) => contact.id == updatedContact.id);
//     if (index != -1) {
//       contacts[index] = updatedContact;
//       filterContacts();
//     }
//   }
// }


// import 'package:get/get.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../model/contact.dart';
// import 'auth_controller.dart';

// class ContactController extends GetxController {
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;
//   final AuthController authController = Get.find<AuthController>();

//   // Reactive variables
//   RxList<Contact> contacts = <Contact>[].obs;
//   RxList<Contact> filteredContacts = <Contact>[].obs;
//   RxString searchQuery = ''.obs;
//   RxMap<String, List<Contact>> groupedContacts = <String, List<Contact>>{}.obs; // Define groupedContacts

//   var isFetching = false.obs;
//   var loadingMore = false.obs;

//   // Pagination variables
//   DocumentSnapshot? lastVisible; // Last document for pagination
//   final int pageSize = 900; // Number of contacts per page

//   @override
//   void onInit() {
//     super.onInit();
//     fetchContacts(); // Automatically fetch contacts on initialization
//   }

//   /// Fetch the first page of contacts from Firestore
//   Future<void> fetchContacts() async {
//     if (isFetching.value) return; // Prevent duplicate fetch calls
//     isFetching.value = true;

//     try {
//       final role = authController.userRole.value;
//       QuerySnapshot<Map<String, dynamic>> snapshot;

//       if (role == 'admin') {
//         snapshot = await firestore.collection('contacts').limit(pageSize).get();
//       } else {
//         snapshot = await firestore
//             .collection('contacts')
//             .where('ownerId', whereIn: [authController.firebaseUser.value!.uid, 'admin'])
//             .limit(pageSize)
//             .get();
//       }

//       // Map Firestore documents to the Contact model
//       contacts.value = snapshot.docs
//           .map((doc) => Contact.fromMap(doc.id, doc.data()))
//           .toList();

//       // Update last visible document for pagination
//       if (snapshot.docs.isNotEmpty) {
//         lastVisible = snapshot.docs.last;
//       }

//       filterContacts(); // Apply search filters
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to fetch contacts: $e');
//     } finally {
//       isFetching.value = false;
//     }
//   }

//   /// Load more contacts for pagination
//   Future<void> loadMoreContacts() async {
//     if (loadingMore.value || lastVisible == null) return; // Prevent loading if already loading or no more documents

//     loadingMore.value = true;

//     try {
//       final role = authController.userRole.value;
//       QuerySnapshot<Map<String, dynamic>> snapshot;

//       if (role == 'admin') {
//         snapshot = await firestore
//             .collection('contacts')
//             .startAfterDocument(lastVisible!)
//             .limit(pageSize)
//             .get();
//       } else {
//         snapshot = await firestore
//             .collection('contacts')
//             .where('ownerId', whereIn: [authController.firebaseUser.value!.uid, 'admin'])
//             .startAfterDocument(lastVisible!)
//             .limit(pageSize)
//             .get();
//       }

//       // Map Firestore documents to the Contact model and append to existing contacts
//       final newContacts = snapshot.docs
//           .map((doc) => Contact.fromMap(doc.id, doc.data()))
//           .toList();

//       contacts.addAll(newContacts);

//       // Update last visible document for next page
//       if (snapshot.docs.isNotEmpty) {
//         lastVisible = snapshot.docs.last;
//       }

//       filterContacts(); // Re-apply filters to the full list
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to load more contacts: $e');
//     } finally {
//       loadingMore.value = false;
//     }
//   }

//   /// Add a new contact to Firestore
//   Future<void> addContact(Contact contact) async {
//     try {
//       final ownerId = authController.userRole.value == 'admin'
//           ? 'admin'
//           : authController.firebaseUser.value!.uid;

//       final updatedContact = contact.copyWith(ownerId: ownerId);
//       final docRef = await firestore.collection('contacts').add(updatedContact.toMap());
//       updatedContact.id = docRef.id;

//       contacts.add(updatedContact);
//       filterContacts(); // Update filtered list
//       Get.snackbar('Success', 'Contact added successfully!');
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to add contact: $e');
//     }
//   }

//   /// Edit an existing contact
//   Future<void> editContact({
//     required Contact contact,
//     required String name,
//     required String phone,
//     required String email,
//     Map<String, String>? customFields,
//     required String? whatsapp,
//     required String? facebook,
//     required String? instagram,
//     required String? youtube,
//   }) async {
//     try {
//       final updatedContact = contact.copyWith(
//         name: name,
//         phone: phone,
//         email: email,
//         facebook: facebook,
//         whatsapp: whatsapp,
//         instagram: instagram,
//         youtube: youtube,
//         customFields: customFields,
//       );

//       await firestore.collection('contacts').doc(contact.id).update(updatedContact.toMap());
//       updateContact(updatedContact);
//       Get.snackbar('Success', 'Contact updated successfully!');
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to update contact: $e');
//     }
//   }

//   /// Delete a contact
//   Future<void> deleteContact(Contact contact) async {
//     final role = authController.userRole.value;

//     try {
//       if (role == 'admin' || contact.ownerId == authController.firebaseUser.value!.uid) {
//         await firestore.collection('contacts').doc(contact.id).delete();
//         contacts.removeWhere((c) => c.id == contact.id);
//         filterContacts();
//         Get.snackbar('Success', 'Contact deleted successfully!');
//       } else {
//         Get.snackbar('Permission Denied', 'You can only delete your own contacts.');
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to delete contact: $e');
//     }
//   }

//   /// Toggle the favorite status of a contact
//   Future<void> toggleFavorite(Contact contact) async {
//     try {
//       final updatedStatus = !contact.isFavorite;

//       await firestore.collection('contacts').doc(contact.id).update({
//         'isFavorite': updatedStatus,
//       });

//       final index = contacts.indexWhere((c) => c.id == contact.id);
//       if (index != -1) {
//         contacts[index] = contacts[index].copyWith(isFavorite: updatedStatus);
//         filterContacts();
//       }

//       Get.snackbar(
//         'Success',
//         updatedStatus
//             ? '${contact.name} added to favorites!'
//             : '${contact.name} removed from favorites!',
//       );
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to update favorite status: $e');
//     }
//   }

//   /// Filter contacts based on the search query and group them by first letter
//   void filterContacts() {
//     if (searchQuery.value.isEmpty) {
//       filteredContacts.value = contacts;
//     } else {
//       final query = searchQuery.value.toLowerCase();
//       filteredContacts.value = contacts.where((contact) {
//         return contact.name.toLowerCase().contains(query) ||
//             contact.phone.contains(query);
//       }).toList();
//     }

//     // Group the filtered contacts by their first letter
//     final Map<String, List<Contact>> grouped = {};
//     for (var contact in filteredContacts) {
//       final firstLetter = contact.name[0].toUpperCase();
//       grouped.putIfAbsent(firstLetter, () => []).add(contact);
//     }

//     // Update the groupedContacts variable
//     groupedContacts.value = grouped;
//   }

//   /// Update the search query and filter results
//   void updateSearchQuery(String query) {
//     searchQuery.value = query;
//     filterContacts();
//   }

//   /// Update a contact in the local list
//   void updateContact(Contact updatedContact) {
//     final index = contacts.indexWhere((contact) => contact.id == updatedContact.id);
//     if (index != -1) {
//       contacts[index] = updatedContact;
//       filterContacts();
//     }
//   }
// }


import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/contact.dart';
import 'auth_controller.dart';

class ContactController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final AuthController authController = Get.find<AuthController>();

  // Reactive variables
  RxList<Contact> contacts = <Contact>[].obs;
  RxList<Contact> filteredContacts = <Contact>[].obs;
  RxString searchQuery = ''.obs;
  RxMap<String, List<Contact>> groupedContacts = <String, List<Contact>>{}.obs; // Define groupedContacts

  var isFetching = false.obs;
  var loadingMore = false.obs;

  // Pagination variables
  DocumentSnapshot? lastVisible; // Last document for pagination
  final int pageSize = 900; // Number of contacts per page

  @override
  void onInit() {
    super.onInit();
    fetchContacts(); // Automatically fetch contacts on initialization
  }

  /// Fetch the first page of contacts from Firestore
  Future<void> fetchContacts() async {
    if (isFetching.value) return; // Prevent duplicate fetch calls
    isFetching.value = true;

    try {
      final role = authController.userRole.value;
      QuerySnapshot<Map<String, dynamic>> snapshot;

      if (role == 'admin') {
        snapshot = await firestore.collection('contacts').limit(pageSize).get();
      } else {
        snapshot = await firestore
            .collection('contacts')
            .where('ownerId', whereIn: [authController.firebaseUser.value!.uid, 'admin'])
            .limit(pageSize)
            .get();
      }

      // Map Firestore documents to the Contact model
      contacts.value = snapshot.docs
          .map((doc) => Contact.fromMap(doc.id, doc.data()))
          .toList();

      // Update last visible document for pagination
      if (snapshot.docs.isNotEmpty) {
        lastVisible = snapshot.docs.last;
      }

      filterContacts(); // Apply search filters
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch contacts: $e');
    } finally {
      isFetching.value = false;
    }
  }

  /// Load more contacts for pagination
  Future<void> loadMoreContacts() async {
    if (loadingMore.value || lastVisible == null) return; // Prevent loading if already loading or no more documents

    loadingMore.value = true;

    try {
      final role = authController.userRole.value;
      QuerySnapshot<Map<String, dynamic>> snapshot;

      if (role == 'admin') {
        snapshot = await firestore
            .collection('contacts')
            .startAfterDocument(lastVisible!)
            .limit(pageSize)
            .get();
      } else {
        snapshot = await firestore
            .collection('contacts')
            .where('ownerId', whereIn: [authController.firebaseUser.value!.uid, 'admin'])
            .startAfterDocument(lastVisible!)
            .limit(pageSize)
            .get();
      }

      // Map Firestore documents to the Contact model and append to existing contacts
      final newContacts = snapshot.docs
          .map((doc) => Contact.fromMap(doc.id, doc.data()))
          .toList();

      contacts.addAll(newContacts);

      // Update last visible document for next page
      if (snapshot.docs.isNotEmpty) {
        lastVisible = snapshot.docs.last;
      }

      filterContacts(); // Re-apply filters to the full list
    } catch (e) {
      Get.snackbar('Error', 'Failed to load more contacts: $e');
    } finally {
      loadingMore.value = false;
    }
  }

  /// Add a new contact to Firestore
  Future<void> addContact(Contact contact) async {
    try {
      final ownerId = authController.userRole.value == 'admin'
          ? 'admin'
          : authController.firebaseUser.value!.uid;

      final updatedContact = contact.copyWith(ownerId: ownerId);
      final docRef = await firestore.collection('contacts').add(updatedContact.toMap());
      updatedContact.id = docRef.id;

      contacts.add(updatedContact);
      filterContacts(); // Update filtered list
      Get.snackbar('Success', 'Contact added successfully!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add contact: $e');
    }
  }

  /// Edit an existing contact
  Future<void> editContact({
    required Contact contact,
    required String name,
    required String phone,
    required String email,
    Map<String, String>? customFields,
    required String? whatsapp,
    required String? facebook,
    required String? instagram,
    required String? youtube,
  }) async {
    try {
      final updatedContact = contact.copyWith(
        name: name,
        phone: phone,
        email: email,
        facebook: facebook,
        whatsapp: whatsapp,
        instagram: instagram,
        youtube: youtube,
        customFields: customFields,
      );

      await firestore.collection('contacts').doc(contact.id).update(updatedContact.toMap());
      updateContact(updatedContact);
      Get.snackbar('Success', 'Contact updated successfully!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update contact: $e');
    }
  }

  /// Delete a contact
  Future<void> deleteContact(Contact contact) async {
    final role = authController.userRole.value;

    try {
      if (role == 'admin' || contact.ownerId == authController.firebaseUser.value!.uid) {
        await firestore.collection('contacts').doc(contact.id).delete();
        contacts.removeWhere((c) => c.id == contact.id);
        filterContacts();
        Get.snackbar('Success', 'Contact deleted successfully!');
      } else {
        Get.snackbar('Permission Denied', 'You can only delete your own contacts.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete contact: $e');
    }
  }

  /// Toggle the favorite status of a contact
  Future<void> toggleFavorite(Contact contact) async {
    try {
      final updatedStatus = !contact.isFavorite;

      await firestore.collection('contacts').doc(contact.id).update({
        'isFavorite': updatedStatus,
      });

      final index = contacts.indexWhere((c) => c.id == contact.id);
      if (index != -1) {
        contacts[index] = contacts[index].copyWith(isFavorite: updatedStatus);
        filterContacts();
      }

      Get.snackbar(
        'Success',
        updatedStatus
            ? '${contact.name} added to favorites!'
            : '${contact.name} removed from favorites!',
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to update favorite status: $e');
    }
  }

  /// Filter contacts based on the search query and group them by first letter
  void filterContacts() {
    if (searchQuery.value.isEmpty) {
      filteredContacts.value = contacts;
    } else {
      final query = searchQuery.value.toLowerCase();
      filteredContacts.value = contacts.where((contact) {
        return contact.name.toLowerCase().contains(query) ||
            contact.phone.contains(query);
      }).toList();
    }

    // Group the filtered contacts by their first letter
    final Map<String, List<Contact>> grouped = {};
    for (var contact in filteredContacts) {
      final firstLetter = contact.name[0].toUpperCase();
      grouped.putIfAbsent(firstLetter, () => []).add(contact);
    }

    // Update the groupedContacts variable
    groupedContacts.value = grouped;
  }

  /// Update the search query and filter results
  void updateSearchQuery(String query) {
    searchQuery.value = query;
    filterContacts();
  }

  /// Update a contact in the local list
  void updateContact(Contact updatedContact) {
    final index = contacts.indexWhere((contact) => contact.id == updatedContact.id);
    if (index != -1) {
      contacts[index] = updatedContact;
      filterContacts();
    }
  }
}
