import 'package:airtable_crud/airtable_plugin.dart';

class GardenParsingException implements Exception {
  final String message;
  GardenParsingException(this.message);

  @override
  String toString() => 'GardenParsingException: $message';
}

class Garden {
  final String id;
  final String groupId;
  final String? plantingDate;
  final String? centerPoint;
  final String geojson;
  final String farmerId;
  final List<String> species;

  Garden({
    required this.id,
    required this.groupId,
    this.plantingDate,
    this.centerPoint,
    required this.geojson,
    required this.farmerId,
    required this.species,
  });

  factory Garden.fromAirtable(AirtableRecord record) {
    try {
      final fields = record.fields;
      final id = record.id;

      if (id == null || id.trim().isEmpty) {
        throw GardenParsingException('Record ID is required');
      }
      if (fields == null) {
        throw GardenParsingException('Fields are missing in Airtable record');
      }

      final groupIdRaw = fields['Group ID'];
      final groupId =
          groupIdRaw is List && groupIdRaw.isNotEmpty
              ? groupIdRaw.first.toString()
              : groupIdRaw is String
              ? groupIdRaw
              : '';
      if (groupId.trim().isEmpty) {
        throw GardenParsingException('Group ID is missing or invalid');
      }

      final geojsonList = fields['Polygon GeoJSON'];
      if (geojsonList is! List ||
          geojsonList.isEmpty ||
          geojsonList.first is! String) {
        throw GardenParsingException('Polygon GeoJSON must be a List<String>');
      }

      final centerPointList = fields['Center Point'];
      final centerPoint =
          centerPointList is List && centerPointList.isNotEmpty
              ? centerPointList.first.toString()
              : null;

      final farmerId = fields['Farmer ID'];
      if (farmerId is! String || farmerId.trim().isEmpty) {
        throw GardenParsingException('Farmer ID is missing');
      }

      final plantingDate =
          fields['Initial planting date'] is String
              ? fields['Initial planting date'] as String
              : null;

      final speciesRaw = fields['Species'];
      final species =
          speciesRaw is List
              ? speciesRaw.whereType<String>().toList()
              : <String>[];

      return Garden(
        id: id,
        groupId: groupId,
        plantingDate: plantingDate,
        centerPoint: centerPoint,
        geojson: geojsonList.first,
        farmerId: farmerId,
        species: species,
      );
    } catch (e) {
      throw GardenParsingException('Failed to parse Garden from Airtable: $e');
    }
  }

  factory Garden.fromJson(Map<String, dynamic> json) {
    try {
      return Garden(
        id: json['id'] as String,
        groupId: json['groupId'] as String,
        plantingDate: json['plantingDate'] as String?,
        centerPoint: json['centerPoint'] as String?,
        geojson: json['geojson'] as String,
        farmerId: json['farmerId'] as String,
        species:
            (json['species'] as List<dynamic>?)?.whereType<String>().toList() ??
            [],
      );
    } catch (e) {
      throw GardenParsingException('Failed to parse Garden from JSON: $e');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'groupId': groupId,
      'plantingDate': plantingDate,
      'centerPoint': centerPoint,
      'geojson': geojson,
      'farmerId': farmerId,
      'species': species,
    };
  }
}
