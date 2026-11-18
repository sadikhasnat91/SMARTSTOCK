import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';

/// Central Supabase service providing client access, connection status,
/// and graceful fallback for offline / university demo / test modes.
class SupabaseService extends GetxService {
  static SupabaseService get to => Get.find<SupabaseService>();

  final RxBool isOnline = false.obs;
  final RxBool isInitialized = false.obs;
  final RxString connectionStatus = 'Offline Mode (Local Reactive Store)'.obs;
  final RxString errorMessage = ''.obs;

  SupabaseClient? _client;
  SupabaseClient? get client => _client;

  /// Initializes Supabase connection if configured
  Future<SupabaseService> init() async {
    if (!SupabaseConfig.isConfigured) {
      debugPrint('[SmartStock] Supabase running in local reactive mode (No external API key provided).');
      connectionStatus.value = 'Local Reactive Mode (Ready for Viva Demo)';
      isInitialized.value = true;
      return this;
    }

    try {
      await Supabase.initialize(
        url: SupabaseConfig.currentUrl,
        // ignore: deprecated_member_use
        anonKey: SupabaseConfig.currentAnonKey,
      );
      _client = Supabase.instance.client;
      isOnline.value = true;
      isInitialized.value = true;
      connectionStatus.value = 'Connected to Supabase (PostgreSQL)';
      debugPrint('[SmartStock] Supabase successfully initialized & connected to ${SupabaseConfig.currentUrl}');
    } catch (e) {
      debugPrint('[SmartStock] Supabase initialization failed, falling back to local store: $e');
      errorMessage.value = e.toString();
      connectionStatus.value = 'Fallback Mode (Local Reactive Store)';
      isOnline.value = false;
      isInitialized.value = true;
    }

    return this;
  }

  /// Re-connect with new credentials dynamically
  Future<bool> reconnect({required String url, required String anonKey}) async {
    SupabaseConfig.updateCredentials(url: url, anonKey: anonKey);
    try {
      await Supabase.initialize(
        url: SupabaseConfig.currentUrl,
        // ignore: deprecated_member_use
        anonKey: SupabaseConfig.currentAnonKey,
      );
      _client = Supabase.instance.client;
      isOnline.value = true;
      connectionStatus.value = 'Connected to Supabase (PostgreSQL)';
      errorMessage.value = '';
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      connectionStatus.value = 'Connection failed: $e';
      return false;
    }
  }
}
