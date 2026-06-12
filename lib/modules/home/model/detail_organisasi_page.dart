import 'package:flutter/material.dart';

class DetailOrganisasiPage extends StatelessWidget {
  const DetailOrganisasiPage({Key? key}) : super(key: key);

  static const String headerImage =
      'https://images.unsplash.com/photo-1600585154340-be6161a56a0c';

  static const String logoImage =
      'https://images.unsplash.com/photo-1529156069898-49953e39b3ac';

  static const List<String> galleryImages = [
    'https://images.unsplash.com/photo-1529156069898-49953e39b3ac',
    'https://images.unsplash.com/photo-1501004318641-b39e6451bec6',
    'https://images.unsplash.com/photo-1517048676732-d65bc937f952',
  ];

  static const Color primaryRed = Color(0xFFD90429);
  static const Color softBg = Color(0xFFF8F7FC);
  static const Color greenWa = Color(0xFF139B8F);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: primaryRed,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Detail Organisasi',
          style: TextStyle(
            color: primaryRed,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
          child: SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: greenWa,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                // TODO: arahkan ke WhatsApp
              },
              icon: const Icon(
                Icons.chat_bubble_outline,
                size: 18,
              ),
              label: const Text(
                'Hubungi Via WhatsApp',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HeaderSection(
              headerImage: headerImage,
              logoImage: logoImage,
            ),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SectionTitle(
                    icon: Icons.info_outline,
                    title: 'Tentang Kami',
                  ),
                  SizedBox(height: 10),
                  TextCard(
                    text:
                        'Yayasan Balikpapan Hijau adalah inisiatif komunitas yang berdedikasi untuk menjaga kelestarian ekosistem pesisir dan hutan kota di Balikpapan. Berdiri sejak tahun 2015, kami telah melibatkan lebih dari 5.000 relawan lokal dalam berbagai program reboisasi dan edukasi lingkungan.',
                  ),
                  SizedBox(height: 18),
                  VisionCard(),
                  SizedBox(height: 14),
                  MissionCard(),
                  SizedBox(height: 16),
                  SimpleMenuCard(
                    icon: Icons.groups_outlined,
                    title: 'Departemen',
                  ),
                  SizedBox(height: 12),
                  SimpleMenuCard(
                    icon: Icons.workspace_premium_outlined,
                    title: 'Prestasi',
                  ),
                  SizedBox(height: 18),
                  GalleryTitle(),
                  SizedBox(height: 10),
                  GallerySection(
                    images: galleryImages,
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  const HeaderSection({
    Key? key,
    required this.headerImage,
    required this.logoImage,
  }) : super(key: key);

  final String headerImage;
  final String logoImage;

  static const Color primaryRed = Color(0xFFD90429);
  static const Color softBg = Color(0xFFF8F7FC);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SizedBox(
            height: 210,
            width: double.infinity,
            child: Image.network(
              headerImage,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey.shade300,
                  child: const Center(
                    child: Icon(
                      Icons.image,
                      size: 40,
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 120,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    softBg,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 18,
            right: 18,
            bottom: -2,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: primaryRed.withOpacity(0.35),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: primaryRed,
                        width: 1.5,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        logoImage,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.image),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: primaryRed,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Keagamaan',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'UKM AL-IZZAH UNIVERSITAS\nMULIA BALIKPAPAN',
                          style: TextStyle(
                            color: primaryRed,
                            fontSize: 14,
                            height: 1.2,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    Key? key,
    required this.icon,
    required this.title,
  }) : super(key: key);

  final IconData icon;
  final String title;

  static const Color primaryRed = Color(0xFFD90429);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: primaryRed,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: primaryRed,
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

class TextCard extends StatelessWidget {
  const TextCard({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  static const Color primaryRed = Color(0xFFD90429);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: primaryRed.withOpacity(0.25),
        ),
      ),
      child: Text(
        text,
        textAlign: TextAlign.justify,
        style: TextStyle(
          color: Colors.grey.shade700,
          fontSize: 12,
          height: 1.7,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class VisionCard extends StatelessWidget {
  const VisionCard({Key? key}) : super(key: key);

  static const Color primaryRed = Color(0xFFD90429);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
      decoration: BoxDecoration(
        color: primaryRed,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'VISI',
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Menjadi pelopor restorasi\nekosistem urban yang mandiri\ndi Kalimantan Timur.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              height: 1.25,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class MissionCard extends StatelessWidget {
  const MissionCard({Key? key}) : super(key: key);

  static const Color primaryRed = Color(0xFFD90429);

  static const List<String> missions = [
    'Mengedukasi masyarakat tentang pengelolaan sampah.',
    'Melakukan penanaman 10.000 mangrove setiap tahun.',
    'Membangun jaringan kolaborasi antar komunitas hijau.',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
      decoration: BoxDecoration(
        color: const Color(0xFFE7F0FF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'MISI',
            style: TextStyle(
              color: primaryRed,
              fontSize: 11,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          Column(
            children: missions.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 9),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '•',
                      style: TextStyle(
                        color: primaryRed,
                        fontSize: 18,
                        height: 1,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 11.5,
                          height: 1.4,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class SimpleMenuCard extends StatelessWidget {
  const SimpleMenuCard({
    Key? key,
    required this.icon,
    required this.title,
  }) : super(key: key);

  final IconData icon;
  final String title;

  static const Color primaryRed = Color(0xFFD90429);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF5F8),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: primaryRed.withOpacity(0.25),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: primaryRed,
            size: 24,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: primaryRed,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              // TODO: arahkan ke halaman detail departemen/prestasi
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 11,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: primaryRed,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Lihat Detail',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GalleryTitle extends StatelessWidget {
  const GalleryTitle({Key? key}) : super(key: key);

  static const Color primaryRed = Color(0xFFD90429);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Galeri Kegiatan',
          style: TextStyle(
            color: primaryRed,
            fontWeight: FontWeight.w800,
            fontSize: 15,
          ),
        ),
        GestureDetector(
          onTap: () {
            // TODO: arahkan ke halaman semua galeri
          },
          child: const Text(
            'Lihat Semua',
            style: TextStyle(
              color: primaryRed,
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }
}

class GallerySection extends StatelessWidget {
  const GallerySection({
    Key? key,
    required this.images,
  }) : super(key: key);

  final List<String> images;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: images.length,
          separatorBuilder: (context, index) {
            return const SizedBox(width: 10);
          },
          itemBuilder: (context, index) {
            final double imageWidth = index == 0 ? 150 : 90;

            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                images[index],
                width: imageWidth,
                height: 115,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: imageWidth,
                    height: 115,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.image),
                  );
                },
              ),
            );
          }),
    );
  }
}
