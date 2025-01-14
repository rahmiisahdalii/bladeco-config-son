import 'package:bladeco/components/components.dart';
import 'package:bladeco/const/const.dart';
import 'package:bladeco/screens/login_page.dart';
import 'package:bladeco/model/userModel.dart';
import 'package:bladeco/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_button/flutter_social_button.dart';
// Ana ekran

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterPageState createState() => _RegisterPageState();
}

final TextEditingController fullNameControl = TextEditingController();
final TextEditingController emailControl = TextEditingController();
final TextEditingController passwdControl = TextEditingController();

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  void registerUser() async {
    User user = User(
      email: emailControl.text.trim(),
      fullName: fullNameControl.text.trim(),
      password: passwdControl.text.trim(),
    );

    AuthService authService = AuthService();
    int registeredUser = await authService.register(user);

    if (registeredUser == 200) {
      showCustomSnackbar(context, "Kayıt Başarılı", Colors.green);
      fullNameControl.clear();
      emailControl.clear();
      passwdControl.clear();

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else if (registeredUser == 400) {
      showCustomSnackbar(
          context, "Kayıt Başarısız , sunucu yanıt vermiyor !", Colors.red);
      print("User mail adresi:");
      print(user.email);
    } else {
      showCustomSnackbar(context,
          "Sunucu şuan yanıt vermiyor,lütfen tekrar deneyiniz !", Colors.red);
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
            SizedBox(height: 70),
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
                  SizedBox(
                    height: 50,
                    width: 250,
                    child: ElevatedButton(
  
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          registerUser();
                        }
                      },
                      style: ButtonStyle(
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
                          backgroundColor: WidgetStatePropertyAll(
                        primaryColor,
                      )),
                      child: const Text(
                        "KAYIT OL",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 100),
                  RowBilgi(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RowBilgi extends StatelessWidget {
  const RowBilgi({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
                MaterialPageRoute(
                    builder: (context) => const LoginScreen()));
          },
          child:Text(
            "Giriş yap",
            style: TextStyle(
                color: primaryColor,
                fontSize: 17,
                fontWeight: FontWeight.w900),
          ),
        ),
      ],
    );
  }
}



