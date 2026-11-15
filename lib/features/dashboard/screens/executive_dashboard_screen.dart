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
          _buildHeroBanner(context, isMobile: false),
          const SizedBox(height: 24),
          _buildHeader(),
          const SizedBox(height: 20),
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
          _buildHeroBanner(context, isMobile: true),
          const SizedBox(height: 16),
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

  Widget _buildHeroBanner(BuildContext context, {required bool isMobile}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 18 : 26),
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.15),
          width: 1.2,
        ),
        boxShadow: AppColors.shadow3DElevated,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: Color(0xFF6EE7B7),
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back, Sadik Hasnat 👋',
                      style: AppTextStyles.h2.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'All 4 warehouses operational • 98.4% fulfillment rate • 3 smart reorders ready for review.',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: const Color(0xFFD1FAE5),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _HeroQuickPill(
                icon: Icons.add_box_rounded,
                label: 'Add Product',
                onTap: () => Get.toNamed(AppRoutes.productAdd),
              ),
              _HeroQuickPill(
                icon: Icons.qr_code_scanner_rounded,
                label: 'Scan Barcode',
                onTap: () => Get.toNamed(AppRoutes.barcodeManagement),
              ),
              _HeroQuickPill(
                icon: Icons.auto_awesome_rounded,
                label: 'AI Insights',
                onTap: () => Get.toNamed(AppRoutes.intelligenceDashboard),
              ),
              _HeroQuickPill(
                icon: Icons.compare_arrows_rounded,
                label: 'Stock Transfer',
                onTap: () => Get.toNamed(AppRoutes.transferCreate),
              ),
            ],
          ),
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
            Text(
              'Performance Overview',
              style: AppTextStyles.h2.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              'Real-time inventory metrics and sales analytics',
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
              onPressed: () {
                Get.snackbar('Exporting', 'Generating executive summary PDF...');
              },
            ),
            AppButton(
              label: 'Smart Reorder',
              variant: AppButtonVariant.primary,
              prefixIcon: Icons.auto_awesome_rounded,
              onPressed: () => Get.toNamed(AppRoutes.smartReorder),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKpiGrid(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isTablet = width < 1100;
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
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isTablet ? 2 : 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        mainAxisExtent: 126,
      ),
      itemBuilder: (context, i) {
        final c = cards[i];
        return KpiCard(
          label: c['label'] as String,
          value: c['value'] as String,
          change: c['change'] as String?,
          changePositive: c['changePositive'] as bool?,
          sub: c['sub'] as String?,
          icon: iconMap[c['icon']] ?? Icons.insights,
          iconColor: colorMap[c['icon']],
          onTap: () => _handleKpiTap(i),
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
    final colorMap = {
      'trending_up': AppColors.success,
      'shopping_bag': AppColors.info,
      'inventory_2': AppColors.primary,
      'warning_amber': AppColors.warning,
    };
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cards.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        mainAxisExtent: 126,
      ),
      itemBuilder: (context, i) {
        final c = cards[i];
        return KpiCard(
          label: c['label'] as String,
          value: c['value'] as String,
          change: c['change'] as String?,
          changePositive: c['changePositive'] as bool?,
          icon: iconMap[c['icon']] ?? Icons.insights,
          iconColor: colorMap[c['icon']],
          onTap: () => _handleKpiTap(i),
        );
      },
    );
  }

  void _handleKpiTap(int index) {
    switch (index) {
      case 0:
        Get.toNamed(AppRoutes.salesOrders);
        break;
      case 1:
        Get.toNamed(AppRoutes.salesOrders);
        break;
      case 2:
        Get.toNamed(AppRoutes.products);
        break;
      case 3:
        Get.toNamed(AppRoutes.stockoutRisk);
        break;
      case 4:
        Get.toNamed(AppRoutes.dispatch);
        break;
      case 5:
        Get.toNamed(AppRoutes.intelligenceDashboard);
        break;
    }
  }

  Widget _buildRevenueChart() {
    final data = MockDashboardData.revenueChart;
    return SectionCard(
      title: 'Revenue & Target Trend',
      titleTrailing: Wrap(
        spacing: 12,
        runSpacing: 6,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          _LegendItem(color: AppColors.primary, label: 'Actual Revenue'),
          _LegendItem(color: AppColors.borderDark, label: 'Forecast Target'),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        height: 230,
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
                    style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600),
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
                        child: Text(
                          data[idx]['month'] as String,
                          style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600),
                        ),
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
              // Revenue line with gradient glow
              LineChartBarData(
                spots: data.asMap().entries.map((e) =>
                    FlSpot(e.key.toDouble(), (e.value['revenue'] as int).toDouble())).toList(),
                isCurved: true,
                color: AppColors.primary,
                barWidth: 3,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 4,
                      color: Colors.white,
                      strokeWidth: 2.5,
                      strokeColor: AppColors.primary,
                    );
                  },
                ),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.primaryLight.withValues(alpha: 0.28),
                      AppColors.primaryLight.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
              // Target line
              LineChartBarData(
                spots: data.asMap().entries.map((e) =>
                    FlSpot(e.key.toDouble(), (e.value['target'] as int).toDouble())).toList(),
                isCurved: true,
                color: AppColors.borderDark,
                barWidth: 2,
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
              height: 170,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 3,
                  centerSpaceRadius: 46,
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
                      radius: isTouched ? 60 : 52,
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
                    style: AppTextStyles.labelSmall.copyWith(fontWeight: FontWeight.w700),
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
      titleTrailing: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8,
        runSpacing: 4,
        children: [
          AppBadge(
            label: '${alerts.length} critical',
            variant: AppBadgeVariant.warning,
            dot: true,
          ),
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
        onPressed: () => Get.toNamed(AppRoutes.auditLogs),
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
        label: 'View All Orders',
        variant: AppButtonVariant.ghost,
        onPressed: () => Get.toNamed(AppRoutes.salesOrders),
        height: 30,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          width: 740,
          child: Column(
            children: [
              // 3D Table Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFFAFCFB), Color(0xFFF1F6F3)],
                  ),
                  border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
                ),
                child: Row(
                  children: [
                    Expanded(flex: 2, child: Text('ID', style: AppTextStyles.labelSmall)),
                    Expanded(flex: 1, child: Text('Type', style: AppTextStyles.labelSmall)),
                    Expanded(flex: 3, child: Text('Party / Customer', style: AppTextStyles.labelSmall)),
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
                    color: e.key.isOdd ? const Color(0xFFF9FBFA) : AppColors.surface,
                    border: const Border(bottom: BorderSide(color: AppColors.divider, width: 1)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(t['id'] as String, style: AppTextStyles.mono.copyWith(fontWeight: FontWeight.w600)),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: (t['type'] == 'Sale' ? AppColors.infoSurface : AppColors.successSurface),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            t['type'] as String,
                            style: AppTextStyles.caption.copyWith(
                              color: t['type'] == 'Sale' ? AppColors.info : AppColors.success,
                              fontWeight: FontWeight.w700,
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

class _HeroQuickPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _HeroQuickPill({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.25),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Colors.white),
            const SizedBox(width: 7),
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
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
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 4,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w500)),
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
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: isVeryLow ? AppColors.dangerSurface : AppColors.warningSurface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: (isVeryLow ? AppColors.danger : AppColors.warning).withValues(alpha: 0.2),
              ),
            ),
            child: Icon(
              isVeryLow ? Icons.error_outline_rounded : Icons.warning_amber_rounded,
              size: 20,
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
                  fontWeight: FontWeight.w700,
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
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: color.withValues(alpha: 0.2)),
            ),
            child: Icon(icon, size: 17, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(activity['title'] as String, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
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
