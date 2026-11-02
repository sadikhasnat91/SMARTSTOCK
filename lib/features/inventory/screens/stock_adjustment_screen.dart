import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/responsive/responsive_layout.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/layouts/app_shell.dart';
import '../../../shared/widgets/buttons/app_button.dart';
import '../../../shared/widgets/inputs/app_text_field.dart';
import '../../../data/mock/mock_products.dart';

class StockAdjustmentScreen extends StatefulWidget {
  const StockAdjustmentScreen({super.key});

  @override
  State<StockAdjustmentScreen> createState() => _StockAdjustmentScreenState();
}

class _StockAdjustmentScreenState extends State<StockAdjustmentScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedWarehouse = 'WH-Main';
  String? _selectedProduct = 'ELC-0042';
  String? _adjustmentType = 'Correction';
  final _qtyCtrl = TextEditingController(text: '5');
  final _notesCtrl = TextEditingController();

  final _warehouses = ['WH-Main', 'WH-East', 'WH-West', 'WH-Cold'];
  final _types = ['Correction', 'Damaged Goods', 'Stocktake Variance', 'Loss / Theft', 'Found Item', 'Internal Sample'];

  @override
  Widget build(BuildContext context) {
    final prod = MockProducts.products.firstWhere((p) => p['sku'] == _selectedProduct, orElse: () => MockProducts.products.first);
    final currentStock = prod['stock'] as int;
    final isDesktop = ResponsiveLayout.isDesktop(context);
    final isMobile = ResponsiveLayout.isMobile(context);

    final paramCard = Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Adjustment Parameters', style: AppTextStyles.h3),
          const SizedBox(height: 20),
          if (isMobile) ...[
            AppDropdownField<String>(
              label: 'Target Warehouse *',
              value: _selectedWarehouse,
              items: _warehouses.map((w) => DropdownMenuItem(value: w, child: Text(w))).toList(),
              onChanged: (v) => setState(() => _selectedWarehouse = v),
            ),
            const SizedBox(height: 16),
            AppDropdownField<String>(
              label: 'Adjustment Reason / Type *',
              value: _adjustmentType,
              items: _types.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
              onChanged: (v) => setState(() => _adjustmentType = v),
            ),
          ] else
            Row(
              children: [
                Expanded(
                  child: AppDropdownField<String>(
                    label: 'Target Warehouse *',
                    value: _selectedWarehouse,
                    items: _warehouses.map((w) => DropdownMenuItem(value: w, child: Text(w))).toList(),
                    onChanged: (v) => setState(() => _selectedWarehouse = v),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppDropdownField<String>(
                    label: 'Adjustment Reason / Type *',
                    value: _adjustmentType,
                    items: _types.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                    onChanged: (v) => setState(() => _adjustmentType = v),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 16),
          AppDropdownField<String>(
            label: 'Select Product / SKU *',
            value: _selectedProduct,
            items: MockProducts.products.map((p) => DropdownMenuItem(
              value: p['sku'] as String,
              child: Text('${p['sku']} - ${p['name']} (OnHand: ${p['stock']})', overflow: TextOverflow.ellipsis),
            )).toList(),
            onChanged: (v) => setState(() => _selectedProduct = v),
          ),
          const SizedBox(height: 16),
          if (isMobile) ...[
            AppTextField(
              label: 'Adjustment Quantity (+ / -) *',
              hint: 'e.g. +10 or -3',
              controller: _qtyCtrl,
              keyboardType: TextInputType.number,
              prefixIcon: Icons.swap_vert_rounded,
              validator: (v) => (v != null && v.isNotEmpty) ? null : 'Required',
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Calculated New Balance', style: AppTextStyles.labelMedium),
                const SizedBox(height: 6),
                Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: AppColors.secondaryBackground,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(
                    '${currentStock + (int.tryParse(_qtyCtrl.text) ?? 0)} ${prod['unit']}',
                    style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ] else
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    label: 'Adjustment Quantity (+ / -) *',
                    hint: 'e.g. +10 or -3',
                    controller: _qtyCtrl,
                    keyboardType: TextInputType.number,
                    prefixIcon: Icons.swap_vert_rounded,
                    validator: (v) => (v != null && v.isNotEmpty) ? null : 'Required',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Calculated New Balance', style: AppTextStyles.labelMedium),
                      const SizedBox(height: 6),
                      Container(
                        height: 44,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: AppColors.secondaryBackground,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Text(
                          '${currentStock + (int.tryParse(_qtyCtrl.text) ?? 0)} ${prod['unit']}',
                          style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Audit Justification Notes *',
            hint: 'Provide context for this adjustment, referencing physical count sheet or incident report...',
            controller: _notesCtrl,
            maxLines: 4,
          ),
        ],
      ),
    );

    final summaryCard = Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Verification Summary', style: AppTextStyles.h4),
          const SizedBox(height: 16),
          _summaryRow('Product', prod['name'] as String),
          _summaryRow('SKU', prod['sku'] as String),
          _summaryRow('Warehouse Hub', _selectedWarehouse ?? ''),
          _summaryRow('Current Physical', '$currentStock ${prod['unit']}'),
          _summaryRow('Unit Valuation', '\$${(prod['costPrice'] as double).toStringAsFixed(2)}'),
          const Divider(height: 24),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.shield_outlined, size: 20, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Adjustments are permanently recorded in the inventory audit ledger with user ID and timestamp.',
                    style: AppTextStyles.caption.copyWith(color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return AppShell(
      breadcrumbs: const ['Inventory', 'Stock Adjustment'],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.contentPadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 12,
                runSpacing: 12,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppIconButton(
                        icon: Icons.arrow_back_rounded,
                        tooltip: 'Back',
                        onPressed: () => Get.back(),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text('Stock Adjustment', style: AppTextStyles.h2, overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      AppButton(
                        label: 'Cancel',
                        variant: AppButtonVariant.ghost,
                        onPressed: () => Get.back(),
                      ),
                      AppButton(
                        label: 'Post Adjustment',
                        prefixIcon: Icons.check_circle_outline,
                        onPressed: _submit,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (isDesktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: paramCard),
                    const SizedBox(width: 20),
                    Expanded(flex: 2, child: summaryCard),
                  ],
                )
              else
                Column(
                  children: [
                    paramCard,
                    const SizedBox(height: 20),
                    summaryCard,
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
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

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Get.snackbar(
        'Adjustment Posted',
        'Stock adjustment ADJ-2026-081 created successfully.',
        backgroundColor: AppColors.success,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.back();
    }
  }

  @override
  void dispose() {
    _qtyCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }
}

