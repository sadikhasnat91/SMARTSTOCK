import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/layouts/app_shell.dart';
import '../../../shared/widgets/badges/app_badge.dart';
import '../../../shared/widgets/cards/kpi_card.dart';
import '../../../data/mock/mock_suppliers.dart';

class SupplierPerformanceScreen extends StatelessWidget {
  const SupplierPerformanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShell(
      breadcrumbs: const ['Procurement', 'Suppliers', 'Performance Scorecards'],
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
                    Text('Vendor SLA & Performance Analytics', style: AppTextStyles.h1),
                    const SizedBox(height: 4),
                    Text('Comparative quality scores, delivery lead time accuracy, and contract fulfillment rates', style: AppTextStyles.bodySmall),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: const [
                  SizedBox(width: 190, child: KpiCard(label: 'Avg On-Time Rate', value: '92.4%', icon: Icons.timer_outlined, iconColor: AppColors.success)),
                  SizedBox(width: 14),
                  SizedBox(width: 190, child: KpiCard(label: 'Defect Return Rate', value: '0.8%', icon: Icons.error_outline_rounded, iconColor: AppColors.primary)),
                  SizedBox(width: 14),
                  SizedBox(width: 190, child: KpiCard(label: 'Top Tier (Tier 1)', value: '4 Vendors', icon: Icons.stars_rounded, iconColor: AppColors.warning)),
                  SizedBox(width: 14),
                  SizedBox(width: 190, child: KpiCard(label: 'Under Probation', value: '1 Vendor', icon: Icons.warning_amber_rounded, iconColor: AppColors.danger)),
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
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: SizedBox(
                  width: 880,
                  child: Column(
                    children: [
                      Container(
                        color: AppColors.secondaryBackground,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        child: Row(
                          children: [
                            Expanded(flex: 3, child: Text('Vendor Partner', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Category', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('On-Time Delivery', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Quality Assurance', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Average Lead Time', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Performance Tier', style: AppTextStyles.labelSmall)),
                          ],
                        ),
                      ),
                      ...MockSuppliers.suppliers.map((s) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide(color: AppColors.divider)),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(s['name'] as String, style: AppTextStyles.labelLarge, overflow: TextOverflow.ellipsis),
                                      Text(s['country'] as String, style: AppTextStyles.caption),
                                    ],
                                  ),
                                ),
                                Expanded(flex: 2, child: Text(s['category'] as String, style: AppTextStyles.bodySmall)),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(s['onTimeDelivery'] as String, style: AppTextStyles.labelSmall),
                                      const SizedBox(height: 4),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(2),
                                        child: LinearProgressIndicator(
                                          value: (double.tryParse((s['onTimeDelivery'] as String).replaceAll('%', '')) ?? 80) / 100,
                                          minHeight: 4,
                                          backgroundColor: AppColors.secondaryBackground,
                                          valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(s['qualityScore'] as String, style: AppTextStyles.bodyMedium),
                                ),
                                Expanded(flex: 2, child: Text(s['leadTime'] as String, style: AppTextStyles.bodySmall)),
                                Expanded(
                                  flex: 2,
                                  child: AppBadge(
                                    label: (s['rating'] as double) >= 4.5 ? 'Tier 1 Preferred' : 'Standard Supplier',
                                    variant: (s['rating'] as double) >= 4.5 ? AppBadgeVariant.success : AppBadgeVariant.neutral,
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

