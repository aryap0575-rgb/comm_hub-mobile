import 'package:com.example.fincome_mobile_mobile/modules/home/model/departmen_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:com.example.fincome_mobile_mobile/modules/home/model/detail_org.dart';
import 'package:com.example.fincome_mobile_mobile/service/detail_organisasi_service.dart';

class DetailOrganisasiPage extends StatefulWidget {
  final int organisasiId;

  const DetailOrganisasiPage({
    Key? key,
    required this.organisasiId,
  }) : super(key: key);

  @override
  State<DetailOrganisasiPage> createState() => _DetailOrganisasiPageState();
}

class _DetailOrganisasiPageState extends State<DetailOrganisasiPage> {
  late Future<DetailOrg> _detailFuture;

  static const Color primaryRed = Color(0xFFD90429);
  static const Color softBg = Color(0xFFF8F7FC);
  static const Color greenWa = Color(0xFF139B8F);

  @override
  void initState() {
    super.initState();

    _detailFuture = DetailOrganisasiService.getDetailOrganisasi(
      organisasiId: widget.organisasiId,
    );
  }

  List<String> _misiToList(String misi) {
    final cleanMisi = misi.trim();

    if (cleanMisi.isEmpty) {
      return ['Belum ada misi organisasi'];
    }

    final result = cleanMisi
        .split(RegExp(r'\n|;'))
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();

    if (result.isEmpty) {
      return [cleanMisi];
    }

    return result;
  }

  String _formatWhatsappNumber(String wa) {
    String cleanNumber = wa.replaceAll(RegExp(r'[^0-9]'), '');

    if (cleanNumber.startsWith('0')) {
      cleanNumber = '62${cleanNumber.substring(1)}';
    }

    return cleanNumber;
  }

