import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/responsive/responsive_layout.dart';
import '../../../shared/layouts/app_shell.dart';
import '../../../shared/widgets/badges/app_badge.dart';
import '../../../shared/widgets/buttons/app_button.dart';
import '../../../shared/widgets/inputs/app_text_field.dart';
import '../../../app/routes/app_routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);

    return AppShell(
      breadcrumbs: const ['Administration', 'User Profile'],
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
                    Text('Operator Profile & Credentials', style: AppTextStyles.h1),
                    const SizedBox(height: 4),
                    Text('Manage personal contact preferences, assigned facility access, and authentication security', style: AppTextStyles.bodySmall),
                  ],
                ),
                AppButton(
                  label: 'Sign Out',
                  variant: AppButtonVariant.danger,
                  prefixIcon: Icons.logout_rounded,
                  onPressed: () => Get.offAllNamed(AppRoutes.login),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: isMobile
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: AppColors.primary,
                          child: Text('AR', style: AppTextStyles.h2.copyWith(color: Colors.white)),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 10,
                          runSpacing: 6,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text('Ahmed Rahman', style: AppTextStyles.h2),
                            AppBadge(label: 'Active Operator', variant: AppBadgeVariant.success, dot: true),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text('Warehouse Operations Lead · Primary Station: WH-Main (Dhaka DC)', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                        const SizedBox(height: 4),
                        Text('ahmed.rahman@smartstock.com · Employee ID: SS-EMP-0142', style: AppTextStyles.caption),
                      ],
                    )
                  : Row(
                      children: [
                        CircleAvatar(
                          radius: 36,
                          backgroundColor: AppColors.primary,
                          child: Text('AR', style: AppTextStyles.h1.copyWith(color: Colors.white)),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text('Ahmed Rahman', style: AppTextStyles.h2),
                                  const SizedBox(width: 12),
                                  AppBadge(label: 'Active Operator', variant: AppBadgeVariant.success, dot: true),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text('Warehouse Operations Lead · Primary Station: WH-Main (Dhaka DC)', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                              const SizedBox(height: 4),
                              Text('ahmed.rahman@smartstock.com · Employee ID: SS-EMP-0142', style: AppTextStyles.caption),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Personal & Facility Preferences', style: AppTextStyles.h3),
                  const SizedBox(height: 20),
                  if (isMobile) ...[
                    AppTextField(
                      label: 'Full Name',
                      controller: TextEditingController(text: 'Ahmed Rahman'),
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'Corporate Email',
                      controller: TextEditingController(text: 'ahmed.rahman@smartstock.com'),
                      readOnly: true,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'Telephone Extension',
                      controller: TextEditingController(text: '+880-2-9876543 (Ext. 204)'),
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'Designated Hub Location',
                      controller: TextEditingController(text: 'WH-Main Distribution Center, Zone A'),
                      readOnly: true,
                    ),
                  ] else ...[
                    Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            label: 'Full Name',
                            controller: TextEditingController(text: 'Ahmed Rahman'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: AppTextField(
                            label: 'Corporate Email',
                            controller: TextEditingController(text: 'ahmed.rahman@smartstock.com'),
                            readOnly: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            label: 'Telephone Extension',
                            controller: TextEditingController(text: '+880-2-9876543 (Ext. 204)'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: AppTextField(
                            label: 'Designated Hub Location',
                            controller: TextEditingController(text: 'WH-Main Distribution Center, Zone A'),
                            readOnly: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 24),
                  AppButton(
                    label: 'Save Profile Changes',
                    prefixIcon: Icons.save_outlined,
                    onPressed: () {
                      Get.snackbar('Profile Updated', 'Your preferences have been saved locally.', backgroundColor: AppColors.success, colorText: Colors.white);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

