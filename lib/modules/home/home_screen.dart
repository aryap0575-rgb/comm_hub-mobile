import 'package:dpad/dpad.dart';
import 'package:com.example.fincome_mobile_mobile/modules/home/model/jadwal_sholat_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'dart:convert';

import 'package:dpad/dpad.dart';
import 'package:com.example.fincome_mobile_mobile/constants/text_styles.dart';
import 'package:com.example.fincome_mobile_mobile/modules/authentication/models/auth_model.dart';
import 'package:com.example.fincome_mobile_mobile/modules/url/urls.dart';
import 'package:com.example.fincome_mobile_mobile/utils/k_images.dart';
import 'package:com.example.fincome_mobile_mobile/utils/utils.dart';
import 'package:com.example.fincome_mobile_mobile/widgets/common_button.dart';
import 'package:com.example.fincome_mobile_mobile/widgets/common_text_field_view.dart';
import 'package:com.example.fincome_mobile_mobile/widgets/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/router_name.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, this.from = 'splash'}) : super(key: key);
  final String? from;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  // For demo purposes
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
      debugPrint("PeriodicReload: RELOAD");
      webViewController!.reload();
    });
  }

  void startFridayListener(Function callback) {
    Timer.periodic(const Duration(seconds: 30), (timer) {
      final now = DateTime.now();
      debugPrint("StartFridayListener: $now");
      if (now.weekday == DateTime.friday &&
          now.hour == 11 &&
          now.minute == 50) {
        callback();
      }
    });
  }

  void endFridayListener(Function callback) {
    Timer.periodic(const Duration(seconds: 30), (timer) {
      final now = DateTime.now();
      debugPrint("EndFridayListener: $now");
      if (now.weekday == DateTime.friday &&
          now.hour == 12 &&
          now.minute == 40) {
        callback();
      }
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
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{}),
    );
    try {
      if (response.statusCode == 200) {
        var respon = JadwalSholat.fromJson(jsonDecode(response.body));
        startPrayerScheduler(respon.jadwalSholat!, (mode) {
          if (mode == "standby") {
            webViewController?.loadUrl(
              urlRequest: URLRequest(
                url: WebUri("${Urls().standbyWallpaper()}"),
              ),
            );
          } else {
            webViewController?.loadUrl(
              urlRequest: URLRequest(
                url: WebUri("${Urls().wallpaper()}"),
              ),
            );
          }
        });

        // startPrayerScheduler(
        //     "{\"imsak\": \"04:46\", \"subuh\": \"04:56\", \"dzuhur\": \"14:47\", \"ashar\": \"15:31\", \"maghrib\": \"18:19\", \"isya\": \"19:28\"}",
        //     (mode) {
        //   if (mode == "standby") {
        //     webViewController?.loadUrl(
        //       urlRequest: URLRequest(
        //         url: WebUri("${Urls().mainUrl}/standbywallpaper/"),
        //       ),
        //     );
        //   } else {
        //     webViewController?.loadUrl(
        //       urlRequest: URLRequest(
        //         url: WebUri("${Urls().mainUrl}/wallpaper/"),
        //       ),
        //     );
        //   }
        // });
      } else {
        ShowNotif.failed(
            duration: 3000, message: "Terjadi kesalahan", context: context);
        throw Exception('Failed to login.');
      }
    } catch (exc) {
      Navigator.of(context).pop();
      ShowNotif.failed(
          message: 'Terjadi kesalahan, harap coba lagi', context: context);
      throw Exception(exc);
    }
  }

  void startPrayerScheduler(
    String jadwalSholatJson,
    Function(String mode) callback,
  ) {
    final Map<String, dynamic> jadwal = jsonDecode(jadwalSholatJson);

    prayerTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      final now = DateTime.now();
      debugPrint("StartPrayerScheduler: $now");
      if (isFridayOverrideActive) return;

      if (now.hour == 0 && now.minute == 0) {
        triggeredToday.clear();
      }

      void checkTrigger(
        String name,
        String timeString,
        int offsetMinutes,
        String mode,
      ) {
        final parts = timeString.split(":");

        final target = DateTime(
          now.year,
          now.month,
          now.day,
          int.parse(parts[0]),
          int.parse(parts[1]),
        ).add(Duration(minutes: offsetMinutes));

        String key = "$name-${target.hour}:${target.minute}";

        // Just in case if CPU throttling, quick frezee, etc
        const toleranceMinutes = 2;
        final difference = now.difference(target).abs().inMinutes;

        if (difference <= toleranceMinutes && !triggeredToday.contains(key)) {
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

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkJadwalSholat();

      startFridayListener(() {
        setState(() {
          isFridayOverrideActive = true;
        });
        webViewController?.loadUrl(
          urlRequest: URLRequest(
            url: WebUri("${Urls().sliderJumat()}"),
          ),
        );
      });

      endFridayListener(() {
        setState(() {
          isFridayOverrideActive = false;
        });
        webViewController?.loadUrl(
          urlRequest: URLRequest(
            url: WebUri("${Urls().wallpaper()}"),
          ),
        );
      });

      periodicReload();
    });
    super.initState();
  }

  Widget logoutDialog(BuildContext buildContext) {
    return AlertDialog(
      content: const Text('Apakah anda ingin logout?'),
      actions: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: DpadFocusable(
                autofocus: true,
                onSelect: () => Navigator.pop(context, 'Batal'),
                builder: FocusEffects.border(
                    focusColor: const Color.fromARGB(255, 0, 109, 68)),
                child: TextButton(
                  onPressed: () => Navigator.pop(context, 'Batal'),
                  child: const Text('Batal',
                      style:
                          TextStyle(color: Color.fromARGB(255, 104, 104, 104))),
                ),
              ),
            ),
            Expanded(
              child: DpadFocusable(
                onSelect: () => logoutProcess(),
                builder: FocusEffects.border(
                    focusColor: const Color.fromARGB(255, 0, 109, 68)),
                child: TextButton(
                  onPressed: () => logoutProcess(),
                  child: const Text('OK', style: TextStyle(color: Colors.red)),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DpadFocusable(
      autofocus: true,
      onSelect: () {
        if (demoMode) {
          if (indexDemo == 0) {
            webViewController?.loadUrl(
              urlRequest: URLRequest(
                url: WebUri("${Urls().standbyWallpaper()}"),
              ),
            );
          } else if (indexDemo == 1) {
            webViewController?.loadUrl(
              urlRequest: URLRequest(
                url: WebUri("${Urls().sliderJumat()}"),
              ),
            );
          } else if (indexDemo == 2) {
            webViewController?.loadUrl(
              urlRequest: URLRequest(
                url: WebUri("${Urls().wallpaper()}"),
              ),
            );
          } else {
            showDialog<String>(
                context: context,
                builder: (BuildContext context) => logoutDialog(context));
          }
          if (indexDemo < 3) {
            setState(() {
              indexDemo++;
            });
          } else {
            setState(() {
              indexDemo = 0;
            });
          }
        } else {
          showDialog<String>(
              context: context,
              builder: (BuildContext context) => logoutDialog(context));
        }
      },
      builder: FocusEffects.border(
          focusColor: const Color.fromARGB(255, 0, 109, 68)),
      child: InAppWebView(
        initialSettings: InAppWebViewSettings(
          // 🔥 AUTOPLAY (v6 cara baru)
          mediaPlaybackRequiresUserGesture: false,
          displayZoomControls: true,
          builtInZoomControls: true,
          useHybridComposition: true,
          // optional
          allowsInlineMediaPlayback: true,
          mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
          forceDark: ForceDark.OFF,
        ),
        initialUrlRequest: URLRequest(
          url: WebUri(url),
        ),
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
        onProgressChanged: (controller, progres) {
          setState(() {
            progress = progres;
          });
        },
        onConsoleMessage: (controller, consoleMessage) {
          print(consoleMessage);
        },
        onLoadStop: (controller, url) async {
          await controller.injectJavascriptFileFromAsset(
              assetFilePath: "assets/javascripts/font_adjust.js");
          webViewController = controller;
        },
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{}
          ..add(Factory<VerticalDragGestureRecognizer>(
            () => VerticalDragGestureRecognizer(),
          )),
      ),
    ));
  }
}
