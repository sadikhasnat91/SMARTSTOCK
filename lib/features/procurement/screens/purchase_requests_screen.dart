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

class PurchaseRequestsScreen extends StatefulWidget {
  const PurchaseRequestsScreen({super.key});

  @override
  State<PurchaseRequestsScreen> createState() => _PurchaseRequestsScreenState();
}

class _PurchaseRequestsScreenState extends State<PurchaseRequestsScreen> {
  final _searchCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppShell(
      breadcrumbs: const ['Procurement', 'Purchase Requests'],
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
                    Text('Internal Purchase Requests', style: AppTextStyles.h1),
                    const SizedBox(height: 4),
                    Text('Departmental replenishment requisitions, budget pre-authorization, and conversion to PO', style: AppTextStyles.bodySmall),
                  ],
                ),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    AppButton(
                      label: 'Approval Center',
                      variant: AppButtonVariant.outline,
                      prefixIcon: Icons.how_to_reg_rounded,
                      onPressed: () => Get.toNamed(AppRoutes.approvalCenter),
                    ),
                    AppButton(
                      label: 'New Purchase Request',
                      prefixIcon: Icons.add_rounded,
                      onPressed: () => Get.toNamed(AppRoutes.purchaseRequestCreate),
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
              child: Row(
                children: [
                  Expanded(
                    child: AppSearchField(
                      hint: 'Search requisitions by PR-ID, title, department, or requester...',
                      controller: _searchCtrl,
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
                            Expanded(flex: 2, child: Text('PR Number', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 3, child: Text('Requisition Title', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Department', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Est. Budget', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Priority', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Approval Status', style: AppTextStyles.labelSmall)),
                            const SizedBox(width: 100, child: Text('Actions', style: AppTextStyles.labelSmall)),
                          ],
                        ),
                      ),
                      ...MockSuppliers.purchaseRequests.map((pr) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide(color: AppColors.divider)),
                            ),
                            child: Row(
                              children: [
                                Expanded(flex: 2, child: Text(pr['id'] as String, style: AppTextStyles.mono)),
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(pr['title'] as String, style: AppTextStyles.labelLarge, overflow: TextOverflow.ellipsis),
                                      Text('By ${pr['requestedBy']} · ${pr['date']}', style: AppTextStyles.caption),
                                    ],
                                  ),
                                ),
                                Expanded(flex: 2, child: Text(pr['department'] as String, style: AppTextStyles.bodySmall)),
                                Expanded(flex: 2, child: Text(pr['estimatedCost'] as String, style: AppTextStyles.labelLarge)),
                                Expanded(flex: 2, child: AppBadge.fromStatus(pr['priority'] as String)),
                                Expanded(flex: 2, child: AppBadge.fromStatus(pr['status'] as String)),
                                SizedBox(
                                  width: 90,
                                  child: AppButton(
                                    label: 'Approve',
                                    variant: AppButtonVariant.secondary,
                                    height: 30,
                                    onPressed: () {
                                      Get.snackbar(
                                        'Requisition Approved',
                                        'PR ${pr['id']} approved for PO generation',
                                        backgroundColor: AppColors.success,
                                        colorText: Colors.white,
                                      );
                                    },
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

