import 'package:get/get.dart';
import '../../core/services/supabase_service.dart';
import '../../data/repositories/product_repository.dart';
import '../../data/repositories/warehouse_repository.dart';
import '../../data/repositories/supplier_repository.dart';
import '../../data/repositories/order_repository.dart';
import '../../data/repositories/transfer_repository.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/audit_repository.dart';
import '../../shared/controllers/sidebar_controller.dart';
import '../../shared/controllers/auth_controller.dart';
import '../../shared/controllers/product_controller.dart';
import '../../shared/controllers/warehouse_controller.dart';
import '../../shared/controllers/supplier_controller.dart';
import '../../shared/controllers/order_controller.dart';
import '../../shared/controllers/transfer_controller.dart';
import '../../shared/controllers/dashboard_controller.dart';
import '../../shared/controllers/intelligence_controller.dart';
import '../../shared/controllers/settings_controller.dart';

/// Centralized GetX Dependency Injection setup.
/// Injects services, repositories, and controllers for all application modules.
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // 1. Core Services
    final supabaseService = Get.isRegistered<SupabaseService>()
        ? Get.find<SupabaseService>()
        : Get.put(SupabaseService(), permanent: true);

    // 2. Repositories
    final productRepo = Get.put(ProductRepository(supabaseService), permanent: true);
    final warehouseRepo = Get.put(WarehouseRepository(supabaseService), permanent: true);
    final supplierRepo = Get.put(SupplierRepository(supabaseService), permanent: true);
    final orderRepo = Get.put(OrderRepository(supabaseService), permanent: true);
    final transferRepo = Get.put(TransferRepository(supabaseService), permanent: true);
    final authRepo = Get.put(AuthRepository(supabaseService), permanent: true);
    Get.put(AuditRepository(supabaseService), permanent: true);

    // 3. Controllers
    Get.put(SidebarController(), permanent: true);
    Get.put(AuthController(authRepo), permanent: true);
    final prodCtrl = Get.put(ProductController(productRepo), permanent: true);
    final whCtrl = Get.put(WarehouseController(warehouseRepo), permanent: true);
    final supCtrl = Get.put(SupplierController(supplierRepo), permanent: true);
    final ordCtrl = Get.put(OrderController(orderRepo), permanent: true);
    Get.put(TransferController(transferRepo), permanent: true);

    Get.put(DashboardController(
      productController: prodCtrl,
      orderController: ordCtrl,
      warehouseController: whCtrl,
      supplierController: supCtrl,
    ), permanent: true);

    Get.put(IntelligenceController(
      productController: prodCtrl,
      orderController: ordCtrl,
      warehouseController: whCtrl,
    ), permanent: true);

    Get.put(SettingsController(supabaseService), permanent: true);
  }
}
