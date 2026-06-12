import 'dart:convert';

import 'package:com.example.fincome_mobile_mobile/service/favorite_organisasi_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DepartemenPage extends StatefulWidget {
  final int organisasiId;
  final String namaOrganisasi;

  const DepartemenPage({
    Key? key,
    required this.organisasiId,
    this.namaOrganisasi = 'Organisasi',
  }) : super(key: key);

  @override
  State<DepartemenPage> createState() => _DepartemenPageState();
}

class _DepartemenPageState extends State<DepartemenPage> {
  static const Color primaryRed = Color(0xFFD90429);
  static const Color softRed = Color(0xFFFFF1F1);

  static String get baseUrl => FavoriteOrganisasiService.baseUrl;

  late Future<DepartementOrg> _futureDepartemen;

  @override
  void initState() {
    super.initState();
    _futureDepartemen = getDepartemenByOrganisasiId();
  }

  Future<DepartementOrg> getDepartemenByOrganisasiId() async {
    final Uri url = Uri.parse(
      '$baseUrl/mobile/departemen_organisasi/${widget.organisasiId}/',
    );

    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
      },
    );

    print('URL GET DEPARTEMEN: $url');
    print('STATUS GET DEPARTEMEN: ${response.statusCode}');
    print('BODY GET DEPARTEMEN: ${response.body}');

    if (response.body.trim().isEmpty) {
      throw Exception('Response API kosong. Cek endpoint Django.');
    }

    if (!response.body.trim().startsWith('{')) {
      throw Exception(
        'API tidak mengembalikan JSON. Cek URL API, IP laptop, atau terminal Django.',
      );
    }

    final Map<String, dynamic> body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return DepartementOrg.fromJson(body);
    }

    final message = body['metadata']?['message'] ??
        body['message'] ??
        'Gagal mengambil data departemen';

    throw Exception(message);
  }

  Future<void> _refreshDepartemen() async {
    setState(() {
      _futureDepartemen = getDepartemenByOrganisasiId();
    });

    await _futureDepartemen;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: FutureBuilder<DepartementOrg>(
                future: _futureDepartemen,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: primaryRed,
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return RefreshIndicator(
                      onRefresh: _refreshDepartemen,
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 90),
                        children: [
                          _buildHeroCard(),
                          const SizedBox(height: 20),
                          _buildInfoText(),
                          const SizedBox(height: 18),
                          _buildErrorCard(snapshot.error.toString()),
                        ],
                      ),
                    );
                  }

                  final List<Data> departemenList = snapshot.data?.data ?? [];

                  if (departemenList.isEmpty) {
                    return RefreshIndicator(
                      onRefresh: _refreshDepartemen,
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 90),
                        children: [
                          _buildHeroCard(),
                          const SizedBox(height: 20),
                          _buildInfoText(),
                          const SizedBox(height: 18),
                          _buildEmptyCard(),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: _refreshDepartemen,
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 90),
                      children: [
                        _buildHeroCard(),
                        const SizedBox(height: 20),
                        _buildInfoText(),
                        const SizedBox(height: 18),
                        Column(
                          children: departemenList.map((item) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: DepartmentCard(
                                title: item.departemen?.isNotEmpty == true
                                    ? item.departemen!
                                    : 'Departemen',
                                description:
                                    item.detailDepartemen?.isNotEmpty == true
                                        ? item.detailDepartemen!
                                        : 'Belum ada detail departemen.',
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 8),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            borderRadius: BorderRadius.circular(30),
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: primaryRed,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            "Departemen",
            style: TextStyle(
              color: primaryRed,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Spacer(),
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.10),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.network(
                "https://i.pravatar.cc/150?img=12",
                fit: BoxFit.cover,
                errorBuilder: functionImageError,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard() {
    return Container(
      height: 150,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            "https://images.unsplash.com/photo-1521737604893-d14cc237f11d?w=900",
            fit: BoxFit.cover,
            errorBuilder: functionImageError,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  primaryRed.withOpacity(0.88),
                  primaryRed.withOpacity(0.20),
                  Colors.black.withOpacity(0.05),
                ],
              ),
            ),
          ),
          Positioned(
            left: 16,
            bottom: 18,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.namaOrganisasi.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Struktur Organisasi",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoText() {
    return const Text(
      "Setiap tim bekerja secara sinergis untuk mencapai visi organisasi.",
      style: TextStyle(
        fontSize: 12,
        color: Color(0xFF555555),
        height: 1.5,
      ),
    );
  }

  Widget _buildEmptyCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: primaryRed.withOpacity(0.22),
          width: 1,
        ),
      ),
      child: const Text(
        'Belum ada data departemen untuk organisasi ini.',
        style: TextStyle(
          color: Colors.grey,
          fontSize: 13,
          height: 1.5,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildErrorCard(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: primaryRed.withOpacity(0.22),
          width: 1,
        ),
      ),
      child: Text(
        'Gagal mengambil data departemen:\n$message',
        style: const TextStyle(
          color: Colors.red,
          fontSize: 13,
          height: 1.5,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 78,
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          BottomNavItem(
            icon: Icons.home_outlined,
            label: "Home",
            isActive: false,
          ),
          BottomNavItem(
            icon: Icons.business_center_rounded,
            label: "Discover",
            isActive: true,
          ),
          BottomNavItem(
            icon: Icons.bookmark_border_rounded,
            label: "Saved",
            isActive: false,
          ),
          BottomNavItem(
            icon: Icons.person_outline_rounded,
            label: "Account",
            isActive: false,
          ),
        ],
      ),
    );
  }
}

