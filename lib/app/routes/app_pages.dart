import 'package:get/get.dart';
import 'app_routes.dart';

// Authentication
import '../../features/authentication/screens/login_screen.dart';
import '../../features/authentication/screens/forgot_password_screen.dart';
import '../../features/authentication/screens/reset_password_screen.dart';

// Dashboards
import '../../features/dashboard/screens/executive_dashboard_screen.dart';
import '../../features/dashboard/screens/inventory_dashboard_screen.dart';

// Inventory
import '../../features/inventory/screens/product_list_screen.dart';
import '../../features/inventory/screens/product_detail_screen.dart';
import '../../features/inventory/screens/add_product_screen.dart';
import '../../features/inventory/screens/categories_screen.dart';
import '../../features/inventory/screens/barcode_management_screen.dart';
import '../../features/inventory/screens/inventory_overview_screen.dart';
import '../../features/inventory/screens/stock_movements_screen.dart';
import '../../features/inventory/screens/stock_adjustment_screen.dart';

// Warehouse
import '../../features/warehouse/screens/warehouse_list_screen.dart';
import '../../features/warehouse/screens/warehouse_detail_screen.dart';
import '../../features/warehouse/screens/add_warehouse_screen.dart';
import '../../features/warehouse/screens/locations_screen.dart';
import '../../features/warehouse/screens/warehouse_operations_screen.dart';

// Transfers
import '../../features/transfers/screens/transfer_list_screen.dart';
import '../../features/transfers/screens/create_transfer_screen.dart';
import '../../features/transfers/screens/transfer_detail_screen.dart';

// Procurement
import '../../features/suppliers/screens/supplier_list_screen.dart';
import '../../features/suppliers/screens/add_supplier_screen.dart';
import '../../features/suppliers/screens/supplier_detail_screen.dart';
import '../../features/suppliers/screens/supplier_performance_screen.dart';
import '../../features/procurement/screens/purchase_requests_screen.dart';
import '../../features/procurement/screens/create_purchase_request_screen.dart';
import '../../features/procurement/screens/approval_center_screen.dart';
import '../../features/procurement/screens/purchase_orders_screen.dart';
import '../../features/procurement/screens/create_purchase_order_screen.dart';
import '../../features/procurement/screens/goods_receiving_screen.dart';

// Sales
import '../../features/sales/screens/customer_list_screen.dart';
import '../../features/sales/screens/add_customer_screen.dart';
import '../../features/sales/screens/sales_orders_screen.dart';
import '../../features/sales/screens/create_sales_order_screen.dart';
import '../../features/sales/screens/reservations_screen.dart';

// Fulfillment
import '../../features/fulfillment/screens/picking_dashboard_screen.dart';
import '../../features/fulfillment/screens/packing_dashboard_screen.dart';
import '../../features/fulfillment/screens/dispatch_management_screen.dart';
import '../../features/fulfillment/screens/returns_management_screen.dart';

// Intelligence
import '../../features/intelligence/screens/intelligence_dashboard_screen.dart';
import '../../features/intelligence/screens/demand_forecasting_screen.dart';
import '../../features/intelligence/screens/stockout_risk_screen.dart';
import '../../features/intelligence/screens/smart_reorder_screen.dart';
import '../../features/intelligence/screens/ai_assistant_screen.dart';

// Reports
import '../../features/reports/screens/reports_center_screen.dart';
import '../../features/reports/screens/audit_logs_screen.dart';

// Administration
import '../../features/administration/screens/user_management_screen.dart';
import '../../features/administration/screens/roles_permissions_screen.dart';
import '../../features/administration/screens/notifications_screen.dart';
import '../../features/administration/screens/profile_screen.dart';
import '../../features/administration/screens/settings_screen.dart';

class AppPages {
  AppPages._();

  static const initial = AppRoutes.login;

