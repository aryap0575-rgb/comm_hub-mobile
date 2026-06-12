import 'dart:convert';

import 'package:com.example.fincome_mobile_mobile/modules/home/model/detailorg.dart';
import 'package:com.example.fincome_mobile_mobile/service/favorite_organisasi_service.dart';
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

  static String get baseUrl => FavoriteOrganisasiService.baseUrl;

  final Set<int> _savedOrgIds = {};
  final Set<int> _loadingFavoriteIds = {};

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

    if (response.body.trim().isEmpty) {
      throw Exception(
        'Response API kosong. Cek URL API, IP laptop, atau terminal Django.',
      );
    }

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

  Future<void> _toggleFavorite(Data item) async {
    final organisasiId = item.id;

    if (organisasiId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ID organisasi tidak ditemukan.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final bool sekarangSudahFavorit = _savedOrgIds.contains(organisasiId);
    final bool targetFavorit = !sekarangSudahFavorit;

    setState(() {
      _loadingFavoriteIds.add(organisasiId);
    });

    try {
      final result = await FavoriteOrganisasiService.setFavorite(
        organisasiId: organisasiId,
        isFavorit: targetFavorit,
      );

      if (!mounted) return;

      setState(() {
        if (targetFavorit) {
          _savedOrgIds.add(organisasiId);
        } else {
          _savedOrgIds.remove(organisasiId);
        }

        _loadingFavoriteIds.remove(organisasiId);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result['metadata']?['message'] ??
                (targetFavorit
                    ? 'Organisasi berhasil disimpan ke favorit'
                    : 'Organisasi berhasil dihapus dari favorit'),
          ),
          backgroundColor: const Color(0xFFD90429),
          duration: const Duration(seconds: 1),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loadingFavoriteIds.remove(organisasiId);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengubah favorit: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _openDetailOrganisasi(Data item) {
  final int? organisasiId = item.id;

  if (organisasiId == null || organisasiId == 0) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('ID organisasi tidak ditemukan.'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  print('Masuk detail organisasi ID: $organisasiId');

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => DetailOrganisasiPage(
        organisasiId: organisasiId,
      ),
    ),
  );
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
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                          icon: const Icon(
                            Icons.close,
                            color: Colors.grey,
                          ),
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
                                final orgId = item.id;

                                return _CommunityListCard(
                                  item: item,
                                  image: _getImage(item),
                                  isSaved: orgId != null &&
                                      _savedOrgIds.contains(orgId),
                                  isLoading: orgId != null &&
                                      _loadingFavoriteIds.contains(orgId),
                                  onFavoriteTap: () {
                                    _toggleFavorite(item);
                                  },
                                  onDetailTap: () {
                                    _openDetailOrganisasi(item);
                                  },
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
  final bool isSaved;
  final bool isLoading;
  final VoidCallback onFavoriteTap;
  final VoidCallback onDetailTap;

  const _CommunityListCard({
    required this.item,
    required this.image,
    required this.isSaved,
    required this.isLoading,
    required this.onFavoriteTap,
    required this.onDetailTap,
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
                    InkWell(
                      onTap: isLoading ? null : onFavoriteTap,
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Color(0xFFC6132C),
                                ),
                              )
                            : Icon(
                                isSaved
                                    ? Icons.bookmark
                                    : Icons.bookmark_border,
                                size: 22,
                                color: isSaved
                                    ? const Color(0xFFC6132C)
                                    : Colors.grey,
                              ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: onDetailTap,
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

  DiscoverOrg({
    this.data,
    this.metadata,
  });

  DiscoverOrg.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];

      if (json['data'] is List) {
        json['data'].forEach((v) {
          data!.add(Data.fromJson(v));
        });
      }
    }

    metadata =
        json['metadata'] != null ? Metadata.fromJson(json['metadata']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = <String, dynamic>{};

    if (data != null) {
      result['data'] = data!.map((v) => v.toJson()).toList();
    }

    if (metadata != null) {
      result['metadata'] = metadata!.toJson();
    }

    return result;
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
    id = _toNullableInt(json['id']);
    name = _toNullableString(json['name']);
    nama = _toNullableString(json['nama'] ?? json['nama_organisasi']);
    tentangOrganisasi = _toNullableString(json['tentang_organisasi']);
    wa = _toNullableString(json['wa']);
    email = _toNullableString(json['email']);
    lokasi = _toNullableString(json['lokasi']);
    isActive = json['is_active'];

    kategori =
        json['kategori'] != null ? Kategori.fromJson(json['kategori']) : null;

    user = json['user'] != null ? User.fromJson(json['user']) : null;

    foto = json['foto'] != null ? Foto.fromJson(json['foto']) : null;

    creationDate = _toNullableString(json['creation_date']);
    updateDate = _toNullableString(json['update_date']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = <String, dynamic>{};

    result['id'] = id;
    result['name'] = name;
    result['nama'] = nama;
    result['tentang_organisasi'] = tentangOrganisasi;
    result['wa'] = wa;
    result['email'] = email;
    result['lokasi'] = lokasi;
    result['is_active'] = isActive;

    if (kategori != null) {
      result['kategori'] = kategori!.toJson();
    }

    if (user != null) {
      result['user'] = user!.toJson();
    }

    if (foto != null) {
      result['foto'] = foto!.toJson();
    }

    result['creation_date'] = creationDate;
    result['update_date'] = updateDate;

    return result;
  }
}

class Kategori {
  int? id;
  String? category;

  Kategori({
    this.id,
    this.category,
  });

  Kategori.fromJson(Map<String, dynamic> json) {
    id = _toNullableInt(json['id']);
    category = _toNullableString(
      json['category'] ?? json['kategori'] ?? json['nama_kategori'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = <String, dynamic>{};
    result['id'] = id;
    result['category'] = category;
    return result;
  }
}

class User {
  int? id;
  String? username;
  String? email;

  User({
    this.id,
    this.username,
    this.email,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = _toNullableInt(json['id']);
    username = _toNullableString(json['username']);
    email = _toNullableString(json['email']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = <String, dynamic>{};
    result['id'] = id;
    result['username'] = username;
    result['email'] = email;
    return result;
  }
}

class Foto {
  int? id;
  String? logo;
  String? sampul;

  Foto({
    this.id,
    this.logo,
    this.sampul,
  });

  Foto.fromJson(Map<String, dynamic> json) {
    id = _toNullableInt(json['id']);
    logo = _toNullableString(json['logo'] ?? json['foto_profile']);
    sampul = _toNullableString(json['sampul'] ?? json['photo']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = <String, dynamic>{};
    result['id'] = id;
    result['logo'] = logo;
    result['sampul'] = sampul;
    return result;
  }
}

class Metadata {
  int? code;
  String? message;

  Metadata({
    this.code,
    this.message,
  });

  Metadata.fromJson(Map<String, dynamic> json) {
    code = _toNullableInt(json['code'] ?? json['status_code']);
    message = _toNullableString(json['message']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = <String, dynamic>{};
    result['code'] = code;
    result['message'] = message;
    return result;
  }
}

int? _toNullableInt(dynamic value) {
  if (value == null) return null;

  if (value is int) {
    return value;
  }

  if (value is String) {
    return int.tryParse(value);
  }

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