Widget functionImageError(
  BuildContext context,
  Object error,
  StackTrace? stackTrace,
) {
  return Container(
    color: Colors.grey.shade300,
    child: const Center(
      child: Icon(
        Icons.image_not_supported_outlined,
        color: Colors.grey,
        size: 32,
      ),
    ),
  );
}

class DepartmentCard extends StatelessWidget {
  const DepartmentCard({
    Key? key,
    required this.title,
    required this.description,
  }) : super(key: key);

  final String title;
  final String description;

  static const Color primaryRed = Color(0xFFD90429);
  static const Color softRed = Color(0xFFFFEFEF);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: primaryRed.withOpacity(0.22),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryRed.withOpacity(0.07),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: softRed,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.groups_rounded,
              color: primaryRed,
              size: 27,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF222222),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 9.5,
                    color: Color(0xFF555555),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BottomNavItem extends StatelessWidget {
  const BottomNavItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.isActive,
  }) : super(key: key);

  final IconData icon;
  final String label;
  final bool isActive;

  static const Color primaryRed = Color(0xFFD90429);

  @override
  Widget build(BuildContext context) {
    if (isActive) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: primaryRed,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: const Color(0xFF555555),
          size: 21,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF555555),
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ===========================================================
// MODEL DEPARTEMEN
// ===========================================================

class DepartementOrg {
  List<Data>? data;
  Metadata? metadata;

  DepartementOrg({
    this.data,
    this.metadata,
  });

  DepartementOrg.fromJson(Map<String, dynamic> json) {
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
  String? departemen;
  String? detailDepartemen;
  bool? isActive;
  int? idOrganisasi;
  String? namaOrganisasi;
  String? creationDate;
  String? updateDate;

  Data({
    this.id,
    this.departemen,
    this.detailDepartemen,
    this.isActive,
    this.idOrganisasi,
    this.namaOrganisasi,
    this.creationDate,
    this.updateDate,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = _toNullableInt(json['id']);
    departemen = _toNullableString(json['departemen']);
    detailDepartemen = _toNullableString(json['detail_departemen']);
    isActive = json['is_active'];
    idOrganisasi = _toNullableInt(json['id_organisasi']);
    namaOrganisasi = _toNullableString(json['nama_organisasi']);
    creationDate = _toNullableString(json['creation_date']);
    updateDate = _toNullableString(json['update_date']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = <String, dynamic>{};

    result['id'] = id;
    result['departemen'] = departemen;
    result['detail_departemen'] = detailDepartemen;
    result['is_active'] = isActive;
    result['id_organisasi'] = idOrganisasi;
    result['nama_organisasi'] = namaOrganisasi;
    result['creation_date'] = creationDate;
    result['update_date'] = updateDate;

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
    code = _toNullableInt(json['code']);
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