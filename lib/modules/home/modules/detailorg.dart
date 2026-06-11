class DetailOrg {
  List<Data>? data;
  Metadata? metadata;

  DetailOrg({this.data, this.metadata});

  DetailOrg.fromJson(Map<String, dynamic> json) {
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
  String? name;
  String? nama;
  String? tentangOrganisasi;
  String? wa;
  String? email;
  String? lokasi;
  bool? isActive;
  Kategori? kategori;
  User? user;
  Foto? foto;
  VisiMisi? visiMisi;
  List<Prestasi>? prestasi;
  List<Departemen>? departemen;
  List<Gallery>? gallery;
  String? creationDate;
  String? updateDate;

  Data(
      {this.id,
      this.name,
      this.nama,
      this.tentangOrganisasi,
      this.wa,
      this.email,
      this.lokasi,
      this.isActive,
      this.kategori,
      this.user,
      this.foto,
      this.visiMisi,
      this.prestasi,
      this.departemen,
      this.gallery,
      this.creationDate,
      this.updateDate});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nama = json['nama'];
    tentangOrganisasi = json['tentang_organisasi'];
    wa = json['wa'];
    email = json['email'];
    lokasi = json['lokasi'];
    isActive = json['is_active'];
    kategori = json['kategori'] != null
        ? new Kategori.fromJson(json['kategori'])
        : null;
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    foto = json['foto'] != null ? new Foto.fromJson(json['foto']) : null;
    visiMisi = json['visi_misi'] != null
        ? new VisiMisi.fromJson(json['visi_misi'])
        : null;
    if (json['prestasi'] != null) {
      prestasi = <Prestasi>[];
      json['prestasi'].forEach((v) {
        prestasi!.add(new Prestasi.fromJson(v));
      });
    }
    if (json['departemen'] != null) {
      departemen = <Departemen>[];
      json['departemen'].forEach((v) {
        departemen!.add(new Departemen.fromJson(v));
      });
    }
    if (json['gallery'] != null) {
      gallery = <Gallery>[];
      json['gallery'].forEach((v) {
        gallery!.add(new Gallery.fromJson(v));
      });
    }
    creationDate = json['creation_date'];
    updateDate = json['update_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['nama'] = this.nama;
    data['tentang_organisasi'] = this.tentangOrganisasi;
    data['wa'] = this.wa;
    data['email'] = this.email;
    data['lokasi'] = this.lokasi;
    data['is_active'] = this.isActive;
    if (this.kategori != null) {
      data['kategori'] = this.kategori!.toJson();
    }
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.foto != null) {
      data['foto'] = this.foto!.toJson();
    }
    if (this.visiMisi != null) {
      data['visi_misi'] = this.visiMisi!.toJson();
    }
    if (this.prestasi != null) {
      data['prestasi'] = this.prestasi!.map((v) => v.toJson()).toList();
    }
    if (this.departemen != null) {
      data['departemen'] = this.departemen!.map((v) => v.toJson()).toList();
    }
    if (this.gallery != null) {
      data['gallery'] = this.gallery!.map((v) => v.toJson()).toList();
    }
    data['creation_date'] = this.creationDate;
    data['update_date'] = this.updateDate;
    return data;
  }
}

class Kategori {
  int? id;
  String? category;

  Kategori({this.id, this.category});

  Kategori.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category'] = this.category;
    return data;
  }
}

class User {
  int? id;
  String? username;
  String? email;

  User({this.id, this.username, this.email});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    return data;
  }
}

class Foto {
  int? id;
  String? logo;
  String? sampul;

  Foto({this.id, this.logo, this.sampul});

  Foto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    logo = json['logo'];
    sampul = json['sampul'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['logo'] = this.logo;
    data['sampul'] = this.sampul;
    return data;
  }
}

class VisiMisi {
  int? id;
  String? visi;
  String? misi;

  VisiMisi({this.id, this.visi, this.misi});

  VisiMisi.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    visi = json['visi'];
    misi = json['misi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['visi'] = this.visi;
    data['misi'] = this.misi;
    return data;
  }
}

class Prestasi {
  int? id;
  String? prestasi;
  String? detailPrestasi;
  bool? isActive;

  Prestasi({this.id, this.prestasi, this.detailPrestasi, this.isActive});

  Prestasi.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    prestasi = json['prestasi'];
    detailPrestasi = json['detail_prestasi'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['prestasi'] = this.prestasi;
    data['detail_prestasi'] = this.detailPrestasi;
    data['is_active'] = this.isActive;
    return data;
  }
}

class Departemen {
  int? id;
  String? departemen;
  String? detailDepartemen;
  bool? isActive;

  Departemen({this.id, this.departemen, this.detailDepartemen, this.isActive});

  Departemen.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    departemen = json['departemen'];
    detailDepartemen = json['detail_departemen'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['departemen'] = this.departemen;
    data['detail_departemen'] = this.detailDepartemen;
    data['is_active'] = this.isActive;
    return data;
  }
}

class Gallery {
  int? id;
  String? informasi;
  String? link;
  String? foto;
  String? video;

  Gallery({this.id, this.informasi, this.link, this.foto, this.video});

  Gallery.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    informasi = json['informasi'];
    link = json['link'];
    foto = json['foto'];
    video = json['video'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['informasi'] = this.informasi;
    data['link'] = this.link;
    data['foto'] = this.foto;
    data['video'] = this.video;
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