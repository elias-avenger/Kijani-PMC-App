import 'package:airtable_crud/airtable_plugin.dart';

class GroupParsingException implements Exception {
  final String message;
  GroupParsingException(this.message);

  @override
  String toString() => 'GroupParsingException: $message';
}

class Group {
  final String id;
  final String name;
  final String parishId;
  final String coordinates;
  final String? parish;
  final int? no;
  final int? seasonsCount;

  Group({
    required this.id,
    required this.name,
    required this.parishId,
    required this.coordinates,
    this.parish,
    this.no,
    this.seasonsCount,
  });

  factory Group.fromAirtable(AirtableRecord record) {
    try {
      final fields = record.fields;
      if (fields == null) {
        throw GroupParsingException('Fields map is null in Airtable record');
      }

      return Group(
        id: _requireString(record.id, 'Record ID'),
        name: _requireString(fields['Group Name'], 'Group Name'),
        parishId: _requireString(fields['Parish ID'], 'Parish ID'),
        coordinates: _parseFirstStringInList(fields['Coordinates']),
        parish: _parseOptionalString(fields['Parish']),
        no: _parseOptionalInt(fields['No_']),
        seasonsCount: _parseOptionalInt(fields['Seasons_count']),
      );
    } catch (e) {
      throw GroupParsingException('Failed to parse Group from Airtable: $e');
    }
  }

  factory Group.fromJson(Map<String, dynamic> json) {
    try {
      return Group(
        id: _requireString(json['id'], 'id'),
        name: _requireString(json['name'], 'name'),
        parishId: _requireString(json['parishId'], 'parishId'),
        coordinates: _requireString(json['coordinates'], 'coordinates'),
        parish: _parseOptionalString(json['parish']),
        no: _parseOptionalInt(json['no']),
        seasonsCount: _parseOptionalInt(json['seasonsCount']),
      );
    } catch (e) {
      throw GroupParsingException('Failed to parse Group from JSON: $e');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'parishId': parishId,
      'coordinates': coordinates,
      'parish': parish,
      'no': no,
      'seasonsCount': seasonsCount,
    };
  }

  // Helper methods for parsing fields

  static String _requireString(dynamic value, String field) {
    if (value is String && value.trim().isNotEmpty) return value;
    throw GroupParsingException(
      '$field is required and must be a non-empty String',
    );
  }

  static String _parseFirstStringInList(dynamic value) {
    if (value is List && value.isNotEmpty && value.first is String) {
      return value.first;
    }
    return '';
  }

  static String? _parseOptionalString(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    return null;
  }

  static int? _parseOptionalInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return null;
  }
}
