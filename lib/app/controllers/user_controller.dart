import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kijani_pgc_app/app/models/user_model.dart';
import 'package:kijani_pgc_app/app/repositories/user_repository.dart';
import 'package:kijani_pgc_app/app/repositories/parish_repository.dart';
import 'package:kijani_pgc_app/app/services/local_storage.dart';
import 'package:kijani_pgc_app/utils/constants/storage_keys.dart';

class UserController extends GetxController {
  final UserRepository userRepo = UserRepository();
  final StorageService storageService =
      Get.find<
        StorageService
      >(); // Optional: for logout or additional storage ops
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final codeController = TextEditingController();

  // Observable variable to track logged-in user
  Rx<User?> currentUser = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    // Check if user is logged in on initialization
    checkIfUserIsLoggedIn();
  }

  // Method to check if a user is logged in
  Future<void> checkIfUserIsLoggedIn() async {
    User? localUser = await userRepo.fetchLocalUser();
    if (localUser != null) {
      currentUser.value = localUser;
      Get.offAllNamed('/home');
    } else {
      currentUser.value = null;
    }
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    // Call user repository to login
    User? user = await userRepo.login(
      emailController.text,
      codeController.text,
    );

    if (user != null) {
      bool isSaved = await userRepo.saveUser(user);
      if (isSaved) {
        currentUser.value = user;
        //parishes to list
        await ParishRepository().saveParishList(user.parishesIDs);
        Get.offAllNamed('/home'); // Navigate to home screen
      } else {
        Get.snackbar(
          "Error",
          "An error occurred while saving user data",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } else {
      Get.snackbar(
        "Invalid Credentials",
        "Please check your email and code !",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Logout method to clear user data
  Future<void> logout() async {
    await storageService.clearAll();
    currentUser.value = null;
    Get.offAllNamed('/login'); // Navigate back to login screen
  }

  @override
  void onClose() {
    emailController.dispose();
    codeController.dispose();
    super.onClose();
  }
}
