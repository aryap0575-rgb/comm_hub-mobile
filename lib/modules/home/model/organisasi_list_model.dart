class OrganisasiListResponse {
  final List<OrganisasiItem> data;
  final Metadata? metadata;

  OrganisasiListResponse({
    required this.data,
    this.metadata,
  });

  factory OrganisasiListResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];

    List<OrganisasiItem> list = [];

    if (rawData is List) {
      list = rawData
          .map(
            (item) => OrganisasiItem.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList();
    }

    return OrganisasiListResponse(
      data: list,
      metadata: json['metadata'] != null
          ? Metadata.fromJson(
              Map<String, dynamic>.from(json['metadata']),
            )
          : null,
    );
  }
}

class OrganisasiItem {
  final int? id;
  final String? name;
  final String? nama;
  final String? tentangOrganisasi;
  final String? lokasi;
  final KategoriItem? kategori;
  final FotoItem? foto;

  OrganisasiItem({
    this.id,
    this.name,
    this.nama,
    this.tentangOrganisasi,
    this.lokasi,
    this.kategori,
    this.foto,
  });

  factory OrganisasiItem.fromJson(Map<String, dynamic> json) {
    return OrganisasiItem(
      id: _toNullableInt(json['id']),
      name: _toNullableString(json['name']),
      nama: _toNullableString(
        json['nama'] ?? json['nama_organisasi'],
      ),
      tentangOrganisasi: _toNullableString(
        json['tentang_organisasi'] ?? json['description'],
      ),
      lokasi: _toNullableString(
        json['lokasi'] ?? json['lokasi_sekretariat'],
      ),
      kategori: json['kategori'] != null
          ? KategoriItem.fromJson(
              Map<String, dynamic>.from(json['kategori']),
            )
          : null,
      foto: json['foto'] != null
          ? FotoItem.fromJson(
              Map<String, dynamic>.from(json['foto']),
            )
          : FotoItem(
              sampul: _toNullableString(json['sampul']),
              logo: _toNullableString(json['foto_profile']),
            ),
    );
  }
}

class KategoriItem {
  final int? id;
  final String? category;
  final String? namaKategori;

  KategoriItem({
    this.id,
    this.category,
    this.namaKategori,
  });

  factory KategoriItem.fromJson(Map<String, dynamic> json) {
    return KategoriItem(
      id: _toNullableInt(json['id']),
      category: _toNullableString(
        json['category'] ?? json['kategori'] ?? json['nama_kategori'],
      ),
      namaKategori: _toNullableString(json['nama_kategori']),
    );
  }
}

class FotoItem {
  final String? sampul;
  final String? logo;

  FotoItem({
    this.sampul,
    this.logo,
  });

  factory FotoItem.fromJson(Map<String, dynamic> json) {
    return FotoItem(
      sampul: _toNullableString(json['sampul']),
      logo: _toNullableString(
        json['logo'] ?? json['foto_profile'],
      ),
    );
  }
}

class Metadata {
  final int? code;
  final String? message;

  Metadata({
    this.code,
    this.message,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(
      code: _toNullableInt(json['code'] ?? json['status_code']),
      message: _toNullableString(json['message']),
    );
  }
}

int? _toNullableInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) return int.tryParse(value);
  return null;
}

String? _toNullableString(dynamic value) {
  if (value == null) return null;

  final text = value.toString().trim();

  if (text.isEmpty || text == 'null') {
    return null;
  }

  return text;
}