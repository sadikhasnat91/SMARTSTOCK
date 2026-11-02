import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/layouts/app_shell.dart';
import '../../../shared/widgets/badges/app_badge.dart';
import '../../../shared/widgets/buttons/app_button.dart';
import '../../../shared/widgets/inputs/app_text_field.dart';
import '../../../data/mock/mock_orders.dart';
import '../../../app/routes/app_routes.dart';

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({super.key});

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  final _searchCtrl = TextEditingController();
  List<Map<String, dynamic>> _customers = [];

  @override
  void initState() {
    super.initState();
    _customers = MockOrders.customers;
  }

  @override
  Widget build(BuildContext context) {
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
                      controller: _searchCtrl,
                      onChanged: (q) {
                        setState(() {
                          _customers = MockOrders.customers.where((c) {
                            return (c['name'] as String).toLowerCase().contains(q.toLowerCase()) ||
                                (c['contact'] as String).toLowerCase().contains(q.toLowerCase());
                          }).toList();
                        });
                      },
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
                      ..._customers.map((c) => Container(
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
                                            Text(c['name'] as String, style: AppTextStyles.labelLarge, overflow: TextOverflow.ellipsis),
                                            Text(c['country'] as String, style: AppTextStyles.caption, overflow: TextOverflow.ellipsis),
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
                                      Text(c['contact'] as String, style: AppTextStyles.bodyMedium, overflow: TextOverflow.ellipsis),
                                      Text(c['email'] as String, style: AppTextStyles.caption, overflow: TextOverflow.ellipsis),
                                    ],
                                  ),
                                ),
                                Expanded(flex: 2, child: Text(c['type'] as String, style: AppTextStyles.bodySmall, overflow: TextOverflow.ellipsis)),
                                Expanded(flex: 2, child: Text(c['creditLimit'] as String, style: AppTextStyles.labelSmall, overflow: TextOverflow.ellipsis)),
                                Expanded(flex: 2, child: Text(c['totalValue'] as String, style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary), overflow: TextOverflow.ellipsis)),
                                Expanded(flex: 2, child: AppBadge.fromStatus(c['status'] as String)),
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

