import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/layouts/app_shell.dart';
import '../../../shared/widgets/badges/app_badge.dart';
import '../../../shared/widgets/buttons/app_button.dart';
import '../../../shared/widgets/inputs/app_text_field.dart';
import '../../../shared/controllers/order_controller.dart';
import '../../../data/models/customer_model.dart';
import '../../../app/routes/app_routes.dart';

class CustomerListScreen extends StatelessWidget {
  const CustomerListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<OrderController>();

    return AppShell(
      breadcrumbs: const ['Sales & Orders', 'Customers'],
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
                    Text('Enterprise Client Directory', style: AppTextStyles.h1),
                    const SizedBox(height: 4),
                    Text('Manage B2B commercial accounts, credit facilities, and purchasing records', style: AppTextStyles.bodySmall),
                  ],
                ),
                AppButton(
                  label: 'Add Customer',
                  prefixIcon: Icons.person_add_rounded,
                  onPressed: () => Get.toNamed(AppRoutes.customerAdd),
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
                      hint: 'Search customers by enterprise name, contact person, or email...',
                      onChanged: (q) => ctrl.customerSearchQuery.value = q,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Obx(() {
              if (ctrl.isLoading.value) {
                return const Center(child: Padding(
                  padding: EdgeInsets.all(40),
                  child: CircularProgressIndicator(),
                ));
              }
              final customers = ctrl.filteredCustomers;
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: SizedBox(
                    width: 860,
                    child: Column(
                      children: [
                        Container(
                          color: AppColors.secondaryBackground,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          child: Row(
                            children: [
                              Expanded(flex: 3, child: Text('Customer Organization', style: AppTextStyles.labelSmall)),
                              Expanded(flex: 3, child: Text('Contact Representative', style: AppTextStyles.labelSmall)),
                              Expanded(flex: 2, child: Text('Account Tier', style: AppTextStyles.labelSmall)),
                              Expanded(flex: 2, child: Text('Credit Line', style: AppTextStyles.labelSmall)),
                              Expanded(flex: 2, child: Text('Lifetime Revenue', style: AppTextStyles.labelSmall)),
                              Expanded(flex: 2, child: Text('Status', style: AppTextStyles.labelSmall)),
                            ],
                          ),
                        ),
                        if (customers.isEmpty)
                          Padding(
                            padding: const EdgeInsets.all(32),
                            child: Text('No customers found', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted)),
                          )
                        else
                          ...customers.map((c) => _buildRow(c)),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(CustomerModel c) {
    return Container(
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
                    color: AppColors.infoSurface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.corporate_fare_rounded, size: 18, color: AppColors.info),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(c.name, style: AppTextStyles.labelLarge, overflow: TextOverflow.ellipsis),
                      Text(c.country, style: AppTextStyles.caption, overflow: TextOverflow.ellipsis),
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
                Text(c.contact, style: AppTextStyles.bodyMedium, overflow: TextOverflow.ellipsis),
                Text(c.email, style: AppTextStyles.caption, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          Expanded(flex: 2, child: Text(c.type, style: AppTextStyles.bodySmall, overflow: TextOverflow.ellipsis)),
          Expanded(flex: 2, child: Text(c.creditLimit, style: AppTextStyles.labelSmall, overflow: TextOverflow.ellipsis)),
          Expanded(flex: 2, child: Text(c.totalValue, style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary), overflow: TextOverflow.ellipsis)),
          Expanded(flex: 2, child: AppBadge.fromStatus(c.status)),
        ],
      ),
    );
  }
}
