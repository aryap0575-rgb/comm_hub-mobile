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

class SigninForm extends StatefulWidget {
  const SigninForm({Key? key, required this.tabController}) : super(key: key);
  final TabController tabController;
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
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(navigationMode: NavigationMode.directional),
      child: DpadNavigator(
        onBackPressed: () {
          usernameFocus.unfocus();
          passwordFocus.unfocus();
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: SingleChildScrollView(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 0, 109, 68),
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10))),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: const CustomImage(
                        path: Kimages.logoIconWhite,
                        width: 180,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Selamat Datang',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 30),
                            ),
                          ),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Silahkan masuk untuk melanjutkan.',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 150, 150, 150),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),
                          ),
                          const SizedBox(height: 12),
                          CommonTextFieldView(
                            focusNode: usernameFocus,
                            controller: username,
                            errorText: _errorEmail,
                            titleText: "Alamat Email",
                            titleStyle: TextStyles(context)
                                .getBoldStyle()
                                .copyWith(fontSize: 15),
                            padding: const EdgeInsets.only(left: 0, right: 0),
                            hintText: 'Masukan alamat email',
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (String txt) {},
                          ),
                          const SizedBox(height: 5),
                          CommonTextFieldView(
                            focusNode: passwordFocus,
                            controller: password,
                            errorText: _errorPassword,
                            titleText: "Password",
                            titleStyle: TextStyles(context)
                                .getBoldStyle()
                                .copyWith(fontSize: 15),
                            padding: const EdgeInsets.only(left: 0, right: 0),
                            hintText: 'Masukan password',
                            keyboardType: TextInputType.emailAddress,
                            isObscureText: true,
                            onChanged: (String txt) {},
                          ),
                          const SizedBox(height: 8),
                          // _buildForgotPassword(),
                          const SizedBox(height: 8),
                          CommonButton(
                            buttonText: 'Masuk',
                            onTap: () {
                              if (_allValidation()) {
                                ShowDialog.waitDialog(context: context);
                                checkLogin(
                                    username.text, password.text, context);
                                // checkLoginDevelopment(
                                //     username.text, password.text, context);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
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
