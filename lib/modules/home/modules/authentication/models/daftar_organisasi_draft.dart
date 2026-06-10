import 'dart:io';

class DaftarOrganisasiDraft {
  final String namaOrganisasi;
  final String tentangOrganisasi;
  final int kategoriId;
  final int userId;
  final String visi;
  final String misi;

  final String wa;
  final String email;
  final String lokasi;

  final List<Map<String, dynamic>> prestasi;
  final List<Map<String, dynamic>> departemen;
  final List<Map<String, dynamic>> gallery;

  // BARU
  final File? fotoProfil;
  final File? fotoSampul;
  final List<File> galleryFiles;

  DaftarOrganisasiDraft({
    required this.namaOrganisasi,
    required this.tentangOrganisasi,
    required this.kategoriId,
    required this.userId,
    required this.visi,
    required this.misi,
    this.wa = '',
    this.email = '',
    this.lokasi = '',
    this.prestasi = const [],
    this.departemen = const [],
    this.gallery = const [],

    // BARU
    this.fotoProfil,
    this.fotoSampul,
    this.galleryFiles = const [],
  });

  DaftarOrganisasiDraft copyWith({
    String? namaOrganisasi,
    String? tentangOrganisasi,
    int? kategoriId,
    int? userId,
    String? visi,
    String? misi,
    String? wa,
    String? email,
    String? lokasi,
    List<Map<String, dynamic>>? prestasi,
    List<Map<String, dynamic>>? departemen,
    List<Map<String, dynamic>>? gallery,

    // BARU
    File? fotoProfil,
    File? fotoSampul,
    List<File>? galleryFiles,
  }) {
    return DaftarOrganisasiDraft(
      namaOrganisasi: namaOrganisasi ?? this.namaOrganisasi,
      tentangOrganisasi: tentangOrganisasi ?? this.tentangOrganisasi,
      kategoriId: kategoriId ?? this.kategoriId,
      userId: userId ?? this.userId,
      visi: visi ?? this.visi,
      misi: misi ?? this.misi,
      wa: wa ?? this.wa,
      email: email ?? this.email,
      lokasi: lokasi ?? this.lokasi,
      prestasi: prestasi ?? this.prestasi,
      departemen: departemen ?? this.departemen,
      gallery: gallery ?? this.gallery,

      // BARU
      fotoProfil: fotoProfil ?? this.fotoProfil,
      fotoSampul: fotoSampul ?? this.fotoSampul,
      galleryFiles: galleryFiles ?? this.galleryFiles,
    );
  }
}