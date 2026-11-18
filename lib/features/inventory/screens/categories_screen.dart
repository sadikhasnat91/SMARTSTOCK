import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/layouts/app_shell.dart';
import '../../../shared/widgets/badges/app_badge.dart';
import '../../../shared/widgets/buttons/app_button.dart';
import '../../../shared/widgets/inputs/app_text_field.dart';
import '../../../shared/widgets/dialogs/app_dialog.dart';
import '../../../shared/controllers/product_controller.dart';
import '../../../data/models/category_model.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});
  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final _searchCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final prodCtrl = Get.find<ProductController>();

    return AppShell(
      breadcrumbs: const ['Inventory', 'Categories'],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.contentPadding),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 12,
            children: [
              Obx(() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Categories', style: AppTextStyles.h1),
                const SizedBox(height: 4),
                Text('${prodCtrl.categories.length} categories configured', style: AppTextStyles.bodySmall),
              ])),
              AppButton(label: 'Add Category', prefixIcon: Icons.add_rounded, onPressed: () => _showAddDialog(context, prodCtrl)),
            ],
          ),
          const SizedBox(height: 24),
          // Stats row
          Obx(() {
            final cats = prodCtrl.categories;
            final activeCount = cats.where((c) => c.status == 'Active').length;
            final inactiveCount = cats.where((c) => c.status != 'Active').length;
            final totalProds = cats.fold(0, (s, c) => s + c.productCount);

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  SizedBox(width: 170, child: _CatStat(label: 'Total Categories', value: '${cats.length}', icon: Icons.label_outline)),
                  const SizedBox(width: 12),
                  SizedBox(width: 170, child: _CatStat(label: 'Active', value: '$activeCount', icon: Icons.check_circle_outline, color: AppColors.success)),
                  const SizedBox(width: 12),
                  SizedBox(width: 170, child: _CatStat(label: 'Inactive', value: '$inactiveCount', icon: Icons.pause_circle_outline, color: AppColors.textMuted)),
                  const SizedBox(width: 12),
                  SizedBox(width: 170, child: _CatStat(label: 'Total Products', value: '$totalProds', icon: Icons.inventory_2_outlined)),
                ],
              ),
            );
          }),
          const SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: AppSearchField(
                  hint: 'Search categories...',
                  controller: _searchCtrl,
                  onChanged: (_) => setState(() {}),
                ),
              ),
              Obx(() {
                final q = _searchCtrl.text.trim().toLowerCase();
                var list = prodCtrl.categories.toList();
                if (q.isNotEmpty) {
                  list = list.where((c) => c.name.toLowerCase().contains(q)).toList();
                }

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: SizedBox(
                    width: 700,
                    child: Column(
                      children: [
                        // Header
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          color: AppColors.secondaryBackground,
                          child: Row(children: [
                            Expanded(flex: 3, child: Text('Category Name', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 1, child: Text('Products', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Inventory Value', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 1, child: Text('Status', style: AppTextStyles.labelSmall)),
                            SizedBox(width: 80, child: Text('Actions', style: AppTextStyles.labelSmall)),
                          ]),
                        ),
                        if (list.isEmpty)
                          Padding(
                            padding: const EdgeInsets.all(32),
                            child: Text('No categories found', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted)),
                          )
                        else
                          ...list.asMap().entries.map((e) {
                            final cat = e.value;
                            return InkWell(
                              hoverColor: AppColors.primarySurface.withValues(alpha: 0.3),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                                decoration: BoxDecoration(
                                  color: e.key.isOdd ? const Color(0xFFFAFCFB) : AppColors.surface,
                                  border: const Border(bottom: BorderSide(color: AppColors.divider, width: 1)),
                                ),
                                child: Row(children: [
                                  Expanded(flex: 3, child: Row(children: [
                                    Container(
                                      width: 36, height: 36,
                                      decoration: BoxDecoration(color: AppColors.primarySurface, borderRadius: BorderRadius.circular(8)),
                                      child: const Icon(Icons.label_outline, size: 18, color: AppColors.primary),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(child: Text(cat.name, style: AppTextStyles.labelLarge, overflow: TextOverflow.ellipsis)),
                                  ])),
                                  Expanded(flex: 1, child: Text('${cat.productCount} items', style: AppTextStyles.bodyMedium)),
                                  Expanded(flex: 2, child: Text('\$${cat.totalValue.toStringAsFixed(2)}', style: AppTextStyles.labelSmall.copyWith(color: AppColors.primary))),
                                  Expanded(flex: 1, child: AppBadge.fromStatus(cat.status)),
                                  SizedBox(width: 80, child: Row(children: [
                                    AppIconButton(icon: Icons.edit_outlined, tooltip: 'Edit', onPressed: () {}),
                                    AppIconButton(icon: Icons.more_vert_rounded, tooltip: 'More', onPressed: () {}),
                                  ])),
                                ]),
                              ),
                            );
                          }),
                      ],
                    ),
                  ),
                );
              }),
            ]),
          ),
        ]),
      ),
    );
  }

  void _showAddDialog(BuildContext context, ProductController prodCtrl) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AppDialog(
        title: 'Add Category',
        content: AppTextField(label: 'Category Name', hint: 'e.g. Electronics', controller: ctrl),
        actions: [
          AppButton(label: 'Cancel', variant: AppButtonVariant.outline, onPressed: () => Navigator.pop(context)),
          AppButton(label: 'Create', onPressed: () {
            if (ctrl.text.trim().isNotEmpty) {
              prodCtrl.addCategory(name: ctrl.text.trim(), description: 'General category');
              Navigator.pop(context);
            }
          }),
        ],
      ),
    );
  }

  @override
  void dispose() { _searchCtrl.dispose(); super.dispose(); }
}

class _CatStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? color;
  const _CatStat({required this.label, required this.value, required this.icon, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
      child: Row(children: [
        Icon(icon, size: 20, color: color ?? AppColors.primary),
        const SizedBox(width: 10),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            FittedBox(fit: BoxFit.scaleDown, child: Text(value, style: AppTextStyles.h3)),
            Text(label, style: AppTextStyles.caption, overflow: TextOverflow.ellipsis),
          ]),
        ),
      ]),
    );
  }
}