  Future<void> _openWhatsApp(String wa) async {
    final cleanNumber = _formatWhatsappNumber(wa);

    if (cleanNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nomor WhatsApp belum tersedia'),
        ),
      );
      return;
    }

    final uri = Uri.parse('https://wa.me/$cleanNumber');

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tidak dapat membuka WhatsApp'),
        ),
      );
    }
  }

  Widget _buildLoadingPage() {
    return const Scaffold(
      backgroundColor: softBg,
      body: Center(
        child: CircularProgressIndicator(
          color: primaryRed,
        ),
      ),
    );
  }

  Widget _buildErrorPage(String message) {
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  String _getText(dynamic value, String fallback) {
    if (value == null) return fallback;

    final text = value.toString().trim();

    if (text.isEmpty || text == 'null') {
      return fallback;
    }

    return text;
  }

  String? _getUrl(dynamic value) {
    if (value == null) return null;

    final text = value.toString().trim();

    if (text.isEmpty || text == 'null') {
      return null;
    }

    return text;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DetailOrg>(
      future: _detailFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingPage();
        }

        if (snapshot.hasError) {
          return _buildErrorPage(snapshot.error.toString());
        }

        final detail = snapshot.data;

        if (detail == null || detail.data == null) {
          return _buildErrorPage('Data organisasi tidak ditemukan.');
        }

        final data = detail.data;
        final organisasi = data?.organisasi;

        if (organisasi == null) {
          return _buildErrorPage('Data organisasi tidak ditemukan.');
        }

        final namaOrganisasi = _getText(
          organisasi.namaOrganisasi,
          'Nama Organisasi',
        );

        final namaKategori = organisasi.kategori?.displayName ?? 'Kategori';

        final tentang = _getText(
          organisasi.tentangOrganisasi,
          'Belum ada deskripsi organisasi.',
        );

        final visi = _getText(
          organisasi.visi,
          'Belum ada visi organisasi.',
        );

        final misi = _getText(
          organisasi.misi,
          'Belum ada misi organisasi.',
        );

        final wa = organisasi.wa;

        final galleryImages = data?.gallery
                .map((item) => _getUrl(item.foto))
                .whereType<String>()
                .toList() ??
            [];

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
                    _openWhatsApp(wa);
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
                HeaderSection(
                  headerImage: organisasi.sampul,
                  logoImage: organisasi.fotoProfile,
                  kategori: namaKategori,
                  namaOrganisasi: namaOrganisasi,
                ),
                const SizedBox(height: 18),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionTitle(
                        icon: Icons.info_outline,
                        title: 'Tentang Kami',
                      ),
                      const SizedBox(height: 10),
                      TextCard(
                        text: tentang,
                      ),
                      const SizedBox(height: 18),
                      VisionCard(
                        visi: visi,
                      ),
                      const SizedBox(height: 14),
                      MissionCard(
                        missions: _misiToList(misi),
                      ),
                      const SizedBox(height: 16),
                      SimpleMenuCard(
                        icon: Icons.groups_outlined,
                        title: 'Departemen',
                        total: data?.totalDepartemen ?? 0,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DepartemenPage(
                                organisasiId: widget.organisasiId,
                                namaOrganisasi: namaOrganisasi,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      SimpleMenuCard(
                        icon: Icons.workspace_premium_outlined,
                        title: 'Prestasi',
                        total: data?.totalPrestasi ?? 0,
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(18),
                              ),
                            ),
                            builder: (context) {
                              return PrestasiBottomSheet(
                                prestasi: data?.prestasi ?? [],
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 18),
                      const GalleryTitle(),
                      const SizedBox(height: 10),
                      GallerySection(
                        images: galleryImages,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class HeaderSection extends StatelessWidget {
  const HeaderSection({
    Key? key,
    required this.headerImage,
    required this.logoImage,
    required this.kategori,
    required this.namaOrganisasi,
  }) : super(key: key);

  final String? headerImage;
  final String? logoImage;
  final String kategori;
  final String namaOrganisasi;

  static const Color primaryRed = Color(0xFFD90429);
  static const Color softBg = Color(0xFFF8F7FC);

  Widget _buildNetworkImage({
    required String? imageUrl,
    required double width,
    required double height,
    required BoxFit fit,
    BorderRadius? borderRadius,
  }) {
    final Widget child;

    if (imageUrl == null || imageUrl.isEmpty) {
      child = Container(
        width: width,
        height: height,
        color: Colors.grey.shade300,
        child: const Center(
          child: Icon(Icons.image),
        ),
      );
    } else {
      child = Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: width,
            height: height,
            color: Colors.grey.shade300,
            child: const Center(
              child: Icon(Icons.image),
            ),
          );
        },
      );
    }

    if (borderRadius == null) {
      return child;
    }

    return ClipRRect(
      borderRadius: borderRadius,
      child: child,
    );
  }

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
            child: _buildNetworkImage(
              imageUrl: headerImage,
              width: double.infinity,
              height: 210,
              fit: BoxFit.cover,
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
                    child: _buildNetworkImage(
                      imageUrl: logoImage,
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                      borderRadius: BorderRadius.circular(6),
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
                          child: Text(
                            kategori,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          namaOrganisasi.toUpperCase(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
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
  const VisionCard({
    Key? key,
    required this.visi,
  }) : super(key: key);

  final String visi;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'VISI',
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            visi,
            style: const TextStyle(
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
  const MissionCard({
    Key? key,
    required this.missions,
  }) : super(key: key);

  final List<String> missions;

  static const Color primaryRed = Color(0xFFD90429);

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
    required this.total,
    required this.onTap,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final int total;
  final VoidCallback onTap;

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
              '$title ($total)',
              style: const TextStyle(
                color: primaryRed,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          InkWell(
            onTap: onTap,
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
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Galeri Kegiatan',
          style: TextStyle(
            color: primaryRed,
            fontWeight: FontWeight.w800,
            fontSize: 15,
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
    if (images.isEmpty) {
      return Container(
        height: 115,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            'Belum ada galeri',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
        ),
      );
    }

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
        },
      ),
    );
  }
}

class DepartemenBottomSheet extends StatelessWidget {
  const DepartemenBottomSheet({
    Key? key,
    required this.departemen,
  }) : super(key: key);

  final List<DepartemenOrg> departemen;

  static const Color primaryRed = Color(0xFFD90429);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Departemen',
            style: TextStyle(
              color: primaryRed,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          if (departemen.isEmpty)
            const Text(
              'Belum ada data departemen',
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            )
          else
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: departemen.length,
                separatorBuilder: (context, index) {
                  return const Divider();
                },
                itemBuilder: (context, index) {
                  final item = departemen[index];

                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.groups_outlined,
                      color: primaryRed,
                    ),
                    title: Text(
                      item.departemen.isNotEmpty
                          ? item.departemen
                          : 'Departemen',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    subtitle: Text(
                      item.detailDepartemen.isNotEmpty
                          ? item.detailDepartemen
                          : 'Belum ada detail departemen',
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class PrestasiBottomSheet extends StatelessWidget {
  const PrestasiBottomSheet({
    Key? key,
    required this.prestasi,
  }) : super(key: key);

  final List<PrestasiOrg> prestasi;

  static const Color primaryRed = Color(0xFFD90429);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Prestasi',
            style: TextStyle(
              color: primaryRed,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          if (prestasi.isEmpty)
            const Text(
              'Belum ada data prestasi',
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            )
          else
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: prestasi.length,
                separatorBuilder: (context, index) {
                  return const Divider();
                },
                itemBuilder: (context, index) {
                  final item = prestasi[index];

                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.workspace_premium_outlined,
                      color: primaryRed,
                    ),
                    title: Text(
                      item.prestasi.isNotEmpty ? item.prestasi : 'Prestasi',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    subtitle: Text(
                      item.detailPrestasi.isNotEmpty
                          ? item.detailPrestasi
                          : 'Belum ada detail prestasi',
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
