class JadwalSholat {
  String? jadwalSholat;

  JadwalSholat({this.jadwalSholat});

  JadwalSholat.fromJson(Map<String, dynamic> json) {
    jadwalSholat = json['jadwal_sholat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['jadwal_sholat'] = jadwalSholat;
    return data;
  }
}
