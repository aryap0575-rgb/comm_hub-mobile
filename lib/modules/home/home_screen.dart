import 'dart:async';

import 'package:com.example.fincome_mobile_mobile/core/router_name.dart';
import 'package:com.example.fincome_mobile_mobile/modules/home/model/detail_org.dart'
    as detail;
import 'package:com.example.fincome_mobile_mobile/modules/home/model/discover_screen.dart';
import 'package:com.example.fincome_mobile_mobile/modules/home/modules/detailorg.dart';
import 'package:com.example.fincome_mobile_mobile/modules/home/profile_screen.dart';
import 'package:com.example.fincome_mobile_mobile/modules/home/saved_screen.dart';
import 'package:com.example.fincome_mobile_mobile/modules/url/urls.dart';
import 'package:com.example.fincome_mobile_mobile/service/detail_organisasi_service.dart';
import 'package:com.example.fincome_mobile_mobile/widgets/CommunityCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, this.from = 'splash'}) : super(key: key);

  final String? from;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;

  bool demoMode = true;
  int indexDemo = 0;

  InAppWebViewController? webViewController;

  bool isFridayOverrideActive = false;
  int progress = 0;

  Timer? prayerTimer;
  Set<String> triggeredToday = {};

  String url = "${Urls().wallpaper()}";

  late Future<DetailOrg> _futureOrganisasi;

  @override
  void initState() {
    super.initState();
    _futureOrganisasi = DetailOrganisasiService.getSemuaOrganisasi();
  }

  @override
  void dispose() {
    prayerTimer?.cancel();
    super.dispose();
  }

  void periodicReload() {
    Timer.periodic(const Duration(minutes: 10), (timer) {
      if (webViewController != null) {
        webViewController!.reload();
      }
    });
  }

  Future<void> logoutProcess() async {
    const storage = FlutterSecureStorage();
    await storage.deleteAll();

    if (!mounted) return;

    Navigator.of(context).pushNamedAndRemoveUntil(
      RouteNames.signInScreen,
      (route) => false,
    );
  }

  Future<void> _refreshOrganisasi() async {
    setState(() {
      _futureOrganisasi = DetailOrganisasiService.getSemuaOrganisasi();
    });

    await _futureOrganisasi;
  }

  Widget _buildHome() {
    return RefreshIndicator(
      onRefresh: _refreshOrganisasi,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SEARCH
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Pencarian Cepat',
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // TITLE SEMUA ORGANISASI
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Semua Organisasi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _currentIndex = 1;
                      });
                    },
                    child: const Text(
                      'Lihat Semua',
                      style: TextStyle(
                        color: Color(0xFFC6132C),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // FUTURE BUILDER ORGANISASI
            FutureBuilder<DetailOrg>(
              future: _futureOrganisasi,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 320,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFC6132C),
                      ),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
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
                  );
                }

                final organisasiList = snapshot.data?.data ?? [];

                if (organisasiList.isEmpty) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
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
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // LIST HORIZONTAL SEMUA ORGANISASI
                    SizedBox(
                      height: 320,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: organisasiList.length,
                        itemBuilder: (context, index) {
                          final org = organisasiList[index];

                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: CommunityCard(
                              image: _getOrganisasiImage(org),
                              category:
                                  org.kategori?.category ?? 'Organisasi',
                              title: org.name ?? org.nama ?? '-',
                              description: org.tentangOrganisasi ??
                                  'Belum ada deskripsi organisasi.',
                            ),
                          );
                        },
                      ),
                    ),

                    // TITLE TERBARU BERGABUNG
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Text(
                        'Terbaru Bergabung',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                    ),

                    // CARD TERBARU
                    _buildTerbaruBergabung(organisasiList.first),
                  ],
                );
              },
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  String _getOrganisasiImage(org) {
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

  Widget _buildTerbaruBergabung(org) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              _getOrganisasiImage(org),
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey.shade200,
                  child: const Icon(
                    Icons.groups,
                    color: Color(0xFFC6132C),
                  ),
                );
              },
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (org.kategori?.category ?? 'ORGANISASI').toUpperCase(),
                  style: const TextStyle(
                    color: Color(0xFFC6132C),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  org.name ?? org.nama ?? '-',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  org.lokasi ?? 'Lokasi belum tersedia',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
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
    );
  }

  Widget _buildSaved() {
    return const SavedScreen();
  }

  Widget _buildAccount() {
    return ProfileScreen(
      onLogout: () => logoutProcess(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildHome(),
      const DiscoverScreen(),
      _buildSaved(),
      _buildAccount(),
    ];

    final List<String> titles = [
      'COMM.HUB',
      'COMM.HUB  ',
      'Saved',
      'Account',
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFC6132C),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.groups,
              color: Colors.white,
            ),
          ),
        ),
        title: Text(
          titles[_currentIndex],
          style: const TextStyle(
            color: Color(0xFFC6132C),
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(
                'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
              ),
            ),
          ),
        ],
      ),

      body: pages[_currentIndex],

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFFC6132C),
          unselectedItemColor: Colors.grey,
          currentIndex: _currentIndex,
          backgroundColor: Colors.white,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined),
              label: 'Discover',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_outline),
              label: 'Saved',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Account',
            ),
          ],
        ),
      ),
    );
  }
}