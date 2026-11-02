import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/layouts/app_shell.dart';
import '../../../shared/widgets/badges/app_badge.dart';
import '../../../shared/widgets/buttons/app_button.dart';
import '../../../app/routes/app_routes.dart';

class PackingDashboardScreen extends StatelessWidget {
  const PackingDashboardScreen({super.key});

  final _packStations = const [
    {'station': 'Packing Bay 01', 'operator': 'Sarah K.', 'currentOrder': 'SO-2024-0891', 'carton': 'Box Medium (30x20x15cm)', 'weight': '1.45 kg', 'status': 'Sealing'},
    {'station': 'Packing Bay 02', 'operator': 'Mike T.', 'currentOrder': 'SO-2024-0888', 'carton': 'Pallet Skid #04', 'weight': '185.0 kg', 'status': 'Weighing'},
    {'station': 'Packing Bay 03', 'operator': 'Lisa M.', 'currentOrder': 'SO-2024-0890', 'carton': 'Box Small (15x15x10cm)', 'weight': '0.80 kg', 'status': 'Labeling'},
  ];

  @override
  Widget build(BuildContext context) {
    return AppShell(
      breadcrumbs: const ['Fulfillment', 'Packing Station'],
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
                    Text('Packing Bench & Weight Verification', style: AppTextStyles.h1),
                    const SizedBox(height: 4),
                    Text('Package boxing, void fill check, gross weight verification, and shipping label generation', style: AppTextStyles.bodySmall),
                  ],
                ),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    AppButton(
                      label: 'Dispatch Dock',
                      variant: AppButtonVariant.outline,
                      prefixIcon: Icons.local_shipping_outlined,
                      onPressed: () => Get.toNamed(AppRoutes.dispatch),
                    ),
                    AppButton(
                      label: 'Print Shipping Label',
                      prefixIcon: Icons.print_rounded,
                      onPressed: () {
                        Get.snackbar('Shipping Label Printed', 'Generated FedEx 4x6 label for SO-2024-0891');
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
                width: 860,
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
                            Expanded(flex: 2, child: Text('Packing Bay', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Bench Operator', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Current Order', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 3, child: Text('Carton Packaging Type', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Scale Weight', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Workflow Step', style: AppTextStyles.labelSmall)),
                            const SizedBox(width: 100, child: Text('Action', style: AppTextStyles.labelSmall)),
                          ],
                        ),
                      ),
                      ..._packStations.map((p) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide(color: AppColors.divider)),
                            ),
                            child: Row(
                              children: [
                                Expanded(flex: 2, child: Text(p['station'] as String, style: AppTextStyles.labelLarge)),
                                Expanded(flex: 2, child: Text(p['operator'] as String, style: AppTextStyles.bodySmall)),
                                Expanded(flex: 2, child: Text(p['currentOrder'] as String, style: AppTextStyles.mono)),
                                Expanded(flex: 3, child: Text(p['carton'] as String, style: AppTextStyles.bodySmall)),
                                Expanded(flex: 2, child: Text(p['weight'] as String, style: AppTextStyles.labelSmall)),
                                Expanded(flex: 2, child: AppBadge.fromStatus(p['status'] as String)),
                                SizedBox(
                                  width: 100,
                                  child: AppButton(
                                    label: 'Pass & Tape',
                                    height: 30,
                                    onPressed: () {
                                      Get.snackbar('Carton Sealed', 'Carton dispatched to conveyor sorting lane.');
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

