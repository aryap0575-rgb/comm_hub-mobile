import 'dart:convert';
import 'package:com.example.fincome_mobile_mobile/modules/home/modules/detailorg.dart';
import 'package:http/http.dart' as http;

// SESUAIKAN PATH MODEL INI
import 'package:com.example.fincome_mobile_mobile/modules/home/model/detail_org.dart';

class DetailOrganisasiService {
  // GANTI IP INI SESUAI IP LAPTOP KAMU
  static const String baseUrl = 'http://192.168.1.2:8000';

  static Future<DetailOrg> getSemuaOrganisasi() async {
    final url = Uri.parse('$baseUrl/mobile/organisasi/');

    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
      },
    );

    print('STATUS GET ORGANISASI: ${response.statusCode}');
    print('BODY GET ORGANISASI: ${response.body}');

    if (!response.body.trim().startsWith('{')) {
      throw Exception(
        'API tidak mengembalikan JSON. Cek URL API atau terminal Django.',
      );
    }

    final Map<String, dynamic> body = jsonDecode(response.body);

    return DetailOrg.fromJson(body);
  }
}