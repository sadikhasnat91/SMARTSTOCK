import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/layouts/app_shell.dart';
import '../../../shared/widgets/badges/app_badge.dart';
import '../../../shared/widgets/buttons/app_button.dart';
import '../../../shared/widgets/inputs/app_text_field.dart';
import '../../../shared/widgets/tables/app_data_table.dart';
import '../../../shared/widgets/dialogs/app_dialog.dart';
import '../../../data/mock/mock_products.dart';
import '../../../app/routes/app_routes.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final _searchCtrl = TextEditingController();
  String _filterCategory = 'All';
  String _filterStatus = 'All';
  int _currentPage = 1;
  final int _pageSize = 8;
  List<Map<String, dynamic>> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _filteredProducts = MockProducts.products;
    _searchCtrl.addListener(_applyFilter);
  }

  void _applyFilter() {
    final q = _searchCtrl.text.toLowerCase();
    setState(() {
      _filteredProducts = MockProducts.products.where((p) {
        final matchSearch = q.isEmpty ||
            (p['name'] as String).toLowerCase().contains(q) ||
            (p['sku'] as String).toLowerCase().contains(q);
        final matchCat = _filterCategory == 'All' || p['category'] == _filterCategory;
        final matchStatus = _filterStatus == 'All' || p['status'] == _filterStatus;
        return matchSearch && matchCat && matchStatus;
      }).toList();
      _currentPage = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    final categories = ['All', ...MockProducts.categories.map((c) => c['name'] as String)];
    final statuses = ['All', 'In Stock', 'Low Stock', 'Critical'];
    final totalPages = (_filteredProducts.length / _pageSize).ceil();
    final start = (_currentPage - 1) * _pageSize;
    final end = (start + _pageSize).clamp(0, _filteredProducts.length);
    final pageProducts = _filteredProducts.sublist(start, end);

    return AppShell(
      breadcrumbs: const ['Inventory', 'Products'],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.contentPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Products', style: AppTextStyles.h1),
                  const SizedBox(height: 4),
                  Text('${MockProducts.products.length} total products', style: AppTextStyles.bodySmall),
                ]),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    AppButton(
                      label: 'Import',
                      variant: AppButtonVariant.outline,
                      prefixIcon: Icons.upload_outlined,
                      onPressed: () {},
                    ),
                    AppButton(
                      label: 'Export',
                      variant: AppButtonVariant.outline,
                      prefixIcon: Icons.download_outlined,
                      onPressed: () {},
                    ),
                    AppButton(
                      label: 'Add Product',
                      prefixIcon: Icons.add_rounded,
                      onPressed: () => Get.toNamed(AppRoutes.productAdd),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Filters
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border, width: 1),
              ),
              child: isMobile
                  ? Column(
                      children: [
                        AppSearchField(
                          hint: 'Search products by name or SKU...',
                          controller: _searchCtrl,
                          onChanged: (_) => _applyFilter(),
                          onClear: () {
                            _searchCtrl.clear();
                            _applyFilter();
                          },
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _FilterDropdown(
                                label: 'Category',
                                value: _filterCategory,
                                items: categories,
                                onChanged: (v) => setState(() { _filterCategory = v!; _applyFilter(); }),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _FilterDropdown(
                                label: 'Status',
                                value: _filterStatus,
                                items: statuses,
                                onChanged: (v) => setState(() { _filterStatus = v!; _applyFilter(); }),
                              ),
                            ),
                            const SizedBox(width: 8),
                            AppButton(
                              label: 'Reset',
                              variant: AppButtonVariant.ghost,
                              onPressed: () {
                                _searchCtrl.clear();
                                setState(() { _filterCategory = 'All'; _filterStatus = 'All'; });
                                _applyFilter();
                              },
                            ),
                          ],
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: AppSearchField(
                            hint: 'Search products by name or SKU...',
                            controller: _searchCtrl,
                            onChanged: (_) => _applyFilter(),
                            onClear: () {
                              _searchCtrl.clear();
                              _applyFilter();
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        _FilterDropdown(
                          label: 'Category',
                          value: _filterCategory,
                          items: categories,
                          onChanged: (v) => setState(() { _filterCategory = v!; _applyFilter(); }),
                        ),
                        const SizedBox(width: 12),
                        _FilterDropdown(
                          label: 'Status',
                          value: _filterStatus,
                          items: statuses,
                          onChanged: (v) => setState(() { _filterStatus = v!; _applyFilter(); }),
                        ),
                        const SizedBox(width: 12),
                        AppButton(
                          label: 'Reset',
                          variant: AppButtonVariant.ghost,
                          onPressed: () {
                            _searchCtrl.clear();
                            setState(() { _filterCategory = 'All'; _filterStatus = 'All'; });
                            _applyFilter();
                          },
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 16),
            // Table
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border, width: 1),
              ),
              child: Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: SizedBox(
                      width: 880,
                      child: Column(
                        children: [
                          // Table header
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
                            decoration: const BoxDecoration(
                              color: AppColors.secondaryBackground,
                              border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
                            ),
                            child: Row(children: [
                              SizedBox(width: 48, child: Text('#', style: AppTextStyles.labelSmall)),
                              Expanded(flex: 4, child: Text('Product', style: AppTextStyles.labelSmall)),
                              Expanded(flex: 2, child: Text('SKU', style: AppTextStyles.labelSmall)),
                              Expanded(flex: 2, child: Text('Category', style: AppTextStyles.labelSmall)),
                              Expanded(flex: 2, child: Text('Stock', style: AppTextStyles.labelSmall)),
                              Expanded(flex: 2, child: Text('Price', style: AppTextStyles.labelSmall)),
                              Expanded(flex: 2, child: Text('Warehouse', style: AppTextStyles.labelSmall)),
                              Expanded(flex: 2, child: Text('Status', style: AppTextStyles.labelSmall)),
                              SizedBox(width: 80, child: Text('Actions', style: AppTextStyles.labelSmall)),
                            ]),
                          ),
                          if (pageProducts.isEmpty)
                            AppEmptyState(
                              title: 'No products found',
                              message: 'Try adjusting your search or filter criteria',
                              icon: Icons.search_off_rounded,
                            )
                          else
                            ...pageProducts.asMap().entries.map((e) => _ProductRow(product: e.value, index: e.key)),
                        ],
                      ),
                    ),
                  ),
                  // Pagination
                  if (_filteredProducts.isNotEmpty)
                    TablePagination(
                      currentPage: _currentPage,
                      totalPages: totalPages,
                      totalItems: _filteredProducts.length,
                      pageSize: _pageSize,
                      onPageChanged: (p) => setState(() => _currentPage = p),
                    ),
                ],
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

