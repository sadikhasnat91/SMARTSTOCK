import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/layouts/app_shell.dart';
import '../../../shared/widgets/badges/app_badge.dart';
import '../../../shared/widgets/buttons/app_button.dart';
import '../../../data/mock/mock_orders.dart';

class ReturnsManagementScreen extends StatelessWidget {
  const ReturnsManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShell(
      breadcrumbs: const ['Fulfillment', 'Reverse Logistics (RMA)'],
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
                    Text('Reverse Logistics & RMA Returns Processing', style: AppTextStyles.h1),
                    const SizedBox(height: 4),
                    Text('Manage customer returns, defect triage, restocking quarantine, and warranty replacement', style: AppTextStyles.bodySmall),
                  ],
                ),
                AppButton(
                  label: 'Create RMA Authorization',
                  prefixIcon: Icons.add_circle_outline_rounded,
                  onPressed: () {
                    Get.snackbar('RMA Generator', 'Generated RMA #RET-0029 with prepaid shipping label.');
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
                            Expanded(flex: 2, child: Text('RMA Code', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Order Ref', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 3, child: Text('Customer', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 3, child: Text('Return Justification', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Refund Credit', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Status', style: AppTextStyles.labelSmall)),
                            const SizedBox(width: 100, child: Text('Triage Action', style: AppTextStyles.labelSmall)),
                          ],
                        ),
                      ),
                      ...MockOrders.returns.map((r) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide(color: AppColors.divider)),
                            ),
                            child: Row(
                              children: [
                                Expanded(flex: 2, child: Text(r['id'] as String, style: AppTextStyles.mono)),
                                Expanded(flex: 2, child: Text(r['orderId'] as String, style: AppTextStyles.mono)),
                                Expanded(flex: 3, child: Text(r['customer'] as String, style: AppTextStyles.labelMedium)),
                                Expanded(flex: 3, child: Text(r['reason'] as String, style: AppTextStyles.bodySmall)),
                                Expanded(flex: 2, child: Text(r['refundAmount'] as String, style: AppTextStyles.labelLarge)),
                                Expanded(flex: 2, child: AppBadge.fromStatus(r['status'] as String)),
                                SizedBox(
                                  width: 100,
                                  child: AppButton(
                                    label: 'Inspect',
                                    height: 30,
                                    variant: AppButtonVariant.outline,
                                    onPressed: () {
                                      Get.snackbar('RMA Triage', 'Inspecting item condition: Approved for Grade A restocking.');
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

