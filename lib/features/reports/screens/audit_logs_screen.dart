import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/layouts/app_shell.dart';
import '../../../shared/widgets/badges/app_badge.dart';
import '../../../shared/widgets/buttons/app_button.dart';
import '../../../data/repositories/audit_repository.dart';
import '../../../data/models/audit_log_model.dart';

class AuditLogsScreen extends StatelessWidget {
  const AuditLogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auditRepo = Get.find<AuditRepository>();

    return AppShell(
      breadcrumbs: const ['Analytics', 'Security & Audit Logs'],
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
                    Text('Enterprise Security & Immutable Audit Trail', style: AppTextStyles.h1),
                    const SizedBox(height: 4),
                    Text('Tamper-evident chronological record of all administrative actions, data modifications, and system events', style: AppTextStyles.bodySmall),
                  ],
                ),
                AppButton(
                  label: 'Export Compliance Log',
                  variant: AppButtonVariant.outline,
                  prefixIcon: Icons.download_rounded,
                  onPressed: () {
                    Get.snackbar('Compliance Export', 'Audit trail exported in CSV format.');
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            FutureBuilder<List<AuditLogModel>>(
              future: auditRepo.getAuditLogs(),
              builder: (context, snapshot) {
                final logs = snapshot.data ?? [];
                return SingleChildScrollView(
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
                                Expanded(flex: 3, child: Text('Action Event', style: AppTextStyles.labelSmall)),
                                Expanded(flex: 2, child: Text('Operator Account', style: AppTextStyles.labelSmall)),
                                Expanded(flex: 4, child: Text('Affected Entity / Parameter', style: AppTextStyles.labelSmall)),
                                Expanded(flex: 2, child: Text('IP Address', style: AppTextStyles.labelSmall)),
                                Expanded(flex: 2, child: Text('Timestamp', style: AppTextStyles.labelSmall)),
                                Expanded(flex: 2, child: Text('Audit Flag', style: AppTextStyles.labelSmall)),
                              ],
                            ),
                          ),
                          if (logs.isEmpty)
                            Padding(
                              padding: const EdgeInsets.all(32),
                              child: Text('No audit logs recorded yet.', style: AppTextStyles.bodyMedium),
                            )
                          else
                            ...logs.map((l) => Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                                  decoration: const BoxDecoration(
                                    border: Border(bottom: BorderSide(color: AppColors.divider)),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(flex: 3, child: Text(l.event, style: AppTextStyles.labelMedium)),
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(l.user, style: AppTextStyles.bodySmall),
                                            Text(l.role, style: AppTextStyles.caption),
                                          ],
                                        ),
                                      ),
                                      Expanded(flex: 4, child: Text(l.entity, style: AppTextStyles.bodySmall)),
                                      Expanded(flex: 2, child: Text(l.ip, style: AppTextStyles.mono)),
                                      Expanded(flex: 2, child: Text(l.time, style: AppTextStyles.caption)),
                                      Expanded(
                                        flex: 2,
                                        child: AppBadge(
                                          label: l.severity,
                                          variant: l.severity == 'Critical'
                                              ? AppBadgeVariant.danger
                                              : l.severity == 'Warning'
                                                  ? AppBadgeVariant.warning
                                                  : AppBadgeVariant.neutral,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
