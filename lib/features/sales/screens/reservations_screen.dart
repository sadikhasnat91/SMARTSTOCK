import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/layouts/app_shell.dart';
import '../../../shared/widgets/badges/app_badge.dart';

class ReservationsScreen extends StatelessWidget {
  const ReservationsScreen({super.key});

  final _reservations = const [
    {'so': 'SO-2024-0891', 'sku': 'ELC-0042', 'name': 'USB-C Hub 7-in-1', 'client': 'Apex Corporation', 'reserved': 5, 'hub': 'WH-Main', 'status': 'Hard Allocated'},
    {'so': 'SO-2024-0890', 'sku': 'ELC-0071', 'name': 'Wireless Keyboard MX', 'client': 'BluePeak Inc', 'reserved': 3, 'hub': 'WH-West', 'status': 'Hard Allocated'},
    {'so': 'SO-2024-0888', 'sku': 'FRN-0055', 'name': 'Ergonomic Office Chair', 'client': 'Nova Systems', 'reserved': 8, 'hub': 'WH-Main', 'status': 'Pending Pick'},
    {'so': 'SO-2024-0889', 'sku': 'OFF-0118', 'name': 'Premium A4 Paper Ream', 'client': 'Meridian Group', 'reserved': 20, 'hub': 'WH-East', 'status': 'Dispatched'},
  ];

  @override
  Widget build(BuildContext context) {
    return AppShell(
      breadcrumbs: const ['Sales & Orders', 'Stock Reservations'],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.contentPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Inventory Allocation & Soft/Hard Reservations', style: AppTextStyles.h1),
                const SizedBox(height: 4),
                Text('Locks on-hand physical stock for confirmed sales orders preventing overselling and deadlocks', style: AppTextStyles.bodySmall),
              ],
            ),
            const SizedBox(height: 24),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: SizedBox(
                width: 860,
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
                            Expanded(flex: 2, child: Text('Order Ref', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('SKU Code', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 3, child: Text('Product Item', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 3, child: Text('Reserving Client', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Allocated Qty', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Warehouse Hub', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Lock State', style: AppTextStyles.labelSmall)),
                          ],
                        ),
                      ),
                      ..._reservations.map((r) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide(color: AppColors.divider)),
                            ),
                            child: Row(
                              children: [
                                Expanded(flex: 2, child: Text(r['so'] as String, style: AppTextStyles.mono)),
                                Expanded(flex: 2, child: Text(r['sku'] as String, style: AppTextStyles.mono)),
                                Expanded(flex: 3, child: Text(r['name'] as String, style: AppTextStyles.labelMedium)),
                                Expanded(flex: 3, child: Text(r['client'] as String, style: AppTextStyles.bodySmall)),
                                Expanded(flex: 2, child: Text('${r['reserved']} units', style: AppTextStyles.labelSmall.copyWith(color: AppColors.primary))),
                                Expanded(flex: 2, child: Text(r['hub'] as String, style: AppTextStyles.bodySmall)),
                                Expanded(flex: 2, child: AppBadge(label: r['status'] as String, variant: AppBadgeVariant.info, dot: true)),
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

