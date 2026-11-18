import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/config/supabase_config.dart';
import '../../core/services/supabase_service.dart';

/// GetX Controller for application settings and dynamic Supabase connectivity.
class SettingsController extends GetxController {
  final SupabaseService _supabaseService;
  SettingsController(this._supabaseService);

  final RxBool isDarkMode = false.obs;
  final RxString supabaseUrl = ''.obs;
  final RxString supabaseAnonKey = ''.obs;

  @override
  void onInit() {
    super.onInit();
    supabaseUrl.value = SupabaseConfig.currentUrl;
    supabaseAnonKey.value = SupabaseConfig.currentAnonKey;
  }

  bool get isConnected => _supabaseService.isOnline.value;
  String get connectionStatus => _supabaseService.connectionStatus.value;

  Future<bool> updateSupabaseConfig(String url, String anonKey) async {
    final success = await _supabaseService.reconnect(url: url, anonKey: anonKey);
    if (success) {
      supabaseUrl.value = url;
      supabaseAnonKey.value = anonKey;
      Get.snackbar(
        'Database Connected',
        'Successfully connected to remote Supabase PostgreSQL database.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF10B981),
        colorText: Colors.white,
      );
      return true;
    } else {
      Get.snackbar(
        'Connection Warning',
        'Could not reach database. Retaining local reactive fallback mode.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFF59E0B),
        colorText: Colors.white,
      );
      return false;
    }
  }

  void toggleTheme() {
    isDarkMode.toggle();
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }
}

