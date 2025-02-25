import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  // SharedPreferences instance'ını merkezi olarak tutuyoruz
  Future<SharedPreferences> _getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  // Token'ı kaydetme
  Future<void> saveToken(String token) async {
    final prefs = await _getPrefs();
    await prefs.setString('jwt_token', token);
  }

  // Kullanıcı profilini kaydetme
  Future<void> saveUserProfile(String fullName, String email) async {
    final prefs = await _getPrefs();
    await prefs.setString('fullname', fullName);
    await prefs.setString('email', email);
  }

  // Kullanıcı adını (fullName) alma
  Future<String?> getUserFullname() async {
    final prefs = await _getPrefs();
    return prefs.getString('fullname');
  }

  // Kullanıcı e-posta adresini alma
  Future<String?> getUserEmail() async {
    final prefs = await _getPrefs();
    return prefs.getString('email');
  }

  // Kullanıcı profilini kaldırma (jwt_token, fullname ve email)
  Future<void> removeUserProfile() async {
    final prefs = await _getPrefs();
    await prefs.remove('fullname');
    await prefs.remove('email');
    await prefs.remove('jwt_token');
  }

  // Kullanıcı giriş durumunu kontrol etme
  Future<bool> loadisLogin() async {
    final prefs = await _getPrefs();
    return prefs.getBool('isAuthenticated') ??
        false; // Varsayılan olarak false döner
  }

  // Kullanıcı giriş durumunu kaydetme
  Future<void> saveisLogin(bool isAuthenticated) async {
    final prefs = await _getPrefs();
    prefs.setBool('isAuthenticated', isAuthenticated);
  }

  // Kullanıcı giriş durumunu kaldırma
  Future<void> removeisLogin() async {
    final prefs = await _getPrefs();
    await prefs.remove('isAuthenticated');
  }
}
