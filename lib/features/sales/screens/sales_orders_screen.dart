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

class SalesOrdersScreen extends StatefulWidget {
  const SalesOrdersScreen({super.key});

  @override
  State<SalesOrdersScreen> createState() => _SalesOrdersScreenState();
}

class _SalesOrdersScreenState extends State<SalesOrdersScreen> {
  final _searchCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppShell(
      breadcrumbs: const ['Sales & Orders', 'Sales Orders'],
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
                    Text('Customer Sales Orders', style: AppTextStyles.h1),
                    const SizedBox(height: 4),
                    Text('Manage inbound customer orders, allocation reservation, picking, and fulfillment dispatch', style: AppTextStyles.bodySmall),
                  ],
                ),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    AppButton(
                      label: 'Stock Reservations',
                      variant: AppButtonVariant.outline,
                      prefixIcon: Icons.bookmark_border_rounded,
                      onPressed: () => Get.toNamed(AppRoutes.reservations),
                    ),
                    AppButton(
                      label: 'New Sales Order',
                      prefixIcon: Icons.add_shopping_cart_rounded,
                      onPressed: () => Get.toNamed(AppRoutes.salesOrderCreate),
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
                      hint: 'Search sales orders by SO-number, client name, or warehouse origin...',
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
                            Expanded(flex: 2, child: Text('Order Code', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 3, child: Text('Purchasing Client', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Subtotal', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Order Date', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Fulfillment Hub', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Order Status', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Payment', style: AppTextStyles.labelSmall)),
                            const SizedBox(width: 80, child: Text('Actions', style: AppTextStyles.labelSmall)),
                          ],
                        ),
                      ),
                      ...MockOrders.salesOrders.map((so) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide(color: AppColors.divider)),
                            ),
                            child: Row(
                              children: [
                                Expanded(flex: 2, child: Text(so['id'] as String, style: AppTextStyles.mono)),
                                Expanded(flex: 3, child: Text(so['customer'] as String, style: AppTextStyles.labelMedium)),
                                Expanded(flex: 2, child: Text(so['subtotal'] as String, style: AppTextStyles.labelLarge)),
                                Expanded(flex: 2, child: Text(so['orderDate'] as String, style: AppTextStyles.caption)),
                                Expanded(flex: 2, child: Text(so['warehouse'] as String, style: AppTextStyles.bodySmall)),
                                Expanded(flex: 2, child: AppBadge.fromStatus(so['status'] as String)),
                                Expanded(flex: 2, child: AppBadge.fromStatus(so['paymentStatus'] as String)),
                                SizedBox(
                                  width: 80,
                                  child: AppIconButton(
                                    icon: Icons.receipt_long_outlined,
                                    tooltip: 'Order Details',
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

