import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'modules/authentication/models/daftar_organisasi_model.dart';

class OrganisasiService {
  static const String baseUrl = 'http://192.168.100.7:8000';

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

    // FILE
    File? fotoProfil,
    File? fotoSampul,
    List<File> galleryFiles = const [],
  }) async {
    final url = Uri.parse(
      '$baseUrl/mobile/daftar/organisasi/',
    );

    final request = http.MultipartRequest(
      'POST',
      url,
    );

    request.headers.addAll({
      'Accept': 'application/json',
    });

    // DATA UTAMA
    request.fields['tipe'] = 'organisasi';
    request.fields['nama_organisasi'] = namaOrganisasi;
    request.fields['tentang_organisasi'] = tentangOrganisasi;
    request.fields['wa'] = wa;
    request.fields['email'] = email;
    request.fields['lokasi'] = lokasi;
    request.fields['kategori_id'] = kategoriId.toString();
    request.fields['user_id'] = userId.toString();
    request.fields['visi'] = visi;
    request.fields['misi'] = misi;

    // JSON DATA
    request.fields['prestasi'] =
        jsonEncode(prestasi);

    request.fields['departemen'] =
        jsonEncode(departemen);

    request.fields['gallery'] =
        jsonEncode(gallery);

    // FOTO PROFIL
    if (fotoProfil != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'foto_profil',
          fotoProfil.path,
        ),
      );
    }

    // FOTO SAMPUL
    if (fotoSampul != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'foto_sampul',
          fotoSampul.path,
        ),
      );
    }

    // GALERI KEGIATAN
    for (final image in galleryFiles) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'gallery_files',
          image.path,
        ),
      );
    }

    final streamedResponse =
        await request.send();

    final response =
        await http.Response.fromStream(
      streamedResponse,
    );

    final responseBody =
        jsonDecode(response.body);

    return DaftarOrg.fromJson(
      responseBody,
    );
  }
}