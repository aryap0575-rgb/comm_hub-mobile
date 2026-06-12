import 'dart:convert';

import 'package:com.example.fincome_mobile_mobile/constants/text_styles.dart';
import 'package:com.example.fincome_mobile_mobile/modules/authentication/change_password.dart';
import 'package:com.example.fincome_mobile_mobile/modules/authentication/models/auth_model.dart';
import 'package:com.example.fincome_mobile_mobile/modules/authentication/widgets/sign_up_form.dart';
import 'package:com.example.fincome_mobile_mobile/modules/url/urls.dart';
import 'package:com.example.fincome_mobile_mobile/utils/utils.dart';
import 'package:dpad/dpad.dart';
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

  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

  final FocusNode usernameFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();

  void _closeLoadingDialog(BuildContext context) {
    if (Navigator.of(context, rootNavigator: true).canPop()) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  Future<AuthModel> checkLogin(
    String usernameValue,
    String passwordValue,
    BuildContext context,
  ) async {
    try {
      final response = await http.post(
        Urls().signin(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': usernameValue,
          'password': passwordValue,
        }),
      );

      print('STATUS LOGIN: ${response.statusCode}');
      print('BODY LOGIN: ${response.body}');

      final Map<String, dynamic> body = jsonDecode(response.body);
      final AuthModel respon = AuthModel.fromJson(body);

      if (response.statusCode == 200) {
        const storage = FlutterSecureStorage();

        if (respon.userId == null) {
          _closeLoadingDialog(context);

          ShowNotif.failed(
            message: 'User ID tidak ditemukan dari response login',
            context: context,
          );

          throw Exception('User ID tidak ditemukan dari response login');
        }

        await storage.write(
          key: 'user_id',
          value: respon.userId.toString(),
        );

        await storage.write(
          key: 'username',
          value: respon.username ?? '',
        );

        await storage.write(
          key: 'is_login',
          value: 'true',
        );

        await storage.write(
          key: 'token',
          value: respon.token ?? '',
        );

        print('USER ID TERSIMPAN: ${respon.userId}');
        print('USERNAME TERSIMPAN: ${respon.username}');
        print('TOKEN TERSIMPAN: ${respon.token}');

        _closeLoadingDialog(context);

        ShowNotif.success(
          message: 'Selamat datang',
          context: context,
        );

        Navigator.pushNamedAndRemoveUntil(
          context,
          RouteNames.mainPage,
          (route) => false,
        );

        return respon;
      } else if (response.statusCode == 201) {
        setState(() {
          _errorPassword = respon.message ?? 'Login gagal';
        });

        _closeLoadingDialog(context);

        ShowNotif.warning(
          message: respon.message ?? 'Login gagal',
          context: context,
        );

        return respon;
      } else {
        _closeLoadingDialog(context);

        ShowNotif.failed(
          duration: 3000,
          message: respon.message ?? 'Gagal login',
          context: context,
        );

        throw Exception('Failed to login.');
      }
    } catch (exc) {
      _closeLoadingDialog(context);

      ShowNotif.failed(
        message: 'Terjadi kesalahan, harap coba lagi',
        context: context,
      );

      throw Exception(exc);
    }
  }

  Future<void> checkLoginDevelopment(
    String usernameValue,
    String passwordValue,
    BuildContext context,
  ) async {
    const storage = FlutterSecureStorage();

    await storage.write(key: 'user_id', value: '1');
    await storage.write(key: 'username', value: usernameValue);
    await storage.write(key: 'is_login', value: 'true');
    await storage.write(key: 'token', value: 'development-token');

    ShowNotif.success(
      message: 'Selamat datang Development',
      context: context,
    );

    Navigator.pushNamedAndRemoveUntil(
      context,
      RouteNames.mainPage,
      (route) => false,
    );
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
  void dispose() {
    username.dispose();
    password.dispose();
    usernameFocus.dispose();
    passwordFocus.dispose();

    super.dispose();
  }

  bool _allValidation() {
    bool isValid = true;

    if (username.text.trim().isEmpty) {
      _errorEmail = "Masukan username anda.";
      isValid = false;
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

  Widget _buildForgotPassword() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        DpadFocusable(
          builder: FocusEffects.border(
            focusColor: const Color.fromARGB(255, 0, 109, 68),
          ),
          onSelect: () {
            Navigator.pushNamed(context, RouteNames.forgotScreen);
          },
          child: Text(
            'Lupa Password?',
            style: TextStyles(context).getBoldStyle().copyWith(
                  color: const Color.fromARGB(255, 170, 128, 0),
                ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          children: [
            const SizedBox(height: 80),
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFC6132C),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.groups,
                color: Colors.white,
                size: 60,
              ),
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
            const Text(
              'BALIKPAPAN',
              style: TextStyle(
                fontSize: 12,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 48),
            const Text(
              'Selamat Datang di\nFINDCOM',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Masuk untuk menjelajahi berbagai komunitas menarik di sekitar Anda.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 40),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Email',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: username,
              focusNode: usernameFocus,
              decoration: InputDecoration(
                hintText: 'Contoh: aryasenpai@email.com',
                prefixIcon: const Icon(Icons.email_outlined),
                fillColor: const Color(0xFFE1F0F9),
                filled: true,
                errorText: _errorEmail.isEmpty ? null : _errorEmail,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Kata Sandi',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChangePasswordScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Lupa Kata Sandi?',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
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
                errorText: _errorPassword.isEmpty ? null : _errorPassword,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () async {
                  if (_allValidation()) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    );

                    await checkLogin(
                      username.text.trim(),
                      password.text.trim(),
                      context,
                    );

                    // Jangan aktifkan ini kalau pakai login asli.
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
                  child: const Text(
                    'Daftar sekarang',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              'ATAU MASUK DENGAN',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () {},
              icon: Image.network(
                'https://www.gstatic.com/images/branding/product/2x/googleg_48dp.png',
                height: 24,
              ),
              label: const Text(
                'Google',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                side: BorderSide(
                  color: Colors.grey.shade300,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
