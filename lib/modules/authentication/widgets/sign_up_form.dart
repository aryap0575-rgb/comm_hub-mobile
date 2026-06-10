import 'dart:convert';

import 'package:com.example.fincome_mobile_mobile/modules/authentication/model_sign_up.dart';
import 'package:com.example.fincome_mobile_mobile/modules/authentication/widgets/sign_in_form.dart';
import 'package:com.example.fincome_mobile_mobile/modules/url/urls.dart';
import 'package:dart_levenshtein/dart_levenshtein.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:com.example.fincome_mobile/core/router_name.dart';
// import 'package:com.example.fincome_mobile/modules/authentication/models/auth_model.dart';
// import 'package:com.example.fincome_mobile/modules/url/urls.dart';
// import 'package:com.example.fincome_mobile/utils/utils.dart';
// import 'package:com.example.fincome_mobile/widgets/common_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:com.example.fincome_mobile_mobile/widgets/model_sign_up.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../utils/constants.dart';
import '../../../../widgets/primary_button.dart';
import 'package:http/http.dart' as http;

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);
  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool _isPasswordEightCharacters = false;
  bool _hasPasswordOneNumber = false;
  bool _hasPasswordOneChar = false;
  bool _hasPasswordOneCharBig = false;
  bool _hasPasswordOneSpecialChar = false;
  final Urls urls = Urls();
  // late ColorNotifire notifire;
  onPasswordChanged(String password) {
    final numericRegex = RegExp(r'[0-9]');
    final smallCharRegex = RegExp(r'[a-z]');
    final bigCharRegex = RegExp(r'[A-Z]');
    final specialCharRegex = RegExp(r'[^A-Za-z0-9]');

    setState(() {
      _isPasswordEightCharacters = false;
      if (password.length >= 8) _isPasswordEightCharacters = true;

      _hasPasswordOneNumber = false;
      if (numericRegex.hasMatch(password)) _hasPasswordOneNumber = true;

      _hasPasswordOneChar = false;
      if (smallCharRegex.hasMatch(password)) _hasPasswordOneChar = true;

      _hasPasswordOneCharBig = false;
      if (bigCharRegex.hasMatch(password)) _hasPasswordOneCharBig = true;

      _hasPasswordOneSpecialChar = false;
      if (specialCharRegex.hasMatch(password)) {
        _hasPasswordOneSpecialChar = true;
      }
    });
  }

  Future<LoginResponse> login({
    required String username,
    required String password,
  }) async {
    final response = await http.post(
      urls.login(),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return LoginResponse.fromJson(
        jsonDecode(response.body),
      );
    }

    throw Exception('Login gagal');
  }

  final TextEditingController firstNameController = TextEditingController();

  final TextEditingController lastNameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController usernameController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    phoneNumber.text = '+62';
  }

  // Form
  final GlobalKey<FormState> _signupFormKey = GlobalKey<FormState>();
  TextEditingController userName = TextEditingController();
  TextEditingController fisrtName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController nisn = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController verPassword = TextEditingController();
  String? selectedClasses;

  // Regex validator
  RegExp onlyNumber = RegExp(r"^[0-9]+$");
  RegExp numericRegex = RegExp(r'[0-9]');
  RegExp smallCharRegex = RegExp(r'[a-z]');
  RegExp bigCharRegex = RegExp(r'[A-Z]');
  RegExp specialCharRegex = RegExp(r'[^A-Za-z0-9]');

  bool _passwordVisible = false;
  bool _verPasswordVisible = false;

  bool isValidEmail(String email) {
    String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regex = RegExp(emailPattern);
    return regex.hasMatch(email);
  }

  Future<bool> isLikelyProviderMistake(String email) async {
    List<String> commonProviders = [
      'gmail.com',
      'yahoo.com',
      'outlook.com',
      'hotmail.com'
    ];

    if (!email.contains('@')) return false;
    String domain = email.split('@').last;

    for (String provider in commonProviders) {
      int typo = await levenshteinDistance(domain, provider);
      if (typo >= 1) {
        return true;
      } else if (typo == 0) {
        return false;
      }
    }
    return false;
  }

  Future<LoginResponse> register(RegisterRequest request) async {
    final response = await http.post(
      urls.signup(),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return LoginResponse.fromJson(
        jsonDecode(response.body),
      );
    }

    throw Exception(response.body);
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
              child: const Icon(Icons.person_add_alt_1,
                  color: Colors.white, size: 60),
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
            const SizedBox(height: 32),

            // Title Text
            const Text(
              'Daftar Akun Baru',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Lengkapi data diri Anda untuk bergabung dengan berbagai komunitas menarik.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),

            // Form Nama Lengkap
            const Align(
                alignment: Alignment.centerLeft,
                child: Text('Nama Lengkap',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            const SizedBox(height: 8),
            TextField(
              controller: firstNameController,
              decoration: InputDecoration(
                hintText: 'Nama lengkap',
                prefixIcon: const Icon(Icons.person_outline),
                fillColor: const Color(0xFFE1F0F9),
                filled: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 20),

            // Form Email
            const Align(
                alignment: Alignment.centerLeft,
                child: Text('Email',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            const SizedBox(height: 8),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'contoh@email.com',
                prefixIcon: const Icon(Icons.email_outlined),
                fillColor: const Color(0xFFE1F0F9),
                filled: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 20),

            // Form Kata Sandi
            const Align(
                alignment: Alignment.centerLeft,
                child: Text('Kata Sandi',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            const SizedBox(height: 8),
            TextField(
              controller: passwordController,
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
            const SizedBox(height: 20),

            // Form Konfirmasi Kata Sandi
            const Align(
                alignment: Alignment.centerLeft,
                child: Text('Konfirmasi Kata Sandi',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            const SizedBox(height: 8),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Ulangi kata sandi',
                prefixIcon: const Icon(Icons.lock_outline),
                fillColor: const Color(0xFFE1F0F9),
                filled: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 32),

            // Tombol Daftar
            SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      final request = RegisterRequest(
                        firstName: firstNameController.text.trim(),
                        lastName: lastNameController.text.trim(),
                        email: emailController.text.trim(),
                        username: usernameController.text.trim(),
                        password: passwordController.text,
                        confirmPassword: confirmPasswordController.text,
                      );

                      final result = await register(request);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            result.metadata?.message ?? 'Registrasi berhasil',
                          ),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(e.toString()),
                        ),
                      );
                    }
                  },
                  child: const Text('Daftar'),
                )),
            const SizedBox(height: 24),

            // Login Link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Sudah punya akun?'),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SigninForm(),
                        ),
                      );
                    },
                    child: const Text('Masuk',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFC6132C)))),
              ],
            ),
            const SizedBox(height: 24),

            // Divider
            Row(
              children: const [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('ATAU DAFTAR DENGAN',
                      style: TextStyle(color: Colors.grey, fontSize: 10)),
                ),
                Expanded(child: Divider()),
              ],
            ),
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
}
