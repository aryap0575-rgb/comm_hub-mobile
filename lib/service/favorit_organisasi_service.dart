import 'dart:convert';

import 'package:http/http.dart' as http;

class FavoritOrganisasiService {
  // GANTI IP INI SESUAI IP LAPTOP KAMU
  static const String baseUrl = 'http://192.168.1.2:8000';

  static Future<bool> simpanFavorit({
    required int organisasiId,
    required int userId,
  }) async {
    final url = Uri.parse('$baseUrl/mobile/organisasi/favorit/');

    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
      },
      body: {
        'organisasi_id': organisasiId.toString(),
        'user_id': userId.toString(),
      },
    );

    print('STATUS FAVORIT: ${response.statusCode}');
    print('BODY FAVORIT: ${response.body}');

    if (!response.body.trim().startsWith('{')) {
      throw Exception('API favorit tidak mengembalikan JSON');
    }

    final body = jsonDecode(response.body);
    final code = body['metadata']?['code'];

    return code == 200 || code == 201;
  }
}
