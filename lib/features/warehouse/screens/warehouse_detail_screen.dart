import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/responsive/responsive_layout.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/layouts/app_shell.dart';
import '../../../shared/widgets/badges/app_badge.dart';
import '../../../shared/widgets/buttons/app_button.dart';
import '../../../data/mock/mock_warehouses.dart';
import '../../../app/routes/app_routes.dart';

class WarehouseDetailScreen extends StatelessWidget {
  const WarehouseDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wh = (Get.arguments as Map<String, dynamic>?) ?? MockWarehouses.warehouses.first;
    final isDesktop = ResponsiveLayout.isDesktop(context);
    final isMobile = ResponsiveLayout.isMobile(context);

    final zoneCard = Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Zone Topology & Storage Layout', style: AppTextStyles.h3),
          const SizedBox(height: 16),
          _zoneTile('Zone A - High-Velocity Pallet Racks', 'Aisles 01-08 · 96 Locations', '82% Utilized', AppColors.primary),
          const SizedBox(height: 12),
          _zoneTile('Zone B - Small Parts & Bin Shelving', 'Aisles 09-14 · 84 Locations', '58% Utilized', AppColors.info),
          const SizedBox(height: 12),
          _zoneTile('Zone C - Bulky & Oversized Goods', 'Aisles 15-18 · 40 Locations', '45% Utilized', AppColors.warning),
          const SizedBox(height: 12),
          _zoneTile('Zone D - Staging & Packing Bays', 'Dock Doors 1-6 · 28 Locations', '60% Utilized', AppColors.textSecondary),
        ],
      ),
    );

    final specCard = Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Facility Telemetry', style: AppTextStyles.h4),
          const SizedBox(height: 16),
          _specRow('Operating Shifts', '2 Shifts (16 hrs/day)'),
          _specRow('Dock Doors', '6 Inbound / 4 Outbound'),
          _specRow('Active Forklifts', '4 Electric Units'),
          _specRow('RF Scanners Active', '12 Connected'),
          _specRow('Average Pick Rate', '42 units / man-hr'),
          _specRow('Cycle Count Frequency', 'Bi-weekly ABC cycle'),
        ],
      ),
    );

    return AppShell(
      breadcrumbs: ['Warehouse', 'Warehouses', wh['name'] as String],
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
                AppButton(
                  label: 'Back',
                  variant: AppButtonVariant.outline,
                  prefixIcon: Icons.arrow_back_rounded,
                  onPressed: () => Get.back(),
                ),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    AppButton(
                      label: 'Floor Plan',
                      variant: AppButtonVariant.outline,
                      prefixIcon: Icons.map_outlined,
                      onPressed: () => Get.toNamed(AppRoutes.locations),
                    ),
                    AppButton(
                      label: 'Operations Hub',
                      prefixIcon: Icons.precision_manufacturing_rounded,
                      onPressed: () => Get.toNamed(AppRoutes.warehouseOps),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: isMobile
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: AppColors.primarySurface,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.warehouse_rounded, size: 28, color: AppColors.primary),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(wh['name'] as String, style: AppTextStyles.h2, overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 4),
                                  AppBadge.fromStatus(wh['status'] as String),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text('${wh['code']} · ${wh['type']} Facility · Managed by ${wh['manager']}', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 16, color: AppColors.textMuted),
                            const SizedBox(width: 4),
                            Expanded(child: Text(wh['address'] as String, style: AppTextStyles.caption, overflow: TextOverflow.ellipsis)),
                          ],
                        ),
                        const Divider(height: 24),
                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 12,
                          runSpacing: 4,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Occupancy: ', style: AppTextStyles.caption),
                                Text(wh['capacity'] as String, style: AppTextStyles.h3.copyWith(color: AppColors.primary)),
                              ],
                            ),
                            Text('${wh['usedArea']} / ${wh['totalArea']}', style: AppTextStyles.caption),
                          ],
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: AppColors.primarySurface,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.warehouse_rounded, size: 36, color: AppColors.primary),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(wh['name'] as String, style: AppTextStyles.h2),
                                  const SizedBox(width: 12),
                                  AppBadge.fromStatus(wh['status'] as String),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text('${wh['code']} · ${wh['type']} Facility · Managed by ${wh['manager']}', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.location_on_outlined, size: 16, color: AppColors.textMuted),
                                  const SizedBox(width: 4),
                                  Text(wh['address'] as String, style: AppTextStyles.caption),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Occupancy', style: AppTextStyles.caption),
                            Text(wh['capacity'] as String, style: AppTextStyles.h1.copyWith(color: AppColors.primary)),
                            Text('${wh['usedArea']} / ${wh['totalArea']}', style: AppTextStyles.caption),
                          ],
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 24),
            if (isDesktop)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: zoneCard),
                  const SizedBox(width: 20),
                  Expanded(flex: 2, child: specCard),
                ],
              )
            else
              Column(
                children: [
                  zoneCard,
                  const SizedBox(height: 20),
                  specCard,
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _zoneTile(String name, String sub, String util, Color col) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.secondaryBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 38,
            decoration: BoxDecoration(color: col, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTextStyles.labelMedium, overflow: TextOverflow.ellipsis),
                Text(sub, style: AppTextStyles.caption, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          const SizedBox(width: 8),
          AppBadge(label: util, variant: AppBadgeVariant.neutral),
        ],
      ),
    );
  }

  Widget _specRow(String label, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.caption),
          const SizedBox(width: 8),
          Flexible(
            child: Text(val, style: AppTextStyles.labelMedium, overflow: TextOverflow.ellipsis, textAlign: TextAlign.right),
          ),
        ],
      ),
    );
  }
}

