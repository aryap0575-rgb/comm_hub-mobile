import 'dart:convert';

import 'package:com.example.fincome_mobile_mobile/modules/authentication/change_password.dart';
import 'package:dpad/dpad.dart';
import 'package:com.example.fincome_mobile_mobile/constants/text_styles.dart';
import 'package:com.example.fincome_mobile_mobile/modules/authentication/models/auth_model.dart';
import 'package:com.example.fincome_mobile_mobile/modules/authentication/widgets/sign_up_form.dart';
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

class SigninForm extends StatefulWidget {
  const SigninForm({Key? key}) : super(key: key);
  @override
  State<SigninForm> createState() => _SigninFormState();
}

class _SigninFormState extends State<SigninForm> {
  String _errorEmail = '';
  String _errorPassword = '';
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  FocusNode usernameFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  Future<AuthModel> checkLogin(
      String username, String password, context) async {
    final response = await http.post(
      Urls().signin(),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );
    try {
      if (response.statusCode == 200) {
        const storage = FlutterSecureStorage();
        var respon = AuthModel.fromJson(jsonDecode(response.body));
        await storage.write(key: 'username', value: respon.username);
        await storage.write(key: 'is_login', value: 'true');
        await storage.write(key: 'token', value: respon.token.toString());
        Navigator.of(context).pop();
        ShowNotif.success(message: 'Selamat datang', context: context);
        Navigator.pushNamedAndRemoveUntil(
            context, RouteNames.mainPage, (route) => false);
        return respon;
      } else if (response.statusCode == 201) {
        var respon = AuthModel.fromJson(jsonDecode(response.body));
        setState(() {
          _errorPassword = respon.metadata!.message!;
        });
        Navigator.of(context).pop();
        ShowNotif.warning(message: respon.metadata!.message!, context: context);
        return respon;
      } else {
        var respon = AuthModel.fromJson(jsonDecode(response.body));
        Navigator.of(context).pop();
        ShowNotif.failed(
            duration: 3000,
            message: respon.metadata!.message!,
            context: context);
        throw Exception('Failed to login.');
      }
    } catch (exc) {
      Navigator.of(context).pop();
      ShowNotif.failed(
          message: 'Terjadi kesalahan, harap coba lagi', context: context);
      throw Exception(exc);
    }
  }

  Future<void> checkLoginDevelopment(
      String username, String password, context) async {
    ShowNotif.success(message: 'Selamat datang Development', context: context);
    Navigator.pushNamedAndRemoveUntil(
        context, RouteNames.mainPage, (route) => false);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // username.text = "admin_masjid@gmail.com";
      // password.text = "admin_masjid.01";
      // usernameFocus.requestFocus();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          children: [
            const SizedBox(height: 80),
            // Logo & Brand
            // Ganti placeholder dengan logo FINDCOM Anda
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFC6132C),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.groups, color: Colors.white, size: 60),
            ),
            const SizedBox(height: 16),
            const Text(
              'COMM.HUB',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFC6132C),
                letterSpacing: 1.2,
              ),
            ),
            const Text('BALIKPAPAN',
                style: TextStyle(fontSize: 12, letterSpacing: 2)),
            const SizedBox(height: 48),

            // Welcome Text
            const Text(
              'Selamat Datang di\nFINDCOM',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Masuk untuk menjelajahi berbagai komunitas menarik di sekitar Anda.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 40),

            // Form Email
            const Align(
                alignment: Alignment.centerLeft,
                child: Text('Email',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            const SizedBox(height: 8),
            TextField(
              controller: username,
              focusNode: usernameFocus,
              decoration: InputDecoration(
                hintText: 'Contoh: aryasenpai@email.com',
                prefixIcon: const Icon(Icons.email_outlined),
                fillColor: const Color(0xFFE1F0F9),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Form Kata Sandi
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Kata Sandi',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChangePasswordScreen(),
                        ),
                      );
                    },
                    child: const Text('Lupa Kata Sandi?',
                        style: TextStyle(fontSize: 12))),
              ],
            ),
            TextField(
              controller: password,
              focusNode: passwordFocus,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Minimal 8 karakter',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: const Icon(Icons.visibility_outlined),
                fillColor: const Color(0xFFE1F0F9),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Tombol Masuk
            // Tombol Masuk
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () async {
                  // validasi input
                  if (_allValidation()) {
                    // tampilkan loading
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );

                    // panggil fungsi login
                    await checkLogin(
                      username.text.trim(),
                      password.text.trim(),
                      context,
                    );

                    // jika development mode gunakan ini:
                    // await checkLoginDevelopment(
                    //   username.text.trim(),
                    //   password.text.trim(),
                    //   context,
                    // );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC6132C),
                  elevation: 4,
                  shadowColor: const Color(0xFFC6132C).withOpacity(0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Masuk',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Register Link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Belum punya akun?'),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpForm(),
                        ),
                      );
                    },
                    child: const Text('Daftar sekarang',
                        style: TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
            const SizedBox(height: 32),

            // Divider
            const Text('ATAU MASUK DENGAN',
                style: TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 24),

            // Google Button
            OutlinedButton.icon(
              onPressed: () {},
              icon: Image.network(
                  'https://www.gstatic.com/images/branding/product/2x/googleg_48dp.png',
                  height: 24),
              label:
                  const Text('Google', style: TextStyle(color: Colors.black)),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                side: BorderSide(color: Colors.grey.shade300),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildForgotPassword() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        DpadFocusable(
          builder: FocusEffects.border(
              focusColor: const Color.fromARGB(255, 0, 109, 68)),
          onSelect: () {
            Navigator.pushNamed(context, RouteNames.forgotScreen);
          },
          child: Text(
            'Lupa Password?',
            style: TextStyles(context)
                .getBoldStyle()
                .copyWith(color: const Color.fromARGB(255, 170, 128, 0)),
          ),
        ),
      ],
    );
  }

  bool _allValidation() {
    bool isValid = true;
    if (username.text.trim().isEmpty) {
      _errorEmail = "Masukan username anda.";
      isValid = false;
      // } else if (!Validator.validateEmail(_emailController.text.trim())) {
      //   _errorEmail = Loc.alized.enter_valid_email;
      //   isValid = false;
    } else {
      _errorEmail = '';
    }

    if (password.text.trim().isEmpty) {
      _errorPassword = "Masukan password anda.";
      isValid = false;
    } else if (password.text.trim().length < 6) {
      _errorPassword = "Masukan password yang valid.";
      isValid = false;
    } else {
      _errorPassword = '';
    }
    setState(() {});
    return isValid;
  }
}
