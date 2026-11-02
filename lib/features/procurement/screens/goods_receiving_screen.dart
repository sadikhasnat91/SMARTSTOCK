import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/responsive/responsive_layout.dart';
import '../../../shared/layouts/app_shell.dart';
import '../../../shared/widgets/badges/app_badge.dart';
import '../../../shared/widgets/buttons/app_button.dart';
import '../../../shared/widgets/inputs/app_text_field.dart';

class GoodsReceivingScreen extends StatefulWidget {
  const GoodsReceivingScreen({super.key});

  @override
  State<GoodsReceivingScreen> createState() => _GoodsReceivingScreenState();
}

class _GoodsReceivingScreenState extends State<GoodsReceivingScreen> {
  final _poSearchCtrl = TextEditingController(text: 'PO-2024-0344');

  final _lineItems = [
    {'sku': 'ELC-0042', 'name': 'USB-C Hub 7-in-1', 'ordered': 50, 'received': 50, 'damaged': 0, 'status': 'Verified'},
    {'sku': 'ELC-0071', 'name': 'Wireless Keyboard MX', 'ordered': 30, 'received': 30, 'damaged': 1, 'status': 'Partial QA'},
    {'sku': 'ELC-0088', 'name': '4K Monitor 27-inch', 'ordered': 20, 'received': 20, 'damaged': 0, 'status': 'Verified'},
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);

    return AppShell(
      breadcrumbs: const ['Procurement', 'Goods Receiving & Inspection (GRN)'],
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
                    Text('Inbound Receiving Dock & QA Verification', style: AppTextStyles.h1),
                    const SizedBox(height: 4),
                    Text('Inspect shipment parcels against PO, register physical variances, and credit inventory', style: AppTextStyles.bodySmall),
                  ],
                ),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    AppButton(
                      label: 'Print GRN',
                      variant: AppButtonVariant.outline,
                      prefixIcon: Icons.receipt_long_rounded,
                      onPressed: () {},
                    ),
                    AppButton(
                      label: 'Finalize Receiving',
                      prefixIcon: Icons.check_circle_outline_rounded,
                      onPressed: () {
                        Get.snackbar(
                          'GRN Issued',
                          'Goods Receipt Note GRN-2026-904 recorded. Stock balances updated.',
                          backgroundColor: AppColors.success,
                          colorText: Colors.white,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: isMobile
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AppTextField(
                          label: 'Scan or Enter PO Number / Tracking No',
                          controller: _poSearchCtrl,
                          prefixIcon: Icons.qr_code_scanner_rounded,
                        ),
                        const SizedBox(height: 12),
                        AppButton(
                          label: 'Fetch PO Lines',
                          prefixIcon: Icons.download_rounded,
                          onPressed: () {},
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: AppTextField(
                            label: 'Scan or Enter PO Number / Tracking No',
                            controller: _poSearchCtrl,
                            prefixIcon: Icons.qr_code_scanner_rounded,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: AppButton(
                            label: 'Fetch PO Lines',
                            prefixIcon: Icons.download_rounded,
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: SizedBox(
                  width: 860,
                  child: Column(
                    children: [
                      Container(
                        color: AppColors.secondaryBackground,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        child: Row(
                          children: [
                            Expanded(flex: 2, child: Text('SKU Code', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 4, child: Text('Item Description', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Ordered Qty', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Received Qty', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Damaged / Rejected', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('QA Clearance', style: AppTextStyles.labelSmall)),
                          ],
                        ),
                      ),
                      ..._lineItems.map((item) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide(color: AppColors.divider)),
                            ),
                            child: Row(
                              children: [
                                Expanded(flex: 2, child: Text(item['sku'] as String, style: AppTextStyles.mono)),
                                Expanded(flex: 4, child: Text(item['name'] as String, style: AppTextStyles.labelMedium)),
                                Expanded(flex: 2, child: Text('${item['ordered']} units', style: AppTextStyles.bodyMedium)),
                                Expanded(flex: 2, child: Text('${item['received']} units', style: AppTextStyles.labelSmall.copyWith(color: AppColors.success))),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    '${item['damaged']} units',
                                    style: AppTextStyles.labelSmall.copyWith(
                                      color: (item['damaged'] as int) > 0 ? AppColors.danger : AppColors.textMuted,
                                    ),
                                  ),
                                ),
                                Expanded(flex: 2, child: AppBadge(label: item['status'] as String, variant: AppBadgeVariant.success, dot: true)),
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

  @override
  void dispose() {
    _poSearchCtrl.dispose();
    super.dispose();
  }
}

