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
import '../../../data/mock/mock_products.dart';
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
    var items = MockProducts.stockMovements;
    if (_selectedType != 'All Types') {
      items = items.where((m) => m['type'] == _selectedType).toList();
    }

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
                      label: 'Export Ledger',
                      variant: AppButtonVariant.outline,
                      prefixIcon: Icons.file_download_outlined,
                      onPressed: () {},
                    ),
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
            Container(
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
                      ...items.map((m) {
                        final isInbound = m['type'] == 'Inbound';
                        final isOutbound = m['type'] == 'Outbound';
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                          decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(color: AppColors.divider)),
                          ),
                          child: Row(
                            children: [
                              Expanded(flex: 2, child: Text(m['reference'] as String, style: AppTextStyles.mono)),
                              Expanded(flex: 2, child: AppBadge.fromStatus(m['type'] as String)),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(m['product'] as String, style: AppTextStyles.labelMedium, overflow: TextOverflow.ellipsis),
                                    Text(m['sku'] as String, style: AppTextStyles.caption),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  '${isInbound ? "+" : isOutbound ? "-" : ""}${(m['qty'] as int).abs()} units',
                                  style: AppTextStyles.labelMedium.copyWith(
                                    color: isInbound ? AppColors.success : isOutbound ? AppColors.danger : AppColors.info,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Expanded(flex: 3, child: Text(m['warehouse'] as String, style: AppTextStyles.bodySmall, overflow: TextOverflow.ellipsis)),
                              Expanded(flex: 2, child: Text(m['date'] as String, style: AppTextStyles.caption)),
                              Expanded(
                                flex: 2,
                                child: Row(
                                  children: [
                                    const Icon(Icons.person_pin_circle_outlined, size: 16, color: AppColors.textMuted),
                                    const SizedBox(width: 4),
                                    Expanded(child: Text(m['user'] as String, style: AppTextStyles.bodySmall, overflow: TextOverflow.ellipsis)),
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
            ),
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

