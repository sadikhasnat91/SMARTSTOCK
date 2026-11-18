import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';
import '../../app/routes/app_routes.dart';

/// GetX Controller managing user authentication state, profile, and authorization.
class AuthController extends GetxController {
  final AuthRepository _repository;
  AuthController(this._repository);

  final Rxn<UserModel> currentUser = Rxn<UserModel>();
  final RxBool isLoggedIn = true.obs; // Defaults to demo session
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    currentUser.value = _repository.currentUser;
  }

  Future<bool> signIn({required String email, required String password}) async {
    isLoading.value = true;
    try {
      final success = await _repository.signIn(email: email, password: password);
      if (success) {
        currentUser.value = _repository.currentUser;
        isLoggedIn.value = true;
        Get.offAllNamed(AppRoutes.executiveDashboard);
        Get.snackbar(
          'Welcome to SmartStock',
          'Signed in as ${currentUser.value?.name ?? email}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF0F172A),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
        return true;
      } else {
        Get.snackbar('Sign In Failed', 'Invalid credentials or connection error');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    await _repository.signOut();
    currentUser.value = null;
    isLoggedIn.value = false;
    Get.offAllNamed(AppRoutes.login);
  }
}
