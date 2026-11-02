import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:smart_stock/main.dart';
import 'package:smart_stock/app/routes/app_routes.dart';

void main() {
  const phoneSize = Size(390, 844);

  Future<void> testScreenAtPhoneSize(WidgetTester tester, String route) async {
    tester.view.physicalSize = phoneSize;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const SmartStockApp());
    Get.toNamed(route);
    await tester.pumpAndSettle();
  }

  final routesToTest = [
    AppRoutes.login,
    AppRoutes.forgotPassword,
    AppRoutes.resetPassword,
    AppRoutes.executiveDashboard,
    AppRoutes.inventoryDashboard,
    AppRoutes.products,
    AppRoutes.productDetail,
    AppRoutes.productAdd,
    AppRoutes.categories,
    AppRoutes.barcodeManagement,
    AppRoutes.inventoryOverview,
    AppRoutes.stockMovements,
    AppRoutes.stockAdjustment,
    AppRoutes.warehouses,
    AppRoutes.warehouseDetail,
    AppRoutes.warehouseAdd,
    AppRoutes.locations,
    AppRoutes.warehouseOps,
    AppRoutes.transfers,
    AppRoutes.transferCreate,
    AppRoutes.transferDetail,
    AppRoutes.suppliers,
    AppRoutes.supplierAdd,
    AppRoutes.supplierDetail,
    AppRoutes.supplierPerformance,
    AppRoutes.purchaseRequests,
    AppRoutes.purchaseRequestCreate,
    AppRoutes.approvalCenter,
    AppRoutes.purchaseOrders,
    AppRoutes.purchaseOrderCreate,
    AppRoutes.goodsReceiving,
    AppRoutes.customers,
    AppRoutes.customerAdd,
    AppRoutes.salesOrders,
    AppRoutes.salesOrderCreate,
    AppRoutes.reservations,
    AppRoutes.pickingDashboard,
    AppRoutes.packingDashboard,
    AppRoutes.dispatch,
    AppRoutes.returns,
    AppRoutes.intelligenceDashboard,
    AppRoutes.demandForecasting,
    AppRoutes.stockoutRisk,
    AppRoutes.smartReorder,
    AppRoutes.aiAssistant,
    AppRoutes.reportsCenter,
    AppRoutes.auditLogs,
    AppRoutes.userManagement,
    AppRoutes.rolesPermissions,
    AppRoutes.notifications,
    AppRoutes.profile,
    AppRoutes.settings,
  ];

  for (final r in routesToTest) {
    testWidgets('Test $r on phone', (tester) async {
      await testScreenAtPhoneSize(tester, r);
    });
  }
}
