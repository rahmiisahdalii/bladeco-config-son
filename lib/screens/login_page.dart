import 'package:bladeco/components/components.dart';
import 'package:bladeco/const/const.dart';
import 'package:bladeco/controller/auth_controller.dart';
import 'package:bladeco/screens/register_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController userControl = TextEditingController();
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
            const SizedBox(height: 100),
            Image.asset(path, color: const Color.fromRGBO(101, 199, 238, 1)),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      girismetni,
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.w900,
                        color: Color.fromRGBO(101, 199, 238, 1),
                      ),
                    ),
                    CustomMailTextFormField(controller: userControl),
                    CustomPasswdTextFormField(controller: passwdControl),
                    const SizedBox(height: 20),
                    Obx(() => authController.isLoading.value
                        ? const CircularProgressIndicator()
                        : _buildLoginButton()),
                    const SizedBox(height: 100),
                    _buildRegisterRow(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      height: 50,
      width: 250,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            authController.login(userControl.text, passwdControl.text);
          }
        },
        style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: const Color.fromRGBO(101, 199, 238, 1),
        ),
        child: const Text("GİRİŞ YAP", style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildRegisterRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Hesabınız yok mu ?",
          style: TextStyle(fontSize: 17, color: Colors.black54),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RegisterPage()),
            );
          },
          child: const Text(
            "Kaydol",
            style: TextStyle(
                color: Color.fromRGBO(101, 199, 238, 1),
                fontSize: 17,
                fontWeight: FontWeight.w900),
          ),
        ),
      ],
    );
  }
}
