import 'dart:convert';
import 'package:http/http.dart' as http;

// import model kamu
// sesuaikan path-nya
import 'modules/authentication/models/daftar_organisasi_model.dart';

class OrganisasiService {
  static const String baseUrl = 'http://192.168.1.2:8000';

  static Future<DaftarOrg> daftarOrganisasi({
    required String namaOrganisasi,
    required String tentangOrganisasi,
    required int kategoriId,
    required int userId,
    required String visi,
    required String misi,
    required String wa,
    required String email,
    required String lokasi,
    List<Map<String, dynamic>> prestasi = const [],
    List<Map<String, dynamic>> departemen = const [],
    List<Map<String, dynamic>> gallery = const [],
  }) async {
    final url = Uri.parse('$baseUrl/mobile/daftar/organisasi/');

    final body = {
      "tipe": "organisasi",
      "nama_organisasi": namaOrganisasi,
      "tentang_organisasi": tentangOrganisasi,
      "wa": wa,
      "email": email,
      "lokasi": lokasi,
      "kategori_id": kategoriId,
      "user_id": userId,
      "visi": visi,
      "misi": misi,
      "prestasi": prestasi,
      "departemen": departemen,
      "gallery": gallery,
    };

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode(body),
    );

    final responseBody = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return DaftarOrg.fromJson(responseBody);
    } else {
      return DaftarOrg.fromJson(responseBody);
    }
  }
}
