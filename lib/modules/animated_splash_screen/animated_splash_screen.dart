import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../core/router_name.dart';
import '../../utils/k_images.dart';
import '../../widgets/custom_image.dart';

class AnimatedSplashScreen extends StatefulWidget {
  const AnimatedSplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<AnimatedSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  Future startTime() async {
    var duration = const Duration(seconds: 3);
    return Timer(duration, () {
      navigationPage(); // Call navigationPage method
    });
  }

  Future<void> navigationPage() async {
    try {
      const storage = FlutterSecureStorage();
      String? isLogin = await storage.read(key: "is_login");

      if (isLogin == 'true') {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(RouteNames.mainPage, (route) => false);
      } else {
        Navigator.of(context).pushNamedAndRemoveUntil(
          RouteNames.signInScreen,
          (route) => false,
        ); // Ensure previous routes are removed
      }
    } on Exception catch (_) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        RouteNames.signInScreen,
        (route) => false,
      ); // Ensure previous routes are removed
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() {
      if (mounted) setState(() {});
    });
    animationController.forward();

    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 0, 109, 68),
            ),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: const CustomImage(path: Kimages.backgroundShape),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CustomImage(
                path: Kimages.logoIconWhite,
                width: animation.value * 350,
                height: animation.value * 350,
              ),
              // const SizedBox(height: 20),
              // Text(
              //   Kstrings.appName,
              //   style: GoogleFonts.poppins(
              //     fontSize: 50,
              //     height: 1,
              //     color: Colors.white,
              //     fontWeight: FontWeight.w900,
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
