import 'package:bladeco/components/components.dart';
import 'package:bladeco/const/const.dart';
import 'package:bladeco/controller/auth_controller.dart';
import 'package:bladeco/screens/login_page.dart';
import 'package:bladeco/model/userModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_button/flutter_social_button.dart';
import 'package:get/get.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController fullNameControl = TextEditingController();
  final TextEditingController emailControl = TextEditingController();
  final TextEditingController passwdControl = TextEditingController();

  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 70),
            Image.asset(path, color: primaryColor),
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    girismetni,
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.w900,
                      color: primaryColor,
                    ),
                  ),
                  CustomTextFormField(
                      info: "Ad-Soyad",
                      validateInfo: 'Lütfen tam adınızı giriniz',
                      icondata: FontAwesomeIcons.addressCard,
                      controller: fullNameControl),
                  CustomMailTextFormField(controller: emailControl),
                  CustomPasswdTextFormField(controller: passwdControl),
                  const SizedBox(height: 20),
                  Obx(() => authController.isLoading.value
                      ? const CircularProgressIndicator()
                      : _buildRegisterButton()),
                  const SizedBox(height: 100),
                  _buildLoginRow(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      height: 50,
      width: 250,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            User user = User(
              email: emailControl.text.trim(),
              fullName: fullNameControl.text.trim(),
              password: passwdControl.text.trim(),
            );
            authController.register(user);
          }
        },
        style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: primaryColor,
        ),
        child: const Text("KAYIT OL", style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildLoginRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Hesabınız var mı?",
          style: TextStyle(color: Colors.black54, fontSize: 17),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          },
          child: Text(
            "Giriş yap",
            style: TextStyle(
                color: primaryColor, fontSize: 17, fontWeight: FontWeight.w900),
          ),
        ),
      ],
    );
  }
}
