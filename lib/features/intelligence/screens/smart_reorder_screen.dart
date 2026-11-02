import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/layouts/app_shell.dart';
import '../../../shared/widgets/badges/app_badge.dart';
import '../../../shared/widgets/buttons/app_button.dart';

class SmartReorderScreen extends StatelessWidget {
  const SmartReorderScreen({super.key});

  final _suggestions = const [
    {'sku': 'ELC-0042', 'name': 'USB-C Hub 7-in-1', 'vendor': 'TechPro Ltd', 'suggestedQty': '120 PCS', 'cost': '\$2,940', 'leadTime': '7 days', 'economicSavings': '12% EOQ Discount'},
    {'sku': 'PKG-0033', 'name': 'Bubble Wrap Roll 50m', 'vendor': 'SafePack Industries', 'suggestedQty': '50 ROLLS', 'cost': '\$600', 'leadTime': '3 days', 'economicSavings': 'Free Freight Tier'},
    {'sku': 'TLS-0009', 'name': 'Precision Screwdriver Set', 'vendor': 'ToolMaster Corp', 'suggestedQty': '40 SETS', 'cost': '\$720', 'leadTime': '5 days', 'economicSavings': 'Standard Order'},
    {'sku': 'ELC-0071', 'name': 'Wireless Keyboard MX', 'vendor': 'TechPro Ltd', 'suggestedQty': '60 PCS', 'cost': '\$2,880', 'leadTime': '7 days', 'economicSavings': 'Combined Shipping'},
  ];

  @override
  Widget build(BuildContext context) {
    return AppShell(
      breadcrumbs: const ['Intelligence', 'Autonomous Smart Reorder'],
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
                    Text('Automated Replenishment & EOQ Optimizer', style: AppTextStyles.h1),
                    const SizedBox(height: 4),
                    Text('Economic Order Quantity (EOQ) algorithms bundle purchase requisitions by vendor to maximize freight efficiency', style: AppTextStyles.bodySmall),
                  ],
                ),
                AppButton(
                  label: 'Approve & Issue POs',
                  prefixIcon: Icons.bolt_rounded,
                  onPressed: () {
                    Get.snackbar(
                      'Automated Procurement Executed',
                      '4 Purchase Orders generated and dispatched to corresponding vendor portals.',
                      backgroundColor: AppColors.success,
                      colorText: Colors.white,
                    );
                  },
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
                            Expanded(flex: 3, child: Text('Contracted Vendor', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Suggested EOQ', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('PO Commitment', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Algorithmic Benefit', style: AppTextStyles.labelSmall)),
                            const SizedBox(width: 100, child: Text('Action', style: AppTextStyles.labelSmall)),
                          ],
                        ),
                      ),
                      ..._suggestions.map((s) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide(color: AppColors.divider)),
                            ),
                            child: Row(
                              children: [
                                Expanded(flex: 2, child: Text(s['sku'] as String, style: AppTextStyles.mono)),
                                Expanded(flex: 3, child: Text(s['name'] as String, style: AppTextStyles.labelMedium)),
                                Expanded(flex: 3, child: Text(s['vendor'] as String, style: AppTextStyles.bodyMedium)),
                                Expanded(flex: 2, child: Text(s['suggestedQty'] as String, style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary))),
                                Expanded(flex: 2, child: Text(s['cost'] as String, style: AppTextStyles.bodyMedium)),
                                Expanded(flex: 2, child: AppBadge(label: s['economicSavings'] as String, variant: AppBadgeVariant.success)),
                                SizedBox(
                                  width: 100,
                                  child: AppButton(
                                    label: 'Approve',
                                    height: 30,
                                    onPressed: () {
                                      Get.snackbar('PO Created', 'Purchase Order generated for ${s['vendor']}');
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

