import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({Key? key}) : super(key: key);

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  String selectedCategory = 'Semua';

  final TextEditingController _searchController = TextEditingController();

  late Future<DiscoverOrg> _futureDiscoverOrg;

  // GANTI IP INI SESUAI IP LAPTOP KAMU
  // Kalau pakai HP fisik, jangan pakai localhost.
  static const String baseUrl = 'http://192.168.1.2:8000';

  final List<String> categories = [
    'Semua',
    'Sosial & Kemanusiaan',
    'Pendidikan & Kepemudaan',
    'Agama',
    'Ekonomi & Kewirausahaan',
    'Hobi & Olahraga',
    'Lingkungan',
  ];

  @override
  void initState() {
    super.initState();
    _futureDiscoverOrg = getSemuaOrganisasi();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<DiscoverOrg> getSemuaOrganisasi() async {
    final url = Uri.parse('$baseUrl/mobile/organisasi/');

    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
      },
    );

    print('STATUS DISCOVER ORG: ${response.statusCode}');
    print('BODY DISCOVER ORG: ${response.body}');

    if (!response.body.trim().startsWith('{')) {
      throw Exception(
        'API tidak mengembalikan JSON. Cek URL API, IP laptop, atau terminal Django.',
      );
    }

    final Map<String, dynamic> body = jsonDecode(response.body);

    return DiscoverOrg.fromJson(body);
  }

  Future<void> _refreshData() async {
    setState(() {
      _futureDiscoverOrg = getSemuaOrganisasi();
    });

    await _futureDiscoverOrg;
  }

  List<Data> _filterOrganisasi(List<Data> list) {
    final keyword = _searchController.text.trim().toLowerCase();

    return list.where((org) {
      final nama = (org.name ?? org.nama ?? '').toLowerCase();
      final deskripsi = (org.tentangOrganisasi ?? '').toLowerCase();
      final kategori = (org.kategori?.category ?? '').toLowerCase();

      final cocokSearch = keyword.isEmpty ||
          nama.contains(keyword) ||
          deskripsi.contains(keyword) ||
          kategori.contains(keyword);

      final cocokKategori = _isCategoryMatch(kategori);

      return cocokSearch && cocokKategori;
    }).toList();
  }

  bool _isCategoryMatch(String kategoriApi) {
    if (selectedCategory == 'Semua') {
      return true;
    }

    final selected = selectedCategory.toLowerCase();

    if (kategoriApi.isEmpty) {
      return false;
    }

    // Biar kategori dari DB seperti "Sosial", "Pendidikan", "Agama"
    // tetap cocok dengan chip seperti "Sosial & Kemanusiaan".
    if (selected.contains(kategoriApi)) {
      return true;
    }

    if (kategoriApi.contains(selected)) {
      return true;
    }

    if (selected.contains('sosial') && kategoriApi.contains('sosial')) {
      return true;
    }

    if (selected.contains('pendidikan') && kategoriApi.contains('pendidikan')) {
      return true;
    }

    if (selected.contains('agama') && kategoriApi.contains('agama')) {
      return true;
    }

    if (selected.contains('ekonomi') && kategoriApi.contains('ekonomi')) {
      return true;
    }

    if (selected.contains('kewirausahaan') &&
        kategoriApi.contains('kewirausahaan')) {
      return true;
    }

    if (selected.contains('hobi') && kategoriApi.contains('hobi')) {
      return true;
    }

    if (selected.contains('olahraga') && kategoriApi.contains('olahraga')) {
      return true;
    }

    if (selected.contains('lingkungan') && kategoriApi.contains('lingkungan')) {
      return true;
    }

    return false;
  }

  String _getImage(Data org) {
    final sampul = org.foto?.sampul ?? '';
    final logo = org.foto?.logo ?? '';

    if (sampul.isNotEmpty) {
      return sampul;
    }

    if (logo.isNotEmpty) {
      return logo;
    }

    return 'https://picsum.photos/seed/organisasi/400/200';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _searchController,
                onChanged: (_) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  hintText: 'Cari organisasi atau komunitas...',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                          icon: const Icon(Icons.close, color: Colors.grey),
                        )
                      : null,
                  fillColor: const Color(0xFFF5F5F5),
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: categories.map((cat) {
                    final isSelected = selectedCategory == cat;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategory = cat;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFC6132C)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFFC6132C),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          cat,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFFC6132C),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder<DiscoverOrg>(
            future: _futureDiscoverOrg,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFC6132C),
                  ),
                );
              }

              if (snapshot.hasError) {
                return RefreshIndicator(
                  onRefresh: _refreshData,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Gagal mengambil data organisasi:\n${snapshot.error}',
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              final semuaOrganisasi = snapshot.data?.data ?? [];
              final filteredOrganisasi = _filterOrganisasi(semuaOrganisasi);

              if (semuaOrganisasi.isEmpty) {
                return RefreshIndicator(
                  onRefresh: _refreshData,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Belum ada organisasi yang terdaftar.',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: _refreshData,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                      child: Text(
                        'Hasil Pencarian (${filteredOrganisasi.length} found)',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                    ),
                    Expanded(
                      child: filteredOrganisasi.isEmpty
                          ? ListView(
                              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    'Tidak ada organisasi yang cocok dengan pencarian atau kategori ini.',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                              itemCount: filteredOrganisasi.length,
                              itemBuilder: (context, index) {
                                final item = filteredOrganisasi[index];

                                return _CommunityListCard(
                                  item: item,
                                  image: _getImage(item),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CommunityListCard extends StatelessWidget {
  final Data item;
  final String image;

  const _CommunityListCard({
    required this.item,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    final kategori = item.kategori?.category ?? 'Organisasi';
    final nama = item.name ?? item.nama ?? '-';
    final deskripsi =
        item.tentangOrganisasi ?? 'Belum ada deskripsi organisasi.';
    final lokasi = item.lokasi ?? 'Lokasi belum tersedia';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.network(
                  image,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 160,
                      width: double.infinity,
                      color: Colors.grey.shade200,
                      child: const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFC6132C),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    kategori,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        nama,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                    ),
                    if (item.isActive == true)
                      const Icon(
                        Icons.verified,
                        color: Color(0xFF22C55E),
                        size: 18,
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  deskripsi,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        lokasi,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(
                      Icons.bookmark_border,
                      size: 20,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        print('ID Organisasi: ${item.id}');
                        // Nanti kalau sudah ada halaman detail:
                        // Navigator.push(context, MaterialPageRoute(
                        //   builder: (_) => DetailOrganisasiScreen(id: item.id!),
                        // ));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC6132C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Lihat Detail',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ===========================================================
// MODEL DISCOVER ORGANISASI
// ===========================================================

class DiscoverOrg {
  List<Data>? data;
  Metadata? metadata;

  DiscoverOrg({this.data, this.metadata});

  DiscoverOrg.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    metadata =
        json['metadata'] != null ? Metadata.fromJson(json['metadata']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (metadata != null) {
      data['metadata'] = metadata!.toJson();
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
  String? creationDate;
  String? updateDate;

  Data({
    this.id,
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
    this.creationDate,
    this.updateDate,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nama = json['nama'];
    tentangOrganisasi = json['tentang_organisasi'];
    wa = json['wa'];
    email = json['email'];
    lokasi = json['lokasi'];
    isActive = json['is_active'];
    kategori =
        json['kategori'] != null ? Kategori.fromJson(json['kategori']) : null;
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    foto = json['foto'] != null ? Foto.fromJson(json['foto']) : null;
    creationDate = json['creation_date'];
    updateDate = json['update_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['nama'] = nama;
    data['tentang_organisasi'] = tentangOrganisasi;
    data['wa'] = wa;
    data['email'] = email;
    data['lokasi'] = lokasi;
    data['is_active'] = isActive;
    if (kategori != null) {
      data['kategori'] = kategori!.toJson();
    }
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (foto != null) {
      data['foto'] = foto!.toJson();
    }
    data['creation_date'] = creationDate;
    data['update_date'] = updateDate;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['category'] = category;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['email'] = email;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['logo'] = logo;
    data['sampul'] = sampul;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    return data;
  }
}
