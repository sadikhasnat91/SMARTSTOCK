import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/responsive/responsive_layout.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/layouts/app_shell.dart';
import '../../../shared/widgets/badges/app_badge.dart';
import '../../../shared/widgets/buttons/app_button.dart';
import '../../../data/mock/mock_warehouses.dart';

class TransferDetailScreen extends StatelessWidget {
  const TransferDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final trf = (Get.arguments as Map<String, dynamic>?) ?? MockWarehouses.transfers.first;
    final isMobile = ResponsiveLayout.isMobile(context);

    return AppShell(
      breadcrumbs: ['Warehouse', 'Stock Transfers', trf['id'] as String],
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
                AppButton(
                  label: 'Back',
                  variant: AppButtonVariant.outline,
                  prefixIcon: Icons.arrow_back_rounded,
                  onPressed: () => Get.back(),
                ),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    AppButton(
                      label: 'Print Waybill',
                      variant: AppButtonVariant.outline,
                      prefixIcon: Icons.print_rounded,
                      onPressed: () {},
                    ),
                    AppButton(
                      label: 'Confirm Receiving',
                      prefixIcon: Icons.check_circle_outline,
                      onPressed: () {
                        Get.snackbar(
                          'Goods Received',
                          'Transfer ${trf['id']} marked as Received and stocks credited to ${trf['to']}',
                          backgroundColor: AppColors.success,
                          colorText: Colors.white,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 16,
                    runSpacing: 12,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.primarySurface,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.compare_arrows_rounded, size: 28, color: AppColors.primary),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                  spacing: 10,
                                  runSpacing: 4,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Text(trf['id'] as String, style: AppTextStyles.h2),
                                    AppBadge.fromStatus(trf['status'] as String),
                                  ],
                                ),
                                Text(
                                  'Requested by ${trf['requestedBy']} on ${trf['date']}',
                                  style: AppTextStyles.caption,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Estimated Delivery', style: AppTextStyles.caption),
                          Text(trf['expectedDate'] as String, style: AppTextStyles.labelLarge),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(height: 1),
                  const SizedBox(height: 20),
                  if (isMobile) ...[
                    _routeBox('Origin Facility', trf['from'] as String, 'Dhaka Main DC', Icons.outbox_rounded),
                    const SizedBox(height: 10),
                    const Center(child: Icon(Icons.arrow_downward_rounded, color: AppColors.primary)),
                    const SizedBox(height: 10),
                    _routeBox('Destination Facility', trf['to'] as String, 'Regional Distribution Node', Icons.inbox_rounded),
                  ] else
                    Row(
                      children: [
                        Expanded(
                          child: _routeBox('Origin Facility', trf['from'] as String, 'Dhaka Main DC', Icons.outbox_rounded),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Icon(Icons.double_arrow_rounded, color: AppColors.primary),
                        ),
                        Expanded(
                          child: _routeBox('Destination Facility', trf['to'] as String, 'Regional Distribution Node', Icons.inbox_rounded),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text('Manifest Itemized Cargo Lines', style: AppTextStyles.h3),
                  ),
                  const Divider(height: 1),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: SizedBox(
                      width: 780,
                      child: Column(
                        children: [
                          Container(
                            color: AppColors.secondaryBackground,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            child: Row(
                              children: [
                                Expanded(flex: 3, child: Text('Product Item', style: AppTextStyles.labelSmall)),
                                Expanded(flex: 2, child: Text('SKU Code', style: AppTextStyles.labelSmall)),
                                Expanded(flex: 2, child: Text('Quantity Shipped', style: AppTextStyles.labelSmall)),
                                Expanded(flex: 2, child: Text('Unit Value', style: AppTextStyles.labelSmall)),
                                Expanded(flex: 2, child: Text('Verification Status', style: AppTextStyles.labelSmall)),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            child: Row(
                              children: [
                                Expanded(flex: 3, child: Text('USB-C Hub 7-in-1', style: AppTextStyles.labelMedium)),
                                Expanded(flex: 2, child: Text('ELC-0042', style: AppTextStyles.mono)),
                                Expanded(flex: 2, child: Text('${trf['items']} PCS', style: AppTextStyles.bodyMedium)),
                                Expanded(flex: 2, child: Text('\$24.50', style: AppTextStyles.bodyMedium)),
                                Expanded(flex: 2, child: AppBadge(label: 'Packed & Sealed', variant: AppBadgeVariant.success, dot: true)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _routeBox(String role, String hub, String sub, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondaryBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, size: 28, color: AppColors.primary),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(role, style: AppTextStyles.caption),
                Text(hub, style: AppTextStyles.h3, overflow: TextOverflow.ellipsis),
                Text(sub, style: AppTextStyles.caption, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

