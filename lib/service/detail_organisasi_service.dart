import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:com.example.fincome_mobile_mobile/modules/home/model/detail_org.dart';
import 'package:com.example.fincome_mobile_mobile/modules/home/model/organisasi_list_model.dart';

class DetailOrganisasiService {
  static const String baseUrl = 'http://192.168.1.2:8000';

  static Future<OrganisasiListResponse> getSemuaOrganisasi() async {
    final Uri url = Uri.parse('$baseUrl/mobile/organisasi/');

    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
      },
    );

    print('URL GET SEMUA ORGANISASI: $url');
    print('STATUS GET SEMUA ORGANISASI: ${response.statusCode}');
    print('BODY GET SEMUA ORGANISASI: ${response.body}');

    if (response.body.trim().isEmpty) {
      throw Exception('Response API kosong. Cek endpoint Django.');
    }

    final Map<String, dynamic> body = _decodeResponse(response.body);

    if (response.statusCode == 200) {
      return OrganisasiListResponse.fromJson(body);
    }

    final message = body['metadata']?['message'] ??
        body['message'] ??
        'Gagal mengambil data organisasi';

    throw Exception(message);
  }

  static Future<DetailOrg> getDetailOrganisasi({
    required int organisasiId,
  }) async {
    final Uri url = Uri.parse(
      '$baseUrl/mobile/detail_organisasi/$organisasiId/',
    );

    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
      },
    );

    print('URL GET DETAIL ORGANISASI: $url');
    print('STATUS GET DETAIL ORGANISASI: ${response.statusCode}');
    print('BODY GET DETAIL ORGANISASI: ${response.body}');

    if (response.body.trim().isEmpty) {
      throw Exception('Response API kosong. Cek endpoint Django.');
    }

    final Map<String, dynamic> body = _decodeResponse(response.body);

    if (response.statusCode == 200) {
      return DetailOrg.fromJson(body);
    }

    final message = body['metadata']?['message'] ??
        body['message'] ??
        'Gagal mengambil detail organisasi';

    throw Exception(message);
  }

  static Map<String, dynamic> _decodeResponse(String responseBody) {
    try {
      final decoded = jsonDecode(responseBody);

      if (decoded is Map<String, dynamic>) {
        return decoded;
      }

      throw Exception('Format JSON bukan object.');
    } catch (e) {
      throw Exception(
        'API tidak mengembalikan JSON valid. Cek URL API atau terminal Django.',
      );
    }
  }
}
