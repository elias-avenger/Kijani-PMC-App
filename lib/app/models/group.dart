import 'package:airtable_crud/airtable_plugin.dart';

class GroupParsingException implements Exception {
  final String message;
  GroupParsingException(this.message);

  @override
  String toString() => 'GroupParsingException: $message';
}

class Group {
  final String id; // "ID" field
  final String name; // "Group Name"
  final String parishId; // "Parish ID"
  final String coordinates; // First in "Coordinates"
  final String? parish; // "Parish"
  final int? no; // "No_"
  final int? seasonsCount; // "Seasons_count"
  final String recordId; // Airtable record.id

  Group({
    required this.id,
    required this.name,
    required this.parishId,
    required this.coordinates,
    required this.recordId,
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

      final id = fields['ID'];
      if (id == null || id is! String || id.trim().isEmpty) {
        throw GroupParsingException(
          '"ID" field is required and must be a non-empty String',
        );
      }

      final name = fields['Group Name'];
      if (name == null || name is! String) {
        throw GroupParsingException(
          '"Group Name" is required and must be a String',
        );
      }

      final parishId = fields['Parish ID'];
      if (parishId == null || parishId is! String) {
        throw GroupParsingException(
          '"Parish ID" is required and must be a String',
        );
      }

      String coordinates = '';
      if (fields['Coordinates'] is List &&
          (fields['Coordinates'] as List).isNotEmpty) {
        final coords = fields['Coordinates'] as List;
        if (coords.first is String) {
          coordinates = coords.first;
        }
      }

      return Group(
        id: id,
        name: name,
        parishId: parishId.trim(),
        coordinates: coordinates,
        parish: fields['Parish'] is String ? fields['Parish'] : null,
        no: fields['No_'] is int ? fields['No_'] : null,
        seasonsCount:
            fields['Seasons_count'] is int ? fields['Seasons_count'] : null,
        recordId: record.id,
      );
    } catch (e) {
      throw GroupParsingException('Failed to parse Group from Airtable: $e');
    }
  }

  factory Group.fromJson(Map<String, dynamic> json) {
    try {
      return Group(
        recordId: json['recordId'] ?? '',
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        parishId: json['parishId'] ?? '',
        coordinates: json['coordinates'] ?? '',
        parish: json['parish'],
        no: json['no'],
        seasonsCount: json['seasonsCount'],
      );
    } catch (e) {
      throw GroupParsingException('Failed to parse Group from JSON: $e');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'recordId': recordId,
      'id': id,
      'name': name,
      'parishId': parishId,
      'coordinates': coordinates,
      'parish': parish,
      'no': no,
      'seasonsCount': seasonsCount,
    };
  }
}
