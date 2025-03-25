import 'package:airtable_crud/airtable_plugin.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:kijani_pgc_app/app/models/group.dart';
import 'package:kijani_pgc_app/app/services/airtable_service.dart';
import 'package:kijani_pgc_app/app/services/local_storage.dart';
import 'package:kijani_pgc_app/utils/constants/airtable_constants.dart';
import 'package:kijani_pgc_app/utils/constants/storage_keys.dart';

class GroupRepository {
  final StorageService storageService = Get.find<StorageService>();

  // Fetch and save groups for a specific parish from Airtable
  Future<List<Group>?> fetchAndSaveParishGroups(String parishCode) async {
    try {
      List<String> groupAirtableFields = [
        'ID',
        'Coordinates',
        'Group Name',
        'Parish ID',
        'Parish',
        'No_',
        'Seasons_count',
      ];
      String filter = 'FIND("$parishCode", ARRAYJOIN({ParishID}, ",")) > 0';
      if (kDebugMode) {
        print('Fetching groups for parish: $parishCode with filter: $filter');
      }

      List<AirtableRecord> records = await uGNurseryActions
          .fetchRecordsWithFilter(
            kGroupsTable,
            filter,
            fields: groupAirtableFields,
          );

      if (records.isNotEmpty) {
        if (kDebugMode) print('Fetched ${records.length} records: $records');
        List<Group> groups = records.map((e) => Group.fromAirtable(e)).toList();

        // Save each group to local storage
        for (Group group in groups) {
          await storageService.saveEntity(
            kGroupsDataKey,
            group.id,
            group,
            group.toJson,
          );
        }
        if (kDebugMode) print('Saved ${groups.length} groups to local storage');
        return groups;
      } else {
        if (kDebugMode) print('No groups found for parish: $parishCode');
        return [];
      }
    } on AirtableException catch (e) {
      if (kDebugMode) print('Airtable error fetching groups: $e');
      return null;
    } catch (e) {
      if (kDebugMode) print('Unexpected error fetching groups: $e');
      return null;
    }
  }

  // Fetch all groups for a list of parish IDs and save them
  Future<List<Group>> fetchAndSaveAllParishGroups(
    List<String> parishIds,
  ) async {
    try {
      List<Group> allGroups = [];
      for (String parishId in parishIds) {
        List<Group>? parishGroups = await fetchAndSaveParishGroups(parishId);
        if (parishGroups != null && parishGroups.isNotEmpty) {
          allGroups.addAll(parishGroups);
        }
      }
      if (kDebugMode) {
        print(
          'Fetched and saved ${allGroups.length} groups for ${parishIds.length} parishes',
        );
      }
      return allGroups;
    } catch (e) {
      if (kDebugMode) print('Error fetching all parish groups: $e');
      return [];
    }
  }

  // Fetch groups from local storage for a specific parish
  Future<List<Group>> fetchLocalParishGroups(String parishCode) async {
    try {
      Map<String, dynamic> allGroups = storageService.fetchAllEntities(
        kGroupsDataKey,
        Group.fromJson,
      );

      List<Group> parishGroups =
          allGroups.values
              .where((group) => (group as Group).parishId == parishCode)
              .cast<Group>()
              .toList();

      if (kDebugMode) {
        print(
          'Fetched ${parishGroups.length} local groups for parish: $parishCode',
        );
      }
      return parishGroups;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching local groups for parish $parishCode: $e');
      }
      return [];
    }
  }

  // Fetch all groups from local storage
  Future<List<Group>> fetchAllLocalGroups() async {
    try {
      Map<String, dynamic> allGroups = storageService.fetchAllEntities(
        kGroupsDataKey,
        Group.fromJson,
      );

      List<Group> groups = allGroups.values.cast<Group>().toList();
      if (kDebugMode) print('Fetched ${groups.length} local groups');
      return groups;
    } catch (e) {
      if (kDebugMode) print('Error fetching all local groups: $e');
      return [];
    }
  }

  // Clear all groups from local storage
  Future<void> clearGroups() async {
    try {
      await storageService.clearEntities(kGroupsDataKey);
      if (kDebugMode) print('Cleared all groups from local storage');
    } catch (e) {
      if (kDebugMode) print('Error clearing groups: $e');
    }
  }

  fetchAndSaveGroupFarmers(String id) {}
}
