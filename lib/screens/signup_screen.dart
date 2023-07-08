import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ogchat/resources/auth_methods.dart';
import 'package:ogchat/responsive/mobile_screen_layout.dart';
import 'package:ogchat/responsive/responsivelayoutscreen.dart';
import 'package:ogchat/responsive/web_screen_layout.dart';
import 'package:ogchat/screens/login_screen.dart';
import 'package:ogchat/utils/colors.dart';
import 'package:ogchat/utils/utils.dart';
import 'package:ogchat/widgets/text_field_input.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void SignUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        file: _image!);

    setState(() {
      _isLoading = false;
    });

    if (res != 'success') {
      showSnackBar(context, res);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(),
          ),
        ),
      );
    }
  }

  void navigatetoLogin() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(child: Container(), flex: 1),
            const SizedBox(height: 64),
            Stack(
              children: [
                _image != null
                    ? CircleAvatar(
                        radius: 64,
                        backgroundImage: MemoryImage(_image!),
                      )
                    : const CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage(
                          'https://thumbs.dreamstime.com/b/default-avatar-profile-icon-vector-social-media-user-portrait-176256935.jpg',
                        )),
                Positioned(
                    bottom: -10,
                    left: 90,
                    child: IconButton(
                        onPressed: selectImage, icon: Icon(Icons.add_a_photo)))
              ],
            ),
            const SizedBox(height: 64),
            TextFieldInput(
              textEditingController: _usernameController,
              hintText: "Crea un nombre de usuario",
              textInputType: TextInputType.text,
            ),
            const SizedBox(height: 20),
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
              onTap: SignUpUser,
              child: Container(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      )
                    : const Text('Sign up'),
                width: 200,
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
                  child: const Text('¿Ya tienes una cuenta?'),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                GestureDetector(
                  onTap: navigatetoLogin,
                  child: Container(
                    child: const Text('Iniciar sesión',
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
