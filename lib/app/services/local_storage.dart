import 'package:get_storage/get_storage.dart';

class StorageService {
  final GetStorage _storage = GetStorage();

  Future<void> init() async {
    await GetStorage.init();
  }

  // Save an entity under a specific key and ID
  Future<void> saveEntity(
    String key,
    String id,
    dynamic entity,
    Map<String, dynamic> Function() toJson,
  ) async {
    try {
      Map<String, dynamic> currentData =
          _storage.read(key) ?? <String, dynamic>{};
      currentData[id] = toJson();
      await _storage.write(key, currentData);
    } catch (e) {
      print('Error saving entity ($key, $id): $e');
    }
  }

  // Fetch an entity by key and ID
  dynamic fetchEntity(
    String key,
    String id,
    dynamic Function(Map<String, dynamic>) fromJson,
  ) {
    try {
      Map<String, dynamic>? storedData = _storage.read(key);
      if (storedData != null && storedData[id] != null) {
        return fromJson(storedData[id] as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error fetching entity ($key, $id): $e');
      return null;
    }
  }

  // Fetch all entities of a type under a key
  Map<String, dynamic> fetchAllEntities(
    String key,
    dynamic Function(Map<String, dynamic>) fromJson,
  ) {
    try {
      Map<String, dynamic>? storedData = _storage.read(key);
      if (storedData != null) {
        return storedData.map(
          (id, data) => MapEntry(id, fromJson(data as Map<String, dynamic>)),
        );
      }
      return {};
    } catch (e) {
      print('Error fetching all entities ($key): $e');
      return {};
    }
  }

  // Delete an entity by key and ID
  Future<bool> deleteEntity(String key, String id) async {
    try {
      Map<String, dynamic> currentData =
          _storage.read(key) ?? <String, dynamic>{};
      currentData.remove(id);
      if (currentData.isEmpty) {
        await _storage.remove(key);
        return true;
      } else {
        await _storage.write(key, currentData);
        return true;
      }
    } catch (e) {
      print('Error deleting entity ($key, $id): $e');
      return false;
    }
  }

  // Clear all entities under a specific key
  Future<bool> clearEntities(String key) async {
    try {
      await _storage.remove(key);
      return true;
    } catch (e) {
      print('Error clearing entities ($key): $e');
      return false;
    }
  }

  // Clear all storage (e.g., for logout)
  Future<bool> clearAll() async {
    try {
      await _storage.erase();
      return true;
    } catch (e) {
      print('Error clearing all storage: $e');
      return false;
    }
  }
}
