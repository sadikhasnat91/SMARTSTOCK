import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/responsive/responsive_layout.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/layouts/app_shell.dart';
import '../../../shared/widgets/buttons/app_button.dart';
import '../../../shared/widgets/inputs/app_text_field.dart';
import '../../../shared/widgets/dialogs/app_dialog.dart';
import '../../../shared/controllers/product_controller.dart';
import '../../../data/models/product_model.dart';
import '../../../app/routes/app_routes.dart';

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
  final _initialStockCtrl = TextEditingController(text: '10');
  final _minStockCtrl = TextEditingController(text: '5');
  final _maxStockCtrl = TextEditingController(text: '100');
  final _barcodeCtrl = TextEditingController();
  String? _selectedCategory = 'Electronics';
  String? _selectedUnit = 'PCS';
  String? _selectedWarehouse = 'WH-Main';
  bool _isEditing = false;
  String? _editingId;

  final _categories = ['Electronics', 'Office Supplies', 'Furniture', 'Packaging', 'Tools'];
  final _units = ['PCS', 'REAM', 'SET', 'ROLL', 'KG', 'L', 'BOX'];
  final _warehouses = ['WH-Main', 'WH-East', 'WH-West', 'WH-Cold'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initFromArgs();
    });
  }

  void _initFromArgs() {
    final args = Get.arguments;
    if (args != null) {
      ProductModel? model;
      if (args is ProductModel) {
        model = args;
      } else if (args is Map<String, dynamic>) {
        model = ProductModel.fromJson(args);
      }
      if (model != null) {
        setState(() {
          _isEditing = true;
          _editingId = model!.id;
          _nameCtrl.text = model.name;
          _skuCtrl.text = model.sku;
          _brandCtrl.text = model.brand;
          _descCtrl.text = model.description;
          _costCtrl.text = model.costPrice.toString();
          _sellCtrl.text = model.sellingPrice.toString();
          _initialStockCtrl.text = model.stock.toString();
          _minStockCtrl.text = model.minStock.toString();
          _maxStockCtrl.text = model.maxStock.toString();
          _barcodeCtrl.text = model.barcode;
          if (_categories.contains(model.category)) {
            _selectedCategory = model.category;
          }
          if (_units.contains(model.unit)) {
            _selectedUnit = model.unit;
          }
          if (_warehouses.contains(model.warehouse)) {
            _selectedWarehouse = model.warehouse;
          }
        });
      }
    }
  }

  void _clearForm() {
    _nameCtrl.clear();
    _skuCtrl.clear();
    _brandCtrl.clear();
    _descCtrl.clear();
    _costCtrl.clear();
    _sellCtrl.clear();
    _initialStockCtrl.text = '10';
    _minStockCtrl.text = '5';
    _maxStockCtrl.text = '100';
    _barcodeCtrl.clear();
    setState(() {
      _selectedCategory = 'Electronics';
      _selectedUnit = 'PCS';
      _selectedWarehouse = 'WH-Main';
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveLayout.isDesktop(context);
    final productCtrl = Get.find<ProductController>();

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
        if (!_isEditing) ...[
          const SizedBox(height: 14),
          AppTextField(label: 'Initial Stock', hint: '0', controller: _initialStockCtrl, keyboardType: TextInputType.number),
        ],
      ]),
      const SizedBox(height: 16),
      _buildSection('Barcode & Identification', [
        AppTextField(label: 'Barcode (EAN-13 / Code-128)', hint: 'Leave blank to auto-generate', controller: _barcodeCtrl),
      ]),
    ];

    return AppShell(
      breadcrumbs: ['Inventory', 'Products', _isEditing ? 'Edit Product' : 'Add Product'],
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
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(_isEditing ? 'Edit Product' : 'New Product Registration', style: AppTextStyles.h1),
                  const SizedBox(height: 4),
                  Text(_isEditing ? 'Update catalog details, pricing, and reorder levels' : 'Configure catalog attributes, SKU categorization, pricing, and stock limits', style: AppTextStyles.bodySmall),
                ]),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    AppButton(
                      label: 'Cancel',
                      variant: AppButtonVariant.outline,
                      onPressed: () => Get.back(),
                    ),
                    Obx(() => AppButton(
                      label: _isEditing ? 'Save Changes' : 'Create Product',
                      prefixIcon: _isEditing ? Icons.save_outlined : Icons.check_circle_outline,
                      loading: productCtrl.isSubmitting.value,
                      onPressed: productCtrl.isSubmitting.value ? null : _submit,
                    )),
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

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final productCtrl = Get.find<ProductController>();
      final prodId = _isEditing && _editingId != null
          ? _editingId!
          : 'PRD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

      final newProduct = ProductModel(
        id: prodId,
        sku: _skuCtrl.text.trim().toUpperCase(),
        name: _nameCtrl.text.trim(),
        brand: _brandCtrl.text.trim(),
        category: _selectedCategory ?? 'Electronics',
        unit: _selectedUnit ?? 'PCS',
        description: _descCtrl.text.trim(),
        costPrice: double.tryParse(_costCtrl.text.trim()) ?? 0.0,
        sellingPrice: double.tryParse(_sellCtrl.text.trim()) ?? 0.0,
        stock: int.tryParse(_initialStockCtrl.text.trim()) ?? 10,
        minStock: int.tryParse(_minStockCtrl.text.trim()) ?? 5,
        maxStock: int.tryParse(_maxStockCtrl.text.trim()) ?? 100,
        warehouse: _selectedWarehouse ?? 'WH-Main',
        barcode: _barcodeCtrl.text.trim().isNotEmpty
            ? _barcodeCtrl.text.trim()
            : '890${DateTime.now().millisecondsSinceEpoch.toString().substring(3)}',
      );

      final success = _isEditing
          ? await productCtrl.updateProduct(newProduct)
          : await productCtrl.addProduct(newProduct);

      if (success) {
        // Clear all form input fields completely
        _clearForm();

        // Show confirmation success dialog box
        if (mounted) {
          _showSuccessDialog(newProduct.name, newProduct.sku);
        }
      }
    }
  }

  void _showSuccessDialog(String productName, String sku) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AppDialog(
        title: _isEditing ? 'Product Updated' : 'Product Saved Successfully',
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 36),
              ),
              const SizedBox(height: 16),
              Text(
                productName,
                style: AppTextStyles.h3,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                'SKU: $sku',
                style: AppTextStyles.mono.copyWith(color: AppColors.textMuted),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                _isEditing
                    ? 'The product details have been successfully updated in the database.'
                    : 'The product has been permanently saved to Supabase PostgreSQL database.',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        actions: [
          AppButton(
            label: 'Add Another Product',
            variant: AppButtonVariant.outline,
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
          AppButton(
            label: 'View Product List',
            prefixIcon: Icons.list_alt_rounded,
            onPressed: () {
              Navigator.of(ctx).pop();
              Get.offNamed(AppRoutes.products);
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _skuCtrl.dispose();
    _brandCtrl.dispose();
    _descCtrl.dispose();
    _costCtrl.dispose();
    _sellCtrl.dispose();
    _initialStockCtrl.dispose();
    _minStockCtrl.dispose();
    _maxStockCtrl.dispose();
    _barcodeCtrl.dispose();
    super.dispose();
  }
}
