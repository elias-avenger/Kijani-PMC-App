import 'package:airtable_crud/airtable_plugin.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:kijani_pgc_app/app/models/user_model.dart';
import 'package:kijani_pgc_app/app/services/airtable_service.dart';
import 'package:kijani_pgc_app/app/services/local_storage.dart';
import 'package:kijani_pgc_app/utils/constants/airtable_constants.dart';
import 'package:kijani_pgc_app/utils/constants/storage_keys.dart';

class UserRepository {
  final StorageService storageService = Get.find<StorageService>();

  // Login user
  Future<User?> login(String email, String code) async {
    try {
      List<AirtableRecord?> userRecord = await uGOperations
          .fetchRecordsWithFilter(
            kPGCAssignmentTable,
            'AND(Email = "$email", AppCode = "$code")',
          );

      if (userRecord.isNotEmpty && userRecord.first != null) {
        if (kDebugMode) {
          print(userRecord.first!.toJson());
        }
        User user = User.fromAirtable(userRecord.first!);
        await saveUser(user);
        return user;
      }
      return null;
    } on AirtableException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  // Save user to local storage using StorageService
  Future<bool> saveUser(User user) async {
    try {
      await storageService.saveEntity(
        kUserDataKey,
        'current',
        user,
        user.toJson,
      );

      // Verify if the data was stored by reading it back
      User? storedUser = await fetchLocalUser();
      return storedUser != null;
    } catch (e) {
      if (kDebugMode) {
        print('Error saving user: $e');
      }
      return false;
    }
  }

  // Fetch locally saved user using StorageService
  Future<User?> fetchLocalUser() async {
    try {
      return storageService.fetchEntity(kUserDataKey, 'current', User.fromJson)
          as User?;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching user: $e');
      }
      return null;
    }
  }
}
