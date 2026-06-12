import 'package:flutter/material.dart';

import 'prestasi_page.dart';
import 'departmen_page.dart';

class DetailOrganisasiPage extends StatefulWidget {
  final int organisasiId;
  final String namaOrganisasi;
  final String? kategori;
  final String? tentangOrganisasi;
  final String? visi;
  final String? misi;
  final String? imageUrl;
  final String? logoUrl;

  const DetailOrganisasiPage({
    Key? key,
    required this.organisasiId,
    required this.namaOrganisasi,
    this.kategori,
    this.tentangOrganisasi,
    this.visi,
    this.misi,
    this.imageUrl,
    this.logoUrl,
  }) : super(key: key);

  @override
  State<DetailOrganisasiPage> createState() => _DetailOrganisasiPageState();
}

class _DetailOrganisasiPageState extends State<DetailOrganisasiPage> {
  static const Color primaryRed = Color(0xFFD90429);
  static const Color softRed = Color(0xFFFFF1F1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 90),
                children: [
                  _buildHeroCard(),
                  const SizedBox(height: 20),
                  _buildAboutSection(),
                  const SizedBox(height: 18),
                  _buildMenuSection(context),
                  const SizedBox(height: 18),
                  _buildVisiMisiSection(),
                ],
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
            "Detail Organisasiex",
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
            child: Image.network(
              widget.logoUrl?.isNotEmpty == true
                  ? widget.logoUrl!
                  : "https://i.pravatar.cc/150?img=12",
              fit: BoxFit.cover,
              errorBuilder: _functionImageError,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard() {
    final String image = widget.imageUrl?.isNotEmpty == true
        ? widget.imageUrl!
        : "https://images.unsplash.com/photo-1521737604893-d14cc237f11d?w=900";

    return Container(
      height: 170,
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
            image,
            fit: BoxFit.cover,
            errorBuilder: _functionImageError,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  primaryRed.withOpacity(0.88),
                  primaryRed.withOpacity(0.25),
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
                  widget.kategori?.isNotEmpty == true
                      ? widget.kategori!.toUpperCase()
                      : "ORGANISASI",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  widget.namaOrganisasi,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    height: 1.15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: primaryRed.withOpacity(0.18),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryRed.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        widget.tentangOrganisasi?.isNotEmpty == true
            ? widget.tentangOrganisasi!
            : "Belum ada deskripsi organisasi.",
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xFF555555),
          height: 1.55,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return Column(
      children: [
        DetailMenuCard(
          icon: Icons.groups_rounded,
          title: "Departemen Organisasi",
          description: "Lihat struktur dan divisi yang ada di organisasi.",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DepartemenPage(
                  organisasiId: widget.organisasiId,
                  namaOrganisasi: widget.namaOrganisasi,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 12),

        // INI BAGIAN PRESTASI ORGANISASI
        DetailMenuCard(
          icon: Icons.emoji_events_rounded,
          title: "Prestasi Organisasi",
          description: "Lihat daftar pencapaian dan prestasi organisasi.",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PrestasiPage(
                  organisasiId: widget.organisasiId,
                  namaOrganisasi: widget.namaOrganisasi,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildVisiMisiSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Visi & Misi",
          style: TextStyle(
            color: Color(0xFF222222),
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 12),
        _buildTextInfoCard(
          title: "Visi",
          value: widget.visi?.isNotEmpty == true
              ? widget.visi!
              : "Belum ada data visi.",
        ),
        const SizedBox(height: 12),
        _buildTextInfoCard(
          title: "Misi",
          value: widget.misi?.isNotEmpty == true
              ? widget.misi!
              : "Belum ada data misi.",
        ),
      ],
    );
  }

  Widget _buildTextInfoCard({
    required String title,
    required String value,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: primaryRed.withOpacity(0.18),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: primaryRed,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF555555),
              height: 1.5,
              fontWeight: FontWeight.w500,
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
          DetailBottomNavItem(
            icon: Icons.home_outlined,
            label: "Home",
            isActive: false,
          ),
          DetailBottomNavItem(
            icon: Icons.business_center_rounded,
            label: "Discover",
            isActive: true,
          ),
          DetailBottomNavItem(
            icon: Icons.bookmark_border_rounded,
            label: "Saved",
            isActive: false,
          ),
          DetailBottomNavItem(
            icon: Icons.person_outline_rounded,
            label: "Account",
            isActive: false,
          ),
        ],
      ),
    );
  }
}

Widget _functionImageError(
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

class DetailMenuCard extends StatelessWidget {
  const DetailMenuCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  static const Color primaryRed = Color(0xFFD90429);
  static const Color softRed = Color(0xFFFFEFEF);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
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
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: softRed,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: primaryRed,
                size: 28,
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
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF555555),
                      height: 1.35,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: primaryRed,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class DetailBottomNavItem extends StatelessWidget {
  const DetailBottomNavItem({
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
