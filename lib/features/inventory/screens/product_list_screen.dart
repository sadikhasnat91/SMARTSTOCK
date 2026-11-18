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
import '../../../app/routes/app_routes.dart';
import '../../../shared/controllers/product_controller.dart';

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

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(() => setState(() => _currentPage = 1));
    // Always refresh data from Supabase/database on screen enter
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<ProductController>().loadData();
    });
  }

  void _confirmDelete(String id, String name) {
    showDialog(
      context: context,
      builder: (ctx) => AppDialog(
        title: 'Delete Product',
        content: Text('Are you sure you want to permanently delete "$name"? This action will remove it from real-time tracking.', style: AppTextStyles.bodyMedium),
        actions: [
          AppButton(
            label: 'Cancel',
            variant: AppButtonVariant.ghost,
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          AppButton(
            label: 'Delete Product',
            variant: AppButtonVariant.danger,
            onPressed: () async {
              Navigator.of(ctx).pop();
              await Get.find<ProductController>().deleteProduct(id);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    final productCtrl = Get.find<ProductController>();

    return Obx(() {
      final allProductModels = productCtrl.products;
      final q = _searchCtrl.text.trim().toLowerCase();

      final filtered = allProductModels.where((p) {
        final matchesSearch = q.isEmpty ||
            p.name.toLowerCase().contains(q) ||
            p.sku.toLowerCase().contains(q) ||
            p.barcode.toLowerCase().contains(q);
        final matchesCat = _filterCategory == 'All' || p.category.toLowerCase() == _filterCategory.toLowerCase();
        final matchesStatus = _filterStatus == 'All' || p.computedStatus.toLowerCase() == _filterStatus.toLowerCase();
        return matchesSearch && matchesCat && matchesStatus;
      }).map((p) => p.toJson()).toList();

      final categories = [
        'All',
        ...productCtrl.categories.map((c) => c.name),
      ];
      final statuses = ['All', 'In Stock', 'Low Stock', 'Critical', 'Out of Stock'];
      final totalPages = (filtered.length / _pageSize).ceil();
      final start = ((_currentPage - 1) * _pageSize).clamp(0, filtered.length);
      final end = (start + _pageSize).clamp(0, filtered.length);
      final pageProducts = filtered.sublist(start, end);

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
                    Text('${allProductModels.length} total products (Supabase & Reactive)', style: AppTextStyles.bodySmall),
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
                            onChanged: (_) => setState(() => _currentPage = 1),
                            onClear: () {
                              _searchCtrl.clear();
                              setState(() => _currentPage = 1);
                            },
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: _FilterDropdown(
                                  label: 'Category',
                                  value: categories.contains(_filterCategory) ? _filterCategory : 'All',
                                  items: categories,
                                  onChanged: (v) => setState(() { _filterCategory = v!; _currentPage = 1; }),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _FilterDropdown(
                                  label: 'Status',
                                  value: statuses.contains(_filterStatus) ? _filterStatus : 'All',
                                  items: statuses,
                                  onChanged: (v) => setState(() { _filterStatus = v!; _currentPage = 1; }),
                                ),
                              ),
                              const SizedBox(width: 8),
                              AppButton(
                                label: 'Reset',
                                variant: AppButtonVariant.ghost,
                                onPressed: () {
                                  _searchCtrl.clear();
                                  setState(() { _filterCategory = 'All'; _filterStatus = 'All'; _currentPage = 1; });
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
                              onChanged: (_) => setState(() => _currentPage = 1),
                              onClear: () {
                                _searchCtrl.clear();
                                setState(() => _currentPage = 1);
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          _FilterDropdown(
                            width: 150,
                            label: 'Category',
                            value: categories.contains(_filterCategory) ? _filterCategory : 'All',
                            items: categories,
                            onChanged: (v) => setState(() { _filterCategory = v!; _currentPage = 1; }),
                          ),
                          const SizedBox(width: 12),
                          _FilterDropdown(
                            width: 150,
                            label: 'Status',
                            value: statuses.contains(_filterStatus) ? _filterStatus : 'All',
                            items: statuses,
                            onChanged: (v) => setState(() { _filterStatus = v!; _currentPage = 1; }),
                          ),
                          const SizedBox(width: 12),
                          AppButton(
                            label: 'Reset',
                            variant: AppButtonVariant.ghost,
                            onPressed: () {
                              _searchCtrl.clear();
                              setState(() { _filterCategory = 'All'; _filterStatus = 'All'; _currentPage = 1; });
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
                        width: 920,
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
                                SizedBox(width: 110, child: Text('Actions', style: AppTextStyles.labelSmall)),
                              ]),
                            ),
                            if (pageProducts.isEmpty)
                              AppEmptyState(
                                title: 'No products found',
                                message: 'Try adjusting your search or filter criteria',
                                icon: Icons.search_off_rounded,
                              )
                            else
                              ...pageProducts.asMap().entries.map((e) => _ProductRow(
                                product: e.value,
                                index: e.key,
                                onDelete: () => _confirmDelete(e.value['id'] as String, e.value['name'] as String),
                              )),
                          ],
                        ),
                      ),
                    ),
                    // Pagination
                    if (filtered.isNotEmpty)
                      TablePagination(
                        currentPage: _currentPage,
                        totalPages: totalPages > 0 ? totalPages : 1,
                        totalItems: filtered.length,
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
    });
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
  final VoidCallback onDelete;
  const _ProductRow({required this.product, required this.index, required this.onDelete});

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
            width: 110,
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
                AppIconButton(
                  icon: Icons.delete_outline_rounded,
                  tooltip: 'Delete',
                  color: AppColors.danger,
                  onPressed: onDelete,
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
  final double? width;

  const _FilterDropdown({
    required this.label,
    required this.value,
    required this.items,
    this.onChanged,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: Container(
        height: 38,
        width: width,
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

