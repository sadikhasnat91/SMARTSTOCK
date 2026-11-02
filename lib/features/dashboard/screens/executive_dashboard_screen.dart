import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/responsive/responsive_layout.dart';
import '../../../shared/layouts/app_shell.dart';
import '../../../shared/widgets/cards/kpi_card.dart';
import '../../../shared/widgets/badges/app_badge.dart';
import '../../../shared/widgets/buttons/app_button.dart';
import '../../../data/mock/mock_dashboard.dart';
import '../../../app/routes/app_routes.dart';

class ExecutiveDashboardScreen extends StatelessWidget {
  const ExecutiveDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShell(
      breadcrumbs: const ['SmartStock', 'Executive Dashboard'],
      child: ResponsiveLayout(
        desktop: _buildDesktop(context),
        mobile: _buildMobile(context),
      ),
    );
  }

  Widget _buildDesktop(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.contentPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          _buildKpiGrid(context),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 5, child: _buildRevenueChart()),
              const SizedBox(width: 20),
              Expanded(flex: 3, child: _buildInventoryPieChart()),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: _buildRecentActivity()),
              const SizedBox(width: 20),
              Expanded(flex: 4, child: _buildLowStockAlerts()),
            ],
          ),
          const SizedBox(height: 24),
          _buildRecentTransactions(),
        ],
      ),
    );
  }

  Widget _buildMobile(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildKpiGridMobile(context),
          const SizedBox(height: 16),
          _buildRevenueChart(),
          const SizedBox(height: 16),
          _buildInventoryPieChart(),
          const SizedBox(height: 16),
          _buildLowStockAlerts(),
          const SizedBox(height: 16),
          _buildRecentActivity(),
          const SizedBox(height: 16),
          _buildRecentTransactions(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 12,
      runSpacing: 12,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Executive Dashboard', style: AppTextStyles.h1),
            const SizedBox(height: 4),
            Text(
              'Monday, November 2, 2026  •  Fiscal Year 2026',
              style: AppTextStyles.bodySmall,
            ),
          ],
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            AppButton(
              label: 'Export Report',
              variant: AppButtonVariant.outline,
              prefixIcon: Icons.file_download_outlined,
              onPressed: () {},
            ),
            AppButton(
              label: 'Date Range',
              variant: AppButtonVariant.outline,
              prefixIcon: Icons.calendar_today_outlined,
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKpiGrid(BuildContext context) {
    final cards = MockDashboardData.kpiCards;
    final iconMap = {
      'trending_up': Icons.trending_up_rounded,
      'shopping_bag': Icons.shopping_bag_outlined,
      'inventory_2': Icons.inventory_2_outlined,
      'warning_amber': Icons.warning_amber_outlined,
      'local_shipping': Icons.local_shipping_outlined,
      'check_circle': Icons.check_circle_outline,
    };
    final colorMap = {
      'trending_up': AppColors.success,
      'shopping_bag': AppColors.info,
      'inventory_2': AppColors.primary,
      'warning_amber': AppColors.warning,
      'local_shipping': AppColors.textSecondary,
      'check_circle': AppColors.success,
    };
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cards.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 2.0,
      ),
      itemBuilder: (_, i) {
        final c = cards[i];
        return KpiCard(
          label: c['label'] as String,
          value: c['value'] as String,
          change: c['change'] as String?,
          changePositive: c['changePositive'] as bool?,
          sub: c['sub'] as String?,
          icon: iconMap[c['icon']] ?? Icons.info_outline,
          iconColor: colorMap[c['icon']],
        );
      },
    );
  }

  Widget _buildKpiGridMobile(BuildContext context) {
    final cards = MockDashboardData.kpiCards.take(4).toList();
    final iconMap = {
      'trending_up': Icons.trending_up_rounded,
      'shopping_bag': Icons.shopping_bag_outlined,
      'inventory_2': Icons.inventory_2_outlined,
      'warning_amber': Icons.warning_amber_outlined,
    };
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cards.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.15,
      ),
      itemBuilder: (_, i) {
        final c = cards[i];
        return KpiCard(
          label: c['label'] as String,
          value: c['value'] as String,
          change: c['change'] as String?,
          changePositive: c['changePositive'] as bool?,
          icon: iconMap[c['icon']] ?? Icons.info_outline,
        );
      },
    );
  }

  Widget _buildRevenueChart() {
    final data = MockDashboardData.revenueChart;
    return SectionCard(
      title: 'Revenue Overview',
      titleTrailing: Wrap(
        spacing: 12,
        runSpacing: 6,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          _LegendItem(color: AppColors.primary, label: 'Revenue'),
          _LegendItem(color: AppColors.border, label: 'Target'),
          AppButton(
            label: 'Last 6 Months',
            variant: AppButtonVariant.outline,
            suffixIcon: Icons.keyboard_arrow_down_rounded,
            onPressed: () {},
            height: 30,
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        height: 220,
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (_) => const FlLine(
                color: AppColors.divider,
                strokeWidth: 1,
                dashArray: [4, 4],
              ),
            ),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 48,
                  getTitlesWidget: (value, _) => Text(
                    '\$${(value / 1000).toStringAsFixed(0)}k',
                    style: AppTextStyles.caption,
                  ),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, _) {
                    final idx = value.toInt();
                    if (idx >= 0 && idx < data.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(data[idx]['month'] as String, style: AppTextStyles.caption),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              // Revenue line
              LineChartBarData(
                spots: data.asMap().entries.map((e) =>
                    FlSpot(e.key.toDouble(), (e.value['revenue'] as int).toDouble())).toList(),
                isCurved: true,
                color: AppColors.primary,
                barWidth: 2.5,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  color: AppColors.primary.withValues(alpha: 0.08),
                ),
              ),
              // Target line
              LineChartBarData(
                spots: data.asMap().entries.map((e) =>
                    FlSpot(e.key.toDouble(), (e.value['target'] as int).toDouble())).toList(),
                isCurved: true,
                color: AppColors.borderDark,
                barWidth: 1.5,
                dashArray: [5, 5],
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(show: false),
              ),
            ],
            minY: 150000,
          ),
        ),
      ),
    );
  }

  Widget _buildInventoryPieChart() {
    final data = MockDashboardData.inventoryDistribution;
    int touchedIndex = -1;
    return StatefulBuilder(builder: (context, setState) {
      return SectionCard(
        title: 'Inventory by Category',
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(
              height: 180,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 3,
                  centerSpaceRadius: 48,
                  pieTouchData: PieTouchData(
                    touchCallback: (event, response) {
                      setState(() {
                        if (response?.touchedSection != null) {
                          touchedIndex = response!.touchedSection!.touchedSectionIndex;
                        } else {
                          touchedIndex = -1;
                        }
                      });
                    },
                  ),
                  sections: data.asMap().entries.map((e) {
                    final isTouched = e.key == touchedIndex;
                    return PieChartSectionData(
                      value: e.value['value'] as double,
                      color: AppColors.chartColors[e.key % AppColors.chartColors.length],
                      radius: isTouched ? 64 : 56,
                      title: '',
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ...data.asMap().entries.map((e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: AppColors.chartColors[e.key % AppColors.chartColors.length],
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(e.value['category'] as String, style: AppTextStyles.bodySmall),
                  ),
                  Text(
                    '${e.value['value']}%',
                    style: AppTextStyles.labelSmall,
                  ),
                ],
              ),
            )),
          ],
        ),
      );
    });
  }

  Widget _buildLowStockAlerts() {
    final alerts = MockDashboardData.lowStockAlerts;
    return SectionCard(
      title: 'Low Stock Alerts',
      titleTrailing: Row(
        children: [
          AppBadge(
            label: '${alerts.length} items',
            variant: AppBadgeVariant.warning,
          ),
          const SizedBox(width: 12),
          AppButton(
            label: 'View All',
            variant: AppButtonVariant.ghost,
            onPressed: () => Get.toNamed(AppRoutes.inventoryOverview),
            height: 30,
          ),
        ],
      ),
      child: Column(
        children: alerts.map((a) => _LowStockRow(alert: a)).toList(),
      ),
    );
  }

  Widget _buildRecentActivity() {
    final activities = MockDashboardData.recentActivities;
    return SectionCard(
      title: 'Recent Activity',
      titleTrailing: AppButton(
        label: 'View All',
        variant: AppButtonVariant.ghost,
        onPressed: () {},
        height: 30,
      ),
      child: Column(
        children: activities.map((a) => _ActivityRow(activity: a)).toList(),
      ),
    );
  }

  Widget _buildRecentTransactions() {
    final txns = MockDashboardData.recentTransactions;
    return SectionCard(
      title: 'Recent Transactions',
      titleTrailing: AppButton(
        label: 'View All',
        variant: AppButtonVariant.ghost,
        onPressed: () => Get.toNamed(AppRoutes.salesOrders),
        height: 30,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          width: 720,
          child: Column(
            children: [
              // Table header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: const BoxDecoration(
                  color: AppColors.secondaryBackground,
                  border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
                ),
                child: Row(
                  children: [
                    Expanded(flex: 2, child: Text('ID', style: AppTextStyles.labelSmall)),
                    Expanded(flex: 1, child: Text('Type', style: AppTextStyles.labelSmall)),
                    Expanded(flex: 3, child: Text('Party', style: AppTextStyles.labelSmall)),
                    Expanded(flex: 2, child: Text('Amount', style: AppTextStyles.labelSmall)),
                    Expanded(flex: 2, child: Text('Status', style: AppTextStyles.labelSmall)),
                    Expanded(flex: 2, child: Text('Date', style: AppTextStyles.labelSmall)),
                  ],
                ),
              ),
              ...txns.asMap().entries.map((e) {
                final t = e.value;
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                  decoration: BoxDecoration(
                    color: e.key.isOdd ? const Color(0xFFFAFCFB) : AppColors.surface,
                    border: const Border(bottom: BorderSide(color: AppColors.divider, width: 1)),
                  ),
                  child: Row(
                    children: [
                      Expanded(flex: 2, child: Text(t['id'] as String, style: AppTextStyles.mono.copyWith(fontSize: 12))),
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: (t['type'] == 'Sale' ? AppColors.infoSurface : AppColors.successSurface),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            t['type'] as String,
                            style: AppTextStyles.caption.copyWith(
                              color: t['type'] == 'Sale' ? AppColors.info : AppColors.success,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Expanded(flex: 3, child: Text(t['customer'] as String, style: AppTextStyles.bodyMedium)),
                      Expanded(flex: 2, child: Text(t['amount'] as String, style: AppTextStyles.labelLarge)),
                      Expanded(flex: 2, child: AppBadge.fromStatus(t['status'] as String)),
                      Expanded(flex: 2, child: Text(t['date'] as String, style: AppTextStyles.bodySmall)),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}

class _LowStockRow extends StatelessWidget {
  final Map<String, dynamic> alert;
  const _LowStockRow({required this.alert});

  @override
  Widget build(BuildContext context) {
    final pct = (alert['stock'] as int) / (alert['minStock'] as int);
    final isVeryLow = pct < 0.25;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider, width: 1)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isVeryLow ? AppColors.dangerSurface : AppColors.warningSurface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isVeryLow ? Icons.error_outline : Icons.warning_amber_outlined,
              size: 18,
              color: isVeryLow ? AppColors.danger : AppColors.warning,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(alert['name'] as String, style: AppTextStyles.labelLarge, overflow: TextOverflow.ellipsis),
                Text('${alert['sku']} · ${alert['warehouse']}', style: AppTextStyles.caption),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${alert['stock']} units',
                style: AppTextStyles.labelSmall.copyWith(
                  color: isVeryLow ? AppColors.danger : AppColors.warning,
                ),
              ),
              Text('Min: ${alert['minStock']}', style: AppTextStyles.caption),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  final Map<String, dynamic> activity;
  const _ActivityRow({required this.activity});

  @override
  Widget build(BuildContext context) {
    final colorMap = {
      'success': AppColors.success,
      'warning': AppColors.warning,
      'danger': AppColors.danger,
      'info': AppColors.info,
      'primary': AppColors.primary,
    };
    final bgMap = {
      'success': AppColors.successSurface,
      'warning': AppColors.warningSurface,
      'danger': AppColors.dangerSurface,
      'info': AppColors.infoSurface,
      'primary': AppColors.primarySurface,
    };
    final iconMap = {
      'order': Icons.receipt_long_outlined,
      'receiving': Icons.move_to_inbox_outlined,
      'alert': Icons.warning_amber_outlined,
      'transfer': Icons.compare_arrows_rounded,
      'return': Icons.assignment_return_outlined,
      'user': Icons.person_add_outlined,
    };
    final color = colorMap[activity['color']] ?? AppColors.primary;
    final bg = bgMap[activity['color']] ?? AppColors.primarySurface;
    final icon = iconMap[activity['type']] ?? Icons.info_outline;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(activity['title'] as String, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text(activity['sub'] as String, style: AppTextStyles.caption),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(activity['time'] as String, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}

