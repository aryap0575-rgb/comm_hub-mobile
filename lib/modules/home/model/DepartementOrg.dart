class DepartementOrg {
  List<Data>? data;
  Metadata? metadata;

  DepartementOrg({this.data, this.metadata});

  DepartementOrg.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    metadata = json['metadata'] != null
        ? new Metadata.fromJson(json['metadata'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.metadata != null) {
      data['metadata'] = this.metadata!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? departemen;
  String? detailDepartemen;
  bool? isActive;
  int? idOrganisasi;
  String? namaOrganisasi;
  String? creationDate;
  String? updateDate;

  Data(
      {this.id,
      this.departemen,
      this.detailDepartemen,
      this.isActive,
      this.idOrganisasi,
      this.namaOrganisasi,
      this.creationDate,
      this.updateDate});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    departemen = json['departemen'];
    detailDepartemen = json['detail_departemen'];
    isActive = json['is_active'];
    idOrganisasi = json['id_organisasi'];
    namaOrganisasi = json['nama_organisasi'];
    creationDate = json['creation_date'];
    updateDate = json['update_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['departemen'] = this.departemen;
    data['detail_departemen'] = this.detailDepartemen;
    data['is_active'] = this.isActive;
    data['id_organisasi'] = this.idOrganisasi;
    data['nama_organisasi'] = this.namaOrganisasi;
    data['creation_date'] = this.creationDate;
    data['update_date'] = this.updateDate;
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
