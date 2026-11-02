import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/layouts/app_shell.dart';
import '../../../shared/widgets/badges/app_badge.dart';
import '../../../shared/widgets/buttons/app_button.dart';
import '../../../shared/widgets/inputs/app_text_field.dart';
import '../../../data/mock/mock_suppliers.dart';
import '../../../app/routes/app_routes.dart';

class SupplierListScreen extends StatefulWidget {
  const SupplierListScreen({super.key});

  @override
  State<SupplierListScreen> createState() => _SupplierListScreenState();
}

class _SupplierListScreenState extends State<SupplierListScreen> {
  final _searchCtrl = TextEditingController();
  List<Map<String, dynamic>> _suppliers = [];

  @override
  void initState() {
    super.initState();
    _suppliers = MockSuppliers.suppliers;
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      breadcrumbs: const ['Procurement', 'Suppliers'],
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
                    Text('Vendor & Supplier Directory', style: AppTextStyles.h1),
                    const SizedBox(height: 4),
                    Text('Manage vendor contacts, terms, SLA contracts, and performance evaluation', style: AppTextStyles.bodySmall),
                  ],
                ),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    AppButton(
                      label: 'Analytics',
                      variant: AppButtonVariant.outline,
                      prefixIcon: Icons.insights_rounded,
                      onPressed: () => Get.toNamed(AppRoutes.supplierPerformance),
                    ),
                    AppButton(
                      label: 'Add Supplier',
                      prefixIcon: Icons.person_add_alt_1_rounded,
                      onPressed: () => Get.toNamed(AppRoutes.supplierAdd),
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
              child: AppSearchField(
                hint: 'Search suppliers by vendor name, representative, email, or category...',
                controller: _searchCtrl,
                onChanged: (q) {
                  setState(() {
                    _suppliers = MockSuppliers.suppliers.where((s) {
                      return (s['name'] as String).toLowerCase().contains(q.toLowerCase()) ||
                          (s['contact'] as String).toLowerCase().contains(q.toLowerCase()) ||
                          (s['category'] as String).toLowerCase().contains(q.toLowerCase());
                    }).toList();
                  });
                },
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
                  width: 920,
                  child: Column(
                    children: [
                      Container(
                        color: AppColors.secondaryBackground,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        child: Row(
                          children: [
                            Expanded(flex: 3, child: Text('Supplier Enterprise', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 3, child: Text('Contact Person', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Category', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Rating Score', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Lead Time', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Status', style: AppTextStyles.labelSmall)),
                            const SizedBox(width: 80, child: Text('Actions', style: AppTextStyles.labelSmall)),
                          ],
                        ),
                      ),
                      ..._suppliers.map((s) => InkWell(
                            onTap: () => Get.toNamed(AppRoutes.supplierDetail, arguments: s),
                            hoverColor: AppColors.primarySurface.withValues(alpha: 0.2),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                              decoration: const BoxDecoration(
                                border: Border(bottom: BorderSide(color: AppColors.divider)),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 36,
                                          height: 36,
                                          decoration: BoxDecoration(
                                            color: AppColors.primarySurface,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: const Icon(Icons.business_rounded, size: 18, color: AppColors.primary),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(s['name'] as String, style: AppTextStyles.labelLarge, overflow: TextOverflow.ellipsis),
                                              Text(s['country'] as String, style: AppTextStyles.caption),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(s['contact'] as String, style: AppTextStyles.bodyMedium, overflow: TextOverflow.ellipsis),
                                        Text(s['email'] as String, style: AppTextStyles.caption, overflow: TextOverflow.ellipsis),
                                      ],
                                    ),
                                  ),
                                  Expanded(flex: 2, child: Text(s['category'] as String, style: AppTextStyles.bodySmall)),
                                  Expanded(
                                    flex: 2,
                                    child: Row(
                                      children: [
                                        const Icon(Icons.star_rounded, size: 16, color: AppColors.warning),
                                        const SizedBox(width: 4),
                                        Expanded(child: Text('${s['rating']} / 5.0', style: AppTextStyles.labelSmall, overflow: TextOverflow.ellipsis)),
                                      ],
                                    ),
                                  ),
                                  Expanded(flex: 2, child: Text(s['leadTime'] as String, style: AppTextStyles.bodySmall)),
                                  Expanded(flex: 2, child: AppBadge.fromStatus(s['status'] as String)),
                                  SizedBox(
                                    width: 80,
                                    child: AppIconButton(
                                      icon: Icons.chevron_right_rounded,
                                      tooltip: 'Details',
                                      onPressed: () => Get.toNamed(AppRoutes.supplierDetail, arguments: s),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
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

