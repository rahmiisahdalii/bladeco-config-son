import 'package:bladeco/const/const.dart';
import 'package:bladeco/screens/login_page.dart';
import 'package:bladeco/screens/register_page.dart';
import 'package:easy_url_launcher/easy_url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_button/flutter_social_button.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            backgroundColor: Colors.white,

      //backgroundColor: Colors.blue[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 400,
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                "assets/images/electric-vehicle-charging-station-png.png",
              ),
            ), //Giriş resmi
            SizedBox(
              child: Text(
                "HOŞGELDİNİZ",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const SizedBox(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  textAlign: TextAlign.center,
                  "Aşağıdaki butonlardan giriş yapabilir ya da henüz üye olmadıysanız üye olarak uygulamayı kullanabilirsiniz.",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.blueGrey),
                ),
              ),
            ), // Hoşgeldinşz yazısı
            const SizedBox(
              height: 30,
            ),
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 50,
                    width: 250,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()));
                      },
                      style: ButtonStyle(
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
                          backgroundColor: WidgetStatePropertyAll(
                             
                              primaryColor)),
                      child: const Text(
                        "GİRİŞ YAP",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 50,
                    width: 250,
                    child: ElevatedButton(
                      onPressed: () {
                         Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RegisterPage()));
                      },
                      style: const ButtonStyle(
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
                          backgroundColor:
                              WidgetStatePropertyAll(Colors.blueGrey)),
                      child: const Text(
                        "KAYIT OL",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ), 
                  const SizedBox(height: 40),
                  SizedBox(
                    width: 300,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: () async {
                            await EasyLauncher.url(
                                url: "https://www.instagram.com/bladecocharge/",
                                mode: Mode.platformDefault);
                          },
                          icon: const Icon(
                            color: Colors.blueGrey,
                            FontAwesomeIcons.instagram,
                            size: 30,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            await EasyLauncher.url(
                                url: "https://www.linkedin.com/company/bladeco-yatirim-a-/?originalSubdomain=tr",
                                mode: Mode.platformDefault);
                          },
                          icon: const Icon(
                            color: Colors.blueGrey,
                            FontAwesomeIcons.linkedin,
                            size: 30,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            await EasyLauncher.url(
                                url: "https://www.bladecocharge.com/",
                                mode: Mode.platformDefault);
                          },
                          icon: const Icon(
                            color: Colors.blueGrey,
                            FontAwesomeIcons.globe,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
