import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/responsive/responsive_layout.dart';
import '../../../shared/layouts/app_shell.dart';
import '../../../shared/widgets/buttons/app_button.dart';
import '../../../shared/widgets/cards/kpi_card.dart';
import '../../../app/routes/app_routes.dart';

class IntelligenceDashboardScreen extends StatelessWidget {
  const IntelligenceDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveLayout.isDesktop(context);

    final alertsCard = Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bolt_rounded, color: AppColors.warning),
              const SizedBox(width: 8),
              Expanded(
                child: Text('High Priority AI Prescription Alerts', style: AppTextStyles.h3),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _alertTile('USB-C Hub 7-in-1 [ELC-0042]', 'Sales surge +42% week-on-week. Runout date projected in 3.4 days. Recommended replenishment: 120 units from TechPro Ltd immediately.', AppColors.danger),
          const SizedBox(height: 12),
          _alertTile('Bubble Wrap Roll [PKG-0033]', 'Only 3 rolls remaining. Shipping packaging operations will be stalled within 48 hours. Auto-trigger PO draft generated.', AppColors.danger),
          const SizedBox(height: 12),
          _alertTile('Whiteboard Markers Set [OFF-0201]', 'Overstocked inventory holding cost alert: 185 units on hand with 0.8 monthly turns. Suggest bundle promotion or cross-selling discount.', AppColors.warning),
        ],
      ),
    );

    final modulesCard = Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Intelligence Modules', style: AppTextStyles.h4),
          const SizedBox(height: 16),
          _navCard('Demand Forecasting', 'Multi-horizon time series forecasting', Icons.timeline_rounded, () => Get.toNamed(AppRoutes.demandForecasting)),
          const SizedBox(height: 12),
          _navCard('Stockout Vulnerability', 'Monte Carlo simulation of supply buffers', Icons.gpp_maybe_rounded, () => Get.toNamed(AppRoutes.stockoutRisk)),
          const SizedBox(height: 12),
          _navCard('Autonomous Reorder Engine', 'Automated vendor replenishment rules', Icons.autorenew_rounded, () => Get.toNamed(AppRoutes.smartReorder)),
        ],
      ),
    );

    return AppShell(
      breadcrumbs: const ['Intelligence', 'Inventory Intelligence Hub'],
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
                    Text('AI Supply Chain Intelligence Hub', style: AppTextStyles.h1),
                    const SizedBox(height: 4),
                    Text('Automated demand signal processing, probabilistic stockout predictions, and EOQ optimizations', style: AppTextStyles.bodySmall),
                  ],
                ),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    AppButton(
                      label: 'Ask AI Copilot',
                      prefixIcon: Icons.smart_toy_outlined,
                      onPressed: () => Get.toNamed(AppRoutes.aiAssistant),
                    ),
                    AppButton(
                      label: 'Smart Reorders',
                      prefixIcon: Icons.auto_mode_rounded,
                      onPressed: () => Get.toNamed(AppRoutes.smartReorder),
                    ),
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
                  SizedBox(width: 200, child: KpiCard(label: 'Imminent Stockout Risk', value: '4 SKUs', icon: Icons.warning_amber_rounded, iconColor: AppColors.danger, sub: 'Projected in < 7 days')),
                  SizedBox(width: 16),
                  SizedBox(width: 200, child: KpiCard(label: 'Forecast Accuracy (MAPE)', value: '94.8%', icon: Icons.insights_rounded, iconColor: AppColors.success, change: '+2.1%', changePositive: true)),
                  SizedBox(width: 16),
                  SizedBox(width: 200, child: KpiCard(label: 'Working Capital Saved', value: '\$142,500', icon: Icons.account_balance_rounded, iconColor: AppColors.primary, sub: 'By reducing buffer safety')),
                  SizedBox(width: 16),
                  SizedBox(width: 200, child: KpiCard(label: 'Automated EOQ Savings', value: '11.4%', icon: Icons.trending_up_rounded, iconColor: AppColors.info, sub: 'Bulk bracket discounts')),
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (isDesktop)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: alertsCard),
                  const SizedBox(width: 20),
                  Expanded(flex: 2, child: modulesCard),
                ],
              )
            else ...[
              alertsCard,
              const SizedBox(height: 20),
              modulesCard,
            ],
          ],
        ),
      ),
    );
  }

  Widget _alertTile(String title, String desc, Color col) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: col.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: col.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded, size: 16, color: col),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.labelLarge.copyWith(color: col),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(desc, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }

  Widget _navCard(String title, String sub, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.secondaryBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.labelMedium),
                  Text(sub, style: AppTextStyles.caption),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}

