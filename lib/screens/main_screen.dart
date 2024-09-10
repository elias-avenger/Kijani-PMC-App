import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/user_controller.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    final UserController userController = Get.put(UserController());

    return Scaffold(
      appBar: AppBar(title: const Text("User Data Example")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Display user data
          Obx(() {
            return Text(
              "Branch: ${userController.branchData['branch'] ?? 'No branch'}",
              style: const TextStyle(fontSize: 24),
            );
          }),
          Obx(() {
            return Text(
              "PMC: ${userController.branchData['coordinator'] ?? 'No PMC'}",
              style: const TextStyle(fontSize: 24),
            );
          }),
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
