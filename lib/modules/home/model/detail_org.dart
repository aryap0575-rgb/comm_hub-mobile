class DetailOrg {
  final DetailOrgData? data;
  final Metadata? metadata;

  DetailOrg({
    this.data,
    this.metadata,
  });

  factory DetailOrg.fromJson(Map<String, dynamic> json) {
    return DetailOrg(
      data: json['data'] != null
          ? DetailOrgData.fromJson(
              Map<String, dynamic>.from(json['data']),
            )
          : null,
      metadata: json['metadata'] != null
          ? Metadata.fromJson(
              Map<String, dynamic>.from(json['metadata']),
            )
          : null,
    );
  }
}

class DetailOrgData {
  final OrganisasiDetail? organisasi;
  final List<DepartemenOrg> departemen;
  final List<PrestasiOrg> prestasi;
  final List<GalleryOrg> gallery;
  final bool isFavorit;
  final int totalDepartemen;
  final int totalPrestasi;
  final int totalGallery;

  DetailOrgData({
    this.organisasi,
    required this.departemen,
    required this.prestasi,
    required this.gallery,
    required this.isFavorit,
    required this.totalDepartemen,
    required this.totalPrestasi,
    required this.totalGallery,
  });

  factory DetailOrgData.fromJson(Map<String, dynamic> json) {
    return DetailOrgData(
      organisasi: json['organisasi'] != null
          ? OrganisasiDetail.fromJson(
              Map<String, dynamic>.from(json['organisasi']),
            )
          : null,
      departemen: json['departemen'] is List
          ? (json['departemen'] as List)
              .map(
                (item) => DepartemenOrg.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList()
          : [],
      prestasi: json['prestasi'] is List
          ? (json['prestasi'] as List)
              .map(
                (item) => PrestasiOrg.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList()
          : [],
      gallery: json['gallery'] is List
          ? (json['gallery'] as List)
              .map(
                (item) => GalleryOrg.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList()
          : [],
      isFavorit: json['is_favorit'] ?? false,
      totalDepartemen: _toInt(json['total_departemen']),
      totalPrestasi: _toInt(json['total_prestasi']),
      totalGallery: _toInt(json['total_gallery']),
    );
  }
}

class OrganisasiDetail {
  final int id;
  final String namaOrganisasi;
  final String tentangOrganisasi;
  final KategoriOrg? kategori;
  final UserOrg? user;
  final String visi;
  final String misi;
  final String wa;
  final String emailOrganisasi;
  final String lokasiSekretariat;
  final String? fotoProfile;
  final String? sampul;
  final bool isActive;
  final String? creationDate;
  final String? updateDate;

  OrganisasiDetail({
    required this.id,
    required this.namaOrganisasi,
    required this.tentangOrganisasi,
    this.kategori,
    this.user,
    required this.visi,
    required this.misi,
    required this.wa,
    required this.emailOrganisasi,
    required this.lokasiSekretariat,
    this.fotoProfile,
    this.sampul,
    required this.isActive,
    this.creationDate,
    this.updateDate,
  });

  factory OrganisasiDetail.fromJson(Map<String, dynamic> json) {
    return OrganisasiDetail(
      id: _toInt(json['id']),
      namaOrganisasi: _toString(json['nama_organisasi']),
      tentangOrganisasi: _toString(json['tentang_organisasi']),
      kategori: json['kategori'] != null
          ? KategoriOrg.fromJson(
              Map<String, dynamic>.from(json['kategori']),
            )
          : null,
      user: json['user'] != null
          ? UserOrg.fromJson(
              Map<String, dynamic>.from(json['user']),
            )
          : null,
      visi: _toString(json['visi']),
      misi: _toString(json['misi']),
      wa: _toString(json['wa']),
      emailOrganisasi: _toString(json['email_organisasi']),
      lokasiSekretariat: _toString(json['lokasi_sekretariat']),
      fotoProfile: _toNullableString(json['foto_profile']),
      sampul: _toNullableString(json['sampul']),
      isActive: json['is_active'] ?? false,
      creationDate: _toNullableString(json['creation_date']),
      updateDate: _toNullableString(json['update_date']),
    );
  }
}

class KategoriOrg {
  final int id;
  final String namaKategori;
  final String kategori;

  KategoriOrg({
    required this.id,
    required this.namaKategori,
    required this.kategori,
  });

  factory KategoriOrg.fromJson(Map<String, dynamic> json) {
    return KategoriOrg(
      id: _toInt(json['id']),
      namaKategori: _toString(json['nama_kategori']),
      kategori: _toString(json['kategori']),
    );
  }

  String get displayName {
    if (namaKategori.isNotEmpty) return namaKategori;
    if (kategori.isNotEmpty) return kategori;
    return 'Kategori';
  }
}

class UserOrg {
  final int id;
  final String username;
  final String email;
  final bool isValidate;
  final bool isActive;

  UserOrg({
    required this.id,
    required this.username,
    required this.email,
    required this.isValidate,
    required this.isActive,
  });

  factory UserOrg.fromJson(Map<String, dynamic> json) {
    return UserOrg(
      id: _toInt(json['id']),
      username: _toString(json['username']),
      email: _toString(json['email']),
      isValidate: json['is_validate'] ?? false,
      isActive: json['is_active'] ?? false,
    );
  }
}

class DepartemenOrg {
  final int id;
  final String departemen;
  final String detailDepartemen;
  final bool isActive;
  final String? creationDate;
  final String? updateDate;

  DepartemenOrg({
    required this.id,
    required this.departemen,
    required this.detailDepartemen,
    required this.isActive,
    this.creationDate,
    this.updateDate,
  });

  factory DepartemenOrg.fromJson(Map<String, dynamic> json) {
    return DepartemenOrg(
      id: _toInt(json['id']),
      departemen: _toString(json['departemen']),
      detailDepartemen: _toString(json['detail_departemen']),
      isActive: json['is_active'] ?? false,
      creationDate: _toNullableString(json['creation_date']),
      updateDate: _toNullableString(json['update_date']),
    );
  }
}

class PrestasiOrg {
  final int id;
  final String prestasi;
  final String detailPrestasi;
  final bool isActive;
  final String? creationDate;
  final String? updateDate;

  PrestasiOrg({
    required this.id,
    required this.prestasi,
    required this.detailPrestasi,
    required this.isActive,
    this.creationDate,
    this.updateDate,
  });

  factory PrestasiOrg.fromJson(Map<String, dynamic> json) {
    return PrestasiOrg(
      id: _toInt(json['id']),
      prestasi: _toString(json['prestasi']),
      detailPrestasi: _toString(json['detail_prestasi']),
      isActive: json['is_active'] ?? false,
      creationDate: _toNullableString(json['creation_date']),
      updateDate: _toNullableString(json['update_date']),
    );
  }
}

class GalleryOrg {
  final int id;
  final String informasi;
  final String? foto;
  final bool isActive;
  final String? creationDate;
  final String? updateDate;

  GalleryOrg({
    required this.id,
    required this.informasi,
    this.foto,
    required this.isActive,
    this.creationDate,
    this.updateDate,
  });

  factory GalleryOrg.fromJson(Map<String, dynamic> json) {
    return GalleryOrg(
      id: _toInt(json['id']),
      informasi: _toString(json['informasi']),
      foto: _toNullableString(json['foto']),
      isActive: json['is_active'] ?? false,
      creationDate: _toNullableString(json['creation_date']),
      updateDate: _toNullableString(json['update_date']),
    );
  }
}

class Metadata {
  final int code;
  final String message;

  Metadata({
    required this.code,
    required this.message,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(
      code: _toInt(json['code'] ?? json['status_code']),
      message: _toString(json['message']),
    );
  }
}

int _toInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

String _toString(dynamic value) {
  if (value == null) return '';
  return value.toString();
}

String? _toNullableString(dynamic value) {
  if (value == null) return null;

  final text = value.toString().trim();

  if (text.isEmpty || text == 'null') {
    return null;
  }

  return text;
}