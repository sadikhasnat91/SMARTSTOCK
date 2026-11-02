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

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final _searchCtrl = TextEditingController();
  List<Map<String, dynamic>> _users = [];

  @override
  void initState() {
    super.initState();
    _users = MockOrders.users;
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      breadcrumbs: const ['Administration', 'User Management'],
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
                    Text('Enterprise Users & Identity Management', style: AppTextStyles.h1),
                    const SizedBox(height: 4),
                    Text('Manage personnel access, assigned warehouse facilities, and operational roles', style: AppTextStyles.bodySmall),
                  ],
                ),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    AppButton(
                      label: 'Roles & Privileges',
                      variant: AppButtonVariant.outline,
                      prefixIcon: Icons.shield_outlined,
                      onPressed: () => Get.toNamed(AppRoutes.rolesPermissions),
                    ),
                    AppButton(
                      label: 'Invite User',
                      prefixIcon: Icons.person_add_rounded,
                      onPressed: () {
                        Get.snackbar('Invitation Sent', 'User onboarding invite link dispatched to email.');
                      },
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
                      hint: 'Search members by name, email, department, or assigned role...',
                      controller: _searchCtrl,
                      onChanged: (q) {
                        setState(() {
                          _users = MockOrders.users.where((u) {
                            return (u['name'] as String).toLowerCase().contains(q.toLowerCase()) ||
                                (u['email'] as String).toLowerCase().contains(q.toLowerCase()) ||
                                (u['role'] as String).toLowerCase().contains(q.toLowerCase());
                          }).toList();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
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
                            Expanded(flex: 3, child: Text('Team Member', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 3, child: Text('Assigned Role', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Department', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Last Active', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Status', style: AppTextStyles.labelSmall)),
                            const SizedBox(width: 80, child: Text('Actions', style: AppTextStyles.labelSmall)),
                          ],
                        ),
                      ),
                      ..._users.map((u) => Container(
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
                                      CircleAvatar(
                                        radius: 16,
                                        backgroundColor: AppColors.primarySurface,
                                        child: Text(
                                          (u['name'] as String).substring(0, 1),
                                          style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(u['name'] as String, style: AppTextStyles.labelLarge, overflow: TextOverflow.ellipsis),
                                            Text(u['email'] as String, style: AppTextStyles.caption, overflow: TextOverflow.ellipsis),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(flex: 3, child: Text(u['role'] as String, style: AppTextStyles.bodyMedium)),
                                Expanded(flex: 2, child: Text(u['department'] as String, style: AppTextStyles.bodySmall)),
                                Expanded(flex: 2, child: Text(u['lastLogin'] as String, style: AppTextStyles.caption)),
                                Expanded(flex: 2, child: AppBadge.fromStatus(u['status'] as String)),
                                SizedBox(
                                  width: 80,
                                  child: AppIconButton(
                                    icon: Icons.more_vert_rounded,
                                    tooltip: 'Options',
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

