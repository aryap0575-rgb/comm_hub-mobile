import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:com.example.fincome_mobile_mobile/modules/url/urls.dart';
import 'package:com.example.fincome_mobile_mobile/modules/home/daftar_komunitas_screen.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback? onLogout;

  const ProfileScreen({
    Key? key,
    this.onLogout,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<ProfileUserResponse> _futureProfile;

  // GANTI IP INI SESUAI IP LAPTOP KAMU
  static const String baseUrl = 'http://192.168.1.10:8000';

  @override
  void initState() {
    super.initState();
    _futureProfile = getProfileUser();
  }

  Future<ProfileUserResponse> getProfileUser() async {
    const storage = FlutterSecureStorage();

    final userIdString = await storage.read(key: 'user_id');

    if (userIdString == null || userIdString.isEmpty) {
      throw Exception('User ID tidak ditemukan. Silakan login ulang.');
    }

    // SESUAIKAN ENDPOINT INI DENGAN API PROFILE KAMU
    final url = Urls().profileUser(int.parse(userIdString));

    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
      },
    );

    print('STATUS PROFILE: ${response.statusCode}');
    print('BODY PROFILE: ${response.body}');

    if (!response.body.trim().startsWith('{')) {
      throw Exception(
        'API profile tidak mengembalikan JSON. Cek URL API atau server Django.',
      );
    }

    final Map<String, dynamic> body = jsonDecode(response.body);

    return ProfileUserResponse.fromJson(body);
  }

  Future<void> _refreshProfile() async {
    setState(() {
      _futureProfile = getProfileUser();
    });

    await _futureProfile;
  }

  String _getDisplayName(ProfileUserResponse profile) {
    final data = profile.data;

    final fullnameProfile = data?.profile?.fullname;
    final fullnameUser = data?.user?.fullname;
    final username = data?.user?.username;

    if (fullnameProfile != null && fullnameProfile.trim().isNotEmpty) {
      return fullnameProfile;
    }

    if (fullnameUser != null && fullnameUser.trim().isNotEmpty) {
      return fullnameUser;
    }

    if (username != null && username.trim().isNotEmpty) {
      return username;
    }

    return 'User';
  }

  String _getEmail(ProfileUserResponse profile) {
    final email = profile.data?.user?.email;

    if (email != null && email.trim().isNotEmpty) {
      return email;
    }

    return 'Email belum tersedia';
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshProfile,
      child: FutureBuilder<ProfileUserResponse>(
        future: _futureProfile,
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
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    'Gagal mengambil data profile:\n${snapshot.error}',
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _logoutButton(),
              ],
            );
          }

          final profile = snapshot.data ?? ProfileUserResponse();
          final name = _getDisplayName(profile);
          final email = _getEmail(profile);

          final totalOrganisasiFavorit =
              profile.data?.totalOrganisasiFavorit ?? 0;

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // PROFILE IMAGE
                Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFD90429),
                          width: 3,
                        ),
                      ),
                      child: const CircleAvatar(
                        radius: 45,
                        backgroundImage: NetworkImage(
                          "https://i.pravatar.cc/300",
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD90429),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.edit,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // NAME DARI API
                Text(
                  name.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                // EMAIL DARI API
                Text(
                  email,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 24),

                _logoutButton(),

                const SizedBox(height: 30),

                // SAVED COMMUNITY CARD
                _buildMenuCard(
                  icon: Icons.bookmark_border,
                  title: "Komunitas Tersimpan",
                  subtitle: "$totalOrganisasiFavorit organisasi tersimpan",
                  backgroundColor: Colors.white,
                  iconBg: const Color(0xFFF8E9EC),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Buka menu Saved di bottom navigation.',
                        ),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),

                // REGISTER CARD
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const DaftarKomunitasScreen(),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD90429),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Daftarkan Komunitas Anda",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Register Your Community",
                                style: TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // HELP CARD
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.help_outline, color: Colors.grey),
                          SizedBox(width: 10),
                          Text(
                            "Butuh bantuan?",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Padding(
                        padding: EdgeInsets.only(left: 34),
                        child: Text(
                          "Hubungi support kami via email",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.only(left: 34),
                        child: Text(
                          "Contact Support ✉",
                          style: TextStyle(
                            color: Color(0xFFD90429),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _logoutButton() {
    return OutlinedButton.icon(
      onPressed: widget.onLogout ?? () {},
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFFD90429),
        side: const BorderSide(
          color: Color(0xFFD90429),
          width: 2,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 28,
          vertical: 14,
        ),
      ),
      icon: const Icon(Icons.logout),
      label: const Text(
        "Logout",
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color backgroundColor,
    required Color iconBg,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFF0D0D5),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: const Color(0xFFD90429),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

// =======================================================
// MODEL PROFILE USER
// =======================================================

class ProfileUserResponse {
  ProfileData? data;
  Metadata? metadata;

  ProfileUserResponse({
    this.data,
    this.metadata,
  });

  ProfileUserResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? ProfileData.fromJson(json['data']) : null;
    metadata =
        json['metadata'] != null ? Metadata.fromJson(json['metadata']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }

    if (metadata != null) {
      data['metadata'] = metadata!.toJson();
    }

    return data;
  }
}

class ProfileData {
  User? user;
  Profile? profile;
  int? totalProfile;
  int? totalPhoto;
  int? totalOrganisasiFavorit;

  ProfileData({
    this.user,
    this.profile,
    this.totalProfile,
    this.totalPhoto,
    this.totalOrganisasiFavorit,
  });

  ProfileData.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    profile =
        json['profile'] != null ? Profile.fromJson(json['profile']) : null;

    totalProfile = json['total_profile'];
    totalPhoto = json['total_photo'];
    totalOrganisasiFavorit = json['total_organisasi_favorit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (user != null) {
      data['user'] = user!.toJson();
    }

    if (profile != null) {
      data['profile'] = profile!.toJson();
    }

    data['total_profile'] = totalProfile;
    data['total_photo'] = totalPhoto;
    data['total_organisasi_favorit'] = totalOrganisasiFavorit;

    return data;
  }
}

class User {
  int? id;
  String? username;
  String? email;
  String? fullname;
  String? encryptId;
  bool? isUser;
  bool? isAdmin;
  bool? isStaff;
  bool? isActive;
  bool? isValidate;
  String? lastLogin;
  String? creationDate;
  String? updateDate;

  User({
    this.id,
    this.username,
    this.email,
    this.fullname,
    this.encryptId,
    this.isUser,
    this.isAdmin,
    this.isStaff,
    this.isActive,
    this.isValidate,
    this.lastLogin,
    this.creationDate,
    this.updateDate,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    fullname = json['fullname'];
    encryptId = json['encrypt_id'];
    isUser = json['is_user'];
    isAdmin = json['is_admin'];
    isStaff = json['is_staff'];
    isActive = json['is_active'];
    isValidate = json['is_validate'];
    lastLogin = json['last_login'];
    creationDate = json['creation_date'];
    updateDate = json['update_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id;
    data['username'] = username;
    data['email'] = email;
    data['fullname'] = fullname;
    data['encrypt_id'] = encryptId;
    data['is_user'] = isUser;
    data['is_admin'] = isAdmin;
    data['is_staff'] = isStaff;
    data['is_active'] = isActive;
    data['is_validate'] = isValidate;
    data['last_login'] = lastLogin;
    data['creation_date'] = creationDate;
    data['update_date'] = updateDate;

    return data;
  }
}

class Profile {
  int? id;
  String? firstName;
  String? lastName;
  String? fullname;
  dynamic placeOfBirth;
  dynamic dateOfBirth;
  dynamic sex;
  String? sexText;
  String? marriedStatus;
  dynamic phoneNo;
  String? creationDate;
  String? updateDate;

  Profile({
    this.id,
    this.firstName,
    this.lastName,
    this.fullname,
    this.placeOfBirth,
    this.dateOfBirth,
    this.sex,
    this.sexText,
    this.marriedStatus,
    this.phoneNo,
    this.creationDate,
    this.updateDate,
  });

  Profile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    fullname = json['fullname'];
    placeOfBirth = json['place_of_birth'];
    dateOfBirth = json['date_of_birth'];
    sex = json['sex'];
    sexText = json['sex_text'];
    marriedStatus = json['married_status'];
    phoneNo = json['phone_no'];
    creationDate = json['creation_date'];
    updateDate = json['update_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['fullname'] = fullname;
    data['place_of_birth'] = placeOfBirth;
    data['date_of_birth'] = dateOfBirth;
    data['sex'] = sex;
    data['sex_text'] = sexText;
    data['married_status'] = marriedStatus;
    data['phone_no'] = phoneNo;
    data['creation_date'] = creationDate;
    data['update_date'] = updateDate;

    return data;
  }
}

class Metadata {
  int? status;
  int? code;
  String? message;

  Metadata({
    this.status,
    this.code,
    this.message,
  });

  Metadata.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['status'] = status;
    data['code'] = code;
    data['message'] = message;

    return data;
  }
}
