import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/layouts/app_shell.dart';
import '../../../shared/widgets/badges/app_badge.dart';
import '../../../shared/widgets/buttons/app_button.dart';
import '../../../shared/controllers/intelligence_controller.dart';

class SmartReorderScreen extends StatelessWidget {
  const SmartReorderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final intelCtrl = Get.find<IntelligenceController>();

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
                      'Purchase Orders generated and dispatched to corresponding vendor portals.',
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
                  child: Obx(() {
                    final items = intelCtrl.getSmartReorderList();
                    return Column(
                      children: [
                        Container(
                          color: AppColors.secondaryBackground,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          child: Row(
                            children: [
                              Expanded(flex: 2, child: Text('SKU Code', style: AppTextStyles.labelSmall)),
                              Expanded(flex: 3, child: Text('Product Item', style: AppTextStyles.labelSmall)),
                              Expanded(flex: 3, child: Text('Assigned Supplier', style: AppTextStyles.labelSmall)),
                              Expanded(flex: 2, child: Text('Suggested EOQ', style: AppTextStyles.labelSmall)),
                              Expanded(flex: 2, child: Text('PO Est. Cost', style: AppTextStyles.labelSmall)),
                              Expanded(flex: 2, child: Text('Algorithmic Benefit', style: AppTextStyles.labelSmall)),
                              const SizedBox(width: 100, child: Text('Action', style: AppTextStyles.labelSmall)),
                            ],
                          ),
                        ),
                        if (items.isEmpty)
                          Padding(
                            padding: const EdgeInsets.all(32),
                            child: Text('All stock levels are optimal. No reorders needed at this time.', style: AppTextStyles.bodyMedium),
                          )
                        else
                          ...items.map((s) => Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                                decoration: const BoxDecoration(
                                  border: Border(bottom: BorderSide(color: AppColors.divider)),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(flex: 2, child: Text(s['sku'] as String, style: AppTextStyles.mono)),
                                    Expanded(flex: 3, child: Text(s['name'] as String, style: AppTextStyles.labelMedium, overflow: TextOverflow.ellipsis)),
                                    Expanded(flex: 3, child: Text(s['supplier'] as String? ?? 'General Vendor', style: AppTextStyles.bodyMedium, overflow: TextOverflow.ellipsis)),
                                    Expanded(flex: 2, child: Text('${s['suggestedQty']} units', style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary))),
                                    Expanded(flex: 2, child: Text(s['estimatedCost'] != null ? '\$${(s['estimatedCost'] as num).toStringAsFixed(2)}' : '\$0.00', style: AppTextStyles.bodyMedium)),
                                    Expanded(flex: 2, child: AppBadge(label: 'EOQ Calculated', variant: AppBadgeVariant.success)),
                                    SizedBox(
                                      width: 100,
                                      child: AppButton(
                                        label: 'Approve',
                                        height: 30,
                                        onPressed: () {
                                          Get.snackbar('PO Created', 'Purchase Order generated for ${s['sku']}');
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              )),
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
