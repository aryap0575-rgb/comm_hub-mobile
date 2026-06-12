import 'package:flutter/material.dart';

class PrestasiOrganisasiPage extends StatelessWidget {
  const PrestasiOrganisasiPage({Key? key}) : super(key: key);

  static const Color primaryRed = Color(0xFFD90429);
  static const Color softRed = Color(0xFFFFEEF1);
  static const Color textDark = Color(0xFF222222);

  static const List<Achievement> achievements = [
    Achievement(
      icon: Icons.emoji_events,
      title: "Juara 1 Lomba\nLingkungan Hidup",
      organization: "Pemerintah Kota Balikpapan",
      description:
          "Pencapaian atas inisiatif pengelolaan sampah terpadu di kawasan pesisir Balikpapan.",
      year: "2023",
    ),
    Achievement(
      icon: Icons.workspace_premium,
      title: "Best Community\nInitiative",
      organization: "East Kalimantan Social Forum",
      description:
          "Pengakuan sebagai komunitas paling aktif dalam pemberdayaan relawan muda di Kalimantan Timur.",
      year: "2023",
    ),
    Achievement(
      icon: Icons.nature_people,
      title: "Pelopor Restorasi\nMangrove",
      organization: "DLH Kota Balikpapan",
      description:
          "Berhasil menanam lebih dari 15.000 bibit mangrove di area kritis sepanjang tahun 2022.",
      year: "2022",
    ),
    Achievement(
      icon: Icons.verified_user,
      title: "Sertifikasi Komunitas\nHijau",
      organization: "Yayasan Keanekaragaman Hayati",
      description:
          "Mendapatkan akreditasi sebagai organisasi pengelola lingkungan dengan standar transparansi tinggi.",
      year: "2021",
    ),
    Achievement(
      icon: Icons.people,
      title: "Apresiasi Relawan\nTerbanyak",
      organization: "Balikpapan Youth Center",
      description:
          "Menggerakkan 5.000+ relawan dalam satu hari kampanye Balikpapan Bersih & Hijau.",
      year: "2020",
    ),
    Achievement(
      icon: Icons.business,
      title: "Kemitraan CSR Terbaik",
      organization: "Pertamina Balikpapan",
      description:
          "Kolaborasi strategis paling berdampak dalam pelestarian hutan kota selama 3 tahun berturut-turut.",
      year: "2019",
    ),
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
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 90),
                child: Column(
                  children: [
                    _buildHighlightCard(),
                    const SizedBox(height: 16),
                    Column(
                      children: achievements.map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: AchievementCard(item: item),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 8),
                    _buildBottomMessageCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavigationPrestasi(),
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
                Icons.arrow_back,
                size: 22,
                color: primaryRed,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            "Prestasi Organisasi",
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
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.network(
                "https://i.pravatar.cc/150?img=12",
                fit: BoxFit.cover,
                errorBuilder: imageErrorBuilder,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: primaryRed,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: primaryRed.withOpacity(0.22),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.emoji_events,
              color: primaryRed,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "PENCAPAIAN TERBARU",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Penghargaan\nLingkungan\nBerkelanjutan\n2025",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    height: 1.05,
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

  Widget _buildBottomMessageCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color(0xFFFFC400),
          width: 3,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 160,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFF2F0EA),
              borderRadius: BorderRadius.circular(2),
            ),
            child: const Icon(
              Icons.emoji_events,
              color: Color(0xFFC58A00),
              size: 72,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            "Kami terus berkomitmen untuk\nmemberikan dampak positif bagi\nBalikpapan melalui aksi nyata.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              height: 1.45,
              color: Color(0xFF444444),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

Widget imageErrorBuilder(
  BuildContext context,
  Object error,
  StackTrace? stackTrace,
) {
  return Container(
    color: Colors.grey.shade300,
    child: const Center(
      child: Icon(
        Icons.image_not_supported,
        color: Colors.grey,
        size: 28,
      ),
    ),
  );
}

class Achievement {
  final IconData icon;
  final String title;
  final String organization;
  final String description;
  final String year;

  const Achievement({
    required this.icon,
    required this.title,
    required this.organization,
    required this.description,
    required this.year,
  });
}

class AchievementCard extends StatelessWidget {
  const AchievementCard({
    Key? key,
    required this.item,
  }) : super(key: key);

  final Achievement item;

  static const Color primaryRed = Color(0xFFD90429);
  static const Color softRed = Color(0xFFFFEEF1);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: primaryRed.withOpacity(0.25),
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: softRed,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Icon(
                  item.icon,
                  color: primaryRed,
                  size: 23,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 34),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 13.5,
                          height: 1.15,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF222222),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.organization,
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF555555),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        item.description,
                        style: const TextStyle(
                          fontSize: 10.2,
                          height: 1.35,
                          color: Color(0xFF555555),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 3,
              ),
              decoration: BoxDecoration(
                color: primaryRed,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                item.year,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 8.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomNavigationPrestasi extends StatelessWidget {
  const BottomNavigationPrestasi({Key? key}) : super(key: key);

  static const Color primaryRed = Color(0xFFD90429);

  @override
  Widget build(BuildContext context) {
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
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          BottomNavItemPrestasi(
            icon: Icons.home,
            label: "Home",
            isActive: false,
          ),
          BottomNavItemPrestasi(
            icon: Icons.explore,
            label: "Discover",
            isActive: true,
          ),
          BottomNavItemPrestasi(
            icon: Icons.bookmark_border,
            label: "Saved",
            isActive: false,
          ),
          BottomNavItemPrestasi(
            icon: Icons.person,
            label: "Account",
            isActive: false,
          ),
        ],
      ),
    );
  }
}

class BottomNavItemPrestasi extends StatelessWidget {
  const BottomNavItemPrestasi({
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