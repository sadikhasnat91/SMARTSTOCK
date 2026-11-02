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
import '../../../data/mock/mock_products.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});
  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final _searchCtrl = TextEditingController();
  List<Map<String, dynamic>> _filtered = [];

  @override
  void initState() {
    super.initState();
    _filtered = MockProducts.categories;
  }

  @override
  Widget build(BuildContext context) {
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
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Categories', style: AppTextStyles.h1),
                const SizedBox(height: 4),
                Text('${MockProducts.categories.length} categories configured', style: AppTextStyles.bodySmall),
              ]),
              AppButton(label: 'Add Category', prefixIcon: Icons.add_rounded, onPressed: () => _showAddDialog(context)),
            ],
          ),
          const SizedBox(height: 24),
          // Stats row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                SizedBox(width: 170, child: _CatStat(label: 'Total Categories', value: '${MockProducts.categories.length}', icon: Icons.label_outline)),
                const SizedBox(width: 12),
                SizedBox(width: 170, child: _CatStat(label: 'Active', value: '${MockProducts.categories.where((c) => c['status'] == 'Active').length}', icon: Icons.check_circle_outline, color: AppColors.success)),
                const SizedBox(width: 12),
                SizedBox(width: 170, child: _CatStat(label: 'Inactive', value: '${MockProducts.categories.where((c) => c['status'] == 'Inactive').length}', icon: Icons.pause_circle_outline, color: AppColors.textMuted)),
                const SizedBox(width: 12),
                SizedBox(width: 170, child: _CatStat(label: 'Total Products', value: '${MockProducts.categories.fold(0, (s, c) => s + (c['products'] as int))}', icon: Icons.inventory_2_outlined)),
              ],
            ),
          ),
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
                  onChanged: (q) => setState(() {
                    _filtered = MockProducts.categories.where((c) => (c['name'] as String).toLowerCase().contains(q.toLowerCase())).toList();
                  }),
                ),
              ),
              SingleChildScrollView(
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
                      ..._filtered.asMap().entries.map((e) {
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
                                Expanded(child: Text(cat['name'] as String, style: AppTextStyles.labelLarge, overflow: TextOverflow.ellipsis)),
                              ])),
                              Expanded(flex: 1, child: Text('${cat['products']} items', style: AppTextStyles.bodyMedium)),
                              Expanded(flex: 2, child: Text(cat['value'] as String, style: AppTextStyles.labelSmall.copyWith(color: AppColors.primary))),
                              Expanded(flex: 1, child: AppBadge.fromStatus(cat['status'] as String)),
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
              ),
            ]),
          ),
        ]),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AppDialog(
        title: 'Add Category',
        content: AppTextField(label: 'Category Name', hint: 'e.g. Electronics', controller: ctrl),
        actions: [
          AppButton(label: 'Cancel', variant: AppButtonVariant.outline, onPressed: () => Navigator.pop(context)),
          AppButton(label: 'Create', onPressed: () {
            Navigator.pop(context);
            Get.snackbar('Category Created', '${ctrl.text} has been added', snackPosition: SnackPosition.BOTTOM, backgroundColor: AppColors.success, colorText: Colors.white);
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

