import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/layouts/app_shell.dart';
import '../../../shared/widgets/badges/app_badge.dart';
import '../../../shared/widgets/buttons/app_button.dart';

class AuditLogsScreen extends StatelessWidget {
  const AuditLogsScreen({super.key});

  final _logs = const [
    {'event': 'Stock Adjustment Posted', 'user': 'Ahmed Rahman', 'role': 'Warehouse Mgr', 'entity': 'ADJ-0044 [OFF-0118 -3 reams]', 'ip': '192.168.1.42', 'time': '10 mins ago', 'severity': 'Normal'},
    {'event': 'PO Transmitted to Vendor', 'user': 'Mike Torres', 'role': 'Procurement Off', 'entity': 'PO-2024-0344 (TechPro Ltd)', 'ip': '192.168.1.18', 'time': '34 mins ago', 'severity': 'Normal'},
    {'event': 'User Role Elevation', 'user': 'James Park', 'role': 'SysAdmin', 'entity': 'Modified permissions for Sarah K.', 'ip': '10.0.4.1', 'time': '2 hours ago', 'severity': 'Warning'},
    {'event': 'Bin Mapping Reconfigured', 'user': 'Ahmed Rahman', 'role': 'Warehouse Mgr', 'entity': 'Location A-01-02 allocated ELC-0088', 'ip': '192.168.1.42', 'time': '5 hours ago', 'severity': 'Normal'},
    {'event': 'Failed Authentication Spike', 'user': 'Unknown Host', 'role': 'External', 'entity': '3 incorrect attempts for user nina.rossi', 'ip': '178.62.204.11', 'time': '1 day ago', 'severity': 'Critical'},
  ];

  @override
  Widget build(BuildContext context) {
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
                  onPressed: () {},
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
                            Expanded(flex: 3, child: Text('Action Event', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Operator Account', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 4, child: Text('Affected Entity / Parameter', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('IP Address', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Timestamp', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Audit Flag', style: AppTextStyles.labelSmall)),
                          ],
                        ),
                      ),
                      ..._logs.map((l) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide(color: AppColors.divider)),
                            ),
                            child: Row(
                              children: [
                                Expanded(flex: 3, child: Text(l['event'] as String, style: AppTextStyles.labelMedium)),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(l['user'] as String, style: AppTextStyles.bodySmall),
                                      Text(l['role'] as String, style: AppTextStyles.caption),
                                    ],
                                  ),
                                ),
                                Expanded(flex: 4, child: Text(l['entity'] as String, style: AppTextStyles.bodySmall)),
                                Expanded(flex: 2, child: Text(l['ip'] as String, style: AppTextStyles.mono)),
                                Expanded(flex: 2, child: Text(l['time'] as String, style: AppTextStyles.caption)),
                                Expanded(
                                  flex: 2,
                                  child: AppBadge(
                                    label: l['severity'] as String,
                                    variant: l['severity'] == 'Critical'
                                        ? AppBadgeVariant.danger
                                        : l['severity'] == 'Warning'
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
            ),
          ],
        ),
      ),
    );
  }
}

