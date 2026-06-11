import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class SavedScreen extends StatefulWidget {
  const SavedScreen({Key? key}) : super(key: key);

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  late Future<FavoriteOrgResponse> _futureFavorite;

  // GANTI IP INI SESUAI IP LAPTOP KAMU
  static const String baseUrl = 'http://192.168.1.2:8000';

  @override
  void initState() {
    super.initState();
    _futureFavorite = getFavoriteOrganisasi();
  }

  Future<FavoriteOrgResponse> getFavoriteOrganisasi() async {
    const storage = FlutterSecureStorage();

    final userIdString = await storage.read(key: 'user_id');

    if (userIdString == null || userIdString.isEmpty) {
      throw Exception('User ID tidak ditemukan. Silakan login ulang.');
    }

    final url = Uri.parse(
      '$baseUrl/mobile/organisasi/favorit/user/$userIdString/',
    );

    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
      },
    );

    print('STATUS FAVORIT GET: ${response.statusCode}');
    print('BODY FAVORIT GET: ${response.body}');

    if (!response.body.trim().startsWith('{')) {
      throw Exception(
        'API favorit tidak mengembalikan JSON. Cek URL atau server Django.',
      );
    }

    final Map<String, dynamic> body = jsonDecode(response.body);

    return FavoriteOrgResponse.fromJson(body);
  }

  Future<void> _refreshFavorite() async {
    setState(() {
      _futureFavorite = getFavoriteOrganisasi();
    });

    await _futureFavorite;
  }

  Future<void> _hapusFavorite(FavoriteData item) async {
    const storage = FlutterSecureStorage();

    final userIdString = await storage.read(key: 'user_id');

    if (userIdString == null || userIdString.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User ID tidak ditemukan. Silakan login ulang.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

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

    try {
      final url = Uri.parse('$baseUrl/mobile/organisasi/favorit/');

      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'organisasi_id': organisasiId,
          'user_id': int.parse(userIdString),
          'is_favorit': false,
        }),
      );

      print('STATUS HAPUS FAVORIT: ${response.statusCode}');
      print('BODY HAPUS FAVORIT: ${response.body}');

      if (!response.body.trim().startsWith('{')) {
        throw Exception('API hapus favorit tidak mengembalikan JSON');
      }

      final body = jsonDecode(response.body);
      final code = body['metadata']?['code'];

      if (code == 200 || code == 201) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Organisasi dihapus dari favorit'),
            backgroundColor: Color(0xFFD90429),
            duration: Duration(seconds: 1),
          ),
        );

        _refreshFavorite();
      } else {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              body['metadata']?['message'] ?? 'Gagal menghapus favorit',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error hapus favorit: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _getImage(FavoriteData item) {
    final sampul = item.foto?.sampul ?? '';
    final logo = item.foto?.logo ?? '';

    if (sampul.isNotEmpty) {
      return sampul;
    }

    if (logo.isNotEmpty) {
      return logo;
    }

    return 'https://picsum.photos/seed/favorit/400/200';
  }

  Color _getCategoryColor(String category) {
    final lower = category.toLowerCase();

    if (lower.contains('lingkungan')) {
      return Colors.green;
    }

    if (lower.contains('pendidikan')) {
      return Colors.blue;
    }

    if (lower.contains('sosial')) {
      return Colors.orange;
    }

    if (lower.contains('agama')) {
      return const Color(0xFFD90429);
    }

    if (lower.contains('olahraga') || lower.contains('hobi')) {
      return Colors.purple;
    }

    if (lower.contains('ekonomi') || lower.contains('usaha')) {
      return Colors.teal;
    }

    return const Color(0xFFD90429);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshFavorite,
      child: FutureBuilder<FavoriteOrgResponse>(
        future: _futureFavorite,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFD90429),
              ),
            );
          }

          if (snapshot.hasError) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  "Tersimpan",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD90429),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Komunitas dan organisasi yang Anda ikuti atau tandai.",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    'Gagal mengambil data favorit:\n${snapshot.error}',
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            );
          }

          final favoriteList = snapshot.data?.data ?? [];

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                "Tersimpan",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD90429),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Komunitas dan organisasi yang Anda ikuti atau tandai.",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 24),
              if (favoriteList.isEmpty)
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.grey.shade200,
                    ),
                  ),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.bookmark_border,
                        size: 50,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Belum ada organisasi tersimpan.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ...favoriteList.map((item) {
                  final kategori = item.kategori?.category ?? 'ORGANISASI';
                  final categoryColor = _getCategoryColor(kategori);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _communityCard(
                      image: _getImage(item),
                      category: kategori.toUpperCase(),
                      categoryColor: categoryColor,
                      title: item.name ?? item.nama ?? '-',
                      location: item.lokasi ?? 'Lokasi belum tersedia',
                      updated: item.favoritUpdateDate ?? 'Data favorit',
                      onDeleteTap: () {
                        _hapusFavorite(item);
                      },
                    ),
                  );
                }).toList(),
              const SizedBox(height: 40),
            ],
          );
        },
      ),
    );
  }

  Widget _communityCard({
    required String image,
    required String category,
    required Color categoryColor,
    required String title,
    required String location,
    required String updated,
    required VoidCallback onDeleteTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE57373)),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                ),
                child: Image.network(
                  image,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 180,
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
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFFD90429),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.bookmark,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: categoryColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      color: categoryColor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD90429),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 18,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Diperbarui $updated',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: onDeleteTap,
                      borderRadius: BorderRadius.circular(8),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 6,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete_outline,
                              color: Color(0xFFD90429),
                              size: 18,
                            ),
                            SizedBox(width: 4),
                            Text(
                              "Hapus",
                              style: TextStyle(
                                color: Color(0xFFD90429),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
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

// =======================================================
// MODEL GET FAVORIT ORGANISASI
// =======================================================

class FavoriteOrgResponse {
  List<FavoriteData>? data;
  Metadata? metadata;

  FavoriteOrgResponse({this.data, this.metadata});

  FavoriteOrgResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <FavoriteData>[];
      json['data'].forEach((v) {
        data!.add(FavoriteData.fromJson(v));
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

class FavoriteData {
  int? favoritId;
  bool? isFavorit;
  String? favoritCreationDate;
  String? favoritUpdateDate;

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

  FavoriteData({
    this.favoritId,
    this.isFavorit,
    this.favoritCreationDate,
    this.favoritUpdateDate,
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

  FavoriteData.fromJson(Map<String, dynamic> json) {
    favoritId = json['favorit_id'];
    isFavorit = json['is_favorit'];
    favoritCreationDate = json['favorit_creation_date'];
    favoritUpdateDate = json['favorit_update_date'];

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

    data['favorit_id'] = favoritId;
    data['is_favorit'] = isFavorit;
    data['favorit_creation_date'] = favoritCreationDate;
    data['favorit_update_date'] = favoritUpdateDate;

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
