import 'dart:convert';
import 'dart:convert';

import 'package:dpad/dpad.dart';
import 'package:fincome_mobile_mobile/constants/text_styles.dart';
import 'package:fincome_mobile_mobile/modules/authentication/models/auth_model.dart';
import 'package:fincome_mobile_mobile/modules/url/urls.dart';
import 'package:fincome_mobile_mobile/utils/k_images.dart';
import 'package:fincome_mobile_mobile/utils/utils.dart';
import 'package:fincome_mobile_mobile/widgets/common_button.dart';
import 'package:fincome_mobile_mobile/widgets/common_text_field_view.dart';
import 'package:fincome_mobile_mobile/widgets/custom_image.dart';
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Ganti Password',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 15),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Ubah Password',
                style: GoogleFonts.poppins(
                    height: 1, fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 5),
            Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Password baru harus berjumlah minimal delapan karakter, terdiri dari huruf kapital, huruf kecil, angka, dan karakter spesial',
                  style: GoogleFonts.poppins(
                      height: 1, fontSize: 12, fontWeight: FontWeight.w200),
                )),
            Form(
              key: _formKeychange,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  TextFormField(
                    validator: (value) {
                      final numericRegex = RegExp(r'[0-9]');
                      final smallCharRegex = RegExp(r'[a-z]');
                      final bigCharRegex = RegExp(r'[A-Z]');
                      final specialCharRegex = RegExp(r'[^\w\s]');
                      if (value == null || value.isEmpty) {
                        return 'Kolom password wajib diisi';
                      } else if (value.length < 8) {
                        return 'Password harus terdiri setidaknya 8 karakter';
                      } else if (!smallCharRegex.hasMatch(value)) {
                        return 'Password harus terdiri setidaknya 1 huruf kecil';
                      } else if (!numericRegex.hasMatch(value)) {
                        return 'Password harus terdiri setidaknya 1 angka';
                      } else if (!bigCharRegex.hasMatch(value)) {
                        return 'Password harus terdiri setidaknya 1 huruf besar';
                      } else if (!specialCharRegex.hasMatch(value)) {
                        return 'Password harus terdiri setidaknya 1 karakter spesial';
                      } else {
                        return null;
                      }
                    },
                    controller: textCurrent,
                    decoration: const InputDecoration(
                      labelText: 'Password Lama',
                      hintText: 'Masukkan Password Lama ',
                      labelStyle:
                          TextStyle(color: Color.fromARGB(255, 80, 80, 80)),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    validator: (value) {
                      final numericRegex = RegExp(r'[0-9]');
                      final smallCharRegex = RegExp(r'[a-z]');
                      final bigCharRegex = RegExp(r'[A-Z]');
                      final specialCharRegex = RegExp(r'[^\w\s]');
                      if (value == null || value.isEmpty) {
                        return 'Kolom password wajib diisi';
                      } else if (value.length < 8) {
                        return 'Password harus terdiri setidaknya 8 karakter';
                      } else if (!smallCharRegex.hasMatch(value)) {
                        return 'Password harus terdiri setidaknya 1 huruf kecil';
                      } else if (!numericRegex.hasMatch(value)) {
                        return 'Password harus terdiri setidaknya 1 angka';
                      } else if (!bigCharRegex.hasMatch(value)) {
                        return 'Password harus terdiri setidaknya 1 huruf besar';
                      } else if (!specialCharRegex.hasMatch(value)) {
                        return 'Password harus terdiri setidaknya 1 karakter spesial';
                      } else {
                        return null;
                      }
                    },
                    obscureText: !_passwordVisible,
                    controller: textpassword,
                    decoration: InputDecoration(
                      labelText: 'Password Baru',
                      hintText: 'Masukkan Password Baru',
                      labelStyle: const TextStyle(
                          color: Color.fromARGB(255, 80, 80, 80)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: grayColor,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    validator: (value) {
                      final numericRegex = RegExp(r'[0-9]');
                      final smallCharRegex = RegExp(r'[a-z]');
                      final bigCharRegex = RegExp(r'[A-Z]');
                      final specialCharRegex = RegExp(r'[^\w\s]');
                      if (value == null || value.isEmpty) {
                        return 'Kolom password wajib diisi';
                      } else if (!numericRegex.hasMatch(value) ||
                          !smallCharRegex.hasMatch(value) ||
                          !bigCharRegex.hasMatch(value) ||
                          !specialCharRegex.hasMatch(value)) {
                        return 'Konfirmasi password tidak valid';
                      } else if (value != textpassword.text) {
                        return 'Kedua password tidak sama';
                      } else {
                        return null;
                      }
                    },
                    obscureText: !_password2Visible,
                    controller: textrepassword,
                    decoration: InputDecoration(
                      labelText: 'Konfirmasi Password',
                      hintText: 'Masukkan konfirmasi password',
                      labelStyle: const TextStyle(
                          color: Color.fromARGB(255, 80, 80, 80)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _password2Visible
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: grayColor,
                        ),
                        onPressed: () {
                          setState(() {
                            _password2Visible = !_password2Visible;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  PrimaryButton(
                      text: 'Ganti',
                      onPressed: () async {
                        if (_formKeychange.currentState!.validate()) {
                          ShowDialog.waitDialog(context: context);
                          checkChanges(textCurrent.text, textpassword.text,
                              textrepassword.text, context);
                          textCurrent.clear();
                          textpassword.clear();
                          textrepassword.clear();
                        }
                      })
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
