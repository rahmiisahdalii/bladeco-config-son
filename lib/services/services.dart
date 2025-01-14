import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/userModel.dart';

bool _logincontrol = false ;
bool get loginControl => _logincontrol;

Future<void> saveToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('jwt_token', token);
}

Future<void> saveUserProfile(String fullName , String email) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('fullname', fullName);
  await prefs.setString('email', email);
}

Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('jwt_token');
}

Future<String?> getUserFullname() async {
  await Future.delayed(Duration(seconds: 1));
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('fullname');
}

Future<String?> getUseremail() async {
    await Future.delayed(Duration(seconds: 1));
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('email');
}

Future<void> removeToken() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('jwt_token');
}

Future<void> removeUserProfile() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('fullname');
  await prefs.remove('email');
  await prefs.remove('jwt_token');
}

class AuthService {
  final String baseUrl = 'http://195.85.207.145:80/Auth';
  // Kayıt fonksiyonu
  Future<int> register(User user) async {
     try {
    final url = Uri.parse('$baseUrl/Register');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': user.email,
        'password': user.password,
        'fullName': user.fullName,
        'siteId': "00000000000",
      }),
    ).timeout(Duration(seconds: 2));
    /////////////////////////////////////////////
    if (response.statusCode == 200) {                       
      print('Kayıt başarılı: ${response.body}');           
      return 200;
    } else {
      print('Kayıt başarısız: ${response.body}');
      return 400;
    }
     } catch (e) {print('\x1B[${31}m$e\x1B[0m'); return 0;}
    
  }

  // Giriş fonksiyonu
  Future<int> login(String email, String password) async {
     try {
    final url = Uri.parse('$baseUrl/Login');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    ).timeout(Duration(seconds: 2));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      print(data);
      final String token = data['token'];
      final String email = data['email'];
      final String fullName = data['fullName'];
      
      saveUserProfile(fullName, email);
      saveToken(token);
      print('Giriş başarılı, token kaydedildi!');
      return 200;
    } else {
      print(response.statusCode);
      print('Giriş başarısız');
      return 400;
    }
    } catch (e) { print('\x1B[${31}m$e\x1B[0m'); return 0;}
  }

  // Silme fonksiyonu
  Future<bool> deleteUser(String email) async {
    final url = Uri.parse('$baseUrl/deleteUser/$email');
    final response = await http.delete(
      url,
    );
    if (response.statusCode == HttpStatus.ok) {
      return true;
    } else {
      return false;
    }
  }
}
//Güncelleme
Future<void> updateControl(int session) async {
  final loginToken = await getToken();

  if (loginToken != null && session == 1) {
   _logincontrol = true ;
  } 
  if (loginToken == null && session==1) {
    print("token boş");
  }
  if (loginToken != null && session==0) {
   _logincontrol = false ;
  }
}

