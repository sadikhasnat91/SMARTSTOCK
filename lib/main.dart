import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/theme/app_theme.dart';
import 'core/config/env_config.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/bindings/initial_binding.dart';
import 'core/services/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Load environment variables (.env / dart-define)
  await EnvConfig.load();
  final supabaseService = Get.put(SupabaseService(), permanent: true);
  await supabaseService.init();
  InitialBinding().dependencies();
  runApp(const SmartStockApp());
}

class SmartStockApp extends StatelessWidget {
  const SmartStockApp({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<SupabaseService>()) {
      InitialBinding().dependencies();
    }

    return GetMaterialApp(
      title: 'SmartStock — Intelligent Inventory & Supply Chain',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialBinding: InitialBinding(),
      initialRoute: AppRoutes.login,
      getPages: AppPages.routes,
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 150),
    );
  }
}
