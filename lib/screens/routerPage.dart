import 'package:bladeco/components/components.dart';
import 'package:bladeco/const/const.dart';
import 'package:bladeco/screens/MyHomePage.dart';
import 'package:bladeco/screens/espConfig.dart';
import 'package:bladeco/screens/deviceConfig.dart';
import 'package:bladeco/services/services.dart';
import 'package:bladeco/state/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_button/flutter_social_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

class RouterPage extends StatefulWidget {
  const RouterPage({super.key});

  @override
  State<RouterPage> createState() => _RouterPageState();
}

class _RouterPageState extends State<RouterPage> {
  void showCustomSnackbar(BuildContext context, String text, Color color) {
    final snackBar = SnackBar(
      content: Text(
        "$text",
        style: TextStyle(
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
      duration: Duration(seconds: 2), // Snackbar'ın gösterim süresi
      backgroundColor: color, // Snackbar arka plan rengi
    );
    // Snackbar'ı gösterme
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  AuthProvider auth = AuthProvider();
  void _deleteUser(String email) async {
    AuthService authService = AuthService();

    bool response = await authService.deleteUser(email);

    if (response == true) {
      clearUserData();
      auth.logout();
      removeUserProfile();
      showCustomSnackbar(
          context, "Hesabınız başarıyla silindi .", Colors.green);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
    if (response == false) {
      showCustomSnackbar(context,
          "Sunucu yanıt vermiyor , daha sonra tekrar deneyiniz!", Colors.red);
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  void _deleteProfile(String email, context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.red[400],
          title: Text(
            'Hesabınız silinecek onaylıyor musunuz?',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            ElevatedButton.icon(
              icon: Icon(
                Icons.cancel,
                color: const Color.fromARGB(214, 244, 67, 54),
              ),
              style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.white)),
              label: Text(
                'İptal',
                style: TextStyle(color: Colors.black54, fontSize: 19),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Popup'ı kapat
              },
            ),
            ElevatedButton.icon(
              label: Text(
                'Onayla',
                style: TextStyle(color: Colors.black54, fontSize: 19),
              ),
              style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.white)),
              icon: Icon(
                Icons.check_box,
                color: Colors.green,
              ),
              onPressed: () => _deleteUser(email),
            ),
          ],
        );
      },
    );
  }

  String? userEmail;
  String? userName;

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  // Email bilgisini asenkron olarak alıyoruz
  Future<void> fetchUser() async {
    String? email = await getUseremail(); // Email sonucunu bekliyoruz
    String? username = await getUserFullname();
    setState(() {
      userEmail = email; // Aldığımız değeri state'e atıyoruz
      userName = username;
    });
  }

  Future<void> clearUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('host');
    await prefs.remove('url');
    await prefs.remove('model');
    await prefs.remove('vendor');
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await _showExitConfirmationDialog(context);
        return shouldPop ?? false;
      },
      child: Scaffold(
        drawer: SafeArea(
            child: Container(
                child: ListTileTheme(
          textColor: Colors.white,
          iconColor: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 128.0,
                height: 128.0,
                margin: const EdgeInsets.only(
                  top: 24.0,
                  bottom: 64.0,
                ),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'assets/images/pngtree-user-profile-avatar-png-image_10211467.png',
                  fit: BoxFit.scaleDown,
                ),
              ),
              ListTile(
                onTap: () {},
                leading: Icon(Icons.person),
                title: Text('AD-SOYAD'),
                subtitle: Text('$userName'),
              ),
              ListTile(
                onTap: () {},
                leading: Icon(Icons.mail),
                title: Text('MAİL'),
                subtitle: Text('$userEmail'),
              ),
              Spacer(),
              Container(
                margin: EdgeInsets.only(bottom: 20),
                width: MediaQuery.of(context).size.width * 0.45,
                color: Colors.transparent,
                child: ListTile(
                  onTap: () {
                    clearUserData();
                    auth.logout();
                    removeToken();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  },
                  leading: Icon(
                    Icons.logout_outlined,
                  ),
                  title: Text(
                    'Çıkış Yap',
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  margin: EdgeInsets.only(bottom: 20),
                  width: MediaQuery.of(context).size.width * 0.5,
                  color: Colors.red[400],
                  child: ListTile(
                    onTap: () => _deleteProfile("$userEmail", context),
                    leading: Icon(
                      Icons.delete_forever,
                    ),
                    title: Text(
                      'Hesabımı Sil',
                    ),
                  ),
                ),
              )
            ],
          ),
        ))),
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Image.asset(
                "assets/images/routepng.png",
                filterQuality: FilterQuality.high,
                width: 250,
              ),
              SizedBox(height: 20),
              NewWidget(
                iconData:
                    FontAwesomeIcons.chargingStation, // Şarj istasyonu ikonu
                data: "İstasyon Yapılandırma",
                bgColors: primaryColor,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DeviceConfigurationScreen(),
                      ));
                },
              ),
              NewWidget(
                iconData: FontAwesomeIcons.cogs, // Ayar/konfigürasyon ikonu
                data: "Esp Yapılandırma",
                bgColors: primaryColor,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EspConfigureScreen(),
                      ));
                },
              ),
              NewWidget(
                iconData:
                    FontAwesomeIcons.undo, // Geri alma veya sıfırlama ikonu
                data: "Sıfırla",
                bgColors: Colors.green,
                onPressed: () => deactive(context),
              ),
              NewWidget(
                iconData: FontAwesomeIcons.infoCircle, // Bilgi ikonu
                data: "Bilgi",
                bgColors: Colors.blueGrey,
                onPressed: () => deactive(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NewWidget extends StatelessWidget {
  const NewWidget({
    super.key,
    required this.data,
    required this.bgColors,
    this.onPressed,
    this.iconData = Icons.info_outline,
  });
  final IconData iconData;
  final String data;
  final Color bgColors;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        child: ElevatedButton.icon(
          label: Text(
            data,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          icon: Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Icon(
              iconData,
              color: Colors.white,
              size: 16,
            ),
          ),
          onPressed: onPressed,
          style: ButtonStyle(
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)))),
            backgroundColor: WidgetStatePropertyAll(bgColors),
          ),
        ),
      ),
    );
  }
}

Future<bool?> _showExitConfirmationDialog(BuildContext context) {
  return PanaraConfirmDialog.show<bool>(
    context,
    title: "ÇIKIŞ !",
    message: "Çıkmak istediğinize emin misiniz ?",
    confirmButtonText: "Evet",
    cancelButtonText: "Hayır",
    onTapCancel: () {
      Navigator.of(context).pop(false);
    },
    onTapConfirm: () {
      Navigator.of(context).pop(true);
    },
    panaraDialogType: PanaraDialogType.custom,
    color: primaryColor,
    barrierDismissible: false, // optional parameter (default is true)
  );
}
