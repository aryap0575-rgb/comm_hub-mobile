import 'package:flutter/material.dart';

class DepartemenPage extends StatelessWidget {
  const DepartemenPage({Key? key}) : super(key: key);

  static const Color primaryRed = Color(0xFFD90429);
  static const Color softRed = Color(0xFFFFF1F1);

  static const List<Map<String, String>> departemenList = [
    {
      "title": "Departemen Kaderisasi",
      "desc":
          "Bidang kaderisasi adalah tulang punggung organisasi yang bertanggung jawab merencanakan, melaksanakan, dan mengevaluasi proses penerimaan anggota baru. Kaderisasi juga menjadi sarana membentuk karakter, loyalitas, dan komitmen anggota."
    },
    {
      "title": "Departemen Syiar Dakwah",
      "desc":
          "Departemen Syiar Dakwah berperan dalam menyusun dan menjalankan kegiatan keislaman seperti kajian, tahsin, kelas keagamaan, serta program dakwah kampus."
    },
    {
      "title": "Departemen Humas dan Media",
      "desc":
          "Departemen Humas dan Media bertugas mengelola komunikasi organisasi, publikasi kegiatan, dokumentasi, desain konten, serta hubungan dengan pihak internal dan eksternal."
    },
    {
      "title": "Departemen Dana Usaha",
      "desc":
          "Departemen Dana Usaha bertanggung jawab dalam merancang kegiatan usaha dan penggalangan dana untuk mendukung kebutuhan program kerja organisasi."
    },
    {
      "title": "Departemen Kemuslimahan",
      "desc":
          "Departemen Kemuslimahan berfokus pada pembinaan, kegiatan, dan ruang pengembangan khusus bagi anggota muslimah dalam organisasi."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 90),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeroCard(),
                    const SizedBox(height: 20),
                    const Text(
                      "Setiap tim bekerja secara sinergis untuk mencapai visi organisasi.",
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF555555),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Column(
                      children: departemenList.map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: DepartmentCard(
                            title: item["title"] ?? "",
                            description: item["desc"] ?? "",
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
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
              children: const [
                Text(
                  "UKM AL-IZZAH",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 4),
                Text(
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
