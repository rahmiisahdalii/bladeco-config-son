import 'package:bladeco/const/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_button/flutter_social_button.dart';
import 'package:permission_handler/permission_handler.dart';

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

class CustomBuildText extends StatelessWidget {
  const CustomBuildText({
    super.key,
    required this.controller,
    required this.labelName,
    required this.validator,
  });

  final TextEditingController controller;
  final String labelName;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: TextFormField(
        cursorColor: Colors.green,
        controller: controller,
        validator: validator, // Validator'ı burada kullanıyoruz
        decoration: InputDecoration(
          labelText: labelName,
          labelStyle: TextStyle(color: primaryColor),
          errorStyle:
              const TextStyle(color: Colors.red), // Hata mesajları kırmızı
        ),
      ),
    );
  }
}

bool isValidEmail(String email) {
  String pattern =
      r'^[a-zA-Z0-9.a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
  RegExp regex = RegExp(pattern);
  return regex.hasMatch(email);
}

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.info,
    required this.validateInfo,
    required this.icondata,
    required this.controller,
  });

  final String info;
  final String validateInfo;
  final IconData icondata;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icondata, color: Colors.black54),
          labelText: info,
          labelStyle: const TextStyle(color: Colors.black38),
          filled: true,
          fillColor: Colors.white.withOpacity(0.5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        style: const TextStyle(color: Colors.black),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return validateInfo;
          }
          return null;
        },
      ),
    );
  }
}

class CustomMailTextFormField extends StatelessWidget {
  const CustomMailTextFormField({
    super.key,
    required this.controller,
  });
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.mail_outline_rounded,
              size: 30, color: Colors.black54),
          labelText: "Mail",
          labelStyle: const TextStyle(color: Colors.black38),
          filled: true,
          fillColor: Colors.white.withOpacity(0.3),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        style: const TextStyle(color: Colors.black),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Lütfen mail adresinizi girin';
          } else if (!isValidEmail(value)) {
            return 'Geçersiz mail adresi';
          }
          return null;
        },
      ),
    );
  }
}

class CustomPasswdTextFormField extends StatelessWidget {
  const CustomPasswdTextFormField({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock_outline_rounded,
              size: 25, color: Colors.black54),
          labelText: "Şifre",
          labelStyle: const TextStyle(color: Colors.black38),
          filled: true,
          fillColor: Colors.white.withOpacity(0.3),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        obscureText: true,
        style: const TextStyle(color: Colors.black),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Lütfen şifre girin';
          }
          if (value.length < 8) {
            return "Şifre 8 karakterden az olamaz !!";
          }
          return null;
        },
      ),
    );
  }
}

class WifiPermissionHandler {
  static Future<bool> requestWifiPermission() async {
    // Wi-Fi ve konum izinlerini kontrol et
    PermissionStatus wifiPermission = await Permission.locationWhenInUse.status;

    if (wifiPermission.isGranted) {
      // İzin zaten verilmiş
      return true;
    } else if (wifiPermission.isDenied || wifiPermission.isRestricted) {
      // İzin verilmemişse kullanıcıya izin isteme diyaloğu göster
      PermissionStatus newStatus = await Permission.locationWhenInUse.request();
      return newStatus.isGranted;
    }

    return false;
  }
}

void deactive(dynamic context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: const Color.fromRGBO(101, 199, 238, 0.7),
      icon: const Icon(
        color: Colors.white54,
        FontAwesomeIcons.roadBarrier,
        size: 30,
      ),
      content: const Text(
        'Bu sürümde mevcut değil!',
        style: TextStyle(color: Colors.white, fontSize: 18),
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Tamam',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
  );
}
