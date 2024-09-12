//import http
import 'dart:convert';
import 'package:http/http.dart' as http;

class AiratableService {
  static const String _baseUrl =
      'https://api.airtable.com/v0/appwz8YV2k3zQ5Q9E';

  final String baseID;
  final String apiKey;

  AiratableService({required this.baseID, required this.apiKey});

  //TODO: add all airtable reusable functions(CRUD);

  //fetch records with filter
  Future<List<dynamic>> fetchRecords(String tableName,
      {String? filterByFormula, int? maxRecords, int? pageSize}) async {
    final url = '$_baseUrl/$tableName';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['records'];
    } else {
      throw Exception('Failed to fetch records');
    }
  }
}
