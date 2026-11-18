import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/responsive/responsive_layout.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/layouts/app_shell.dart';
import '../../../shared/widgets/badges/app_badge.dart';
import '../../../shared/widgets/buttons/app_button.dart';
import '../../../shared/widgets/inputs/app_text_field.dart';
import '../../../shared/controllers/warehouse_controller.dart';
import '../../../data/models/warehouse_model.dart';
import '../../../app/routes/app_routes.dart';

class WarehouseListScreen extends StatelessWidget {
  const WarehouseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<WarehouseController>();
    final isDesktop = ResponsiveLayout.isDesktop(context);

    return AppShell(
      breadcrumbs: const ['Warehouse', 'Warehouses'],
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
                    Text('Warehouse Facilities', style: AppTextStyles.h1),
                    const SizedBox(height: 4),
                    Text('Manage fulfillment hubs, regional depots, cold storage, and distribution zones', style: AppTextStyles.bodySmall),
                  ],
                ),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    AppButton(
                      label: 'Stock Transfers',
                      variant: AppButtonVariant.outline,
                      prefixIcon: Icons.compare_arrows_rounded,
                      onPressed: () => Get.toNamed(AppRoutes.transfers),
                    ),
                    AppButton(
                      label: 'Add Warehouse',
                      prefixIcon: Icons.add_business_rounded,
                      onPressed: () => Get.toNamed(AppRoutes.warehouseAdd),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            AppSearchField(
              hint: 'Search warehouses by name, location, or facility code...',
              onChanged: (q) => ctrl.searchQuery.value = q,
            ),
            const SizedBox(height: 20),
            Obx(() {
              if (ctrl.isLoading.value) {
                return const Center(child: Padding(
                  padding: EdgeInsets.all(40),
                  child: CircularProgressIndicator(),
                ));
              }
              final warehouses = ctrl.filteredWarehouses;
              if (warehouses.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      children: [
                        const Icon(Icons.warehouse_outlined, size: 48, color: AppColors.textMuted),
                        const SizedBox(height: 12),
                        Text('No warehouses found', style: AppTextStyles.h4),
                        const SizedBox(height: 8),
                        AppButton(
                          label: 'Add Warehouse',
                          prefixIcon: Icons.add_business_rounded,
                          onPressed: () => Get.toNamed(AppRoutes.warehouseAdd),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: warehouses.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isDesktop ? 2 : 1,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: isDesktop ? 1.65 : 1.35,
                ),
                itemBuilder: (context, idx) {
                  return _buildWarehouseCard(warehouses[idx]);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildWarehouseCard(WarehouseModel wh) {
    return Container(
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
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.warehouse_rounded, size: 24, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(wh.name, style: AppTextStyles.h3, overflow: TextOverflow.ellipsis),
                    Text('${wh.code} · ${wh.type}', style: AppTextStyles.caption),
                  ],
                ),
              ),
              AppBadge.fromStatus(wh.status),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 16, color: AppColors.textMuted),
              const SizedBox(width: 6),
              Expanded(child: Text(wh.address, style: AppTextStyles.bodySmall, overflow: TextOverflow.ellipsis)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.person_outline_rounded, size: 16, color: AppColors.textMuted),
              const SizedBox(width: 6),
              Expanded(
                child: Text('Manager: ${wh.manager}', style: AppTextStyles.bodySmall, overflow: TextOverflow.ellipsis),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.phone_outlined, size: 16, color: AppColors.textMuted),
              const SizedBox(width: 4),
              Text(wh.phone, style: AppTextStyles.caption),
            ],
          ),
          const Spacer(),
          const Divider(height: 1),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                _metric('Zones', '${wh.zones}'),
                const SizedBox(width: 20),
                _metric('Locations', '${wh.locations}'),
                const SizedBox(width: 20),
                _metric('SKUs Hosted', '${wh.products}'),
                const SizedBox(width: 20),
                _metric('Capacity', wh.capacity),
                const SizedBox(width: 20),
                AppButton(
                  label: 'Manage',
                  variant: AppButtonVariant.outline,
                  onPressed: () => Get.toNamed(AppRoutes.warehouseDetail, arguments: wh),
                  height: 32,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _metric(String label, String val) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(val, style: AppTextStyles.labelLarge),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}
