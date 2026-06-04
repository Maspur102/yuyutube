import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class ApiService {
  // Menambahkan Header 'User-Agent' agar server tidak mengira kita adalah Bot/Scraper
  final Map<String, String> _headers = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
    'Accept': 'application/json',
  };

  Future<List<dynamic>> getTrending() async {
    try {
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/trending'), 
        headers: _headers
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Server menolak akses (Kode: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Gagal terhubung: $e');
    }
  }

  Future<List<dynamic>> searchVideos(String query) async {
    try {
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/search?q=$query'), 
        headers: _headers
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Server menolak akses (Kode: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Gagal terhubung: $e');
    }
  }

  Future<Map<String, dynamic>> getVideoDetail(String id) async {
    try {
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/videos/$id'), 
        headers: _headers
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Server menolak akses (Kode: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Gagal terhubung: $e');
    }
  }
}