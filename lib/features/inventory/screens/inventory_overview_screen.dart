import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/responsive/responsive_layout.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/layouts/app_shell.dart';
import '../../../shared/widgets/badges/app_badge.dart';
import '../../../shared/widgets/buttons/app_button.dart';
import '../../../shared/widgets/cards/kpi_card.dart';
import '../../../data/mock/mock_products.dart';
import '../../../app/routes/app_routes.dart';

class InventoryOverviewScreen extends StatelessWidget {
  const InventoryOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveLayout.isDesktop(context);

    final allocationCard = Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Warehouse Stock Allocation', style: AppTextStyles.h3),
          const SizedBox(height: 16),
          _buildWarehouseAllocation('WH-Main (Dhaka DC)', 8200, 12500, '\$890,200', AppColors.primary),
          const SizedBox(height: 16),
          _buildWarehouseAllocation('WH-East (Narayanganj)', 4100, 6800, '\$310,400', AppColors.info),
          const SizedBox(height: 16),
          _buildWarehouseAllocation('WH-West (Savar Regional)', 2860, 5200, '\$185,150', AppColors.warning),
          const SizedBox(height: 16),
          _buildWarehouseAllocation('WH-Cold (Gazipur)', 2408, 2800, '\$43,200', AppColors.danger),
        ],
      ),
    );

    final velocityCard = Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Stock Velocity Analysis', style: AppTextStyles.h3),
          const SizedBox(height: 16),
          _buildVelocityTile('Fast Moving (Class A)', '48 SKUs (68% of sales)', AppColors.success),
          const SizedBox(height: 12),
          _buildVelocityTile('Moderate Moving (Class B)', '112 SKUs (24% of sales)', AppColors.info),
          const SizedBox(height: 12),
          _buildVelocityTile('Slow Moving (Class C)', '180 SKUs (8% of sales)', AppColors.warning),
          const SizedBox(height: 12),
          _buildVelocityTile('Zero Turn (>90 days)', '14 SKUs (Liquidation needed)', AppColors.danger),
        ],
      ),
    );

    return AppShell(
      breadcrumbs: const ['Inventory', 'Inventory Overview'],
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
                    Text('Enterprise Inventory Overview', style: AppTextStyles.h1),
                    const SizedBox(height: 4),
                    Text('Multi-location aggregated stock valuation, turnover velocity, and safety margins', style: AppTextStyles.bodySmall),
                  ],
                ),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    AppButton(
                      label: 'Reorder Critical',
                      variant: AppButtonVariant.danger,
                      prefixIcon: Icons.warning_amber_rounded,
                      onPressed: () => Get.toNamed(AppRoutes.smartReorder),
                    ),
                    AppButton(
                      label: 'Adjust Inventory',
                      prefixIcon: Icons.tune_rounded,
                      onPressed: () => Get.toNamed(AppRoutes.stockAdjustment),
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
                  SizedBox(width: 200, child: KpiCard(label: 'Total SKU Count', value: '1,280', icon: Icons.category_rounded, sub: 'Active SKUs across 4 hubs')),
                  SizedBox(width: 14),
                  SizedBox(width: 200, child: KpiCard(label: 'Net Inventory Value', value: '\$1,428,950', icon: Icons.attach_money_rounded, change: '+4.8%', changePositive: true)),
                  SizedBox(width: 14),
                  SizedBox(width: 200, child: KpiCard(label: 'Stock Health Score', value: '94.2%', icon: Icons.health_and_safety_rounded, change: '+1.5%', changePositive: true)),
                  SizedBox(width: 14),
                  SizedBox(width: 200, child: KpiCard(label: 'Dead Stock Estimate', value: '\$12,400', icon: Icons.hourglass_disabled_rounded, iconColor: AppColors.danger, change: '-3.1%', changePositive: true)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (isDesktop)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: allocationCard),
                  const SizedBox(width: 20),
                  Expanded(flex: 2, child: velocityCard),
                ],
              )
            else
              Column(
                children: [
                  allocationCard,
                  const SizedBox(height: 20),
                  velocityCard,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        Text('Inventory Safety Margin Table', style: AppTextStyles.h3),
                        AppButton(
                          label: 'View Detailed Products',
                          variant: AppButtonVariant.outline,
                          onPressed: () => Get.toNamed(AppRoutes.products),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: SizedBox(
                      width: 820,
                      child: Column(
                        children: [
                          Container(
                            color: AppColors.secondaryBackground,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            child: Row(
                              children: [
                                Expanded(flex: 3, child: Text('Product Item', style: AppTextStyles.labelSmall)),
                                Expanded(flex: 2, child: Text('SKU', style: AppTextStyles.labelSmall)),
                                Expanded(flex: 2, child: Text('On Hand', style: AppTextStyles.labelSmall)),
                                Expanded(flex: 2, child: Text('Safety Buffer', style: AppTextStyles.labelSmall)),
                                Expanded(flex: 2, child: Text('Runway', style: AppTextStyles.labelSmall)),
                                Expanded(flex: 2, child: Text('Condition', style: AppTextStyles.labelSmall)),
                              ],
                            ),
                          ),
                          ...MockProducts.products.take(6).map((p) => Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                                decoration: const BoxDecoration(
                                  border: Border(bottom: BorderSide(color: AppColors.divider)),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Text(p['name'] as String, style: AppTextStyles.labelMedium),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(p['sku'] as String, style: AppTextStyles.mono),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text('${p['stock']} ${p['unit']}', style: AppTextStyles.bodyMedium),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text('${p['minStock']} min / ${p['maxStock']} max', style: AppTextStyles.caption),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text('${((p['stock'] as int) / 3).toStringAsFixed(1)} days', style: AppTextStyles.bodySmall),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: AppBadge.fromStatus(p['status'] as String),
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWarehouseAllocation(String name, int used, int total, String val, Color barColor) {
    final pct = (used / total).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(name, style: AppTextStyles.labelMedium, overflow: TextOverflow.ellipsis),
            ),
            const SizedBox(width: 8),
            Text('$val · ${(pct * 100).toStringAsFixed(1)}% full', style: AppTextStyles.caption),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: pct,
            minHeight: 8,
            backgroundColor: AppColors.secondaryBackground,
            valueColor: AlwaysStoppedAnimation(barColor),
          ),
        ),
      ],
    );
  }

  Widget _buildVelocityTile(String title, String sub, Color col) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: col.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: col.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: col, shape: BoxShape.circle)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.labelMedium.copyWith(color: col)),
                Text(sub, style: AppTextStyles.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

