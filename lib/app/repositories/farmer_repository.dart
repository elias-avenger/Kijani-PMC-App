import 'package:flutter/foundation.dart';
import 'package:kijani_pgc_app/app/models/farmer.dart';
import 'package:kijani_pgc_app/app/services/airtable_service.dart';
import 'package:kijani_pgc_app/app/services/local_storage.dart';
import 'package:kijani_pgc_app/utils/constants/airtable_constants.dart';
import 'package:kijani_pgc_app/utils/constants/storage_keys.dart';

class FarmerRepository {
  final StorageService _storage = StorageService();

  Future<List<Farmer>> fetchFarmersByGroup(String groupId) async {
    try {
      // Fetch gardens
      final gardenRecords = await uGGardens.fetchRecordsWithFilter(
        kGardensTable,
        'FIND("$groupId", ARRAYJOIN({Group ID}, ",")) > 0',
        fields: ['Farmer ID'],
      );
      if (gardenRecords.isEmpty) return [];

      // Extract farmer IDs
      final farmerIds =
          gardenRecords
              .map((r) => r.fields['Farmer ID'] as String?)
              .where((id) => id != null && id.isNotEmpty)
              .toSet()
              .toList();
      if (farmerIds.isEmpty) return [];

      // Optimized farmer fetching with chunking
      const batchSize = 50;
      final farmers = <Farmer>[];
      for (var i = 0; i < farmerIds.length; i += batchSize) {
        final batchIds = farmerIds.sublist(
          i,
          (i + batchSize).clamp(0, farmerIds.length),
        );
        final filter = 'OR(${batchIds.map((id) => '{ID}="$id"').join(',')})';

        final records = await uGGardens.fetchRecordsWithFilter(
          kFarmersTable,
          filter,
        );

        farmers.addAll(
          records.map((r) {
            final farmer = Farmer.fromAirtable(r);
            _storage.saveEntity(
              kFarmersDataKey,
              farmer.id,
              farmer,
              farmer.toJson,
            );
            return farmer;
          }),
        );
      }

      return farmers;
    } catch (e) {
      if (kDebugMode) print('❌ Error: $e');
      return [];
    }
  }

  Future<Farmer?> fetchFarmerById(String farmerId) async {
    try {
      final records = await uGGardens.fetchRecordsWithFilter(
        kFarmersTable,
        '{ID}="$farmerId"',
      );
      if (records.isEmpty) return null;
      final farmer = Farmer.fromAirtable(records.first);
      await _storage.saveEntity(
        kFarmersDataKey,
        farmer.id,
        farmer,
        farmer.toJson,
      );
      return farmer;
    } catch (e) {
      return null;
    }
  }

  Map<String, dynamic> getCachedFarmers() =>
      _storage.fetchAllEntities(kFarmersDataKey, Farmer.fromJson);
  Future<bool> deleteFarmer(String farmerId) =>
      _storage.deleteEntity(kFarmersDataKey, farmerId);
  Future<bool> clearFarmers() => _storage.clearEntities(kFarmersDataKey);
}
