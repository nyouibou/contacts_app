
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controllers/auth_controller.dart';
// import 'contactsview.dart';
// import 'admin_view.dart';
// import 'fav_view.dart';
// import 'importcontact.dart';

// class HomeView extends StatelessWidget {
//   final AuthController authController = Get.find<AuthController>();

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       // Check if the user is logged in and has a valid role
//       final isLoggedIn = authController.userRole.value.isNotEmpty;
//       final isAdmin = authController.userRole.value == 'admin';

//       return DefaultTabController(
//         length: isAdmin ? 3 : 2, // Admins see 3 tabs, Users see 2
//         child: Scaffold(
//           appBar: AppBar(
//             backgroundColor: Colors.blue, // Custom background color
//             title: Text(
//               isAdmin ? 'Admin Management' : 'My Contacts',
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
//             ),
//             bottom: TabBar(
//               indicatorColor: Colors.white,labelColor: Colors.white,
//               labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//               tabs: [
//                 Tab(
//                   icon: Icon(Icons.contacts),
//                   text: 'All Contacts',
//                 ),
//                 Tab(
//                   icon: Icon(Icons.favorite),
//                   text: 'Favorites',
//                 ),
//                 if (isAdmin)
//                   Tab(
//                     icon: Icon(Icons.admin_panel_settings),
//                     text: 'Manage',
//                   ),
//               ],
//             ),
//             actions: [
//               if (isLoggedIn) // Show import icon only if logged in
//                 IconButton(
//                   icon: Icon(Icons.download, color: Colors.white), // White color for icons
//                   onPressed: () {
//                     Get.to(ContactImportView());
//                   },
//                 ),
//               IconButton(
//                 icon: Icon(Icons.logout_rounded, color: Colors.white),
//                 onPressed: authController.logout,
//               ),
//             ],
//           ),
//           body: TabBarView(
//             children: [
//               // Show all contacts for logged-in users
//               if (isLoggedIn) ContactsView(), // Shared Contacts tab
//               FavoriteContactsPage(), // Shared Favorites tab
//               if (isAdmin) AdminView(), // Admin-specific tab
//             ],
//           ),
//         ),
//       );
//     });
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import 'contactsview.dart';
import 'admin_view.dart';
import 'fav_view.dart';
import 'importcontact.dart';

class HomeView extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Check if the user is logged in and has a valid role
      final isLoggedIn = authController.userRole.value.isNotEmpty;
      final isAdmin = authController.userRole.value == 'admin';

      return DefaultTabController(
        length: isAdmin ? 3 : 2, // Admins see 3 tabs, Users see 2
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue, // Custom background color
            title: Obx(() {
              // Show username if logged in, otherwise a generic title
              final username = authController.username.value;
              return Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isAdmin
                        ? 'Admin Management'
                        : 'My Contacts',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text(
                    isAdmin
                        ?'$username'
                        : '$username',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,color: Colors.white),
                  ),
                ],
              );
            }),
            bottom: TabBar(
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              tabs: [
                Tab(
                  icon: Icon(Icons.contacts),
                  text: 'All Contacts',
                ),
                Tab(
                  icon: Icon(Icons.favorite),
                  text: 'Favorites',
                ),
                if (isAdmin)
                  Tab(
                    icon: Icon(Icons.admin_panel_settings),
                    text: 'Manage',
                  ),
              ],
            ),
            actions: [
              if (isLoggedIn) // Show import icon only if logged in
                IconButton(
                  icon: Icon(Icons.download, color: Colors.white),
                  onPressed: () {
                    Get.to(ContactImportView());
                  },
                ),
              IconButton(
                icon: Icon(Icons.logout_rounded, color: Colors.white),
                onPressed: authController.logout,
              ),
            ],
          ),
          body: TabBarView(
            children: [
              // Show all contacts for logged-in users
              if (isLoggedIn) ContactsView(), // Shared Contacts tab
              FavoriteContactsPage(), // Shared Favorites tab
              if (isAdmin) AdminView(), // Admin-specific tab
            ],
          ),
        ),
      );
    });
  }
}
