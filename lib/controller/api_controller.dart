import 'package:get/get.dart';
import 'package:dio/dio.dart';

class ApiController extends GetxController {
  late Dio _dio;

  // 🟢 Yüklenme durumu
  var isLoading = false.obs;
  var responseMessage = ''.obs;
  var responseStatus = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _dio = Dio(BaseOptions(
      baseUrl: 'http://192.168.4.1',
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 5),
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    // Loglama ve hata yönetimi için interceptor ekleme
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print('🟡 İstek gönderiliyor: ${options.method} ${options.uri}');
        print('📤 Gönderilen veri: ${options.data}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('🟢 Başarılı yanıt: ${response.statusCode}');
        print('📥 Yanıt verisi: ${response.data}');
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        print('🔴 Hata oluştu: ${e.message}');
        print('🚨 Hata detayları: ${e.response?.data}');
        return handler.next(e);
      },
    ));
  }

  /// 📌 **Wi-Fi ve OCPP yapılandırmasını `/config` endpoint'ine gönderir.**
  Future<void> sendWiFiAndOcppConfig({
    required String ssid,
    required String password,
    required String ocppHost,
    required String ocppUrl,
    required String ocppModel,
    required String ocppVendor,
  }) async {
    isLoading.value = true;
    try {
      final response = await _dio.post('/config', data: {
        "ssid": ssid,
        "password": password,
        "ocppHost": ocppHost,
        "ocppUrl": ocppUrl,
        "ocppModel": ocppModel,
        "ocppVendor": ocppVendor,
      });

      if (response.statusCode == 200) {
        responseMessage.value = "Wi-Fi ve OCPP Konfigurasyonu başarılı!";
        responseStatus.value = 1;
      } else {
        responseMessage.value =
            "Wi-Fi ve OCPP Konfigurasyonu başarısız! HTTP ${response.statusCode}";
        responseStatus.value = 0;
      }
    } on DioException catch (e) {
      responseMessage.value = "Dio Hatası: ${e.message}";
      responseStatus.value = 0;
    } catch (e) {
      responseMessage.value = "Beklenmeyen Hata: $e";
      responseStatus.value = 0;
    } finally {
      isLoading.value = false;
    }
  }

  /// 📌 **Cihaz yapılandırmasını `/configuration` endpoint'ine gönderir.**
  Future<void> sendDeviceConfiguration({
    required String ocppModel,
    required String ocppVendor,
    required String firmwareVersion,
    required String chargePointSerial,
    required String meterSerial,
    required String meterType,
    required String chargeBoxSerial,
    required String iccid,
    required String imsi,
  }) async {
    isLoading.value = true;
    try {
      final response = await _dio.post('/configuration', data: {
        "ocppModel": ocppModel,
        "ocppVendor": ocppVendor,
        "firmwareVersion": firmwareVersion,
        "chargePointSerial": chargePointSerial,
        "meterSerial": meterSerial,
        "meterType": meterType,
        "chargeBoxSerial": chargeBoxSerial,
        "iccid": iccid,
        "imsi": imsi,
      });

      if (response.statusCode == 200) {
        responseMessage.value = "Cihaz Konfigurasyonu başarılı!";
        responseStatus.value = 1;
      } else {
        responseMessage.value =
            "Cihaz Konfigurasyonu başarısız! HTTP ${response.statusCode}";
        responseStatus.value = 0;
      }
    } on DioException catch (e) {
      responseMessage.value = "Dio Hatası: ${e.message}";
      responseStatus.value = 0;
    } catch (e) {
      responseMessage.value = "Beklenmeyen Hata: $e";
      responseStatus.value = 0;
    } finally {
      isLoading.value = false;
    }
  }
}
