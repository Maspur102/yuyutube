import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class ApiService {
  // Mengambil video yang sedang trending
  Future<List<dynamic>> getTrending() async {
    final response = await http.get(Uri.parse('${Constants.baseUrl}/trending'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Gagal memuat trending');
  }

  // Melakukan pencarian video
  Future<List<dynamic>> searchVideos(String query) async {
    final response = await http.get(Uri.parse('${Constants.baseUrl}/search?q=$query'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Gagal mencari video');
  }

  // Mengambil detail spesifik video dan stream URL-nya
  Future<Map<String, dynamic>> getVideoDetail(String id) async {
    final response = await http.get(Uri.parse('${Constants.baseUrl}/videos/$id'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Gagal memuat detail video');
  }
}