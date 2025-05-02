import 'package:bladeco/components/components.dart';
import 'package:bladeco/const/const.dart';
import 'package:bladeco/controller/api_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeviceConfigurationScreen extends StatefulWidget {
  @override
  State<DeviceConfigurationScreen> createState() =>
      _DeviceConfigurationScreenState();
}

class _DeviceConfigurationScreenState extends State<DeviceConfigurationScreen> {
  final _formKey = GlobalKey<FormState>(); // FormState için key

  final ocppModelController = TextEditingController();
  final ocppVendorController = TextEditingController();
  final firmwareVersionController = TextEditingController();
  final chargePointSerialController = TextEditingController();
  final meterSerialController = TextEditingController();
  final meterTypeController = TextEditingController();
  final chargeBoxSerialController = TextEditingController();
  final iccidController = TextEditingController();
  final imsiController = TextEditingController();

  final ApiController _apiController = Get.put(ApiController());
    @override
  void initState() {
    super.initState();
      ocppModelController.text = 'BLDC';             // İstasyon modeli
  ocppVendorController.text = 'BLADECO';              // Firma ismi
  firmwareVersionController.text = '1.0.1';          // Firmware sürümü
  chargePointSerialController.text = 'BLDC-AC';    // Şarj noktası seri no
  meterSerialController.text = '';           // Sayaç seri no
  meterTypeController.text = 'Schneider-IEM3150';                 // Sayaç tipi
  chargeBoxSerialController.text = '';       // Charge Box seri no
  iccidController.text = '';        // SIM kart ICCID
  imsiController.text = '';             // SIM kart IMSI
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
          'İstasyon Bilgi',
          style:
              TextStyle(color: Color.fromRGBO(101, 199, 238, 1), fontSize: 22),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey, // Formu oluştur
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                CustomBuildText(
                  controller: ocppModelController,
                  labelName: "OCPP Modeli",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bu alan boş bırakılamaz';
                    }
                    return null;
                  },
                ),
                CustomBuildText(
                  controller: ocppVendorController,
                  labelName: "OCPP Vendor",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bu alan boş bırakılamaz';
                    }
                    return null;
                  },
                ),
                CustomBuildText(
                  controller: firmwareVersionController,
                  labelName: "Firmware Sürümü",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bu alan boş bırakılamaz';
                    }
                    return null;
                  },
                ),
                CustomBuildText(
                  controller: chargePointSerialController,
                  labelName: "Şarj Noktası Seri No",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bu alan boş bırakılamaz';
                    }
                    return null;
                  },
                ),
                CustomBuildText(
                  controller: meterSerialController,
                  labelName: "Sayac Seri No",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bu alan boş bırakılamaz';
                    }
                    return null;
                  },
                ),
                CustomBuildText(
                  controller: meterTypeController,
                  labelName: "Sayaç Tipi",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bu alan boş bırakılamaz';
                    }
                    return null;
                  },
                ),
                CustomBuildText(
                  controller: chargeBoxSerialController,
                  labelName: "Şarj Kutusu Seri No",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bu alan boş bırakılamaz';
                    }
                    return null;
                  },
                ),
                CustomBuildText(
                  controller: iccidController,
                  labelName: "ICCID",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bu alan boş bırakılamaz';
                    }
                    return null;
                  },
                ),
                CustomBuildText(
                  controller: imsiController,
                  labelName: "IMSI",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bu alan boş bırakılamaz';
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
                              _apiController.sendDeviceConfiguration(
                                model: ocppModelController.text,
                                vendor: ocppVendorController.text,
                                firmwareVersion: firmwareVersionController.text,
                                chargePointSerialNumber:
                                    chargePointSerialController.text,
                                meterSerialNumber: meterSerialController.text,
                                meterType: meterTypeController.text,
                                chargeBoxSerialNumber: chargeBoxSerialController.text,
                                iccid: iccidController.text,
                                imsi: imsiController.text,
                              );
                            }
                          },
                          label: const Text(
                            "Kaydet",
                            style: TextStyle(
                                color: Color.fromRGBO(101, 199, 238, 1),
                                fontSize: 20),
                          ),
                        );
                }),
                const SizedBox(height: 10),
                Obx(() {
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
                                      ),
                              ),
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
