
import 'package:flutter/material.dart';
import '../modules/authentication/authentication_screen.dart';
import '../modules/authentication/forgot_screen.dart';
import '../modules/main_page/main_page.dart';
import '../modules/animated_splash_screen/animated_splash_screen.dart';
import '../modules/home/home_screen.dart';

class RouteNames {
  static const String animatedSplashScreen = '/animatedSplashScreen';
  static const String animatedSplashScreenToken = '/animatedSplashScreenToken';
  static const String mainPage = '/';
  static const String homeScreen = '/homeScreen';
  static const String signInScreen = '/signInScreen';
  static const String notificationScreen = '/notificationScreen';
  static const String userlogScreen = '/userlogScreen';
  static const String profileEditScreen = '/profileEditScreen';
  static const String changePasswordScreen = '/changePasswordScreen';
  static const String HasilUjianScreen = '/HasilUjianScreen';
  static const String profileScreen = '/profileScreen';
  static const String verificationCodeScreen = '/verificationCodeScreen';
  static const String forgotScreen = '/forgotScreen';
  static const String setpasswordScreen = '/setpasswordScreen';

  // Delete in future with the case --- Do not forget ---
  static const String allCategoryListScreen = '/allCategoryListScreen';
  static const String allPopulerProductScreen = '/allPopulerProductScreen';
  static const String messageScreen = '/messageScreen';
  static const String chatListScreen = '/chatListScreen';
  static const String singleCategoryProductScreen =
      '/singleCategoryProductScreen';
  static const String orderScreen = '/orderScreen';
  static const String settingScreen = '/settingScreen';
  static const String termsConditionScreen = '/termsConditionScreen';
  static const String privacyPolicyScreen = '/privacyPolicyScreen';
  static const String faqScreen = '/faqScreen';
  static const String aboutUsScreen = '/aboutUsScreen';
  static const String contactUsScreen = '/contactUsScreen';
  static const String profileOfferScreen = '/profileOfferScreen';
  static const String wishlistOfferScreen = '/wishlistOfferScreen';
  static const String addAddressScreen = '/addAddressScreen';
  static const String addNewPaymentCardScreen = '/addNewPaymentCardScreen';
  static const String cartScreen = '/cartScreen';
  static const String checkoutScreen = '/checkoutScreen';
  static const String productDetailsScreen = '/productDetailsScreen';
  static const String submitFeedBackScreen = '/submitFeedBackScreen';
  static const String addressScreen = '/addressScreen';
  static const String paymentsScreen = '/paymentsScreen';
  // End delete

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.mainPage:
        return MaterialPageRoute(
            builder: (_) => const MainPage(),
            settings: const RouteSettings(
              name: 'mainPage',
            ));
      case RouteNames.homeScreen:
        final from = settings.arguments as String;
        return MaterialPageRoute(
            builder: (_) => HomeScreen(from: from),
            settings: const RouteSettings(
              name: 'homeScreen',
            ));
      case RouteNames.animatedSplashScreen:
        return MaterialPageRoute(
            builder: (_) => const AnimatedSplashScreen(),
            settings: const RouteSettings(
              name: 'animatedSplashScreen',
            ));
      case RouteNames.signInScreen:
        return MaterialPageRoute(
            builder: (_) => const AuthenticationScreen(),
            settings: const RouteSettings(
              name: 'signInScreen',
            ));
      case RouteNames.forgotScreen:
        return MaterialPageRoute(
            builder: (_) => const ForgotScreen(),
            settings: const RouteSettings(
              name: 'forgotScreen',
            ));
      

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
