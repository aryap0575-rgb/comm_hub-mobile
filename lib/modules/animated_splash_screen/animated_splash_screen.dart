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
      navigationPage();
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
        );
      }
    } on Exception catch (_) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        RouteNames.signInScreen,
        (route) => false,
      );
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

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOut,
    );

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
              color: Color.fromARGB(255, 255, 0, 0),
            ),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Transform.scale(
                  scale: animation.value,
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFFC6132C),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.groups,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Transform.scale(
                  scale: animation.value,
                  child: const Text(
                    'COMM.HUB',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Transform.scale(
                  scale: animation.value,
                  child: const Text(
                    'Communication & Collaboration',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                      letterSpacing: 1,
                    ),
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