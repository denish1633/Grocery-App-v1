import 'package:get/get.dart';
import '../models/user.dart';
import '../services/AuthService.dart';
import '../utils/storage.dart';

class AuthController extends GetxController {
  var user = Rxn<User>();
  final AuthService _authService = AuthService();

  bool get isLoggedIn => user.value != null;

  /// Login
  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Email and password cannot be empty');
      return;
    }

    try {
      final result = await _authService.login(email, password);
      if (result == null) {
        Get.snackbar('Login Failed', 'Invalid credentials or server error');
        return;
      }
      user.value = result; // Make sure User model includes access_token
      final token = user.value?.accessToken;
      print('Token: $token');
      if (token != null && token.isNotEmpty) {
        await Storage.setToken(token);
        Get.offAllNamed('/home');
      } else {
        user.value = null;
        Get.snackbar('Login Failed', 'Token missing from server response');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  /// Register
  Future<void> register(String email, String password, String username) async {
    if (email.isEmpty || password.isEmpty || username.isEmpty) {
      Get.snackbar('Error', 'Email, password and username cannot be empty');
      return;
    }

    try {
      final result = await _authService.register(email, password, username);
      if (result == null) {
        Get.snackbar('Registration Failed', 'Server returned null');
        return;
      }

      user.value = result;

      final token = user.value?.accessToken;
      if (token != null && token.isNotEmpty) {
        await Storage.setToken(token);
        Get.offAllNamed('/home');
      } else {
        user.value = null;
        Get.snackbar(
          'Registration Failed',
          'Token missing from server response',
        );
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  /// Logout
  Future<void> logout() async {
    await Storage.removeToken();
    user.value = null;
    Get.offAllNamed('/login');
  }
}
