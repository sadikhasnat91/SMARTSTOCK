import 'env_config.dart';

/// Supabase Configuration for SmartStock
/// Uses EnvConfig to dynamically obtain keys from .env or dart-define.
class SupabaseConfig {
  static String get currentUrl => EnvConfig.supabaseUrl;
  static String get currentAnonKey => EnvConfig.supabaseAnonKey;

  /// Returns true if valid real-world Supabase credentials have been configured
  static bool get isConfigured {
    return currentUrl.isNotEmpty &&
        currentAnonKey.isNotEmpty &&
        !currentUrl.contains('demo-smartstock') &&
        currentUrl.startsWith('https://');
  }

  /// Update credentials dynamically at runtime (e.g. from Settings screen)
  static void updateCredentials({required String url, required String anonKey}) {
    EnvConfig.supabaseUrl = url.trim();
    EnvConfig.supabaseAnonKey = anonKey.trim();
  }
}
