abstract class AppRoutes {
  // Auth
  static const login = '/login';
  static const forgotPassword = '/forgot-password';
  static const resetPassword = '/reset-password';

  // Dashboard
  static const executiveDashboard = '/dashboard/executive';
  static const inventoryDashboard = '/dashboard/inventory';

  // Inventory
  static const products = '/inventory/products';
  static const productAdd = '/inventory/products/add';
  static const productEdit = '/inventory/products/edit';
  static const productDetail = '/inventory/products/detail';
  static const categories = '/inventory/categories';
  static const categoryAdd = '/inventory/categories/add';
  static const barcodeManagement = '/inventory/barcodes';
  static const inventoryOverview = '/inventory/overview';
  static const stockMovements = '/inventory/stock-movements';
  static const stockAdjustment = '/inventory/stock-adjustment';

  // Warehouse
  static const warehouses = '/warehouse/list';
  static const warehouseAdd = '/warehouse/add';
  static const warehouseDetail = '/warehouse/detail';
  static const warehouseOverview = '/warehouse/overview';
  static const locations = '/warehouse/locations';
  static const warehouseOps = '/warehouse/operations';

  // Transfers
  static const transfers = '/transfers/list';
  static const transferCreate = '/transfers/create';
  static const transferDetail = '/transfers/detail';

  // Procurement
  static const suppliers = '/procurement/suppliers';
  static const supplierAdd = '/procurement/suppliers/add';
  static const supplierDetail = '/procurement/suppliers/detail';
  static const supplierPerformance = '/procurement/suppliers/performance';
  static const purchaseRequests = '/procurement/purchase-requests';
  static const purchaseRequestCreate = '/procurement/purchase-requests/create';
  static const purchaseRequestDetail = '/procurement/purchase-requests/detail';
  static const approvalCenter = '/procurement/approvals';
  static const purchaseOrders = '/procurement/purchase-orders';
  static const purchaseOrderCreate = '/procurement/purchase-orders/create';
  static const purchaseOrderDetail = '/procurement/purchase-orders/detail';
  static const goodsReceiving = '/procurement/goods-receiving';
  static const qualityInspection = '/procurement/quality-inspection';

  // Sales
  static const customers = '/sales/customers';
  static const customerAdd = '/sales/customers/add';
  static const customerDetail = '/sales/customers/detail';
  static const salesOrders = '/sales/orders';
  static const salesOrderCreate = '/sales/orders/create';
  static const salesOrderDetail = '/sales/orders/detail';
  static const reservations = '/sales/reservations';

  // Fulfillment
  static const pickingDashboard = '/fulfillment/picking';
  static const pickingDetail = '/fulfillment/picking/detail';
  static const packingDashboard = '/fulfillment/packing';
  static const packingDetail = '/fulfillment/packing/detail';
  static const dispatch = '/fulfillment/dispatch';
  static const deliveryTracking = '/fulfillment/tracking';
  static const returns = '/fulfillment/returns';
  static const returnDetail = '/fulfillment/returns/detail';

  // Intelligence
  static const intelligenceDashboard = '/intelligence/dashboard';
  static const demandForecasting = '/intelligence/forecasting';
  static const stockoutRisk = '/intelligence/stockout-risk';
  static const smartReorder = '/intelligence/smart-reorder';
  static const supplierIntelligence = '/intelligence/supplier';
  static const aiAssistant = '/intelligence/ai-assistant';

  // Reports
  static const reportsCenter = '/reports/center';
  static const inventoryReports = '/reports/inventory';
  static const salesReports = '/reports/sales';
  static const procurementReports = '/reports/procurement';
  static const warehouseReports = '/reports/warehouse';
  static const stockMovementReports = '/reports/stock-movements';
  static const auditLogs = '/reports/audit-logs';

  // Administration
  static const userManagement = '/admin/users';
  static const userAdd = '/admin/users/add';
  static const userDetail = '/admin/users/detail';
  static const rolesPermissions = '/admin/roles';
  static const notifications = '/admin/notifications';
  static const notificationPrefs = '/admin/notifications/preferences';
  static const profile = '/admin/profile';
  static const settings = '/admin/settings';
  static const offlineSync = '/admin/offline-sync';
}

