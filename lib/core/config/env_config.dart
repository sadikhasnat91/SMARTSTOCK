import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/foundation.dart';

/// Central Environment loader for SmartStock.
/// Reads `.env` from app assets or fallbacks to --dart-define environment flags.
class EnvConfig {
  static String supabaseUrl = '';
  static String supabaseAnonKey = '';
  static String geminiApiKey = '';

  static Future<void> load() async {
    // 1. First, check dart-define compile-time environment flags
    supabaseUrl = const String.fromEnvironment('SUPABASE_URL', defaultValue: '');
    supabaseAnonKey = const String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: '');
    geminiApiKey = const String.fromEnvironment('GEMINI_API_KEY', defaultValue: '');

    // 2. If not defined via dart-define, attempt to read root .env asset
    try {
      final envString = await rootBundle.loadString('.env');
      final lines = envString.split('\n');
      for (var line in lines) {
        line = line.trim();
        if (line.isEmpty || line.startsWith('#')) continue;
        final eqIdx = line.indexOf('=');
        if (eqIdx != -1) {
          final key = line.substring(0, eqIdx).trim();
          final val = line.substring(eqIdx + 1).trim();
          if (key == 'SUPABASE_URL' && supabaseUrl.isEmpty) {
            supabaseUrl = val;
          } else if (key == 'SUPABASE_ANON_KEY' && supabaseAnonKey.isEmpty) {
            supabaseAnonKey = val;
          } else if (key == 'GEMINI_API_KEY' && geminiApiKey.isEmpty) {
            geminiApiKey = val;
          }
        }
      }
      debugPrint('[EnvConfig] Successfully loaded configuration from .env asset');
    } catch (e) {
      debugPrint('[EnvConfig] Note: .env asset not found or unreadable: $e');
    }
  }
}
