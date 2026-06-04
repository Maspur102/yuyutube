import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class ApiService {
  Future<List<dynamic>> getTrending() async {
    try {
      final response = await http.get(Uri.parse('${Constants.baseUrl}/trending'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Server menolak (Kode: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Kesalahan Jaringan: $e');
    }
  }

  Future<List<dynamic>> searchVideos(String query) async {
    try {
      final response = await http.get(Uri.parse('${Constants.baseUrl}/search?q=$query'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Server menolak (Kode: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Kesalahan Jaringan: $e');
    }
  }

  Future<Map<String, dynamic>> getVideoDetail(String id) async {
    try {
      final response = await http.get(Uri.parse('${Constants.baseUrl}/videos/$id'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Server menolak (Kode: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Kesalahan Jaringan: $e');
    }
  }
}