import 'package:bladeco/components/components.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wifi_iot/wifi_iot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';

class configure extends StatefulWidget {
  @override
  _configureState createState() => _configureState();
}

class _configureState extends State<configure> { 
  final ssidController = TextEditingController();
  final passwordController = TextEditingController();
  final hostController = TextEditingController();
  final urlController = TextEditingController();
  final modelController = TextEditingController();
  final vendorController = TextEditingController();

  String responseMessage = '';
  bool responseStatus = false ;
  // ignore: deprecated_member_use
  List<WifiNetwork> _wifiNetworks = [];

  void initState() {
    super.initState();
    scanWifi();
    _loadSavedData();
  }

  Future<void> _saveUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('host', hostController.text);
    await prefs.setString('url', urlController.text);
    await prefs.setString('model', modelController.text);
    await prefs.setString('vendor', vendorController.text);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Bilgiler kaydedildi!', textAlign: TextAlign.center)),
    );
  }

  // Kayıtlı bilgileri yükle
  Future<void> _loadSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      hostController.text = prefs.getString('host') ?? "";
      urlController.text = prefs.getString('url') ?? "";
      modelController.text = prefs.getString('model') ?? "";
      vendorController.text = prefs.getString('vendor') ?? "";
    });
  }

  Future<void> sendConfig(String ssid, String password, String ocppHost,
    String ocppUrl, String ocppModel, String ocppVendor) async {

    final url = Uri.parse('http://192.168.4.1/config');
    final response = await http.post(url, body: {
      "ssid": ssid,
      "password": password,
      "ocppHost": ocppHost,
      "ocppUrl": ocppUrl,
      "ocppModel": ocppModel,
      "ocppVendor": ocppVendor,
    });

    if (response.statusCode == 200) {
      setState(() {
        responseMessage = '* Konfigurasyon başarılı *';
        responseStatus = true ;
      });
    } else {
      setState(() {
        responseMessage = '* Konfigurasyon başarısız *';
      });
    }
  }

Future<void> scanWifi() async {
  LocationPermission permission = await Geolocator.checkPermission();
  bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();

  if (permission == LocationPermission.denied || !isLocationEnabled) {
    // Konum izni yok veya konum servisleri kapalı
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.green,
      content: Text(
        'Uyarı: Wifi ağlarını görebilmek için konumunuzun açık durumda olması gerekiyor',
        textAlign: TextAlign.center,
      ),
    ));
  } else {
    // ignore: deprecated_member_use
    bool hasWifiPermission = await WifiPermissionHandler.requestWifiPermission();

    if (hasWifiPermission) {
      // ignore: deprecated_member_use
      List<WifiNetwork>? networks = await WiFiForIoTPlugin.loadWifiList();
      setState(() {
        _wifiNetworks = networks ?? [];
      });
    } else {
      // Kullanıcı izni reddettiyse uyarı gösterebilirsiniz
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          'Konum erişimi yok. Lütfen ayarlardan izinleri kontrol ediniz.',
          textAlign: TextAlign.center,
        ),
      ));
    }
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          ' Yapılandırma ',
          style:
              TextStyle(color: Color.fromRGBO(101, 199, 238, 1), fontSize: 22),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              SingleChildScrollView(
                child: DropdownButton<String>(
                  dropdownColor: Colors.white,
                  iconSize: 20,
                  alignment: Alignment.center,
                  icon: const Icon(Icons.wifi),
                  hint: const Text('WiFi ağı seçin'),
                  items: _wifiNetworks.map((network) {
                    var ssid = network.ssid;
                    return DropdownMenuItem(
                      value: network.ssid,
                      child: Text(ssid!),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      ssidController.text = value ?? "";
                    });
                  },
                ),
              ),
              customBuildText(
                vendorController: ssidController,
                labelName: "WİFİ ADI",
              ),
              customBuildText(
                vendorController: passwordController,
                labelName: "WİFİ ŞİFRE",
              ),
              customBuildText(
                vendorController: hostController,
                labelName: "BACKEND URL",
              ),
              customBuildText(
                vendorController: urlController,
                labelName: "BACKEND PATH",
              ),
              customBuildText(
                vendorController: modelController,
                labelName: "İSTASYON MODELİ",
              ),
              customBuildText(
                vendorController: vendorController,
                labelName: "FİRMA İSMİ",
              ),
              const SizedBox(height: 20),
              TextButton.icon(
                iconAlignment: IconAlignment.end,
                icon: const Icon(
                  Icons.arrow_circle_right_outlined,
                  color: Color.fromRGBO(101, 199, 238, 1),
                ),
                onPressed: () {
                  _saveUserData();
                  sendConfig(
                    ssidController.text,
                    passwordController.text,
                    hostController.text,
                    urlController.text,
                    modelController.text,
                    vendorController.text,
                  );
                },
                label: const Text("Kaydet",
                    style: TextStyle(
                        color: Color.fromRGBO(101, 199, 238, 1), fontSize: 20)),
              ),
              const SizedBox(height: 30),
              Text(responseMessage.toUpperCase() , style: TextStyle(color: responseStatus ? Colors.green : Colors.red , fontSize: 20),),
            ],
          ),
        ),
      ),
    );
  }
}
