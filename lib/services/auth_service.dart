import 'dart:convert';

import 'package:bladeco/model/userModel.dart';
import 'package:bladeco/services/storage_service.dart';
import 'package:dio/dio.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();

  factory DioClient() {
    return _instance;
  }

  Dio _dio;

  DioClient._internal()
      : _dio = Dio(BaseOptions(
          baseUrl: 'http://193.111.78.145:7133/Auth', // Base URL
          connectTimeout:
              Duration(milliseconds: 5000), // 5 saniye bağlantı zaman aşımı
          receiveTimeout:
              Duration(milliseconds: 3000), // 3 saniye veri alma zaman aşımı
          sendTimeout: Duration(
              milliseconds: 3000), // 3 saniye veri gönderme zaman aşımı
          headers: {
            'Content-Type': 'application/json', // Varsayılan içerik tipi
          },
        )) {
    // Interceptor ile tüm istekleri loglama
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // İstek logu
        print('İstek Yapılıyor: ${options.method} ${options.path}');
        print('Request Headers: ${options.headers}');
        print('Request Body: ${options.data}');
        return handler.next(options); // İstek işlemi devam etsin
      },
      onResponse: (response, handler) {
        // Yanıt logu
        print(
            'Yanıt Geldi: ${response.statusCode} ${response.requestOptions.path}');
        print('Response Data: ${response.data}');
        return handler.next(response); // Yanıt işlemi devam etsin
      },
      onError: (DioError e, handler) {
        // Hata logu
        print('Hata: ${e.message}');
        if (e.response != null) {
          print('Response Data: ${e.response?.data}');
        } else {
          print('Request Error: ${e.requestOptions}');
        }
        return handler.next(e); // Hata işlemi devam etsin
      },
    ));
  }

  Dio get dio => _dio;
}

class AuthService {
  final Dio dio = DioClient().dio; // DioClient instance
  StorageService storageService = StorageService();

  // Kayıt fonksiyonu
  Future<int> register(User user) async {
    try {
      final response = await dio
          .post(
            '/Register',
            data: jsonEncode({
              'email': user.email,
              'password': user.password,
              'fullName': user.fullName,
              'siteId': "00000000000",
            }),
          )
          .timeout(Duration(seconds: 2));

      if (response.statusCode == 200) {
        print('Kayıt başarılı: ${response.data}');
        return 200;
      } else {
        print('Kayıt başarısız: ${response.data}');
        return 400;
      }
    } catch (e) {
      print('Hata: $e');
      return 0;
    }
  }

  // Giriş fonksiyonu
  Future<int> login(String email, String password) async {
    try {
      final response = await dio
          .post(
            '/Login',
            data: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(Duration(seconds: 2));

      if (response.statusCode == 200) {
        final data = response.data;
        final String token = data['token'];
        final String email = data['email'];
        final String fullName = data['fullName'];

        storageService.saveUserProfile(fullName, email);
        storageService.saveToken(token);

        print('Giriş başarılı, token kaydedildi!');
        return 200;
      } else {
        print('Giriş başarısız');
        return 400;
      }
    } catch (e) {
      print('Hata: $e');
      return 0;
    }
  }

  // Silme fonksiyonu
  Future<bool> deleteUser(String email) async {
    try {
      final response = await dio.delete('/deleteUser/$email');

      if (response.statusCode == 200) {
        storageService.removeUserProfile();
        storageService.removeisLogin();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Hata: $e');
      return false;
    }
  }
}
