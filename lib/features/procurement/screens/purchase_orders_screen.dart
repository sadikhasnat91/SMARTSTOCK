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

class PurchaseOrdersScreen extends StatefulWidget {
  const PurchaseOrdersScreen({super.key});

  @override
  State<PurchaseOrdersScreen> createState() => _PurchaseOrdersScreenState();
}

class _PurchaseOrdersScreenState extends State<PurchaseOrdersScreen> {
  final _searchCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppShell(
      breadcrumbs: const ['Procurement', 'Purchase Orders'],
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
                    Text('Vendor Purchase Orders (PO)', style: AppTextStyles.h1),
                    const SizedBox(height: 4),
                    Text('Legally binding vendor supply orders, delivery scheduling, and receiving tracking', style: AppTextStyles.bodySmall),
                  ],
                ),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    AppButton(
                      label: 'Goods Inbound',
                      variant: AppButtonVariant.outline,
                      prefixIcon: Icons.move_to_inbox_rounded,
                      onPressed: () => Get.toNamed(AppRoutes.goodsReceiving),
                    ),
                    AppButton(
                      label: 'Create PO',
                      prefixIcon: Icons.add_rounded,
                      onPressed: () => Get.toNamed(AppRoutes.purchaseOrderCreate),
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
                hint: 'Filter POs by PO code, supplier, or date range...',
                controller: _searchCtrl,
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
                            Expanded(flex: 2, child: Text('PO Reference', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 3, child: Text('Vendor Partner', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Order Value', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Line Items', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Order Date', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Expected Date', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Status', style: AppTextStyles.labelSmall)),
                            const SizedBox(width: 80, child: Text('Actions', style: AppTextStyles.labelSmall)),
                          ],
                        ),
                      ),
                      ...MockSuppliers.purchaseOrders.map((po) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide(color: AppColors.divider)),
                            ),
                            child: Row(
                              children: [
                                Expanded(flex: 2, child: Text(po['id'] as String, style: AppTextStyles.mono)),
                                Expanded(flex: 3, child: Text(po['supplier'] as String, style: AppTextStyles.labelMedium, overflow: TextOverflow.ellipsis)),
                                Expanded(flex: 2, child: Text(po['total'] as String, style: AppTextStyles.labelLarge)),
                                Expanded(flex: 2, child: Text('${po['items']} Items', style: AppTextStyles.bodySmall)),
                                Expanded(flex: 2, child: Text(po['orderDate'] as String, style: AppTextStyles.caption)),
                                Expanded(flex: 2, child: Text(po['expectedDate'] as String, style: AppTextStyles.caption)),
                                Expanded(flex: 2, child: AppBadge.fromStatus(po['status'] as String)),
                                SizedBox(
                                  width: 80,
                                  child: AppIconButton(
                                    icon: Icons.description_outlined,
                                    tooltip: 'View PO Document',
                                    onPressed: () {},
                                  ),
                                ),
                              ],
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

