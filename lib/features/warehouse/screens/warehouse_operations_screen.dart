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
import '../../../app/routes/app_routes.dart';

class WarehouseOperationsScreen extends StatelessWidget {
  const WarehouseOperationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveLayout.isDesktop(context);

    final dockCard = Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Live Dock Schedule & Gate Appointments', style: AppTextStyles.h3),
          const SizedBox(height: 16),
          _dockRow('Bay 1 (Inbound)', 'Carrier: DHL Freight · PO-2024-0343 · 8 Pallets', 'Unloading', AppColors.info),
          const SizedBox(height: 12),
          _dockRow('Bay 2 (Inbound)', 'Carrier: Apex Express · TRF-0092 · 28 Boxes', 'Docked', AppColors.warning),
          const SizedBox(height: 12),
          _dockRow('Bay 3 (Outbound)', 'Carrier: FedEx Ground · SO-2024-0890 · Bulk LTL', 'Loading', AppColors.success),
          const SizedBox(height: 12),
          _dockRow('Bay 4 (Outbound)', 'Carrier: SAIA Logistics · Scheduled 14:30', 'Awaiting Arrival', AppColors.textMuted),
        ],
      ),
    );

    final fleetCard = Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Equipment & Fleet Status', style: AppTextStyles.h4),
          const SizedBox(height: 16),
          _fleetItem('Electric Forklift #01', 'Operator: Ahmed R. · Battery 92%', 'Active'),
          _fleetItem('Electric Forklift #02', 'Operator: Kamal H. · Battery 74%', 'Active'),
          _fleetItem('Reach Truck #03', 'Zone A High Racks · Battery 88%', 'Active'),
          _fleetItem('Hand Pallet Jack #07', 'Staging Area D · Manual', 'Standby'),
        ],
      ),
    );

    return AppShell(
      breadcrumbs: const ['Warehouse', 'Operations Hub'],
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
                    Text('Floor Operations Command Center', style: AppTextStyles.h1),
                    const SizedBox(height: 4),
                    Text('Real-time warehouse floor task queue, dock appointments, and material handling status', style: AppTextStyles.bodySmall),
                  ],
                ),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    AppButton(
                      label: 'Inbound Receiving',
                      variant: AppButtonVariant.outline,
                      prefixIcon: Icons.move_to_inbox_rounded,
                      onPressed: () => Get.toNamed(AppRoutes.goodsReceiving),
                    ),
                    AppButton(
                      label: 'Picking Queue',
                      prefixIcon: Icons.checklist_rounded,
                      onPressed: () => Get.toNamed(AppRoutes.pickingDashboard),
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
                  SizedBox(width: 200, child: KpiCard(label: 'Pending Inbound Putaways', value: '14 Pallets', icon: Icons.archive_rounded, iconColor: AppColors.info)),
                  SizedBox(width: 14),
                  SizedBox(width: 200, child: KpiCard(label: 'Active Pick Waves', value: '8 Waves', icon: Icons.shopping_basket_outlined, iconColor: AppColors.primary)),
                  SizedBox(width: 14),
                  SizedBox(width: 200, child: KpiCard(label: 'Staged for Dispatch', value: '26 Shipments', icon: Icons.local_shipping_outlined, iconColor: AppColors.success)),
                  SizedBox(width: 14),
                  SizedBox(width: 200, child: KpiCard(label: 'Dock Utilization', value: '83.3%', icon: Icons.door_front_door_outlined, iconColor: AppColors.warning)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (isDesktop)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: dockCard),
                  const SizedBox(width: 20),
                  Expanded(flex: 2, child: fleetCard),
                ],
              )
            else
              Column(
                children: [
                  dockCard,
                  const SizedBox(height: 20),
                  fleetCard,
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _dockRow(String bay, String carrier, String status, Color col) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.secondaryBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 6,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4), border: Border.all(color: AppColors.border)),
                child: Text(bay, style: AppTextStyles.labelSmall),
              ),
              AppBadge(label: status, variant: AppBadgeVariant.neutral),
            ],
          ),
          const SizedBox(height: 8),
          Text(carrier, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }

  Widget _fleetItem(String title, String sub, String status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.precision_manufacturing_rounded, size: 20, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.labelSmall, overflow: TextOverflow.ellipsis),
                Text(sub, style: AppTextStyles.caption, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          const SizedBox(width: 8),
          AppBadge(label: status, variant: AppBadgeVariant.success, dot: true),
        ],
      ),
    );
  }
}

