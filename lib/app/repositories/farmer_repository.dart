import 'package:airtable_crud/airtable_plugin.dart';
import 'package:flutter/foundation.dart';
import 'package:kijani_pgc_app/app/models/farmer.dart';
import 'package:kijani_pgc_app/app/models/garden.dart';
import 'package:kijani_pgc_app/app/services/airtable_service.dart';
import 'package:kijani_pgc_app/app/services/local_storage.dart';
import 'package:kijani_pgc_app/utils/constants/airtable_constants.dart';
import 'package:kijani_pgc_app/utils/constants/storage_keys.dart';

class FarmerRepository {
  final StorageService storageService = StorageService();

  // Fetches farmers by group ID by querying gardens first
  Future<List<Farmer>> fetchFarmersByGroup(String groupId) async {
    try {
      if (kDebugMode) print('Fetching gardens for group: $groupId');

      // Step 1: Fetch gardens for the group
      String gardenFilter = '{Group} = "$groupId"';
      List<AirtableRecord> gardenRecords = await uGGardens
          .fetchRecordsWithFilter(kGardensTable, gardenFilter);

      if (gardenRecords.isEmpty) {
        if (kDebugMode) print('No gardens found for group: $groupId');
        return [];
      }

      // Step 2: Extract unique farmer IDs from gardens
      List<Garden> gardens =
          gardenRecords
              .map((record) {
                try {
                  return Garden.fromAirtable(record);
                } catch (e) {
                  if (kDebugMode) print('Skipping garden ${record.id}: $e');
                  return null;
                }
              })
              .where((garden) => garden != null)
              .cast<Garden>()
              .toList();

      List<String> farmerIds =
          gardens.map((garden) => garden.farmerId).toSet().toList();
      if (farmerIds.isEmpty) {
        if (kDebugMode) {
          print('No farmers found in gardens for group: $groupId');
        }
        return [];
      }

      // Step 3: Fetch farmers using the extracted farmer IDs
      String farmerFilter =
          'OR(${farmerIds.map((id) => '{Record ID} = "$id"').join(', ')})';
      List<AirtableRecord> farmerRecords = await uGNurseryActions
          .fetchRecordsWithFilter(kFarmersTable, farmerFilter);

      List<Farmer> farmers = [];
      for (var record in farmerRecords) {
        try {
          Farmer farmer = Farmer.fromAirtable(record);
          farmers.add(farmer);
          // Save to local storage using StorageService
          await storageService.saveEntity(
            kFarmersDataKey,
            farmer.id,
            farmer,
            farmer.toJson,
          );
        } catch (e) {
          if (kDebugMode) print('Skipping farmer ${record.id}: $e');
        }
      }

      if (kDebugMode) {
        print(
          'Fetched and saved ${farmers.length} farmers for group: $groupId',
        );
      }
      return farmers;
    } on AirtableException catch (e) {
      if (kDebugMode) print('Airtable error fetching farmers: $e');
      return [];
    } catch (e) {
      if (kDebugMode) {
        print('Unexpected error fetching farmers for group $groupId: $e');
      }
      return [];
    }
  }

  /// Fetches a single farmer by ID
  Future<Farmer?> fetchFarmerById(String farmerId) async {
    try {
      String filter = '{Record ID} = "$farmerId"';
      List<AirtableRecord> records = await uGNurseryActions
          .fetchRecordsWithFilter(kFarmersTable, filter);

      if (records.isEmpty) {
        if (kDebugMode) print('No farmer found for ID: $farmerId');
        return null;
      }

      Farmer farmer = Farmer.fromAirtable(records.first);
      await storageService.saveEntity(
        kFarmersDataKey,
        farmer.id,
        farmer,
        farmer.toJson,
      );
      if (kDebugMode) print('Fetched and saved farmer: $farmerId');
      return farmer;
    } on AirtableException catch (e) {
      if (kDebugMode) print('Airtable error fetching farmer $farmerId: $e');
      return null;
    } catch (e) {
      if (kDebugMode) print('Unexpected error fetching farmer $farmerId: $e');
      return null;
    }
  }

  /// Gets cached farmers from local storage
  Map<String, dynamic> getCachedFarmers() {
    try {
      return storageService.fetchAllEntities(
        kFarmersDataKey,
        (json) => Farmer.fromJson(json),
      );
    } catch (e) {
      if (kDebugMode) print('Error retrieving cached farmers: $e');
      return {};
    }
  }

  /// Deletes a farmer from local storage
  Future<bool> deleteFarmer(String farmerId) async {
    return await storageService.deleteEntity(kFarmersDataKey, farmerId);
  }

  /// Clears all cached farmers
  Future<bool> clearFarmers() async {
    return await storageService.clearEntities(kFarmersDataKey);
  }
}
