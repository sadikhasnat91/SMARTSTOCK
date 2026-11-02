import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/layouts/app_shell.dart';
import '../../../shared/widgets/badges/app_badge.dart';
import '../../../shared/widgets/buttons/app_button.dart';
import '../../../data/mock/mock_orders.dart';
import '../../../app/routes/app_routes.dart';

class PickingDashboardScreen extends StatelessWidget {
  const PickingDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShell(
      breadcrumbs: const ['Fulfillment', 'Picking Waves'],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.contentPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Warehouse Pick Wave Dispatch', style: AppTextStyles.h1),
                    const SizedBox(height: 4),
                    Text('Direct pickers through optimized shortest-path aisle routes with RF barcode verification', style: AppTextStyles.bodySmall),
                  ],
                ),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    AppButton(
                      label: 'Packing Station',
                      variant: AppButtonVariant.outline,
                      prefixIcon: Icons.inventory_2_rounded,
                      onPressed: () => Get.toNamed(AppRoutes.packingDashboard),
                    ),
                    AppButton(
                      label: 'Generate Pick Wave',
                      prefixIcon: Icons.playlist_add_check_rounded,
                      onPressed: () {
                        Get.snackbar('Pick Wave Created', 'Wave #W-082 created with 16 order lines.');
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: SizedBox(
                width: 880,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      Container(
                        color: AppColors.secondaryBackground,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        child: Row(
                          children: [
                            Expanded(flex: 2, child: Text('Pick Task ID', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Order Ref', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 3, child: Text('Customer', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Items Progress', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Assigned Picker', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Due Time', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Status', style: AppTextStyles.labelSmall)),
                            const SizedBox(width: 100, child: Text('Action', style: AppTextStyles.labelSmall)),
                          ],
                        ),
                      ),
                      ...MockOrders.pickingTasks.map((t) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide(color: AppColors.divider)),
                            ),
                            child: Row(
                              children: [
                                Expanded(flex: 2, child: Text(t['id'] as String, style: AppTextStyles.mono)),
                                Expanded(flex: 2, child: Text(t['orderId'] as String, style: AppTextStyles.mono)),
                                Expanded(flex: 3, child: Text(t['customer'] as String, style: AppTextStyles.labelMedium)),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    '${t['pickedItems']} / ${t['items']} picked',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: t['pickedItems'] == t['items'] ? AppColors.success : AppColors.warning,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Expanded(flex: 2, child: Text(t['assignedTo'] as String, style: AppTextStyles.bodySmall)),
                                Expanded(flex: 2, child: Text(t['dueTime'] as String, style: AppTextStyles.caption)),
                                Expanded(flex: 2, child: AppBadge.fromStatus(t['status'] as String)),
                                SizedBox(
                                  width: 100,
                                  child: AppButton(
                                    label: 'Scan Pick',
                                    height: 30,
                                    prefixIcon: Icons.qr_code_scanner_rounded,
                                    onPressed: () {
                                      Get.snackbar('Item Verified', 'SKU scanned and confirmed into tote #T-14');
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

