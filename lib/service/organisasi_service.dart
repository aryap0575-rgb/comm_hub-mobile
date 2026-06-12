import 'dart:convert';
import 'dart:io';

import 'package:com.example.fincome_mobile_mobile/service/modules/authentication/models/daftar_organisasi_model.dart';
import 'package:http/http.dart' as http;

// SESUAIKAN PATH INI DENGAN LOKASI FILE MODEL DaftarOrg KAMU
import 'package:com.example.fincome_mobile_mobile/modules/home/modules/authentication/models/daftar_org.dart';

class OrganisasiService {
  // GANTI IP INI DENGAN IP LAPTOP KAMU
  // Jangan pakai localhost kalau jalan di HP fisik
  static const String _url =
      'http://192.168.1.2:8000/mobile/daftar/organisasi/';

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
    required List<Map<String, dynamic>> prestasi,
    required List<Map<String, dynamic>> departemen,
    required List<Map<String, dynamic>> gallery,
    File? fotoProfil,
    File? fotoSampul,
    List<File> galleryFiles = const [],
  }) async {
    try {
      // =========================================================
      // 1. KIRIM DATA ORGANISASI + FOTO PROFIL + SAMPUL
      // =========================================================
      final organisasiRequest = http.MultipartRequest(
        'POST',
        Uri.parse(_url),
      );

      organisasiRequest.fields['tipe'] = 'organisasi';
      organisasiRequest.fields['nama_organisasi'] = namaOrganisasi;
      organisasiRequest.fields['tentang_organisasi'] = tentangOrganisasi;
      organisasiRequest.fields['kategori_id'] = kategoriId.toString();
      organisasiRequest.fields['user_id'] = userId.toString();
      organisasiRequest.fields['visi'] = visi;
      organisasiRequest.fields['misi'] = misi;
      organisasiRequest.fields['wa'] = wa;
      organisasiRequest.fields['email'] = email;
      organisasiRequest.fields['lokasi'] = lokasi;

      // Backend membaca:
      // request.FILES.get('foto_profile')
      if (fotoProfil != null) {
        organisasiRequest.files.add(
          await http.MultipartFile.fromPath(
            'foto_profile',
            fotoProfil.path,
          ),
        );
      }

      // Backend membaca:
      // request.FILES.get('sampul')
      if (fotoSampul != null) {
        organisasiRequest.files.add(
          await http.MultipartFile.fromPath(
            'sampul',
            fotoSampul.path,
          ),
        );
      }

      final organisasiStream = await organisasiRequest.send();
      final organisasiResponse = await http.Response.fromStream(
        organisasiStream,
      );

      print('STATUS ORGANISASI: ${organisasiResponse.statusCode}');
      print('BODY ORGANISASI: ${organisasiResponse.body}');

      final Map<String, dynamic> organisasiBody = jsonDecode(
        organisasiResponse.body,
      );

      final organisasiResult = DaftarOrg.fromJson(organisasiBody);

      if (organisasiResult.metadata?.code != 200 &&
          organisasiResult.metadata?.code != 201) {
        return organisasiResult;
      }

      final organisasiId = organisasiResult.data?.id;

      if (organisasiId == null) {
        return DaftarOrg(
          data: null,
          metadata: Metadata(
            code: 500,
            message:
                'Organisasi berhasil dibuat, tetapi ID organisasi tidak ditemukan.',
          ),
        );
      }

      // =========================================================
      // 2. KIRIM DEPARTEMEN SATU PER SATU
      // =========================================================
      for (final item in departemen) {
        final namaDepartemen = item['departemen']?.toString().trim() ?? '';
        final detailDepartemen =
            item['detail_departemen']?.toString().trim() ?? '';

        if (namaDepartemen.isEmpty) {
          continue;
        }

        final response = await http.post(
          Uri.parse(_url),
          body: {
            'tipe': 'departemen',
            'organisasi_id': organisasiId.toString(),
            'departemen': namaDepartemen,
            'detail_departemen': detailDepartemen,
            'is_active': '${item['is_active'] ?? true}',
          },
        );

        print('STATUS DEPARTEMEN: ${response.statusCode}');
        print('BODY DEPARTEMEN: ${response.body}');
      }

      // =========================================================
      // 3. KIRIM PRESTASI SATU PER SATU
      // =========================================================
      for (final item in prestasi) {
        final namaPrestasi = item['prestasi']?.toString().trim() ?? '';
        final detailPrestasi = item['detail_prestasi']?.toString().trim() ?? '';

        if (namaPrestasi.isEmpty) {
          continue;
        }

        final response = await http.post(
          Uri.parse(_url),
          body: {
            'tipe': 'prestasi',
            'organisasi_id': organisasiId.toString(),
            'prestasi': namaPrestasi,
            'detail_prestasi': detailPrestasi,
            'is_active': '${item['is_active'] ?? true}',
          },
        );

        print('STATUS PRESTASI: ${response.statusCode}');
        print('BODY PRESTASI: ${response.body}');
      }

      // =========================================================
      // 4. KIRIM FOTO GALLERY SATU PER SATU
      // =========================================================
      for (int i = 0; i < galleryFiles.length; i++) {
        final galleryRequest = http.MultipartRequest(
          'POST',
          Uri.parse(_url),
        );

        String informasi = 'Galeri Kegiatan ${i + 1}';
        String link = '';

        if (i < gallery.length) {
          informasi = gallery[i]['informasi']?.toString() ?? informasi;
          link = gallery[i]['link']?.toString() ?? '';
        }

        galleryRequest.fields['tipe'] = 'gallery';
        galleryRequest.fields['organisasi_id'] = organisasiId.toString();
        galleryRequest.fields['informasi'] = informasi;
        galleryRequest.fields['link'] = link;

        // Backend membaca:
        // request.FILES.get('foto')
        galleryRequest.files.add(
          await http.MultipartFile.fromPath(
            'foto',
            galleryFiles[i].path,
          ),
        );

        final galleryStream = await galleryRequest.send();
        final galleryResponse = await http.Response.fromStream(
          galleryStream,
        );

        print('STATUS GALLERY ${i + 1}: ${galleryResponse.statusCode}');
        print('BODY GALLERY ${i + 1}: ${galleryResponse.body}');
      }

      return organisasiResult;
    } catch (e) {
      print('ERROR DAFTAR ORGANISASI: $e');

      return DaftarOrg(
        data: null,
        metadata: Metadata(
          code: 500,
          message: 'Terjadi kesalahan Flutter: $e',
        ),
      );
    }
  }
}
