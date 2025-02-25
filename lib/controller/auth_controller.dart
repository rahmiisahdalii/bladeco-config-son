import 'package:bladeco/screens/login_page.dart';
import 'package:bladeco/screens/routerPage.dart';
import 'package:bladeco/services/auth_service.dart';
import 'package:bladeco/services/storage_service.dart';
import 'package:get/get.dart';
import 'package:bladeco/model/userModel.dart';

class AuthController extends GetxController {
  var isLoading = false.obs; // Loading durumu
  var isAuthenticated = false.obs; // Kullanıcı giriş yaptı mı?
  var errorMessage = ''.obs; // Hata mesajı
  var successMessage = ''.obs; // Başarı mesajı

  final AuthService authService = AuthService();
  final StorageService storageService = StorageService();

  @override
  void onInit() async {
    super.onInit();
    // Uygulama başlatıldığında, storage'dan kullanıcı giriş durumu alınır
    isAuthenticated.value = await storageService.loadisLogin();
  }

  // Kayıt fonksiyonu
  Future<void> register(User user) async {
    isLoading.value = true;
    errorMessage.value = '';
    successMessage.value = '';

    final response = await authService.register(user);

    if (response == 200) {
      successMessage.value = 'Kayıt başarılı!';
      Get.snackbar('Başarılı', successMessage.value,
          snackPosition: SnackPosition.TOP);
      Get.offAll(() => LoginScreen());
    } else {
      errorMessage.value = 'Kayıt başarısız oldu!';
      Get.snackbar('Hata', errorMessage.value,
          snackPosition: SnackPosition.TOP);
    }
    isLoading.value = false;
  }

  // Giriş fonksiyonu
  Future<void> login(String email, String password) async {
    isLoading.value = true;
    errorMessage.value = '';

    final response = await authService.login(email, password);

    if (response == 200) {
      isAuthenticated.value = true;
      await storageService.saveisLogin(true);
      Get.offAll(() => RouterPage());
    } else {
      errorMessage.value = 'Giriş başarısız oldu!';
      Get.snackbar('Hata', errorMessage.value,
          snackPosition: SnackPosition.TOP);
    }
    isLoading.value = false;
  }

  // Silme fonksiyonu
  Future<void> deleteUser(String email) async {
    isLoading.value = true;
    errorMessage.value = '';
    successMessage.value = '';

    final success = await authService.deleteUser(email);
    if (success) {
      isAuthenticated.value = false;
      await storageService.saveisLogin(false);
      successMessage.value = 'Kullanıcı silindi!';
      Get.snackbar('Başarılı', successMessage.value,
          snackPosition: SnackPosition.TOP);
      Get.offAll(() => LoginScreen());
    } else {
      errorMessage.value = 'Kullanıcı silinemedi!';
      Get.snackbar('Hata', errorMessage.value,
          snackPosition: SnackPosition.TOP);
    }
    isLoading.value = false;
  }
}
