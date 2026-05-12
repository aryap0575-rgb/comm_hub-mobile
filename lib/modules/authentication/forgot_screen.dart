import 'dart:async';
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
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/router_name.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/router_name.dart';
import '../../../../utils/constants.dart';
import '../../../../widgets/primary_button.dart';
import '../../utils/k_images.dart';
import '../../widgets/custom_image.dart';
import 'package:http/http.dart' as http;

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({Key? key}) : super(key: key);

  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  TextEditingController email = TextEditingController();

  final StreamController _timerStream = StreamController<int>();
  late int timerCounter;
  late Timer _resendCodeTimer;

  @override
  void initState() {
    activeCounter(0);

    super.initState();
  }

  @override
  void dispose() {
    _timerStream.close();
    _resendCodeTimer.cancel();

    super.dispose();
  }

  activeCounter(int duration) {
    var timerDuration = duration;
    _resendCodeTimer =
        Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      _timerStream.sink.add(timerDuration - timer.tick);
      if (timerDuration - timer.tick > 0) {
      } else {
        _timerStream.sink.add(0);
        _resendCodeTimer.cancel();
      }
    });
  }

  Future<void> checkResend(String email, context) async {
    final response = await http.post(
      Urls().forgotPass(),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
      }),
    );
    try {
      if (response.statusCode == 200) {
        _timerStream.sink.add(30);
        activeCounter(30);
        ShowNotif.success(
            message: 'Email reset password telah dikirimkan ke email',
            duration: 2500,
            context: context);
      } else if (response.statusCode == 201) {
        ShowNotif.failed(
            message: 'Email tidak ditemukan', duration: 2500, context: context);
      } else {
        ShowNotif.failed(
            message: 'Terjadi kesalahan, coba lagi',
            duration: 2500,
            context: context);
      }
    } catch (exc) {
      ShowNotif.failed(
          message: 'Terjadi kesalahan, coba lagi',
          duration: 2500,
          context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.center,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Color(0xffFFEFE7),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              CircleAvatar(
                radius: 96,
                backgroundColor: redColor.withOpacity(0.1),
                child: const CustomImage(path: Kimages.forgotIcon),
              ),
              const SizedBox(height: 55),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Lupa Password',
                  style: GoogleFonts.poppins(
                      height: 1, fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 22),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukan email akun anda';
                  }
                  return null;
                },
                controller: email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Email akun anda',
                ),
              ),
              const SizedBox(height: 28),
              const SizedBox(height: 28),
              StreamBuilder(
                stream: _timerStream.stream,
                builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                  return PrimaryButton(
                    text: snapshot.data == 0
                        ? 'Kirim kode'
                        : 'Harap tunggu ${snapshot.hasData ? snapshot.data.toString() : 30} detik',
                    onPressed: () {
                      if (email != '') {
                        submit(context, email.text, snapshot.data);
                      }
                    },
                  );
                },
              ),
              const SizedBox(height: 15),
              Text.rich(
                TextSpan(
                    text: 'Sudah ingat password ? ',
                    style: const TextStyle(color: Color(0xff878D97)),
                    children: [
                      TextSpan(
                          text: 'Kembali login.',
                          style: const TextStyle(color: Color(0xff000000)),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushNamed(
                                  context, RouteNames.signInScreen);
                            })
                    ]),
              )
            ],
          ),
        ),
      ),
    );
  }

  submit(BuildContext context, String email, int timer) {
    if (timer == 0) {
      checkResend(email, context);
    } else {
      ShowNotif.failed(
          message: 'Harap tunggu $timer detik lagi.',
          duration: 2500,
          context: context);
    }
  }
}
