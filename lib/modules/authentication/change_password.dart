import 'dart:convert';
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
import 'package:com.example.fincome_mobile_mobile/modules/authentication/widgets/sign_in_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/router_name.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/constants.dart';
import '../../widgets/primary_button.dart';
import '../../../core/router_name.dart';
import 'package:http/http.dart' as http;

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePasswordScreen> {
  final GlobalKey<FormState> _formKeychange =
      GlobalKey<FormState>(debugLabel: '_formKeychange');

  TextEditingController textCurrent = TextEditingController();
  TextEditingController textpassword = TextEditingController();
  TextEditingController textrepassword = TextEditingController();

  final bool _passwordCVisible = false;
  bool _passwordVisible = false;
  bool _password2Visible = false;

  Future<void> checkChanges(
      String current, String password, String repassword, context) async {
    const storage = FlutterSecureStorage();
    String? username = await storage.read(key: "username");
    String? token = await storage.read(key: "token");

    final response = await http.put(
      Urls().changePass(),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-token': token!,
        'x-username': username!,
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'current_pass': current,
        'new_pass': password,
        'confirm_new_pass': repassword,
      }),
    );
    try {
      if (response.statusCode == 200) {
        Navigator.pop(context);

        const storage = FlutterSecureStorage();
        await storage.deleteAll();
        Navigator.of(context).pushNamedAndRemoveUntil(
          RouteNames.signInScreen,
          (route) => false,
        ); // Ensure previous routes are removed
        ShowNotif.success(
            duration: 5000,
            message: 'Password di ganti, harap login kembali',
            context: context);
      } else if (response.statusCode == 201) {
        Navigator.pop(context);
        ShowNotif.failed(
            duration: 5000,
            message: 'Password gagal di ganti, harap coba lagi',
            context: context);
      } else {
        Navigator.pop(context);
        ShowNotif.failed(
            duration: 5000,
            message: 'Password gagal di ganti, harap coba lagi',
            context: context);
      }
    } catch (exc) {
      Navigator.pop(context);
      ShowNotif.failed(
          duration: 5000,
          message: 'Password gagal di ganti, harap coba lagi',
          context: context);
      throw Exception(exc);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          children: [
            const SizedBox(height: 60),
            // Logo & Brand
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

            // Title Text
            const Text(
              'Atur Ulang Kata Sandi',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Silakan masukkan kata sandi baru Anda di bawah ini.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 40),

            // Form Kata Sandi Baru
            const Align(
                alignment: Alignment.centerLeft,
                child: Text('KATA SANDI BARU',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.brown))),
            const SizedBox(height: 8),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Minimal 8 karakter',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: const Icon(Icons.visibility_outlined),
                fillColor: const Color(0xFFE1F0F9),
                filled: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 24),

            // Form Konfirmasi Kata Sandi Baru
            const Align(
                alignment: Alignment.centerLeft,
                child: Text('KONFIRMASI KATA SANDI BARU',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.brown))),
            const SizedBox(height: 8),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Ulangi kata sandi',
                prefixIcon: const Icon(Icons.sync_lock_outlined),
                suffixIcon: const Icon(Icons.visibility_outlined),
                fillColor: const Color(0xFFE1F0F9),
                filled: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 40),

            // Tombol Simpan
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC6132C),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Simpan Kata Sandi',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 24),

            // Back to Login
            TextButton.icon(
               onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SigninForm(),
          ),
        );
      },
              icon: const Icon(Icons.arrow_back,
                  size: 18, color: Color(0xFFC6132C)),
              label: const Text('Kembali ke Login',
                  style: TextStyle(
                      color: Color(0xFFC6132C), fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
