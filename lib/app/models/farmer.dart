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
  final String? dateOfBirth;
  final String? phoneNumber;
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
    this.dateOfBirth,
    this.phoneNumber,
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
      if (record.id == null || record.id!.trim().isEmpty) {
        throw FarmerParsingException('Record ID is required');
      }
      if (fields == null) {
        throw FarmerParsingException('Fields map is null');
      }

      final farmerId = fields['ID'];
      final firstName = fields['First Name'];
      final lastName = fields['Last Name'];
      final gender = fields['Gender'];

      if (farmerId is! String || farmerId.trim().isEmpty) {
        throw FarmerParsingException('ID is required');
      }
      if (firstName is! String || firstName.trim().isEmpty) {
        throw FarmerParsingException('First Name is required');
      }
      if (lastName is! String || lastName.trim().isEmpty) {
        throw FarmerParsingException('Last Name is required');
      }
      if (gender is! String || gender.trim().isEmpty) {
        throw FarmerParsingException('Gender is required');
      }

      return Farmer(
        id: record.id,
        farmerId: farmerId,
        firstName: firstName,
        lastName: lastName,
        gender: gender,
        dateOfBirth:
            fields['Date of Birth'] is String ? fields['Date of Birth'] : null,
        phoneNumber:
            fields['Phone Number'] is String ? fields['Phone Number'] : null,
        fullFarmerId:
            fields['Farmer ID'] is String ? fields['Farmer ID'] : null,
        farmerGardens:
            fields['FarmerGardens'] is String ? fields['FarmerGardens'] : null,
        registeredFrom:
            fields['Registered From'] is String
                ? fields['Registered From']
                : null,
        registeredDate:
            fields['Registered'] is String ? fields['Registered'] : null,
        seasons:
            fields['Seasons'] is List
                ? (fields['Seasons'] as List).whereType<String>().toList()
                : null,
        yearOfRegistration:
            fields['Year of registration'] is String
                ? fields['Year of registration']
                : null,
        lastModified: fields['last mod'] is String ? fields['last mod'] : null,
      );
    } catch (e) {
      throw FarmerParsingException('Failed to parse Farmer from Airtable: $e');
    }
  }

  factory Farmer.fromJson(Map<String, dynamic> json) {
    try {
      final id = json['id'];
      final farmerId = json['farmerId'];
      final firstName = json['firstName'];
      final lastName = json['lastName'];
      final gender = json['gender'];

      if (id == null || id is! String || id.trim().isEmpty) {
        throw FarmerParsingException('id is required');
      }
      if (farmerId == null || farmerId is! String || farmerId.trim().isEmpty) {
        throw FarmerParsingException('farmerId is required');
      }
      if (firstName == null ||
          firstName is! String ||
          firstName.trim().isEmpty) {
        throw FarmerParsingException('firstName is required');
      }
      if (lastName == null || lastName is! String || lastName.trim().isEmpty) {
        throw FarmerParsingException('lastName is required');
      }
      if (gender == null || gender is! String || gender.trim().isEmpty) {
        throw FarmerParsingException('gender is required');
      }

      return Farmer(
        id: id,
        farmerId: farmerId,
        firstName: firstName,
        lastName: lastName,
        gender: gender,
        dateOfBirth: json['dateOfBirth'] as String?,
        phoneNumber: json['phoneNumber'] as String?,
        fullFarmerId: json['fullFarmerId'] as String?,
        farmerGardens: json['farmerGardens'] as String?,
        registeredFrom: json['registeredFrom'] as String?,
        registeredDate: json['registeredDate'] as String?,
        seasons:
            (json['seasons'] as List<dynamic>?)?.whereType<String>().toList(),
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
}
