import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/layouts/app_shell.dart';
import '../../../shared/widgets/buttons/app_button.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  final _alerts = const [
    {'title': 'Critical Stockout Depletion Imminent', 'desc': 'USB-C Hub 7-in-1 [ELC-0042] runway calculated at < 3 days. Automated replenishment draft PO-2024-0346 queued.', 'time': '12 mins ago', 'type': 'Danger'},
    {'title': 'Goods Received from Carrier', 'desc': 'DHL freight unloaded for PO-2024-0344 at WH-Main Dock 1. 128 units cleared QA inspection.', 'time': '45 mins ago', 'type': 'Success'},
    {'title': 'Stock Transfer Authorization Required', 'desc': 'Transfer TRF-0094 requesting 15 units of ELC-0042 from WH-Main to WH-East awaiting site manager approval.', 'time': '2 hours ago', 'type': 'Warning'},
    {'title': 'Large Enterprise Sales Order Booked', 'desc': 'Apex Corporation placed order SO-2024-0891 for \$4,200. Inventory allocation locked.', 'time': '5 hours ago', 'type': 'Info'},
    {'title': 'Vendor Performance Scorecard Updated', 'desc': 'TechPro Ltd quarterly on-time delivery rate rose to 96.2%. Tier 1 benefits maintained.', 'time': '1 day ago', 'type': 'Success'},
  ];

  @override
  Widget build(BuildContext context) {
    return AppShell(
      breadcrumbs: const ['Administration', 'Notifications & Operational Alerts'],
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
                    Text('Operational Notification Center', style: AppTextStyles.h1),
                    const SizedBox(height: 4),
                    Text('Automated system alerts, workflow transitions, threshold warnings, and approval notifications', style: AppTextStyles.bodySmall),
                  ],
                ),
                AppButton(
                  label: 'Mark All Read',
                  variant: AppButtonVariant.outline,
                  prefixIcon: Icons.done_all_rounded,
                  onPressed: () {
                    Get.snackbar('Notifications Cleared', 'All alerts marked as acknowledged.');
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: _alerts.map((n) {
                  final (icon, col, bg) = switch (n['type']) {
                    'Danger' => (Icons.error_outline_rounded, AppColors.danger, AppColors.dangerSurface),
                    'Warning' => (Icons.warning_amber_rounded, AppColors.warning, AppColors.warningSurface),
                    'Success' => (Icons.check_circle_outline_rounded, AppColors.success, AppColors.successSurface),
                    _ => (Icons.info_outline_rounded, AppColors.info, AppColors.infoSurface),
                  };

                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: AppColors.divider)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
                          child: Icon(icon, color: col, size: 20),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 8,
                                runSpacing: 4,
                                children: [
                                  Text(n['title'] as String, style: AppTextStyles.labelLarge),
                                  Text(n['time'] as String, style: AppTextStyles.caption),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(n['desc'] as String, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

