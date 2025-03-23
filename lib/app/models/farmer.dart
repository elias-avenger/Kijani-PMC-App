import 'package:airtable_crud/airtable_plugin.dart';

class FarmerParsingException implements Exception {
  final String message;
  FarmerParsingException(this.message);

  @override
  String toString() => 'FarmerParsingException: $message';
}

class Farmer {
  final String id;
  final String farmerId;
  final String firstName;
  final String lastName;
  final String gender;
  final String dateOfBirth;
  final String phoneNumber;
  final String? fullFarmerId;
  final String? farmerGardens;
  final String? registeredFrom;
  final String? registeredDate;
  final List<String>? seasons;
  final String? yearOfRegistration;
  final String? lastModified;

  Farmer({
    required this.id,
    required this.farmerId,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.dateOfBirth,
    required this.phoneNumber,
    this.fullFarmerId,
    this.farmerGardens,
    this.registeredFrom,
    this.registeredDate,
    this.seasons,
    this.yearOfRegistration,
    this.lastModified,
  });

  factory Farmer.fromAirtable(AirtableRecord record) {
    try {
      final fields = record.fields;

      return Farmer(
        id: _require(record.id, 'Record ID'),
        farmerId: _require(fields['ID'], 'ID'),
        firstName: _require(fields['First Name'], 'First Name'),
        lastName: _require(fields['Last Name'], 'Last Name'),
        gender: _require(fields['Gender'], 'Gender'),
        dateOfBirth: _require(fields['Date of Birth'], 'Date of Birth'),
        phoneNumber: _require(fields['Phone Number'], 'Phone Number'),
        fullFarmerId: _parseString(fields['Farmer ID']),
        farmerGardens: _parseString(fields['FarmerGardens']),
        registeredFrom: _parseString(fields['Registered From']),
        registeredDate: _parseString(fields['Registered']),
        seasons: _parseStringList(fields['Seasons']),
        yearOfRegistration: _parseString(fields['Year of registration']),
        lastModified: _parseString(fields['last mod']),
      );
    } catch (e) {
      throw FarmerParsingException('Failed to parse Farmer from Airtable: $e');
    }
  }

  factory Farmer.fromJson(Map<String, dynamic> json) {
    try {
      return Farmer(
        id: _require(json['id'], 'id'),
        farmerId: _require(json['farmerId'], 'farmerId'),
        firstName: _require(json['firstName'], 'firstName'),
        lastName: _require(json['lastName'], 'lastName'),
        gender: _require(json['gender'], 'gender'),
        dateOfBirth: _require(json['dateOfBirth'], 'dateOfBirth'),
        phoneNumber: _require(json['phoneNumber'], 'phoneNumber'),
        fullFarmerId: json['fullFarmerId'] as String?,
        farmerGardens: json['farmerGardens'] as String?,
        registeredFrom: json['registeredFrom'] as String?,
        registeredDate: json['registeredDate'] as String?,
        seasons:
            (json['seasons'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList(),
        yearOfRegistration: json['yearOfRegistration'] as String?,
        lastModified: json['lastModified'] as String?,
      );
    } catch (e) {
      throw FarmerParsingException('Failed to parse Farmer from JSON: $e');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'farmerId': farmerId,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
      'phoneNumber': phoneNumber,
      'fullFarmerId': fullFarmerId,
      'farmerGardens': farmerGardens,
      'registeredFrom': registeredFrom,
      'registeredDate': registeredDate,
      'seasons': seasons,
      'yearOfRegistration': yearOfRegistration,
      'lastModified': lastModified,
    };
  }

  // Helpers
  static String _require(dynamic value, String field) {
    if (value == null || value is! String || value.trim().isEmpty) {
      throw FarmerParsingException(
        '$field is required and must be a non-empty String',
      );
    }
    return value;
  }

  static String? _parseString(dynamic value) => value is String ? value : null;

  static List<String>? _parseStringList(dynamic value) {
    if (value is List) {
      return value
          .where((e) => e is String && e.trim().isNotEmpty)
          .map((e) => e as String)
          .toList();
    }
    return null;
  }
}
