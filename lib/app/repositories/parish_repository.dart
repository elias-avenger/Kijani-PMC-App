import 'package:airtable_crud/airtable_plugin.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:kijani_pgc_app/app/models/group.dart';
import 'package:kijani_pgc_app/app/services/airtable_service.dart';
import 'package:kijani_pgc_app/app/services/local_storage.dart';
import 'package:kijani_pgc_app/utils/constants/airtable_constants.dart';
import 'package:kijani_pgc_app/utils/constants/storage_keys.dart';

class ParishRepository {
  final StorageService storageService = Get.find<StorageService>();

  // Save parish list to local storage
  Future<bool> saveParishList(String parishListString) async {
    try {
      // Convert the parish string into a list
      List<dynamic> parishes =
          parishListString.split(',').map((e) => e.trim()).toList();
      if (kDebugMode) print('Saving parishes: $parishes');

      await storageService.saveEntity(
        kParishListDataKey,
        'current',
        parishes,
        () => {'parishes': parishes},
      );
      return true;
    } catch (e) {
      if (kDebugMode) print('Error saving parish list: $e');
      rethrow; // Rethrow to allow callers to handle the error
    }
  }

  // Fetch groups for all parishes associated with the user
  Future<List<Group>> fetchAllParishGroups() async {
    try {
      // Fetch the stored parish list
      final parishData = storageService.fetchEntity(
        kParishListDataKey,
        'current',
        (json) => json['parishes'] as List<dynamic>,
      );

      if (parishData == null || parishData.isEmpty) {
        if (kDebugMode) print('No parishes found in storage');
        return [];
      }

      List<String> parishIds =
          parishData.map((e) => e.toString().trim()).toList();
      List<Group> allGroups = [];

      // Fetch groups for each parish
      for (String parishId in parishIds) {
        List<Group>? parishGroups = await fetchParishGroups(parishId);
        if (parishGroups != null && parishGroups.isNotEmpty) {
          allGroups.addAll(parishGroups);
        }
      }

      if (kDebugMode)
        print('Fetched ${allGroups.length} groups for all parishes');
      return allGroups;
    } catch (e) {
      if (kDebugMode) print('Error fetching all parish groups: $e');
      return [];
    }
  }

  // Fetch groups for a specific parish
  Future<List<Group>?> fetchParishGroups(String parishCode) async {
    try {
      // Use curly braces for field names with spaces in Airtable formula
      String filter = 'AND({Parish ID} = "$parishCode ")';
      if (kDebugMode)
        print('Fetching groups for parish: $parishCode with filter: $filter');

      List<AirtableRecord> records = await uGNurseryActions
          .fetchRecordsWithFilter(kGroupsTable, filter);

      if (records.isNotEmpty) {
        if (kDebugMode) print('Fetched records: $records');
        List<Group> groups = records.map((e) => Group.fromAirtable(e)).toList();
        if (kDebugMode) print('Parsed ${groups.length} groups: $groups');
        return groups;
      } else {
        if (kDebugMode) print('No groups found for parish: $parishCode');
        return [];
      }
    } on AirtableException catch (e) {
      if (kDebugMode) print('Airtable error fetching groups: $e');
      return null; // Return null to indicate an error
    } catch (e) {
      if (kDebugMode) print('Unexpected error fetching parish groups: $e');
      return null;
    }
  }
}
