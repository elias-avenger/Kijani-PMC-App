import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kijani_pmc_app/screens/login_screen.dart';
import 'package:kijani_pmc_app/screens/parish_screen.dart';
import 'package:kijani_pmc_app/utilities/greetings.dart';

import '../controllers/user_controller.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final UserController pmcCtrl = Get.find();
  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    //final userController = Get.put(UserController());

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'images/kijani_logo.png',
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xff23566d),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) async {
              if (value == 'logout') {
                if (await pmcCtrl.logout()) {
                  Get.to(const LoginScreen());
                }
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(
                        Icons.logout,
                        color: Colors.red,
                      ),
                      SizedBox(width: 16),
                      Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                Greetings().getGreeting(),
                style: const TextStyle(fontSize: 20),
              ),
              Text(
                "${pmcCtrl.branchData['coordinator'].split(" | ")[1]}",
                style: const TextStyle(
                  color: Color(0xff23566d),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "${pmcCtrl.branchData['branch']}",
                style: const TextStyle(
                  color: Color(0xff23566d),
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'You have ${pmcCtrl.branchData['parishes'].length} assigned parishes',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              for (String parish in pmcCtrl.branchData['parishes'])
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            const WidgetStatePropertyAll(Color(0xff23566d)),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        minimumSize:
                            const WidgetStatePropertyAll(Size(300, 60)),
                      ),
                      onPressed: () {
                        Get.to(ParishScreen(parish: parish));
                      },
                      child: Text(
                        "${parish.split(' | ').last} Parish",
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  backgroundColor: WidgetStatePropertyAll(Colors.grey[400]),
                  minimumSize: const WidgetStatePropertyAll(Size(200, 50)),
                  maximumSize: const WidgetStatePropertyAll(Size(200, 50)),
                ),
                onPressed: () {},
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, size: 24, color: Color(0xff23566d)),
                    Text(
                      'Add parish',
                      style: TextStyle(color: Color(0xff23566d), fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
