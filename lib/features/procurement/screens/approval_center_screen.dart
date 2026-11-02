import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/layouts/app_shell.dart';
import '../../../shared/widgets/badges/app_badge.dart';
import '../../../shared/widgets/buttons/app_button.dart';
import '../../../data/mock/mock_suppliers.dart';

class ApprovalCenterScreen extends StatelessWidget {
  const ApprovalCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShell(
      breadcrumbs: const ['Procurement', 'Approval Center'],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.contentPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Executive & Financial Sign-Off Hub', style: AppTextStyles.h1),
                const SizedBox(height: 4),
                Text('Review pending requisitions, cross-departmental stock releases, and PO commitments', style: AppTextStyles.bodySmall),
              ],
            ),
            const SizedBox(height: 24),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: SizedBox(
                width: 990,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      Container(
                        color: AppColors.secondaryBackground,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        child: Row(
                          children: [
                            Expanded(flex: 2, child: Text('Requisition ID', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 3, child: Text('Description', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Department', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Commitment Amount', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Urgency', style: AppTextStyles.labelSmall)),
                            const SizedBox(width: 290, child: Text('Decision Actions', style: AppTextStyles.labelSmall)),
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
                                      Text(pr['title'] as String, style: AppTextStyles.labelMedium),
                                      Text('Requested by ${pr['requestedBy']}', style: AppTextStyles.caption),
                                    ],
                                  ),
                                ),
                                Expanded(flex: 2, child: Text(pr['department'] as String, style: AppTextStyles.bodySmall)),
                                Expanded(flex: 2, child: Text(pr['estimatedCost'] as String, style: AppTextStyles.labelLarge)),
                                Expanded(flex: 2, child: AppBadge.fromStatus(pr['priority'] as String)),
                                SizedBox(
                                  width: 290,
                                  child: Row(
                                    children: [
                                      AppButton(
                                        label: 'Decline',
                                        variant: AppButtonVariant.ghost,
                                        height: 32,
                                        onPressed: () {
                                          Get.snackbar('Declined', 'Requisition returned to requester for revisions.');
                                        },
                                      ),
                                      const SizedBox(width: 8),
                                      AppButton(
                                        label: 'Approve',
                                        height: 32,
                                        onPressed: () {
                                          Get.snackbar(
                                            'Requisition Authorized',
                                            'Authorization token issued. Ready to generate formal PO.',
                                            backgroundColor: AppColors.success,
                                            colorText: Colors.white,
                                          );
                                        },
                                      ),
                                    ],
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
}

