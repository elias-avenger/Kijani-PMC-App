import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kijani_pmc_app/screens/login_screen.dart';
import 'package:kijani_pmc_app/screens/parish_screen.dart';

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
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('images/kijani_logo.png'),
        ),
        backgroundColor: const Color(0xff23566d),
        title: Text(
          "${pmcCtrl.branchData['branch']}",
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                if (await pmcCtrl.logout()) {
                  Get.to(const LoginScreen());
                }
              },
              child: Text(
                "Logout",
                style: TextStyle(color: Colors.orange[900], fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  "PMC: ${pmcCtrl.branchData['coordinator'].split(" | ")[1]}",
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 20),
                for (String parish in pmcCtrl.branchData['parishes'])
                  Column(
                    children: [
                      ElevatedButton(
                        style: const ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll(Color(0xff23566d)),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero),
                          ),
                          minimumSize: WidgetStatePropertyAll(Size(300, 60)),
                        ),
                        onPressed: () {
                          Get.to(ParishScreen(parish: parish));
                        },
                        child: Text(
                          "${parish.split(' | ').last} Parish",
                          style: const TextStyle(
                              fontSize: 18, color: Colors.white),
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
                        style:
                            TextStyle(color: Color(0xff23566d), fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
