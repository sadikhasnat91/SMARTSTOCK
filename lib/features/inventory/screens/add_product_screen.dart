import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/responsive/responsive_layout.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/layouts/app_shell.dart';
import '../../../shared/widgets/buttons/app_button.dart';
import '../../../shared/widgets/inputs/app_text_field.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});
  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _skuCtrl = TextEditingController();
  final _brandCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _costCtrl = TextEditingController();
  final _sellCtrl = TextEditingController();
  final _minStockCtrl = TextEditingController();
  final _maxStockCtrl = TextEditingController();
  String? _selectedCategory;
  String? _selectedUnit;
  String? _selectedWarehouse;

  final _categories = ['Electronics', 'Office Supplies', 'Furniture', 'Packaging', 'Tools'];
  final _units = ['PCS', 'REAM', 'SET', 'ROLL', 'KG', 'L', 'BOX'];
  final _warehouses = ['WH-Main', 'WH-East', 'WH-West', 'WH-Cold'];

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveLayout.isDesktop(context);

    final leftContent = [
      _buildSection('Basic Information', [
        AppTextField(label: 'Product Name *', hint: 'Enter product name', controller: _nameCtrl, validator: (v) => v!.isEmpty ? 'Required' : null),
        const SizedBox(height: 14),
        Row(children: [
          Expanded(child: AppTextField(label: 'SKU *', hint: 'e.g. ELC-0001', controller: _skuCtrl, validator: (v) => v!.isEmpty ? 'Required' : null)),
          const SizedBox(width: 14),
          Expanded(child: AppTextField(label: 'Brand', hint: 'Brand name', controller: _brandCtrl)),
        ]),
        const SizedBox(height: 14),
        Row(children: [
          Expanded(child: AppDropdownField<String>(
            label: 'Category *',
            value: _selectedCategory,
            items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
            onChanged: (v) => setState(() => _selectedCategory = v),
          )),
          const SizedBox(width: 14),
          Expanded(child: AppDropdownField<String>(
            label: 'Unit',
            value: _selectedUnit,
            items: _units.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
            onChanged: (v) => setState(() => _selectedUnit = v),
          )),
        ]),
        const SizedBox(height: 14),
        AppTextField(label: 'Description', hint: 'Product description...', controller: _descCtrl, maxLines: 4),
      ]),
      const SizedBox(height: 16),
      _buildSection('Pricing', [
        Row(children: [
          Expanded(child: AppTextField(label: 'Cost Price (\$)', hint: '0.00', controller: _costCtrl, keyboardType: TextInputType.number)),
          const SizedBox(width: 14),
          Expanded(child: AppTextField(label: 'Selling Price (\$)', hint: '0.00', controller: _sellCtrl, keyboardType: TextInputType.number)),
        ]),
      ]),
    ];

    final rightContent = [
      _buildSection('Stock Settings', [
        AppDropdownField<String>(
          label: 'Warehouse',
          value: _selectedWarehouse,
          items: _warehouses.map((w) => DropdownMenuItem(value: w, child: Text(w))).toList(),
          onChanged: (v) => setState(() => _selectedWarehouse = v),
        ),
        const SizedBox(height: 14),
        Row(children: [
          Expanded(child: AppTextField(label: 'Min Stock Level', hint: '0', controller: _minStockCtrl, keyboardType: TextInputType.number)),
          const SizedBox(width: 14),
          Expanded(child: AppTextField(label: 'Max Stock Level', hint: '0', controller: _maxStockCtrl, keyboardType: TextInputType.number)),
        ]),
      ]),
      const SizedBox(height: 16),
      _buildSection('Product Image', [
        Container(
          height: 160,
          decoration: BoxDecoration(
            color: AppColors.secondaryBackground,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border, style: BorderStyle.solid),
          ),
          child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.cloud_upload_outlined, size: 36, color: AppColors.textMuted),
            const SizedBox(height: 8),
            Text('Click to upload image', style: AppTextStyles.bodySmall),
            Text('PNG, JPG up to 5MB', style: AppTextStyles.caption),
          ])),
        ),
      ]),
      const SizedBox(height: 16),
      _buildSection('Barcode', [
        AppTextField(label: 'Barcode / EAN', hint: 'Scan or enter barcode', prefixIcon: Icons.qr_code_scanner),
      ]),
    ];

    return AppShell(
      breadcrumbs: const ['Inventory', 'Products', 'Add Product'],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.contentPadding),
        child: Form(
          key: _formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                      child: Text('Add New Product', style: AppTextStyles.h2, overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    AppButton(label: 'Save as Draft', variant: AppButtonVariant.outline, onPressed: () {}),
                    AppButton(label: 'Create Product', prefixIcon: Icons.check_rounded, onPressed: _submit),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (isDesktop)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: Column(children: leftContent)),
                  const SizedBox(width: 20),
                  Expanded(flex: 2, child: Column(children: rightContent)),
                ],
              )
            else
              Column(
                children: [
                  ...leftContent,
                  const SizedBox(height: 16),
                  ...rightContent,
                ],
              ),
          ]),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: AppTextStyles.h4),
        const SizedBox(height: 16),
        ...children,
      ]),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Get.snackbar(
        'Product Created',
        'Product has been added to inventory',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.success,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      Get.back();
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose(); _skuCtrl.dispose(); _brandCtrl.dispose();
    _descCtrl.dispose(); _costCtrl.dispose(); _sellCtrl.dispose();
    _minStockCtrl.dispose(); _maxStockCtrl.dispose();
    super.dispose();
  }
}

