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
      if (record == null) {
        throw GroupParsingException('Airtable record is null');
      }
      final fields = record.fields;
      if (fields == null) {
        throw GroupParsingException('Fields map is null in Airtable record');
      }

      final id = record.id;
      if (id == null || id.isEmpty) {
        throw GroupParsingException('Record ID is missing or empty');
      }

      final name = fields['Group Name'];
      if (name != null && name is! String) {
        throw GroupParsingException(
          'Group Name must be a String, got ${name.runtimeType}',
        );
      }

      final parishId = fields['Parish ID'];
      if (parishId != null && parishId is! String) {
        throw GroupParsingException(
          'Parish ID must be a String, got ${parishId.runtimeType}',
        );
      }

      // Handle Coordinates with improved error checking
      String coordinates = '';
      final coordinatesList = fields['Coordinates'];
      if (coordinatesList != null) {
        if (coordinatesList is! List<dynamic>) {
          throw GroupParsingException(
            'Coordinates must be a List, got ${coordinatesList.runtimeType}',
          );
        }
        if (coordinatesList.isNotEmpty) {
          final firstCoord = coordinatesList.first;
          if (firstCoord != null && firstCoord is String) {
            coordinates = firstCoord;
          } else {
            print(
              'Warning: First Coordinate is null or not a String (${firstCoord.runtimeType}), using empty string',
            );
          }
        }
      }

      String? parish;
      final parishValue = fields['Parish'];
      if (parishValue != null) {
        if (parishValue is! String) {
          print(
            'Warning: Parish should be a String, got ${parishValue.runtimeType}, ignoring',
          );
        } else {
          parish = parishValue;
        }
      }

      int? no;
      final noValue = fields['No_'];
      if (noValue != null) {
        if (noValue is! int) {
          print(
            'Warning: No_ should be an int, got ${noValue.runtimeType}, ignoring',
          );
        } else {
          no = noValue;
        }
      }

      int? seasonsCount;
      final seasonsCountValue = fields['Seasons_count'];
      if (seasonsCountValue != null) {
        if (seasonsCountValue is! int) {
          print(
            'Warning: Seasons_count should be an int, got ${seasonsCountValue.runtimeType}, ignoring',
          );
        } else {
          seasonsCount = seasonsCountValue;
        }
      }

      return Group(
        id: id,
        name: name as String? ?? '',
        parishId: parishId as String? ?? '',
        coordinates: coordinates,
        parish: parish,
        no: no,
        seasonsCount: seasonsCount,
      );
    } catch (e) {
      throw GroupParsingException('Failed to parse Group from Airtable: $e');
    }
  }

  factory Group.fromJson(Map<String, dynamic> json) {
    try {
      if (json == null) {
        throw GroupParsingException('JSON map is null');
      }

      final id = json['id'];
      if (id == null || id is! String || (id as String).isEmpty) {
        throw GroupParsingException('id is missing, not a String, or empty');
      }

      final name = json['name'];
      if (name == null || name is! String) {
        throw GroupParsingException('name is missing or not a String');
      }

      final parishId = json['parishId'];
      if (parishId == null || parishId is! String) {
        throw GroupParsingException('parishId is missing or not a String');
      }

      final coordinates = json['coordinates'];
      if (coordinates == null || coordinates is! String) {
        throw GroupParsingException('coordinates is missing or not a String');
      }

      String? parish;
      final parishValue = json['parish'];
      if (parishValue != null && parishValue is! String) {
        print(
          'Warning: parish should be a String, got ${parishValue.runtimeType}, ignoring',
        );
      } else {
        parish = parishValue as String?;
      }

      int? no;
      final noValue = json['no'];
      if (noValue != null && noValue is! int) {
        print(
          'Warning: no should be an int, got ${noValue.runtimeType}, ignoring',
        );
      } else {
        no = noValue as int?;
      }

      int? seasonsCount;
      final seasonsCountValue = json['seasonsCount'];
      if (seasonsCountValue != null && seasonsCountValue is! int) {
        print(
          'Warning: seasonsCount should be an int, got ${seasonsCountValue.runtimeType}, ignoring',
        );
      } else {
        seasonsCount = seasonsCountValue as int?;
      }

      return Group(
        id: id,
        name: name,
        parishId: parishId,
        coordinates: coordinates,
        parish: parish,
        no: no,
        seasonsCount: seasonsCount,
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
}
