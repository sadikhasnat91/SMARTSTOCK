import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/layouts/app_shell.dart';
import '../../../shared/widgets/badges/app_badge.dart';
import '../../../shared/widgets/buttons/app_button.dart';
import '../../../shared/widgets/cards/kpi_card.dart';
import '../../../data/mock/mock_products.dart';
import '../../../app/routes/app_routes.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../data/mock/mock_dashboard.dart';

class InventoryDashboardScreen extends StatelessWidget {
  const InventoryDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 1024;

    return AppShell(
      breadcrumbs: const ['SmartStock', 'Inventory Dashboard'],
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
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Inventory Dashboard', style: AppTextStyles.h1),
                  const SizedBox(height: 4),
                  Text('Real-time inventory health and analytics', style: AppTextStyles.bodySmall),
                ]),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    AppButton(
                      label: 'Adjust Stock',
                      variant: AppButtonVariant.outline,
                      prefixIcon: Icons.tune_outlined,
                      onPressed: () => Get.toNamed(AppRoutes.stockAdjustment),
                    ),
                    AppButton(
                      label: 'Add Product',
                      prefixIcon: Icons.add_rounded,
                      onPressed: () => Get.toNamed(AppRoutes.productAdd),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Stats horizontal scroll on mobile / row on desktop
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  SizedBox(width: isDesktop ? 220 : 180, child: const _StatTile(label: 'Total Products', value: '130', icon: Icons.category_outlined, color: AppColors.primary)),
                  const SizedBox(width: 14),
                  SizedBox(width: isDesktop ? 220 : 180, child: const _StatTile(label: 'In Stock', value: '104', icon: Icons.check_circle_outline, color: AppColors.success)),
                  const SizedBox(width: 14),
                  SizedBox(width: isDesktop ? 220 : 180, child: const _StatTile(label: 'Low Stock', value: '18', icon: Icons.warning_amber_outlined, color: AppColors.warning)),
                  const SizedBox(width: 14),
                  SizedBox(width: isDesktop ? 220 : 180, child: const _StatTile(label: 'Out of Stock', value: '8', icon: Icons.error_outline, color: AppColors.danger)),
                  const SizedBox(width: 14),
                  SizedBox(width: isDesktop ? 220 : 180, child: const _StatTile(label: 'Total Value', value: '\$1.24M', icon: Icons.monetization_on_outlined, color: AppColors.info)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (isDesktop)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: _buildStockByCategory()),
                  const SizedBox(width: 20),
                  Expanded(flex: 2, child: _buildTopProducts()),
                ],
              )
            else
              Column(
                children: [
                  _buildStockByCategory(),
                  const SizedBox(height: 20),
                  _buildTopProducts(),
                ],
              ),
            const SizedBox(height: 24),
            _buildRecentMovementsTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildStockByCategory() {
    final data = MockDashboardData.inventoryDistribution;
    return SectionCard(
      title: 'Stock Value by Category',
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        height: 200,
        child: BarChart(
          BarChartData(
            barGroups: data.asMap().entries.map((e) =>
              BarChartGroupData(
                x: e.key,
                barRods: [
                  BarChartRodData(
                    toY: e.value['value'] as double,
                    color: AppColors.chartColors[e.key % AppColors.chartColors.length],
                    width: 28,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
            ).toList(),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (_) => const FlLine(color: AppColors.divider, strokeWidth: 1),
            ),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (v, _) => Text('${v.toInt()}%', style: AppTextStyles.caption),
              )),
              bottomTitles: AxisTitles(sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (v, _) {
                  final idx = v.toInt();
                  if (idx >= 0 && idx < data.length) {
                    final label = (data[idx]['category'] as String).split(' ').first;
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(label, style: AppTextStyles.caption),
                    );
                  }
                  return const SizedBox();
                },
              )),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopProducts() {
    final products = MockProducts.products.take(5).toList();
    return SectionCard(
      title: 'Stock Level Overview',
      child: Column(
        children: products.map((p) {
          final pct = ((p['stock'] as int) / (p['maxStock'] as int)).clamp(0.0, 1.0);
          final isLow = pct < 0.2;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(p['name'] as String, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary), overflow: TextOverflow.ellipsis)),
                    Text('${p['stock']}/${p['maxStock']}', style: AppTextStyles.caption),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: pct,
                    backgroundColor: AppColors.secondaryBackground,
                    valueColor: AlwaysStoppedAnimation<Color>(isLow ? AppColors.danger : AppColors.primary),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRecentMovementsTable() {
    final movements = MockProducts.stockMovements;
    return SectionCard(
      title: 'Recent Stock Movements',
      titleTrailing: AppButton(
        label: 'View All',
        variant: AppButtonVariant.ghost,
        onPressed: () => Get.toNamed(AppRoutes.stockMovements),
        height: 30,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          width: 760,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: const BoxDecoration(
                  color: AppColors.secondaryBackground,
                  border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
                ),
                child: Row(children: [
                  Expanded(flex: 2, child: Text('Reference', style: AppTextStyles.labelSmall)),
                  Expanded(flex: 1, child: Text('Type', style: AppTextStyles.labelSmall)),
                  Expanded(flex: 3, child: Text('Product', style: AppTextStyles.labelSmall)),
                  Expanded(flex: 1, child: Text('Qty', style: AppTextStyles.labelSmall)),
                  Expanded(flex: 2, child: Text('Warehouse', style: AppTextStyles.labelSmall)),
                  Expanded(flex: 2, child: Text('Date', style: AppTextStyles.labelSmall)),
                ]),
              ),
              ...movements.asMap().entries.map((e) {
                final m = e.value;
                final isInbound = m['type'] == 'Inbound';
                final isOutbound = m['type'] == 'Outbound';
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                  decoration: BoxDecoration(
                    color: e.key.isOdd ? const Color(0xFFFAFCFB) : AppColors.surface,
                    border: const Border(bottom: BorderSide(color: AppColors.divider, width: 1)),
                  ),
                  child: Row(children: [
                    Expanded(flex: 2, child: Text(m['reference'] as String, style: AppTextStyles.mono.copyWith(fontSize: 12))),
                    Expanded(flex: 1, child: AppBadge.fromStatus(m['type'] as String)),
                    Expanded(
                      flex: 3,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(m['product'] as String, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary), overflow: TextOverflow.ellipsis),
                        Text(m['sku'] as String, style: AppTextStyles.caption),
                      ]),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        '${isInbound ? '+' : isOutbound ? '-' : ''}${(m['qty'] as int).abs()}',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: isInbound ? AppColors.success : isOutbound ? AppColors.danger : AppColors.info,
                        ),
                      ),
                    ),
                    Expanded(flex: 2, child: Text(m['warehouse'] as String, style: AppTextStyles.bodySmall, overflow: TextOverflow.ellipsis)),
                    Expanded(flex: 2, child: Text(m['date'] as String, style: AppTextStyles.bodySmall)),
                  ]),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatTile({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(value, style: AppTextStyles.h3),
                ),
                Text(
                  label,
                  style: AppTextStyles.caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

