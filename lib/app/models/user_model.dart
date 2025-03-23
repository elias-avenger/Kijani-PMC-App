import 'package:airtable_crud/airtable_plugin.dart';

class User {
  final String id;
  final String email;
  final String branch;
  final String parishesIDs;
  final String firstName;
  final String lastName;

  User({
    required this.id,
    required this.email,
    required this.branch,
    required this.parishesIDs,
    required this.firstName,
    required this.lastName,
  });

  // Factory for Airtable record
  factory User.fromAirtable(AirtableRecord record) {
    final fields = record.fields;
    return User(
      id: record.id ?? '',
      email: (fields['Email'] as List<dynamic>?)?.first as String? ?? '',
      branch: (fields['Branch Name'] as List<dynamic>?)?.first as String? ?? '',
      parishesIDs:
          (fields['Parishes IDs'] as List<dynamic>?)?.first as String? ?? '',
      firstName:
          (fields['First Name'] as List<dynamic>?)?.first as String? ?? '',
      lastName: (fields['Last Name'] as List<dynamic>?)?.first as String? ?? '',
    );
  }

  // Factory for local storage JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      branch: json['branch'] as String? ?? '',
      parishesIDs: json['parishesIDs'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
    );
  }

  // Convert to JSON for local storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'branch': branch,
      'parishesIDs': parishesIDs,
      'firstName': firstName,
      'lastName': lastName,
    };
  }
}
