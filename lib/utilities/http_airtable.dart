import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class HttpAirtable {
  final String apiKey;
  final String baseId;
  final String tableName;

  HttpAirtable({
    required this.apiKey,
    required this.baseId,
    required this.tableName,
  });

  Future<List<dynamic>?> fetchData() async {
    List<dynamic> data = [];
    String url = 'https://api.airtable.com/v0/$baseId/$tableName';
    Map<String, String> headers = {
      'Authorization': 'Bearer $apiKey',
    };
    try {
      String offset = '';
      do {
        final response =
            await http.get(Uri.parse('$url?offset=$offset'), headers: headers);
        if (response.statusCode != 200) {
          return null;
          // throw Exception(
          //     'Failed to fetch data from Airtable: ${response.statusCode} ${response.reasonPhrase}');
        } else {
          Map<String, dynamic> responseData = json.decode(response.body);
          data.addAll(responseData['records']);
          offset =
              responseData.containsKey('offset') ? responseData['offset'] : '';
        }
      } while (offset.isNotEmpty);
    } catch (error) {
      //print('ERROR GOT: $error');
      return null;
    }
    //print("Data: $data");
    return data;
  }

  Future<List<dynamic>?> fetchDataFromView({
    required String view,
  }) async {
    final encodedView = Uri.encodeComponent(view);

    final url = Uri.parse(
      'https://api.airtable.com/v0/$baseId/$tableName?view=$encodedView',
    );

    try {
      String offset = '';
      List<Map<String, dynamic>> finalData = [];

      do {
        final response = await http.get(
          Uri.parse('$url&offset=$offset'),
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          Map<String, dynamic> data = json.decode(response.body);
          finalData.addAll(List<Map<String, dynamic>>.from(data['records']));
          offset = data['offset'] ?? '';
        } else {
          throw Exception('Failed to load data: ${response.reasonPhrase}');
        }
      } while (offset.isNotEmpty);
      return finalData;
    } catch (e) {
      if (kDebugMode) print('Error: $e');
      throw Exception('Failed to load data: $e');
    }
  }

  Future<List<dynamic>?> fetchDataFromViewWithFilter({
    required String view,
    required String filter,
  }) async {
    final encodedView = Uri.encodeComponent(view);
    final encodedFilter = Uri.encodeComponent(filter);

    final url = Uri.parse(
      'https://api.airtable.com/v0/$baseId/$tableName?$encodedFilter&view=$encodedView',
    );

    try {
      String offset = '';
      List<Map<String, dynamic>> finalData = [];

      do {
        final response = await http.get(
          Uri.parse('$url&offset=$offset'),
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          Map<String, dynamic> data = json.decode(response.body);
          finalData.addAll(List<Map<String, dynamic>>.from(data['records']));
          offset = data['offset'] ?? '';
        } else {
          throw Exception('Failed to load data: ${response.reasonPhrase}');
        }
      } while (offset.isNotEmpty);
      return finalData;
    } catch (e) {
      if (kDebugMode) print('Error: $e');
      throw Exception('Failed to load data: $e');
    }
  }

  Future<Map> fetchDataWithFilter({
    required String filter,
    // required String view,
  }) async {
    final encodedFilter = Uri.encodeComponent(filter);
    // final encodedView = Uri.encodeComponent(view);

    final url = Uri.parse(
      'https://api.airtable.com/v0/$baseId/$tableName?filterByFormula=$encodedFilter',
    );

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        Map data = json.decode(response.body);
        print('FROM AIRTABLE: $data');
        return data;
      } else {
        throw Exception('Failed to load data: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load data: $e');
    }
  }
}
