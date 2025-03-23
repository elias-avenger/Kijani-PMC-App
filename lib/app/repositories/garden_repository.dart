import 'package:airtable_crud/airtable_plugin.dart';
import 'package:flutter/foundation.dart';
import 'package:kijani_pgc_app/app/models/garden.dart';
import 'package:kijani_pgc_app/app/services/airtable_service.dart';
import 'package:kijani_pgc_app/app/services/local_storage.dart';
import 'package:kijani_pgc_app/utils/constants/airtable_constants.dart';
import 'package:kijani_pgc_app/utils/constants/storage_keys.dart';

class GardenRepository {
  final StorageService storageService = StorageService();

  /// Fetches gardens by group ID
  Future<List<Garden>> fetchGardensByGroup(String groupId) async {
    try {
      String filter = '{Group} = "$groupId"';
      if (kDebugMode) {
        print('Fetching gardens for group: $groupId with filter: $filter');
      }

      List<AirtableRecord> records = await uGGardens.fetchRecordsWithFilter(
        kGardensTable,
        filter,
      );

      if (records.isEmpty) {
        if (kDebugMode) print('No gardens found for group: $groupId');
        return [];
      }

      List<Garden> gardens = [];
      for (var record in records) {
        try {
          Garden garden = Garden.fromAirtable(record);
          gardens.add(garden);
          // Save to local storage using StorageService
          await storageService.saveEntity(
            kGardensDataKey,
            garden.id,
            garden,
            garden.toJson,
          );
        } catch (e) {
          if (kDebugMode) print('Skipping garden ${record.id}: $e');
        }
      }

      if (kDebugMode) {
        print(
          'Fetched and saved ${gardens.length} gardens for group: $groupId',
        );
      }
      return gardens;
    } on AirtableException catch (e) {
      if (kDebugMode) print('Airtable error fetching gardens: $e');
      return [];
    } catch (e) {
      if (kDebugMode) {
        print('Unexpected error fetching gardens for group $groupId: $e');
      }
      return [];
    }
  }

  /// Fetches gardens by farmer ID
  Future<List<Garden>> fetchGardensByFarmer(String farmerId) async {
    try {
      String filter = '{Farmer ID} = "$farmerId"';
      if (kDebugMode) {
        print('Fetching gardens for farmer: $farmerId with filter: $filter');
      }

      List<AirtableRecord> records = await uGGardens.fetchRecordsWithFilter(
        kGardensTable,
        filter,
      );

      if (records.isEmpty) {
        if (kDebugMode) print('No gardens found for farmer: $farmerId');
        return [];
      }

      List<Garden> gardens = [];
      for (var record in records) {
        try {
          Garden garden = Garden.fromAirtable(record);
          gardens.add(garden);
          // Save to local storage using StorageService
          await storageService.saveEntity(
            kGardensDataKey,
            garden.id,
            garden,
            garden.toJson,
          );
        } catch (e) {
          if (kDebugMode) print('Skipping garden ${record.id}: $e');
        }
      }

      if (kDebugMode) {
        print(
          'Fetched and saved ${gardens.length} gardens for farmer: $farmerId',
        );
      }
      return gardens;
    } on AirtableException catch (e) {
      if (kDebugMode) print('Airtable error fetching gardens: $e');
      return [];
    } catch (e) {
      if (kDebugMode) {
        print('Unexpected error fetching gardens for farmer $farmerId: $e');
      }
      return [];
    }
  }

  /// Gets cached gardens from local storage
  Map<String, dynamic> getCachedGardens() {
    try {
      return storageService.fetchAllEntities(
        kGardensDataKey,
        (json) => Garden.fromJson(json),
      );
    } catch (e) {
      if (kDebugMode) print('Error retrieving cached gardens: $e');
      return {};
    }
  }

  /// Deletes a garden from local storage
  Future<bool> deleteGarden(String gardenId) async {
    return await storageService.deleteEntity(kGardensDataKey, gardenId);
  }

  /// Clears all cached gardens
  Future<bool> clearGardens() async {
    return await storageService.clearEntities(kGardensDataKey);
  }
}
