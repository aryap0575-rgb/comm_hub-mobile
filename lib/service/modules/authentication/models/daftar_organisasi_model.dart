// TODO Implement this library.
class DaftarOrg {
  Data? data;
  Metadata? metadata;

  DaftarOrg({this.data, this.metadata});

  DaftarOrg.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    metadata = json['metadata'] != null
        ? new Metadata.fromJson(json['metadata'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.metadata != null) {
      data['metadata'] = this.metadata!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? name;
  String? tentangOrganisasi;
  String? wa;
  String? email;
  String? lokasi;
  bool? isActive;
  int? kategoriId;
  String? kategori;
  int? userId;
  String? visi;
  String? misi;
  String? logo;
  String? sampul;

  Data(
      {this.id,
      this.name,
      this.tentangOrganisasi,
      this.wa,
      this.email,
      this.lokasi,
      this.isActive,
      this.kategoriId,
      this.kategori,
      this.userId,
      this.visi,
      this.misi,
      this.logo,
      this.sampul});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    tentangOrganisasi = json['tentang_organisasi'];
    wa = json['wa'];
    email = json['email'];
    lokasi = json['lokasi'];
    isActive = json['is_active'];
    kategoriId = json['kategori_id'];
    kategori = json['kategori'];
    userId = json['user_id'];
    visi = json['visi'];
    misi = json['misi'];
    logo = json['logo'];
    sampul = json['sampul'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['tentang_organisasi'] = this.tentangOrganisasi;
    data['wa'] = this.wa;
    data['email'] = this.email;
    data['lokasi'] = this.lokasi;
    data['is_active'] = this.isActive;
    data['kategori_id'] = this.kategoriId;
    data['kategori'] = this.kategori;
    data['user_id'] = this.userId;
    data['visi'] = this.visi;
    data['misi'] = this.misi;
    data['logo'] = this.logo;
    data['sampul'] = this.sampul;
    return data;
  }
}

class Metadata {
  int? code;
  String? message;

  Metadata({this.code, this.message});

  Metadata.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    return data;
  }
}
