import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/layouts/app_shell.dart';
import '../../../shared/widgets/badges/app_badge.dart';
import '../../../shared/widgets/buttons/app_button.dart';
import '../../../app/routes/app_routes.dart';

class StockoutRiskScreen extends StatelessWidget {
  const StockoutRiskScreen({super.key});

  final _risks = const [
    {'sku': 'ELC-0042', 'name': 'USB-C Hub 7-in-1', 'stock': '4 units', 'burnRate': '1.8 / day', 'daysLeft': '2.2 Days', 'riskScore': '98% Stockout Prob', 'severity': 'Critical'},
    {'sku': 'PKG-0033', 'name': 'Bubble Wrap Roll 50m', 'stock': '3 rolls', 'burnRate': '1.2 / day', 'daysLeft': '2.5 Days', 'riskScore': '94% Stockout Prob', 'severity': 'Critical'},
    {'sku': 'TLS-0009', 'name': 'Precision Screwdriver Set', 'stock': '2 sets', 'burnRate': '0.5 / day', 'daysLeft': '4.0 Days', 'riskScore': '89% Stockout Prob', 'severity': 'Critical'},
    {'sku': 'ELC-0071', 'name': 'Wireless Keyboard MX', 'stock': '6 units', 'burnRate': '1.1 / day', 'daysLeft': '5.5 Days', 'riskScore': '76% Stockout Prob', 'severity': 'High'},
    {'sku': 'OFF-0118', 'name': 'Premium A4 Paper Ream', 'stock': '12 reams', 'burnRate': '1.8 / day', 'daysLeft': '6.6 Days', 'riskScore': '68% Stockout Prob', 'severity': 'High'},
  ];

  @override
  Widget build(BuildContext context) {
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
                  child: Column(
                    children: [
                      Container(
                        color: AppColors.secondaryBackground,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        child: Row(
                          children: [
                            Expanded(flex: 2, child: Text('SKU Code', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 3, child: Text('Product Item', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('On-Hand Physical', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Daily Burn Rate', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Days Until Zero', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Stockout Risk', style: AppTextStyles.labelSmall)),
                            const SizedBox(width: 100, child: Text('Action', style: AppTextStyles.labelSmall)),
                          ],
                        ),
                      ),
                      ..._risks.map((r) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide(color: AppColors.divider)),
                            ),
                            child: Row(
                              children: [
                                Expanded(flex: 2, child: Text(r['sku'] as String, style: AppTextStyles.mono)),
                                Expanded(flex: 3, child: Text(r['name'] as String, style: AppTextStyles.labelMedium)),
                                Expanded(flex: 2, child: Text(r['stock'] as String, style: AppTextStyles.bodySmall)),
                                Expanded(flex: 2, child: Text(r['burnRate'] as String, style: AppTextStyles.caption)),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    r['daysLeft'] as String,
                                    style: AppTextStyles.labelLarge.copyWith(
                                      color: r['severity'] == 'Critical' ? AppColors.danger : AppColors.warning,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: AppBadge(
                                    label: r['riskScore'] as String,
                                    variant: r['severity'] == 'Critical' ? AppBadgeVariant.danger : AppBadgeVariant.warning,
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

