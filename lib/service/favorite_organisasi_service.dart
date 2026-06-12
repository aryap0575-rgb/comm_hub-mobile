import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:com.example.fincome_mobile_mobile/modules/url/urls.dart';

class FavoriteOrganisasiService {
  static String get baseUrl => Urls().mainUrl;

  static Future<String?> _getUserId() async {
    const storage = FlutterSecureStorage();

    final userId = await storage.read(key: 'user_id');
    final idUser = await storage.read(key: 'id_user');
    final id = await storage.read(key: 'id');
    final userIdCamel = await storage.read(key: 'userId');

    print('CEK STORAGE user_id: $userId');
    print('CEK STORAGE id_user: $idUser');
    print('CEK STORAGE id: $id');
    print('CEK STORAGE userId: $userIdCamel');

    return userId ?? idUser ?? id ?? userIdCamel;
  }

  static Future<String> getCurrentUserId() async {
    final userIdString = await _getUserId();

    if (userIdString == null || userIdString.isEmpty) {
      throw Exception(
        'User ID tidak ditemukan. Silakan logout lalu login ulang.',
      );
    }

    return userIdString;
  }

  static Future<Map<String, dynamic>> setFavorite({
    required int organisasiId,
    required bool isFavorit,
  }) async {
    final userIdString = await getCurrentUserId();

    final response = await http.post(
      Urls().favoritOrganisasi(),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'organisasi_id': organisasiId,
        'user_id': int.parse(userIdString),
        'is_favorit': isFavorit,
      }),
    );

    print('STATUS FAVORITE: ${response.statusCode}');
    print('BODY FAVORITE: ${response.body}');

    if (!response.body.trim().startsWith('{')) {
      throw Exception('API favorit tidak mengembalikan JSON.');
    }

    final Map<String, dynamic> body = jsonDecode(response.body);

    final metadata = body['metadata'];
    final dynamic code =
        metadata?['code'] ?? metadata?['status'] ?? response.statusCode;

    final String message =
        metadata?['message']?.toString() ?? 'Gagal mengubah favorit.';

    final bool httpOk =
        response.statusCode == 200 || response.statusCode == 201;

    final bool metadataOk = code == 200 ||
        code == 201 ||
        code.toString() == '200' ||
        code.toString() == '201';

    if (!httpOk || !metadataOk) {
      throw Exception(message);
    }

    return body;
  }

  static Future<Set<int>> getFavoriteIds() async {
    final userIdString = await getCurrentUserId();

    final response = await http.get(
      Urls().favoritOrganisasiByUser(int.parse(userIdString)),
      headers: {
        'Accept': 'application/json',
      },
    );

    print('STATUS GET FAVORITE IDS: ${response.statusCode}');
    print('BODY GET FAVORITE IDS: ${response.body}');

    if (!response.body.trim().startsWith('{')) {
      throw Exception('API favorit user tidak mengembalikan JSON.');
    }

    final Map<String, dynamic> body = jsonDecode(response.body);

    final metadata = body['metadata'];
    final dynamic code =
        metadata?['code'] ?? metadata?['status'] ?? response.statusCode;

    final bool httpOk = response.statusCode == 200;
    final bool metadataOk = code == 200 || code.toString() == '200';

    if (!httpOk || !metadataOk) {
      throw Exception(
        metadata?['message']?.toString() ?? 'Gagal mengambil data favorit.',
      );
    }

    final List favoriteList = body['data'] ?? [];

    return favoriteList
        .map((item) => item['id'])
        .where((id) => id != null)
        .map<int>((id) => int.parse(id.toString()))
        .toSet();
  }
}