class _ProductRow extends StatelessWidget {
  final Map<String, dynamic> product;
  final int index;
  const _ProductRow({required this.product, required this.index});

  @override
  Widget build(BuildContext context) {
    final stock = product['stock'] as int;
    final minStock = product['minStock'] as int;
    final isLow = stock < minStock;

    return InkWell(
      onTap: () => Get.toNamed(AppRoutes.productDetail, arguments: product),
      hoverColor: AppColors.primarySurface.withValues(alpha: 0.3),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
        decoration: BoxDecoration(
          color: index.isOdd ? const Color(0xFFFAFCFB) : AppColors.surface,
          border: const Border(bottom: BorderSide(color: AppColors.divider, width: 1)),
        ),
        child: Row(children: [
          SizedBox(
            width: 48,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.secondaryBackground,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.inventory_2_outlined, size: 16, color: AppColors.textMuted),
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(product['name'] as String, style: AppTextStyles.labelLarge, overflow: TextOverflow.ellipsis),
              Text(product['brand'] as String, style: AppTextStyles.caption),
            ]),
          ),
          Expanded(flex: 2, child: Text(product['sku'] as String, style: AppTextStyles.mono.copyWith(fontSize: 12))),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.secondaryBackground,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(product['category'] as String, style: AppTextStyles.caption, overflow: TextOverflow.ellipsis),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(children: [
              Text(
                '${product['stock']}',
                style: AppTextStyles.labelSmall.copyWith(
                  color: isLow ? AppColors.danger : AppColors.textPrimary,
                ),
              ),
              Text(' ${product['unit']}', style: AppTextStyles.caption),
            ]),
          ),
          Expanded(
            flex: 2,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('\$${(product['sellingPrice'] as double).toStringAsFixed(2)}', style: AppTextStyles.labelSmall),
              Text('Cost: \$${(product['costPrice'] as double).toStringAsFixed(2)}', style: AppTextStyles.caption),
            ]),
          ),
          Expanded(flex: 2, child: Text(product['warehouse'] as String, style: AppTextStyles.bodySmall)),
          Expanded(flex: 2, child: AppBadge.fromStatus(product['status'] as String)),
          SizedBox(
            width: 80,
            child: Row(
              children: [
                AppIconButton(
                  icon: Icons.visibility_outlined,
                  tooltip: 'View',
                  onPressed: () => Get.toNamed(AppRoutes.productDetail, arguments: product),
                ),
                AppIconButton(
                  icon: Icons.edit_outlined,
                  tooltip: 'Edit',
                  onPressed: () => Get.toNamed(AppRoutes.productEdit, arguments: product),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final void Function(String?)? onChanged;

  const _FilterDropdown({
    required this.label,
    required this.value,
    required this.items,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.border, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          items: items.map((i) => DropdownMenuItem(
            value: i,
            child: Text(
              i,
              style: AppTextStyles.bodyMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          )).toList(),
          onChanged: onChanged,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: AppColors.textMuted),
          style: AppTextStyles.bodyMedium,
          borderRadius: BorderRadius.circular(8),
          dropdownColor: AppColors.surface,
        ),
      ),
    );
  }
}

