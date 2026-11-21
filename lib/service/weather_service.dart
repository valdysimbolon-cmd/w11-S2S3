import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const _apiKey = String.fromEnvironment('OWM_KEY');

  Future<Map<String, dynamic>> fetchWeather(String city) async {
    final uri = Uri.https('api.openweathermap.org', '/data/2.5/weather', {
      'q': city,
      'appid': _apiKey,
      'units': 'metric',
    });
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    } else if (res.statusCode == 401) {
      throw Exception('API key tidak valid (401)');
    } else if (res.statusCode == 404) {
      throw Exception('Kota tidak ditemukan (404)');
    }
    throw Exception('Gagal memuat data (${res.statusCode})');
  }
}