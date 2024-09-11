import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kijani_pmc_app/screens/login_screen.dart';

import '../controllers/user_controller.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final UserController ctrl = Get.find();
  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    //final userController = Get.put(UserController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("User Data Example"),
        actions: [
          ElevatedButton(
            onPressed: () async {
              if (await ctrl.logout()) {
                Get.to(const LoginScreen());
              }
            },
            child: Text(
              "Logout",
              style: TextStyle(color: Colors.orange[900]),
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Display user data
          Text("Branch: ${ctrl.branchData['branch']}"),
          Text("PMC: ${ctrl.branchData['coordinator'].split(" | ")[1]}"),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Update the user data map
              // userController.updateUserData('name', 'John Doe');
              // userController.updateUserData('age', 30);
            },
            child: const Text('Update User Data'),
          ),
        ],
      ),
    );
  }
}
