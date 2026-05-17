import 'dart:convert';

import 'package:dart_levenshtein/dart_levenshtein.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:com.example.fincome_mobile/core/router_name.dart';
// import 'package:com.example.fincome_mobile/modules/authentication/models/auth_model.dart';
// import 'package:com.example.fincome_mobile/modules/url/urls.dart';
// import 'package:com.example.fincome_mobile/utils/utils.dart';
// import 'package:com.example.fincome_mobile/widgets/common_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  @override
  void initState() {
    super.initState();
    phoneNumber.text = '+62';
  }

  // API POST
  // Future<SignupModel> signupProcess(
  //     String username,
  //     String firstName,
  //     String lastName,
  //     String email,
  //     String address,
  //     String phoneNumber,
  //     String nisn,
  //     String password,
  //     String confirmPassword,
  //     String selectedClasses,
  //     context) async {
  //   ShowDialog.waitDialog(context: context);
  //   final response = await http.post(
  //     Urls().signup(),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(<String, dynamic>{
  //       'username': username,
  //       'first_name': firstName,
  //       'last_name': lastName,
  //       'email': email,
  //       'address': address,
  //       'phone_number': phoneNumber,
  //       'nisn': nisn,
  //       'password': password,
  //       'confirm_password': confirmPassword,
  //       'class': selectedClasses
  //     }),
  //   );
  //   try {
  //     if (response.statusCode == 200) {
  //       var respon = SignupModel.fromJson(jsonDecode(response.body));
  //       //Setup Session
  //       const storage = FlutterSecureStorage();
  //       await storage.write(key: 'username', value: respon.username);
  //       Navigator.of(context).pop();
  //       //Next Page
  //       ShowNotif.success(
  //           message: 'Pendaftaran berhasil, silahkan aktivasi',
  //           duration: 2500,
  //           context: context);
  //       Navigator.pushNamed(context, RouteNames.verificationCodeScreen,
  //           arguments: email);
  //       return respon;
  //     } else if (response.statusCode == 201) {
  //       var respon = SignupModel.fromJson(jsonDecode(response.body));
  //       Navigator.of(context).pop();
  //       ShowNotif.warning(
  //           message: respon.metadata!.message ?? '', context: context);
  //       return respon;
  //     } else {
  //       Navigator.of(context).pop();
  //       ShowNotif.failed(
  //           message: 'Terjadi kesalahan, harap coba lagi', context: context);
  //       throw Exception('Failed to login.');
  //     }
  //   } catch (exc) {
  //     Navigator.of(context).pop();
  //     ShowNotif.failed(
  //         message: 'Terjadi kesalahan, harap coba lagi', context: context);
  //     throw Exception(exc);
  //   }
  // }

  // Future<GetClasses> getAllClasses() async {
  //   try {
  //     final response = await http.get(Urls().getClasses());

  //     if (response.statusCode == 200) {
  //       return GetClasses.fromJson(json.decode(response.body));
  //     } else {
  //       throw Exception('Failed to load classes');
  //     }
  //   } catch (exc) {
  //     throw Exception('Error fetching classes: ${exc.toString()}');
  //   }
  // }

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
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC6132C),
                  elevation: 4,
                  shadowColor: const Color(0xFFC6132C).withOpacity(0.4),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('Daftar',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, color: Colors.white),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Login Link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Sudah punya akun?'),
                TextButton(
                    onPressed: () {},
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

  // Widget classOption(GetClasses data) {
  //   return DropdownButtonHideUnderline(
  //     child: DropdownButton2<String>(
  //         isDense: true,
  //         isExpanded: true,
  //         hint: const Row(
  //           children: [
  //             Expanded(
  //               child: Text(
  //                 'Kelas',
  //                 style: TextStyle(
  //                   fontSize: 14,
  //                   fontWeight: FontWeight.bold,
  //                   color: Colors.grey,
  //                 ),
  //                 overflow: TextOverflow.ellipsis,
  //               ),
  //             ),
  //           ],
  //         ),
  //         items: data.data!
  //             .map((item) => DropdownMenuItem<String>(
  //                   value: "${item.className}",
  //                   child: Text(
  //                     "${item.className}",
  //                     style: const TextStyle(
  //                       fontSize: 15,
  //                       fontWeight: FontWeight.bold,
  //                       color: Color.fromARGB(255, 0, 0, 0),
  //                     ),
  //                     overflow: TextOverflow.ellipsis,
  //                   ),
  //                 ))
  //             .toList(),
  //         value: selectedClasses,
  //         onChanged: (String? value) {
  //           setState(() {
  //             selectedClasses = value ?? '';
  //           });
  //         },
  //         buttonStyleData: ButtonStyleData(
  //             height: 40,
  //             decoration: BoxDecoration(
  //                 border: Border.all(
  //                     color: const Color.fromARGB(255, 176, 206, 231)),
  //                 borderRadius: BorderRadius.circular(5)))),
  //   );
  // }
}
