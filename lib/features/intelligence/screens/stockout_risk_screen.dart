import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/layouts/app_shell.dart';
import '../../../shared/widgets/badges/app_badge.dart';
import '../../../shared/widgets/buttons/app_button.dart';
import '../../../shared/controllers/intelligence_controller.dart';
import '../../../app/routes/app_routes.dart';

class StockoutRiskScreen extends StatelessWidget {
  const StockoutRiskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final intelCtrl = Get.find<IntelligenceController>();

    return AppShell(
      breadcrumbs: const ['Intelligence', 'Stockout Risk Analysis'],
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
                    Text('Stockout Vulnerability & Stock Depletion Radar', style: AppTextStyles.h1),
                    const SizedBox(height: 4),
                    Text('Monte Carlo stochastic burn-rate modeling calculating exact runaway days before out-of-stock zero state', style: AppTextStyles.bodySmall),
                  ],
                ),
                AppButton(
                  label: 'Generate Emergency Orders',
                  variant: AppButtonVariant.danger,
                  prefixIcon: Icons.warning_amber_rounded,
                  onPressed: () => Get.toNamed(AppRoutes.smartReorder),
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
                  child: Obx(() {
                    final risks = intelCtrl.calculateStockoutRisks();
                    return Column(
                      children: [
                        Container(
                          color: AppColors.secondaryBackground,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          child: Row(
                            children: [
                              Expanded(flex: 2, child: Text('SKU Code', style: AppTextStyles.labelSmall)),
                              Expanded(flex: 3, child: Text('Product Item', style: AppTextStyles.labelSmall)),
                              Expanded(flex: 2, child: Text('On-Hand Physical', style: AppTextStyles.labelSmall)),
                              Expanded(flex: 2, child: Text('Days of Supply', style: AppTextStyles.labelSmall)),
                              Expanded(flex: 2, child: Text('Reorder Point', style: AppTextStyles.labelSmall)),
                              Expanded(flex: 2, child: Text('Risk Assessment', style: AppTextStyles.labelSmall)),
                              const SizedBox(width: 100, child: Text('Action', style: AppTextStyles.labelSmall)),
                            ],
                          ),
                        ),
                        if (risks.isEmpty)
                          Padding(
                            padding: const EdgeInsets.all(32),
                            child: Text('No products currently being tracked.', style: AppTextStyles.bodyMedium),
                          )
                        else
                          ...risks.map((r) {
                            final severity = r['riskLevel'] as String;
                            final isCritical = severity == 'Critical';
                            final isHigh = severity == 'High';
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                              decoration: const BoxDecoration(
                                border: Border(bottom: BorderSide(color: AppColors.divider)),
                              ),
                              child: Row(
                                children: [
                                  Expanded(flex: 2, child: Text(r['sku'] as String, style: AppTextStyles.mono)),
                                  Expanded(flex: 3, child: Text(r['name'] as String, style: AppTextStyles.labelMedium, overflow: TextOverflow.ellipsis)),
                                  Expanded(flex: 2, child: Text('${r['stock']} units', style: AppTextStyles.bodySmall)),
                                  Expanded(flex: 2, child: Text('${r['daysOfSupply']} Days', style: AppTextStyles.labelMedium.copyWith(
                                    color: isCritical ? AppColors.danger : (isHigh ? AppColors.warning : AppColors.success),
                                    fontWeight: FontWeight.w600,
                                  ))),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      '${r['reorderPoint']} units',
                                      style: AppTextStyles.caption,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: AppBadge(
                                      label: '${r['riskScore']}% ($severity)',
                                      variant: isCritical
                                          ? AppBadgeVariant.danger
                                          : (isHigh ? AppBadgeVariant.warning : AppBadgeVariant.success),
                                      dot: true,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: AppButton(
                                      label: 'Reorder',
                                      height: 30,
                                      prefixIcon: Icons.add_shopping_cart_rounded,
                                      onPressed: () {
                                        Get.snackbar('Reorder Queued', 'Triggered replenishment PO for ${r['sku']}');
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
