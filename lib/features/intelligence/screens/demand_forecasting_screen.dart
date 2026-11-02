import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/layouts/app_shell.dart';
import '../../../shared/widgets/badges/app_badge.dart';
import '../../../shared/widgets/buttons/app_button.dart';
import '../../../shared/widgets/inputs/app_text_field.dart';

class DemandForecastingScreen extends StatefulWidget {
  const DemandForecastingScreen({super.key});

  @override
  State<DemandForecastingScreen> createState() => _DemandForecastingScreenState();
}

class _DemandForecastingScreenState extends State<DemandForecastingScreen> {
  String _selectedHorizon = '30 Days Forecast';

  final _forecastItems = const [
    {'sku': 'ELC-0042', 'name': 'USB-C Hub 7-in-1', 'current30': '450 units', 'projected30': '640 units', 'variance': '+42.2%', 'confidence': '96.4%'},
    {'sku': 'OFF-0118', 'name': 'Premium A4 Paper Ream', 'current30': '320 units', 'projected30': '310 units', 'variance': '-3.1%', 'confidence': '98.1%'},
    {'sku': 'FRN-0055', 'name': 'Ergonomic Office Chair', 'current30': '65 units', 'projected30': '88 units', 'variance': '+35.4%', 'confidence': '92.0%'},
    {'sku': 'ELC-0088', 'name': '4K Monitor 27-inch', 'current30': '90 units', 'projected30': '115 units', 'variance': '+27.7%', 'confidence': '94.5%'},
  ];

  @override
  Widget build(BuildContext context) {
    return AppShell(
      breadcrumbs: const ['Intelligence', 'Demand Forecasting'],
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
                    Text('Predictive Demand Velocity Forecasting', style: AppTextStyles.h1),
                    const SizedBox(height: 4),
                    Text('Ensemble time-series modeling factoring seasonality, promotion lifts, and trend decomposition', style: AppTextStyles.bodySmall),
                  ],
                ),
                AppButton(
                  label: 'Retrain Predictive Model',
                  variant: AppButtonVariant.outline,
                  prefixIcon: Icons.refresh_rounded,
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      Text('Aggregate 6-Month Demand vs Actuals', style: AppTextStyles.h3),
                      SizedBox(
                        width: 180,
                        child: AppDropdownField<String>(
                          label: null,
                          value: _selectedHorizon,
                          items: const [
                            DropdownMenuItem(value: '30 Days Forecast', child: Text('30 Days Forecast')),
                            DropdownMenuItem(value: '60 Days Forecast', child: Text('60 Days Forecast')),
                            DropdownMenuItem(value: '90 Days Forecast', child: Text('90 Days Forecast')),
                          ],
                          onChanged: (v) => setState(() => _selectedHorizon = v ?? _selectedHorizon),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 220,
                    child: LineChart(
                      LineChartData(
                        gridData: const FlGridData(show: true, drawVerticalLine: false),
                        borderData: FlBorderData(show: false),
                        titlesData: const FlTitlesData(
                          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            spots: const [
                              FlSpot(0, 120),
                              FlSpot(1, 145),
                              FlSpot(2, 160),
                              FlSpot(3, 190),
                              FlSpot(4, 230),
                              FlSpot(5, 290),
                            ],
                            isCurved: true,
                            color: AppColors.primary,
                            barWidth: 3,
                            dotData: const FlDotData(show: false),
                          ),
                          LineChartBarData(
                            spots: const [
                              FlSpot(0, 115),
                              FlSpot(1, 138),
                              FlSpot(2, 165),
                              FlSpot(3, 185),
                              FlSpot(4, 215),
                              FlSpot(5, 270),
                            ],
                            isCurved: true,
                            dashArray: [6, 4],
                            color: AppColors.info,
                            barWidth: 2,
                            dotData: const FlDotData(show: false),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
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
                            Expanded(flex: 2, child: Text('SKU Code', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 3, child: Text('Product Item', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Historical 30D', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('AI Projected 30D', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Forecasted Lift', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Confidence Level', style: AppTextStyles.labelSmall)),
                          ],
                        ),
                      ),
                      ..._forecastItems.map((f) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide(color: AppColors.divider)),
                            ),
                            child: Row(
                              children: [
                                Expanded(flex: 2, child: Text(f['sku'] as String, style: AppTextStyles.mono)),
                                Expanded(flex: 3, child: Text(f['name'] as String, style: AppTextStyles.labelMedium)),
                                Expanded(flex: 2, child: Text(f['current30'] as String, style: AppTextStyles.bodySmall)),
                                Expanded(flex: 2, child: Text(f['projected30'] as String, style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary))),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    f['variance'] as String,
                                    style: AppTextStyles.labelSmall.copyWith(
                                      color: (f['variance'] as String).startsWith('+') ? AppColors.success : AppColors.danger,
                                    ),
                                  ),
                                ),
                                Expanded(flex: 2, child: AppBadge(label: f['confidence'] as String, variant: AppBadgeVariant.success, dot: true)),
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