  static final routes = [
    // Auth
    GetPage(name: AppRoutes.login, page: () => const LoginScreen()),
    GetPage(name: AppRoutes.forgotPassword, page: () => const ForgotPasswordScreen()),
    GetPage(name: AppRoutes.resetPassword, page: () => const ResetPasswordScreen()),

    // Dashboards
    GetPage(name: AppRoutes.executiveDashboard, page: () => const ExecutiveDashboardScreen()),
    GetPage(name: AppRoutes.inventoryDashboard, page: () => const InventoryDashboardScreen()),

    // Inventory
    GetPage(name: AppRoutes.products, page: () => const ProductListScreen()),
    GetPage(name: AppRoutes.productAdd, page: () => const AddProductScreen()),
    GetPage(name: AppRoutes.productEdit, page: () => const AddProductScreen()),
    GetPage(name: AppRoutes.productDetail, page: () => const ProductDetailScreen()),
    GetPage(name: AppRoutes.categories, page: () => const CategoriesScreen()),
    GetPage(name: AppRoutes.categoryAdd, page: () => const CategoriesScreen()),
    GetPage(name: AppRoutes.barcodeManagement, page: () => const BarcodeManagementScreen()),
    GetPage(name: AppRoutes.inventoryOverview, page: () => const InventoryOverviewScreen()),
    GetPage(name: AppRoutes.stockMovements, page: () => const StockMovementsScreen()),
    GetPage(name: AppRoutes.stockAdjustment, page: () => const StockAdjustmentScreen()),

    // Warehouse
    GetPage(name: AppRoutes.warehouses, page: () => const WarehouseListScreen()),
    GetPage(name: AppRoutes.warehouseAdd, page: () => const AddWarehouseScreen()),
    GetPage(name: AppRoutes.warehouseDetail, page: () => const WarehouseDetailScreen()),
    GetPage(name: AppRoutes.warehouseOverview, page: () => const WarehouseListScreen()),
    GetPage(name: AppRoutes.locations, page: () => const LocationsScreen()),
    GetPage(name: AppRoutes.warehouseOps, page: () => const WarehouseOperationsScreen()),

    // Transfers
    GetPage(name: AppRoutes.transfers, page: () => const TransferListScreen()),
    GetPage(name: AppRoutes.transferCreate, page: () => const CreateTransferScreen()),
    GetPage(name: AppRoutes.transferDetail, page: () => const TransferDetailScreen()),

    // Procurement
    GetPage(name: AppRoutes.suppliers, page: () => const SupplierListScreen()),
    GetPage(name: AppRoutes.supplierAdd, page: () => const AddSupplierScreen()),
    GetPage(name: AppRoutes.supplierDetail, page: () => const SupplierDetailScreen()),
    GetPage(name: AppRoutes.supplierPerformance, page: () => const SupplierPerformanceScreen()),
    GetPage(name: AppRoutes.purchaseRequests, page: () => const PurchaseRequestsScreen()),
    GetPage(name: AppRoutes.purchaseRequestCreate, page: () => const CreatePurchaseRequestScreen()),
    GetPage(name: AppRoutes.purchaseRequestDetail, page: () => const PurchaseRequestsScreen()),
    GetPage(name: AppRoutes.approvalCenter, page: () => const ApprovalCenterScreen()),
    GetPage(name: AppRoutes.purchaseOrders, page: () => const PurchaseOrdersScreen()),
    GetPage(name: AppRoutes.purchaseOrderCreate, page: () => const CreatePurchaseOrderScreen()),
    GetPage(name: AppRoutes.purchaseOrderDetail, page: () => const PurchaseOrdersScreen()),
    GetPage(name: AppRoutes.goodsReceiving, page: () => const GoodsReceivingScreen()),
    GetPage(name: AppRoutes.qualityInspection, page: () => const GoodsReceivingScreen()),

    // Sales
    GetPage(name: AppRoutes.customers, page: () => const CustomerListScreen()),
    GetPage(name: AppRoutes.customerAdd, page: () => const AddCustomerScreen()),
    GetPage(name: AppRoutes.customerDetail, page: () => const CustomerListScreen()),
    GetPage(name: AppRoutes.salesOrders, page: () => const SalesOrdersScreen()),
    GetPage(name: AppRoutes.salesOrderCreate, page: () => const CreateSalesOrderScreen()),
    GetPage(name: AppRoutes.salesOrderDetail, page: () => const SalesOrdersScreen()),
    GetPage(name: AppRoutes.reservations, page: () => const ReservationsScreen()),

    // Fulfillment
    GetPage(name: AppRoutes.pickingDashboard, page: () => const PickingDashboardScreen()),
    GetPage(name: AppRoutes.pickingDetail, page: () => const PickingDashboardScreen()),
    GetPage(name: AppRoutes.packingDashboard, page: () => const PackingDashboardScreen()),
    GetPage(name: AppRoutes.packingDetail, page: () => const PackingDashboardScreen()),
    GetPage(name: AppRoutes.dispatch, page: () => const DispatchManagementScreen()),
    GetPage(name: AppRoutes.deliveryTracking, page: () => const DispatchManagementScreen()),
    GetPage(name: AppRoutes.returns, page: () => const ReturnsManagementScreen()),
    GetPage(name: AppRoutes.returnDetail, page: () => const ReturnsManagementScreen()),

    // Intelligence
    GetPage(name: AppRoutes.intelligenceDashboard, page: () => const IntelligenceDashboardScreen()),
    GetPage(name: AppRoutes.demandForecasting, page: () => const DemandForecastingScreen()),
    GetPage(name: AppRoutes.stockoutRisk, page: () => const StockoutRiskScreen()),
    GetPage(name: AppRoutes.smartReorder, page: () => const SmartReorderScreen()),
    GetPage(name: AppRoutes.supplierIntelligence, page: () => const SupplierPerformanceScreen()),
    GetPage(name: AppRoutes.aiAssistant, page: () => const AiAssistantScreen()),

    // Reports
    GetPage(name: AppRoutes.reportsCenter, page: () => const ReportsCenterScreen()),
    GetPage(name: AppRoutes.inventoryReports, page: () => const ReportsCenterScreen()),
    GetPage(name: AppRoutes.salesReports, page: () => const ReportsCenterScreen()),
    GetPage(name: AppRoutes.procurementReports, page: () => const ReportsCenterScreen()),
    GetPage(name: AppRoutes.warehouseReports, page: () => const ReportsCenterScreen()),
    GetPage(name: AppRoutes.stockMovementReports, page: () => const StockMovementsScreen()),
    GetPage(name: AppRoutes.auditLogs, page: () => const AuditLogsScreen()),

    // Administration
    GetPage(name: AppRoutes.userManagement, page: () => const UserManagementScreen()),
    GetPage(name: AppRoutes.userAdd, page: () => const UserManagementScreen()),
    GetPage(name: AppRoutes.userDetail, page: () => const UserManagementScreen()),
    GetPage(name: AppRoutes.rolesPermissions, page: () => const RolesPermissionsScreen()),
    GetPage(name: AppRoutes.notifications, page: () => const NotificationsScreen()),
    GetPage(name: AppRoutes.notificationPrefs, page: () => const NotificationsScreen()),
    GetPage(name: AppRoutes.profile, page: () => const ProfileScreen()),
    GetPage(name: AppRoutes.settings, page: () => const SettingsScreen()),
    GetPage(name: AppRoutes.offlineSync, page: () => const SettingsScreen()),
  ];
}

