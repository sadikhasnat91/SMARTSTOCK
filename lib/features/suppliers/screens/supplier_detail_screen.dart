import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/responsive/responsive_layout.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/layouts/app_shell.dart';
import '../../../shared/widgets/badges/app_badge.dart';
import '../../../shared/widgets/buttons/app_button.dart';
import '../../../data/mock/mock_suppliers.dart';
import '../../../app/routes/app_routes.dart';

class SupplierDetailScreen extends StatelessWidget {
  const SupplierDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sup = (Get.arguments as Map<String, dynamic>?) ?? MockSuppliers.suppliers.first;
    final isMobile = ResponsiveLayout.isMobile(context);

    return AppShell(
      breadcrumbs: ['Procurement', 'Suppliers', sup['name'] as String],
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
                      label: 'Analytics',
                      variant: AppButtonVariant.outline,
                      prefixIcon: Icons.insights_rounded,
                      onPressed: () => Get.toNamed(AppRoutes.supplierPerformance),
                    ),
                    AppButton(
                      label: 'Issue PO',
                      prefixIcon: Icons.add_shopping_cart_rounded,
                      onPressed: () => Get.toNamed(AppRoutes.purchaseOrderCreate),
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
              child: isMobile
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: AppColors.primarySurface,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.business_rounded, size: 28, color: AppColors.primary),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(sup['name'] as String, style: AppTextStyles.h2, overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 4),
                                  AppBadge.fromStatus(sup['status'] as String),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text('${sup['category']} Supplier · Based in ${sup['country']} · SLA Lead Time: ${sup['leadTime']}', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                        const SizedBox(height: 4),
                        Text('POC: ${sup['contact']} (${sup['email']} / ${sup['phone']})', style: AppTextStyles.caption),
                        const Divider(height: 24),
                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 12,
                          runSpacing: 4,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.star_rounded, size: 18, color: AppColors.warning),
                                const SizedBox(width: 4),
                                Text('${sup['rating']} / 5.0', style: AppTextStyles.h3),
                              ],
                            ),
                            Text('Vol: ${sup['totalValue']}', style: AppTextStyles.caption),
                          ],
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: AppColors.primarySurface,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.business_rounded, size: 36, color: AppColors.primary),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(sup['name'] as String, style: AppTextStyles.h2),
                                  const SizedBox(width: 12),
                                  AppBadge.fromStatus(sup['status'] as String),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text('${sup['category']} Supplier · Based in ${sup['country']} · SLA Lead Time: ${sup['leadTime']}', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                              const SizedBox(height: 4),
                              Text('POC: ${sup['contact']} (${sup['email']} / ${sup['phone']})', style: AppTextStyles.caption),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Vendor Scorecard', style: AppTextStyles.caption),
                            Row(
                              children: [
                                const Icon(Icons.star_rounded, size: 24, color: AppColors.warning),
                                const SizedBox(width: 4),
                                Text('${sup['rating']} / 5.0', style: AppTextStyles.h1),
                              ],
                            ),
                            Text('Lifetime Volume: ${sup['totalValue']}', style: AppTextStyles.caption),
                          ],
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 24),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  SizedBox(width: 190, child: _kpiTile('Lifetime Orders', '${sup['totalOrders']}', Icons.shopping_bag_outlined, AppColors.primary)),
                  const SizedBox(width: 14),
                  SizedBox(width: 190, child: _kpiTile('On-Time Fulfillment', sup['onTimeDelivery'] as String, Icons.alarm_on_rounded, AppColors.success)),
                  const SizedBox(width: 14),
                  SizedBox(width: 190, child: _kpiTile('Quality Score', sup['qualityScore'] as String, Icons.verified_outlined, AppColors.info)),
                  const SizedBox(width: 14),
                  SizedBox(width: 190, child: _kpiTile('Payment Terms', sup['paymentTerms'] as String, Icons.account_balance_wallet_outlined, AppColors.warning)),
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
                    child: Text('Purchase Order History with Vendor', style: AppTextStyles.h3),
                  ),
                  const Divider(height: 1),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: SizedBox(
                      width: 760,
                      child: Column(
                        children: [
                          Container(
                            color: AppColors.secondaryBackground,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            child: Row(
                              children: [
                                Expanded(flex: 2, child: Text('PO Reference', style: AppTextStyles.labelSmall)),
                                Expanded(flex: 2, child: Text('Order Date', style: AppTextStyles.labelSmall)),
                                Expanded(flex: 2, child: Text('Total Amount', style: AppTextStyles.labelSmall)),
                                Expanded(flex: 2, child: Text('Line Items', style: AppTextStyles.labelSmall)),
                                Expanded(flex: 2, child: Text('Fulfillment Status', style: AppTextStyles.labelSmall)),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            child: Row(
                              children: [
                                Expanded(flex: 2, child: Text('PO-2024-0344', style: AppTextStyles.mono)),
                                Expanded(flex: 2, child: Text('Oct 28, 2026', style: AppTextStyles.bodySmall)),
                                Expanded(flex: 2, child: Text('\$12,800', style: AppTextStyles.labelSmall)),
                                Expanded(flex: 2, child: Text('5 Items', style: AppTextStyles.bodyMedium)),
                                Expanded(flex: 2, child: AppBadge.fromStatus('Received')),
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

  Widget _kpiTile(String label, String val, IconData icon, Color col) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: col.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: col, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                FittedBox(fit: BoxFit.scaleDown, child: Text(val, style: AppTextStyles.h3)),
                Text(label, style: AppTextStyles.caption, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

