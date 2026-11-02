import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/layouts/app_shell.dart';
import '../../../shared/widgets/badges/app_badge.dart';
import '../../../shared/widgets/buttons/app_button.dart';

class ReportsCenterScreen extends StatelessWidget {
  const ReportsCenterScreen({super.key});

  final _reports = const [
    {'title': 'Consolidated Inventory Valuation (FIFO)', 'type': 'Financial Audit', 'period': 'Monthly Q3/Q4', 'size': '2.4 MB', 'format': 'PDF / CSV'},
    {'title': 'Warehouse Capacity & Throughput Velocity', 'type': 'Operations', 'period': 'Weekly Aggregate', 'size': '1.1 MB', 'format': 'XLSX'},
    {'title': 'Procurement Spend & Supplier SLA Compliance', 'type': 'Procurement', 'period': 'Fiscal YTD', 'size': '3.8 MB', 'format': 'PDF / CSV'},
    {'title': 'Stock Discrepancy & Cycle Count Variance', 'type': 'Inventory Control', 'period': 'Bi-weekly', 'size': '850 KB', 'format': 'PDF'},
    {'title': 'Customer Order Fulfillment Lead-Time Metrics', 'type': 'Sales & Logistics', 'period': 'Quarterly', 'size': '1.9 MB', 'format': 'PDF / CSV'},
  ];

  @override
  Widget build(BuildContext context) {
    return AppShell(
      breadcrumbs: const ['Analytics', 'Reports Center'],
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
                    Text('Executive Intelligence & Compliance Reporting', style: AppTextStyles.h1),
                    const SizedBox(height: 4),
                    Text('Generate GAAP/IFRS compliant valuation reports, inventory movement audits, and operational KPIs', style: AppTextStyles.bodySmall),
                  ],
                ),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    AppButton(
                      label: 'Schedule Report',
                      variant: AppButtonVariant.outline,
                      prefixIcon: Icons.schedule_rounded,
                      onPressed: () {},
                    ),
                    AppButton(
                      label: 'Custom Export',
                      prefixIcon: Icons.download_rounded,
                      onPressed: () {
                        Get.snackbar('Report Generating', 'Compiling dataset across 4 warehouse nodes. Download ready shortly.');
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
                            Expanded(flex: 4, child: Text('Report Document', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Category', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Frequency / Cadence', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('File Payload', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Formats', style: AppTextStyles.labelSmall)),
                            const SizedBox(width: 100, child: Text('Action', style: AppTextStyles.labelSmall)),
                          ],
                        ),
                      ),
                      ..._reports.map((r) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide(color: AppColors.divider)),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Row(
                                    children: [
                                      const Icon(Icons.picture_as_pdf_outlined, color: AppColors.danger, size: 22),
                                      const SizedBox(width: 12),
                                      Expanded(child: Text(r['title'] as String, style: AppTextStyles.labelLarge)),
                                    ],
                                  ),
                                ),
                                Expanded(flex: 2, child: Text(r['type'] as String, style: AppTextStyles.bodySmall)),
                                Expanded(flex: 2, child: Text(r['period'] as String, style: AppTextStyles.caption)),
                                Expanded(flex: 2, child: Text(r['size'] as String, style: AppTextStyles.mono)),
                                Expanded(flex: 2, child: AppBadge(label: r['format'] as String, variant: AppBadgeVariant.neutral)),
                                SizedBox(
                                  width: 100,
                                  child: AppButton(
                                    label: 'Export',
                                    height: 30,
                                    prefixIcon: Icons.file_download_outlined,
                                    onPressed: () {
                                      Get.snackbar('Download Dispatched', 'Exporting "${r['title']}" to local drive.');
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

