import 'package:bladeco/controller/auth_controller.dart';
import 'package:bladeco/screens/MyHomePage.dart';
import 'package:bladeco/screens/routerPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance(); // SharedPreferences başlatılıyor
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // AuthController'ı GetX ile başlatıyoruz
    Get.put(AuthController());

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Obx(() {
        // isAuthenticated değerine göre ekranı seçiyoruz
        return Get.find<AuthController>().isAuthenticated.value
            ? RouterPage()
            : HomePage();
      }),
    );
  }
}
