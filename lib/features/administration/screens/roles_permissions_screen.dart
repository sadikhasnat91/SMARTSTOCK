import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/layouts/app_shell.dart';
import '../../../shared/widgets/badges/app_badge.dart';

class RolesPermissionsScreen extends StatelessWidget {
  const RolesPermissionsScreen({super.key});

  final _roles = const [
    {'role': 'Warehouse Manager', 'users': 4, 'desc': 'Full inventory adjustments, transfers, cycle counting, bin mapping, and dispatch sign-off', 'tier': 'Operations Admin'},
    {'role': 'Procurement Officer', 'users': 3, 'desc': 'Create/approve purchase requests, transmit purchase orders, vendor onboarding, and GRN receipts', 'tier': 'Commercial Admin'},
    {'role': 'Inventory Controller', 'users': 6, 'desc': 'Perform barcode scanning, count entries, pick-wave verification, and transfer requests', 'tier': 'Floor Staff'},
    {'role': 'Sales Representative', 'users': 5, 'desc': 'View client catalogs, create sales orders, check stock reservation allocations', 'tier': 'Commercial Staff'},
    {'role': 'System Administrator', 'users': 2, 'desc': 'Full unrestricted access across all tenant databases, audit logs, and security controls', 'tier': 'Super User'},
  ];

  @override
  Widget build(BuildContext context) {
    return AppShell(
      breadcrumbs: const ['Administration', 'Roles & RBAC Permissions'],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.contentPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Role-Based Access Control (RBAC)', style: AppTextStyles.h1),
                const SizedBox(height: 4),
                Text('Configure granular permission sets across inventory, procurement, warehouse, and financial modules', style: AppTextStyles.bodySmall),
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
                            Expanded(flex: 3, child: Text('Role Title', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 5, child: Text('Permission Scope & Authorization', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Assigned Users', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Security Tier', style: AppTextStyles.labelSmall)),
                          ],
                        ),
                      ),
                      ..._roles.map((r) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide(color: AppColors.divider)),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Row(
                                    children: [
                                      const Icon(Icons.shield_outlined, size: 18, color: AppColors.primary),
                                      const SizedBox(width: 10),
                                      Expanded(child: Text(r['role'] as String, style: AppTextStyles.labelLarge, overflow: TextOverflow.ellipsis)),
                                    ],
                                  ),
                                ),
                                Expanded(flex: 5, child: Text(r['desc'] as String, style: AppTextStyles.bodySmall)),
                                Expanded(flex: 2, child: Text('${r['users']} active users', style: AppTextStyles.bodyMedium)),
                                Expanded(flex: 2, child: AppBadge(label: r['tier'] as String, variant: AppBadgeVariant.primary)),
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

