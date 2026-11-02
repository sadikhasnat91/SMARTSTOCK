import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/layouts/app_shell.dart';
import '../../../shared/widgets/badges/app_badge.dart';
import '../../../shared/widgets/buttons/app_button.dart';

class DispatchManagementScreen extends StatelessWidget {
  const DispatchManagementScreen({super.key});

  final _shipments = const [
    {'bol': 'BOL-9902', 'carrier': 'FedEx Express Ground', 'order': 'SO-2024-0890', 'dest': 'San Francisco, CA', 'packages': '3 Boxes', 'status': 'Manifested'},
    {'bol': 'BOL-9901', 'carrier': 'DHL Global Forwarding', 'order': 'SO-2024-0889', 'dest': 'London, UK (Heathrow)', 'packages': '2 Pallets', 'status': 'In Transit'},
    {'bol': 'BOL-9900', 'carrier': 'Local Courier Fleet #02', 'order': 'SO-2024-0886', 'dest': 'Dhaka Commercial Hub', 'packages': '10 Parcels', 'status': 'Delivered'},
  ];

  @override
  Widget build(BuildContext context) {
    return AppShell(
      breadcrumbs: const ['Fulfillment', 'Outbound Dispatch'],
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
                    Text('Outbound Staging & Carrier Manifests', style: AppTextStyles.h1),
                    const SizedBox(height: 4),
                    Text('Bill of Lading (BOL), driver sign-offs, freight pickups, and parcel handover', style: AppTextStyles.bodySmall),
                  ],
                ),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    AppButton(
                      label: 'Print Master Manifest',
                      variant: AppButtonVariant.outline,
                      prefixIcon: Icons.print_outlined,
                      onPressed: () {},
                    ),
                    AppButton(
                      label: 'Dispatch Carrier Truck',
                      prefixIcon: Icons.local_shipping_rounded,
                      onPressed: () {
                        Get.snackbar('Trailer Dispatched', 'Carrier driver signature logged. Vehicle dispatched from Bay 3.');
                      },
                    ),
                  ],
                ),
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
                            Expanded(flex: 2, child: Text('Bill of Lading', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 3, child: Text('Freight Carrier', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Order Code', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 3, child: Text('Destination Port / City', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Cargo Units', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Status', style: AppTextStyles.labelSmall)),
                          ],
                        ),
                      ),
                      ..._shipments.map((s) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide(color: AppColors.divider)),
                            ),
                            child: Row(
                              children: [
                                Expanded(flex: 2, child: Text(s['bol'] as String, style: AppTextStyles.mono)),
                                Expanded(flex: 3, child: Text(s['carrier'] as String, style: AppTextStyles.labelMedium)),
                                Expanded(flex: 2, child: Text(s['order'] as String, style: AppTextStyles.mono)),
                                Expanded(flex: 3, child: Text(s['dest'] as String, style: AppTextStyles.bodySmall)),
                                Expanded(flex: 2, child: Text(s['packages'] as String, style: AppTextStyles.labelSmall)),
                                Expanded(flex: 2, child: AppBadge.fromStatus(s['status'] as String)),
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

