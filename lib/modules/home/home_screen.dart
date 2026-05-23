import 'package:dpad/dpad.dart';
import 'package:com.example.fincome_mobile_mobile/modules/home/model/jadwal_sholat_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:com.example.fincome_mobile_mobile/constants/text_styles.dart';
import 'package:com.example.fincome_mobile_mobile/modules/authentication/models/auth_model.dart';
import 'package:com.example.fincome_mobile_mobile/modules/url/urls.dart';
import 'package:com.example.fincome_mobile_mobile/modules/home/model/discover_screen.dart';
import 'package:com.example.fincome_mobile_mobile/widgets/CommunityCard.dart';
import 'package:com.example.fincome_mobile_mobile/widgets/CategoryItem.dart';
// Tambah import ini
import 'package:com.example.fincome_mobile_mobile/modules/home/profile_screen.dart';
import 'package:com.example.fincome_mobile_mobile/modules/home/saved_screen.dart';
import 'package:com.example.fincome_mobile_mobile/utils/k_images.dart';
import 'package:com.example.fincome_mobile_mobile/utils/utils.dart';
import 'package:com.example.fincome_mobile_mobile/widgets/common_button.dart';
import 'package:com.example.fincome_mobile_mobile/widgets/common_text_field_view.dart';
import 'package:com.example.fincome_mobile_mobile/widgets/custom_image.dart';
import '../../../core/router_name.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:com.example.fincome_mobile_mobile/modules/home/profile_screen.dart';
import 'package:com.example.fincome_mobile_mobile/modules/home/saved_screen.dart';

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

  void periodicReload() {
    Timer.periodic(const Duration(minutes: 10), (timer) {
      webViewController!.reload();
    });
  }

  logoutProcess() async {
    const storage = FlutterSecureStorage();
    await storage.deleteAll();
    Navigator.of(context).pushNamedAndRemoveUntil(
      RouteNames.signInScreen,
      (route) => false,
    );
  }

  Future<void> checkJadwalSholat() async {
    final response = await http.post(
      Urls().synchJadwalSholat(),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{}),
    );
    try {
      if (response.statusCode == 200) {
        var respon = JadwalSholat.fromJson(jsonDecode(response.body));
        startPrayerScheduler(respon.jadwalSholat!, (mode) {
          if (mode == "standby") {
            webViewController?.loadUrl(
              urlRequest:
                  URLRequest(url: WebUri("${Urls().standbyWallpaper()}")),
            );
          } else {
            webViewController?.loadUrl(
              urlRequest: URLRequest(url: WebUri("${Urls().wallpaper()}")),
            );
          }
        });
      } else {
        ShowNotif.failed(
            duration: 3000, message: "Terjadi kesalahan", context: context);
      }
    } catch (exc) {
      ShowNotif.failed(
          message: 'Terjadi kesalahan, harap coba lagi', context: context);
    }
  }

  void startPrayerScheduler(
      String jadwalSholatJson, Function(String mode) callback) {
    final Map<String, dynamic> jadwal = jsonDecode(jadwalSholatJson);
    prayerTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      final now = DateTime.now();
      if (isFridayOverrideActive) return;
      if (now.hour == 0 && now.minute == 0) triggeredToday.clear();

      void checkTrigger(
          String name, String timeString, int offsetMinutes, String mode) {
        final parts = timeString.split(":");
        final target = DateTime(now.year, now.month, now.day,
                int.parse(parts[0]), int.parse(parts[1]))
            .add(Duration(minutes: offsetMinutes));
        String key = "$name-${target.hour}:${target.minute}";
        final difference = now.difference(target).abs().inMinutes;
        if (difference <= 2 && !triggeredToday.contains(key)) {
          triggeredToday.add(key);
          callback(mode);
        }
      }

      checkTrigger("isya+30", jadwal["isya"], 30, "standby");
      checkTrigger("imsak-30", jadwal["imsak"], -30, "wallpaper");
      checkTrigger("subuh+30", jadwal["subuh"], 30, "standby");
      checkTrigger("dzuhur-30", jadwal["dzuhur"], -30, "wallpaper");
      checkTrigger("ashar+30", jadwal["ashar"], 30, "standby");
      checkTrigger("maghrib-30", jadwal["maghrib"], -30, "wallpaper");
    });
  }

  Widget _buildHome() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Pencarian Cepat',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
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
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text('Kategori Populer',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937))),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: const [
                CategoryItem(
                    icon: Icons.sports_soccer, label: 'HOBI &\nOLAHRAGA'),
                CategoryItem(
                    icon: Icons.school, label: 'PENDIDIKAN &\nKEPEMUDAAN'),
                CategoryItem(
                    icon: Icons.favorite, label: 'SOSIAL &\nKEMANUSIAAN'),
                CategoryItem(icon: Icons.church, label: 'KEAGAMAAN'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Favorit Terbanyak',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937))),
                TextButton(
                  onPressed: () => setState(() => _currentIndex = 1),
                  child: const Text('Lihat Semua',
                      style: TextStyle(
                          color: Color(0xFFC6132C),
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 320,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: const [
                CommunityCard(
                  image: 'https://picsum.photos/seed/masjid/400/200',
                  category: 'Keagamaan',
                  title: 'UKM AL-IZZAH UNIVERSITAS MULIA',
                  description:
                      'Membangun generasi cerdas melalui program mentoring dan pengembangan diri yang berkelanjutan...',
                ),
                CommunityCard(
                  image: 'https://picsum.photos/seed/sosial/400/200',
                  category: 'Sosial',
                  title: 'HIMPUNAN MAHASISWA SOSIAL',
                  description:
                      'Pusat kolaborasi untuk membantu sesama dan mengembangkan jiwa sosial kemanusiaan...',
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text('Terbaru Bergabung',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937))),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4)),
              ],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    'https://picsum.photos/seed/basket/200/200',
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('KEAGAMAAN',
                          style: TextStyle(
                              color: Color(0xFFC6132C),
                              fontSize: 10,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('UKM Al-Izzah Universitas Mulia',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14)),
                      SizedBox(height: 2),
                      Text('2 jam yang lalu',
                          style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
          const SizedBox(height: 100),
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

    final List<String> titles = ['COMM.HUB', 'COMM.HUB  ', 'Saved', 'Account'];

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
            child: const Icon(Icons.groups, color: Colors.white),
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
                  'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100'),
            ),
          ),
        ],
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFFC6132C),
          unselectedItemColor: Colors.grey,
          currentIndex: _currentIndex,
          backgroundColor: Colors.white,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
            BottomNavigationBarItem(
                icon: Icon(Icons.explore_outlined), label: 'Discover'),
            BottomNavigationBarItem(
                icon: Icon(Icons.bookmark_outline), label: 'Saved'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_outline), label: 'Account'),
          ],
        ),
      ),
    );
  }
}
