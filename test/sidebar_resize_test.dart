import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:smart_stock/main.dart';
import 'package:smart_stock/app/routes/app_routes.dart';
import 'package:smart_stock/shared/controllers/sidebar_controller.dart';

void main() {
  testWidgets('Sidebar can be dragged to extend and shrink on desktop', (tester) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const SmartStockApp());
    Get.toNamed(AppRoutes.executiveDashboard);
    await tester.pumpAndSettle();

    final controller = Get.find<SidebarController>();
    expect(controller.sidebarWidth.value, equals(250.0));
    expect(controller.isCollapsed.value, isFalse);

    // Find the drag handle by Tooltip message
    final handleFinder = find.byTooltip('Drag to resize sidebar • Double-click to toggle');
    expect(handleFinder, findsOneWidget);

    // 1. Drag to extend right
    await tester.drag(handleFinder, const Offset(100, 0));
    await tester.pumpAndSettle();
    expect(controller.sidebarWidth.value, greaterThan(250.0));
    final extendedWidth = controller.sidebarWidth.value;

    // 2. Drag to shrink left
    await tester.drag(handleFinder, const Offset(-100, 0));
    await tester.pumpAndSettle();
    expect(controller.sidebarWidth.value, lessThan(extendedWidth));

    // 3. Drag past threshold to snap collapse (< 120 -> snaps to 64px)
    await tester.drag(handleFinder, const Offset(-200, 0));
    await tester.pumpAndSettle();
    expect(controller.sidebarWidth.value, equals(64.0));
    expect(controller.isCollapsed.value, isTrue);

    // 4. Drag right while collapsed to restore/expand
    await tester.drag(handleFinder, const Offset(80, 0));
    await tester.pumpAndSettle();
    expect(controller.sidebarWidth.value, greaterThanOrEqualTo(180.0));
    expect(controller.isCollapsed.value, isFalse);

    // 5. Double tap to toggle collapse
    await tester.tap(handleFinder);
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(handleFinder);
    await tester.pumpAndSettle();
    expect(controller.isCollapsed.value, isTrue);
  });
}
