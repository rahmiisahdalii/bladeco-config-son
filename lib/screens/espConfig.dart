import 'package:bladeco/components/components.dart';
import 'package:bladeco/const/const.dart';
import 'package:bladeco/controller/api_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:geolocator/geolocator.dart';

class EspConfigureScreen extends StatefulWidget {
  @override
  State<EspConfigureScreen> createState() => _EspConfigureScreenState();
}

class _EspConfigureScreenState extends State<EspConfigureScreen> {
  final ssidController = TextEditingController();

  final passwordController = TextEditingController();

  final hostController = TextEditingController();

  final urlController = TextEditingController();

  final modelController = TextEditingController();

  final controller = TextEditingController();

  // Form key
  final _formKey = GlobalKey<FormState>();

  // ignore: deprecated_member_use
  List<WifiNetwork> _wifiNetworks = [];

  // ApiController'ı GetX ile yöneteceğiz
  final ApiController _apiController = Get.put(ApiController());

  @override
  void initState() {
    super.initState();
    scanWifi();
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
      bool hasWifiPermission =
          await WifiPermissionHandler.requestWifiPermission();

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
          child: Form(
            key: _formKey, // Formu belirtiyoruz
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                DropdownButton<String>(
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
                    ssidController.text = value ?? "";
                  },
                ),
                CustomBuildText(
                  controller: ssidController,
                  labelName: "WİFİ ADI",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'WiFi adı boş olamaz';
                    }
                    return null;
                  },
                ),
                CustomBuildText(
                  controller: passwordController,
                  labelName: "WİFİ ŞİFRE",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Şifre boş olamaz';
                    }
                    return null;
                  },
                ),
                CustomBuildText(
                  controller: hostController,
                  labelName: "BACKEND URL",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'URL boş olamaz';
                    }
                    return null;
                  },
                ),
                CustomBuildText(
                  controller: urlController,
                  labelName: "BACKEND PATH",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Path boş olamaz';
                    }
                    return null;
                  },
                ),
                CustomBuildText(
                  controller: modelController,
                  labelName: "İSTASYON MODELİ",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'İstasyon modeli boş olamaz';
                    }
                    return null;
                  },
                ),
                CustomBuildText(
                  controller: controller,
                  labelName: "FİRMA İSMİ",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Firma ismi boş olamaz';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Obx(() {
                  return _apiController.isLoading.value
                      ? CircularProgressIndicator(
                          color: primaryColor,
                        ) // Yükleniyor göstergesi
                      : TextButton.icon(
                          iconAlignment: IconAlignment.end,
                          icon: const Icon(
                            Icons.arrow_circle_right_outlined,
                            color: Color.fromRGBO(101, 199, 238, 1),
                          ),
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              _apiController.sendWiFiAndOcppConfig(
                                ssid: ssidController.text,
                                password: passwordController.text,
                                ocppHost: hostController.text,
                                ocppUrl: urlController.text,
                                ocppModel: modelController.text,
                                ocppVendor: controller.text,
                              );
                            }
                          },
                          label: const Text("Kaydet",
                              style: TextStyle(
                                  color: Color.fromRGBO(101, 199, 238, 1),
                                  fontSize: 20)),
                        );
                }),
                const SizedBox(height: 10),
                Obx(() {
                  // Yanıt mesajını kontrol et ve göster
                  if (_apiController.responseMessage.value.isNotEmpty) {
                    Future.delayed(Duration.zero, () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            title: _apiController.responseStatus.value == 1
                                ? Icon(
                                    Icons.check_circle_outline,
                                    color: Colors.green,
                                    size: 50,
                                  )
                                : Icon(
                                    Icons.error_outline_outlined,
                                    size: 50,
                                    color: Colors.red,
                                  ),
                            content: Card(
                              color: Colors.white,
                              shadowColor: primaryColor,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  _apiController.responseMessage.value,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    _apiController.responseStatus.value = 0;
                                    _apiController.responseMessage.value = '';
                                  },
                                  child: _apiController.responseStatus == 1
                                      ? const Text(
                                          'Tamam',
                                          style: TextStyle(color: Colors.green),
                                        )
                                      : const Text(
                                          'Tekrar Dene',
                                          style: TextStyle(color: Colors.red),
                                        )),
                            ],
                          );
                        },
                      );
                    });
                  }
                  return SizedBox.shrink(); // Ekranda görünmeyen bir widget
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
