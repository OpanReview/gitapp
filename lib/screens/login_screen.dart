// ignore_for_file: deprecated_member_use

import "package:flutter/material.dart";
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ogchat/resources/auth_methods.dart';
import 'package:ogchat/responsive/mobile_screen_layout.dart';
import 'package:ogchat/responsive/responsivelayoutscreen.dart';
import 'package:ogchat/responsive/web_screen_layout.dart';
import 'package:ogchat/screens/signup_screen.dart';
import 'package:ogchat/utils/colors.dart';
import 'package:ogchat/utils/global_variables.dart';
import 'package:ogchat/utils/utils.dart';
import 'package:ogchat/widgets/text_field_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().LoginUser(
        email: _emailController.text, password: _passwordController.text);
    if (res == "success") {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(),
          ),
        ),
      );
    } else {
      showSnackBar(context, res);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void navigatetoSignup() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const SignupScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        padding: MediaQuery.of(context).size.width > webScreenSize
            ? EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 3)
            : const EdgeInsets.symmetric(horizontal: 32),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(child: Container(), flex: 1),
            SvgPicture.asset(
              'assets/OG_s-APP-logos.svg',
              height: 250,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
            const SizedBox(height: 64),
            TextFieldInput(
                textEditingController: _emailController,
                hintText: "Email",
                textInputType: TextInputType.emailAddress),
            const SizedBox(
              height: 20,
            ),
            TextFieldInput(
              textEditingController: _passwordController,
              hintText: "Contraseña",
              textInputType: TextInputType.text,
              isPass: true,
            ),
            Flexible(child: Container(), flex: 1),
            InkWell(
              onTap: loginUser,
              child: Container(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      )
                    : const Text('Login'),
                width: 150,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: const ShapeDecoration(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32))),
                  color: Color.fromARGB(255, 73, 144, 90),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Flexible(child: Container(), flex: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: const Text('¿No tienes una cuenta?'),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                GestureDetector(
                  onTap: navigatetoSignup,
                  child: Container(
                    child: const Text('Crear cuenta',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    ));
  }
}
