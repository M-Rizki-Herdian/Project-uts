import 'dart:convert';
import 'package:http/http.dart' as http;
import 'santri_model.dart';

class ApiService {
  static const String baseUrl = 'https://6734513ca042ab85d1199e93.mockapi.io/santri/v1';

  Future<List<Santri>> getSantri() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((json) => Santri.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> createSantri(Santri santri) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(santri.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create data');
    }
  }

  Future<void> updateSantri(Santri santri) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${santri.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(santri.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update data');
    }
  }

  Future<void> deleteSantri(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete data');
    }
  }
}
