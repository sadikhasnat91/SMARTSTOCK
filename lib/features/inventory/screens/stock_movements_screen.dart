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
import '../../../shared/controllers/product_controller.dart';
import '../../../app/routes/app_routes.dart';

class StockMovementsScreen extends StatefulWidget {
  const StockMovementsScreen({super.key});

  @override
  State<StockMovementsScreen> createState() => _StockMovementsScreenState();
}

class _StockMovementsScreenState extends State<StockMovementsScreen> {
  String _selectedType = 'All Types';
  final _searchCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final prodCtrl = Get.find<ProductController>();
    final isMobile = ResponsiveLayout.isMobile(context);

    return AppShell(
      breadcrumbs: const ['Inventory', 'Stock Movements'],
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
                    Text('Stock Movement Ledger', style: AppTextStyles.h1),
                    const SizedBox(height: 4),
                    Text('Complete immutable audit log of all inbound, outbound, transfer, and adjustment transactions', style: AppTextStyles.bodySmall),
                  ],
                ),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    AppButton(
                      label: 'New Adjustment',
                      prefixIcon: Icons.add_rounded,
                      onPressed: () => Get.toNamed(AppRoutes.stockAdjustment),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: isMobile
                  ? Column(
                      children: [
                        AppSearchField(
                          hint: 'Filter reference, SKU, user...',
                          controller: _searchCtrl,
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: 12),
                        AppDropdownField<String>(
                          label: null,
                          value: _selectedType,
                          items: const [
                            DropdownMenuItem(value: 'All Types', child: Text('All Types')),
                            DropdownMenuItem(value: 'Inbound', child: Text('Inbound')),
                            DropdownMenuItem(value: 'Outbound', child: Text('Outbound')),
                            DropdownMenuItem(value: 'Transfer', child: Text('Transfer')),
                            DropdownMenuItem(value: 'Adjustment', child: Text('Adjustment')),
                          ],
                          onChanged: (v) => setState(() => _selectedType = v ?? 'All Types'),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: AppSearchField(
                            hint: 'Filter by reference code, SKU, or user...',
                            controller: _searchCtrl,
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                        const SizedBox(width: 16),
                        SizedBox(
                          width: 180,
                          child: AppDropdownField<String>(
                            label: null,
                            value: _selectedType,
                            items: const [
                              DropdownMenuItem(value: 'All Types', child: Text('All Types')),
                              DropdownMenuItem(value: 'Inbound', child: Text('Inbound')),
                              DropdownMenuItem(value: 'Outbound', child: Text('Outbound')),
                              DropdownMenuItem(value: 'Transfer', child: Text('Transfer')),
                              DropdownMenuItem(value: 'Adjustment', child: Text('Adjustment')),
                            ],
                            onChanged: (v) => setState(() => _selectedType = v ?? 'All Types'),
                          ),
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 20),
            Obx(() {
              var items = prodCtrl.movements.toList();
              if (_selectedType != 'All Types') {
                items = items.where((m) => m.type.toLowerCase() == _selectedType.toLowerCase()).toList();
              }
              final q = _searchCtrl.text.trim().toLowerCase();
              if (q.isNotEmpty) {
                items = items.where((m) =>
                  m.reference.toLowerCase().contains(q) ||
                  m.product.toLowerCase().contains(q) ||
                  m.sku.toLowerCase().contains(q) ||
                  m.user.toLowerCase().contains(q)
                ).toList();
              }

              return Container(
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
                              Expanded(flex: 2, child: Text('Reference ID', style: AppTextStyles.labelSmall)),
                              Expanded(flex: 2, child: Text('Transaction', style: AppTextStyles.labelSmall)),
                              Expanded(flex: 3, child: Text('Product / SKU', style: AppTextStyles.labelSmall)),
                              Expanded(flex: 2, child: Text('Quantity Changed', style: AppTextStyles.labelSmall)),
                              Expanded(flex: 3, child: Text('Warehouse Route', style: AppTextStyles.labelSmall)),
                              Expanded(flex: 2, child: Text('Timestamp', style: AppTextStyles.labelSmall)),
                              Expanded(flex: 2, child: Text('Logged By', style: AppTextStyles.labelSmall)),
                            ],
                          ),
                        ),
                        if (items.isEmpty)
                          Padding(
                            padding: const EdgeInsets.all(32),
                            child: Text('No stock movements recorded', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted)),
                          )
                        else
                          ...items.map((m) {
                            final isInbound = m.type.toLowerCase() == 'inbound';
                            final isOutbound = m.type.toLowerCase() == 'outbound';
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                              decoration: const BoxDecoration(
                                border: Border(bottom: BorderSide(color: AppColors.divider)),
                              ),
                              child: Row(
                                children: [
                                  Expanded(flex: 2, child: Text(m.reference, style: AppTextStyles.mono)),
                                  Expanded(flex: 2, child: AppBadge.fromStatus(m.type)),
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(m.product, style: AppTextStyles.labelMedium, overflow: TextOverflow.ellipsis),
                                        Text(m.sku, style: AppTextStyles.caption),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      '${isInbound ? "+" : isOutbound ? "-" : ""}${m.quantity.abs()} units',
                                      style: AppTextStyles.labelMedium.copyWith(
                                        color: isInbound ? AppColors.success : isOutbound ? AppColors.danger : AppColors.info,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Expanded(flex: 3, child: Text(m.to != '-' ? m.to : m.from, style: AppTextStyles.bodySmall, overflow: TextOverflow.ellipsis)),
                                  Expanded(flex: 2, child: Text(m.date, style: AppTextStyles.caption)),
                                  Expanded(
                                    flex: 2,
                                    child: Row(
                                      children: [
                                        const Icon(Icons.person_pin_circle_outlined, size: 16, color: AppColors.textMuted),
                                        const SizedBox(width: 4),
                                        Expanded(child: Text(m.user, style: AppTextStyles.bodySmall, overflow: TextOverflow.ellipsis)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }
}
