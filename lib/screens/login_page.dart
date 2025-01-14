// lib/screens/login_screen.dart

import 'package:bladeco/components/components.dart';
import 'package:bladeco/const/const.dart';
import 'package:bladeco/screens/register_page.dart';
import 'package:bladeco/screens/routerPage.dart';
import 'package:bladeco/services/services.dart';
import 'package:flutter/material.dart';
import 'package:bladeco/state/state.dart';

// Ana ekran

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

final TextEditingController userControl = TextEditingController();
final TextEditingController passwdControl = TextEditingController();

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
  }

  void loginUser(String email, String password) async {
    AuthService authService = AuthService();
    AuthProvider auth = AuthProvider();
    int data = await authService.login(email, password);
    if (data == 200) {
      auth.login();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RouterPage()),
      );
    } else if (data == 400) {
      showCustomSnackbar(
          context, "Kullanıcı adı veya şifre yanlış !", Colors.red);
    } else {
      showCustomSnackbar(
          context,
          "Sunucu şuan yanıt vermiyor , lütfen daha sonra tekrar deneyiniz !",
          Colors.red);
    }
  }

  void _login(String email, String password) async {
    bool hasWifiPermission =
        await WifiPermissionHandler.requestWifiPermission();

    if (hasWifiPermission) {
      loginUser(email, password);
    } else {
      // Kullanıcı izni reddettiyse uyarı gösterebilirsiniz
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Konum izni verilmedi.Lütfen ayarlardan izinleri kontrol ediniz.',
            textAlign: TextAlign.center,
          )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 100),
            Image.asset(path, color: Color.fromRGBO(101, 199, 238, 1)),
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
                    GirisYap(),
                    SizedBox(height: 100),
                    RowInfo(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SizedBox GirisYap() {
    return SizedBox(
                    height: 50,
                    width: 250,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _login(userControl.text, passwdControl.text);
                        }
                      },
                      style: const ButtonStyle(
                          shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)))),
                          backgroundColor: WidgetStatePropertyAll(
                            Color.fromRGBO(101, 199, 238, 1),
                          )),
                      child: const Text(
                        "GİRİŞ YAP",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
  }

  Row RowInfo(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Hesabınız yok mu ?",
          style: TextStyle(fontSize: 17, color: Colors.black54),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const RegisterPage()));
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
