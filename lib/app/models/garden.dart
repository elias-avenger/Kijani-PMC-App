import 'dart:convert';
import 'package:airtable_crud/airtable_plugin.dart';

class GardenParsingException implements Exception {
  final String message;
  GardenParsingException(this.message);

  @override
  String toString() => 'GardenParsingException: $message';
}

class Garden {
  final String id;
  final String group;
  final String plantingDate;
  final String geojson; // Stored as a JSON string
  final String centerPoint; // Stored as "lat,lng"
  final String farmerId;
  final List<String> species;

  Garden({
    required this.id,
    required this.group,
    required this.plantingDate,
    required this.geojson,
    required this.centerPoint,
    required this.farmerId,
    required this.species,
  });

  factory Garden.fromAirtable(AirtableRecord record) {
    try {
      final fields = record.fields;

      return Garden(
        id: _requireString(record.id, 'Record ID'),
        group: _requireString(fields['Group'], 'Group'),
        plantingDate: _requireString(
          fields['Initial planting date'],
          'Initial planting date',
        ),
        geojson: _requireGeoJson(fields['Polygon GeoJSON']),
        centerPoint: _requireLatLngList(fields['Center Point']),
        farmerId: _requireString(fields['Farmer ID'], 'Farmer ID'),
        species: _parseSpeciesList(fields['Species']),
      );
    } catch (e) {
      throw GardenParsingException('Failed to parse Garden from Airtable: $e');
    }
  }

  factory Garden.fromJson(Map<String, dynamic> json) {
    try {
      return Garden(
        id: _requireString(json['id'], 'id'),
        group: _requireString(json['group'], 'group'),
        plantingDate: _requireString(json['plantingDate'], 'plantingDate'),
        geojson: _requireString(json['geojson'], 'geojson'),
        centerPoint: _requireString(json['centerPoint'], 'centerPoint'),
        farmerId: _requireString(json['farmerId'], 'farmerId'),
        species: _parseSpeciesList(json['species']),
      );
    } catch (e) {
      throw GardenParsingException('Failed to parse Garden from JSON: $e');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'group': group,
      'plantingDate': plantingDate,
      'geojson': geojson,
      'centerPoint': centerPoint,
      'farmerId': farmerId,
      'species': species,
    };
  }

  // ────────────────────────────────
  // 🔧 Helpers
  // ────────────────────────────────

  static String _requireString(dynamic value, String fieldName) {
    if (value is String && value.trim().isNotEmpty) return value;
    throw GardenParsingException(
      '$fieldName is required and must be a non-empty String',
    );
  }

  static String _requireGeoJson(dynamic value) {
    if (value is List && value.isNotEmpty && value.first is Map) {
      try {
        return jsonEncode(value.first); // serialize only first polygon
      } catch (e) {
        throw GardenParsingException(
          'Failed to encode Polygon GeoJSON to JSON: $e',
        );
      }
    }
    throw GardenParsingException(
      'Polygon GeoJSON must be a non-empty List<Map>',
    );
  }

  static String _requireLatLngList(dynamic value) {
    if (value is List && value.length >= 2) {
      final lat = value[0]?.toString();
      final lng = value[1]?.toString();
      if (lat != null && lng != null) return '$lat,$lng';
    }
    throw GardenParsingException(
      'Center Point must be a List with at least two numeric values',
    );
  }

  static List<String> _parseSpeciesList(dynamic value) {
    if (value is List) {
      return value
          .where((e) => e is String && e.trim().isNotEmpty)
          .map((e) => e as String)
          .toList();
    }
    throw GardenParsingException('Species must be a List<String>');
  }
}
