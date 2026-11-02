import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/layouts/app_shell.dart';
import '../../../shared/widgets/badges/app_badge.dart';
import '../../../shared/widgets/buttons/app_button.dart';

class LocationsScreen extends StatefulWidget {
  const LocationsScreen({super.key});

  @override
  State<LocationsScreen> createState() => _LocationsScreenState();
}

class _LocationsScreenState extends State<LocationsScreen> {
  String _selectedZone = 'Zone A';

  final _bins = [
    {'bin': 'A-01-01', 'sku': 'ELC-0042', 'name': 'USB-C Hub 7-in-1', 'qty': '4 PCS', 'status': 'Low Stock'},
    {'bin': 'A-01-02', 'sku': 'ELC-0088', 'name': '4K Monitor 27-inch', 'qty': '42 PCS', 'status': 'In Stock'},
    {'bin': 'A-01-03', 'sku': 'TLS-0009', 'name': 'Precision Screwdriver Set', 'qty': '2 SET', 'status': 'Critical'},
    {'bin': 'A-02-01', 'sku': 'FRN-0055', 'name': 'Ergonomic Office Chair', 'qty': '28 PCS', 'status': 'In Stock'},
    {'bin': 'A-02-02', 'sku': 'FRN-0061', 'name': 'Standing Desk 160cm', 'qty': '14 PCS', 'status': 'In Stock'},
    {'bin': 'A-03-01', 'sku': 'PKG-0033', 'name': 'Bubble Wrap Roll 50m', 'qty': '3 ROLL', 'status': 'Critical'},
  ];

  @override
  Widget build(BuildContext context) {
    return AppShell(
      breadcrumbs: const ['Warehouse', 'Location Management'],
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
                    Text('Location Hierarchy & Bin Mapping', style: AppTextStyles.h1),
                    const SizedBox(height: 4),
                    Text('Hierarchy: Facility → Zone → Aisle → Rack → Shelf → Bin Address', style: AppTextStyles.bodySmall),
                  ],
                ),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    AppButton(
                      label: 'Print Barcodes',
                      variant: AppButtonVariant.outline,
                      prefixIcon: Icons.qr_code_rounded,
                      onPressed: () {},
                    ),
                    AppButton(
                      label: 'Add Bin / Location',
                      prefixIcon: Icons.add_location_alt_rounded,
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _zoneTab('Zone A (High Velocity)', 'Zone A'),
                  const SizedBox(width: 10),
                  _zoneTab('Zone B (Small Bins)', 'Zone B'),
                  const SizedBox(width: 10),
                  _zoneTab('Zone C (Bulk Storage)', 'Zone C'),
                  const SizedBox(width: 10),
                  _zoneTab('Zone D (Staging/Docks)', 'Zone D'),
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
                  width: 900,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        color: AppColors.secondaryBackground,
                        child: Row(
                          children: [
                            Expanded(flex: 2, child: Text('Bin Location ID', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Assigned SKU', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 4, child: Text('Item Description', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Stored Count', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Status', style: AppTextStyles.labelSmall)),
                            const SizedBox(width: 80, child: Text('Actions', style: AppTextStyles.labelSmall)),
                          ],
                        ),
                      ),
                      ..._bins.map((b) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide(color: AppColors.divider)),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Row(
                                    children: [
                                      const Icon(Icons.grid_view_rounded, size: 16, color: AppColors.primary),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(b['bin'] as String, style: AppTextStyles.labelLarge, overflow: TextOverflow.ellipsis),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(flex: 2, child: Text(b['sku'] as String, style: AppTextStyles.mono)),
                                Expanded(flex: 4, child: Text(b['name'] as String, style: AppTextStyles.bodyMedium, overflow: TextOverflow.ellipsis)),
                                Expanded(flex: 2, child: Text(b['qty'] as String, style: AppTextStyles.labelSmall)),
                                Expanded(flex: 2, child: AppBadge.fromStatus(b['status'] as String)),
                                SizedBox(
                                  width: 80,
                                  child: Row(
                                    children: [
                                      AppIconButton(icon: Icons.qr_code_2_rounded, tooltip: 'Scan / Label', onPressed: () {}),
                                      AppIconButton(icon: Icons.edit_outlined, tooltip: 'Edit', onPressed: () {}),
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

  Widget _zoneTab(String label, String key) {
    final active = _selectedZone == key;
    return InkWell(
      onTap: () => setState(() => _selectedZone = key),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: active ? AppColors.primary : AppColors.border),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(color: active ? Colors.white : AppColors.textSecondary),
        ),
      ),
    );
  }
}

