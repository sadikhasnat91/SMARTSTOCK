import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/layouts/app_shell.dart';
import '../../../shared/widgets/badges/app_badge.dart';
import '../../../shared/widgets/buttons/app_button.dart';
import '../../../shared/widgets/inputs/app_text_field.dart';
import '../../../shared/controllers/settings_controller.dart';
import '../../../core/config/supabase_config.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _autoReorder = true;
  bool _offlineSync = true;
  bool _soundAlerts = true;
  bool _barcodeLaser = true;

  late final TextEditingController _urlCtrl;
  late final TextEditingController _keyCtrl;

  @override
  void initState() {
    super.initState();
    _urlCtrl = TextEditingController(text: SupabaseConfig.currentUrl);
    _keyCtrl = TextEditingController(text: SupabaseConfig.currentAnonKey);
  }

  @override
  void dispose() {
    _urlCtrl.dispose();
    _keyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsCtrl = Get.find<SettingsController>();

    return AppShell(
      breadcrumbs: const ['Administration', 'Platform Settings'],
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
                    Text('Enterprise Platform Configuration', style: AppTextStyles.h1),
                    const SizedBox(height: 4),
                    Text('System valuation principles, automated reorder triggers, Supabase cloud sync, and scanner peripherals', style: AppTextStyles.bodySmall),
                  ],
                ),
                AppButton(
                  label: 'Save Configuration',
                  prefixIcon: Icons.save_outlined,
                  onPressed: () {
                    Get.snackbar('Configuration Saved', 'System parameters updated across all nodes.', backgroundColor: AppColors.success, colorText: Colors.white);
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Supabase Database Connection Card
            Obx(() {
              final isOnline = settingsCtrl.isConnected;
              return Material(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isOnline ? AppColors.success.withValues(alpha: 0.6) : AppColors.primary.withValues(alpha: 0.4),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 12,
                        runSpacing: 10,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: (isOnline ? AppColors.success : AppColors.primary).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.cloud_sync_rounded,
                                  color: isOnline ? AppColors.success : AppColors.primary,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Supabase PostgreSQL Cloud Backend', style: AppTextStyles.h3, overflow: TextOverflow.ellipsis),
                                    Text(
                                      isOnline ? 'Online — Connected to live PostgreSQL database' : 'Ready — Local Reactive Store (Offline Viva Mode)',
                                      style: AppTextStyles.caption.copyWith(
                                        color: isOnline ? AppColors.success : AppColors.textSecondary,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          AppBadge(
                            label: isOnline ? 'Online (PostgreSQL)' : 'Offline / Viva Ready',
                            variant: isOnline ? AppBadgeVariant.success : AppBadgeVariant.warning,
                            dot: true,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text('Row Level Security (RLS) is active. Client operations authenticate with public anon key.', style: AppTextStyles.bodySmall),
                      const SizedBox(height: 16),
                      AppTextField(
                        label: 'Supabase Project URL',
                        hint: 'https://your-project.supabase.co',
                        controller: _urlCtrl,
                        prefixIcon: Icons.link_rounded,
                      ),
                      const SizedBox(height: 14),
                      AppTextField(
                        label: 'Supabase Anon Public Key',
                        hint: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
                        controller: _keyCtrl,
                        prefixIcon: Icons.key_rounded,
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 12,
                        runSpacing: 10,
                        children: [
                          AppButton(
                            label: 'Connect & Verify Database',
                            prefixIcon: Icons.sync_rounded,
                            onPressed: () {
                              settingsCtrl.updateSupabaseConfig(
                                _urlCtrl.text.trim(),
                                _keyCtrl.text.trim(),
                              );
                            },
                          ),
                          AppButton(
                            label: 'Reset to Demo Mode',
                            variant: AppButtonVariant.ghost,
                            onPressed: () {
                              _urlCtrl.text = 'https://demo-smartstock.supabase.co';
                              _keyCtrl.text = 'demo-anon-key';
                              settingsCtrl.updateSupabaseConfig(_urlCtrl.text, _keyCtrl.text);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 20),
            Material(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Inventory Valuation & Currency', style: AppTextStyles.h3),
                  const SizedBox(height: 16),
                  _settingTile(
                    'Costing Accounting Method',
                    'FIFO (First-In, First-Out) valuation standard for balance sheets',
                    AppBadge(label: 'FIFO Standard', variant: AppBadgeVariant.primary),
                  ),
                  const Divider(height: 24),
                  _settingTile(
                    'Base Reporting Currency',
                    'Primary ledger currency for procurement commitments and stock assets',
                    AppBadge(label: 'USD (\$)', variant: AppBadgeVariant.neutral),
                  ),
                ],
              ),
            ),
          ),
            const SizedBox(height: 20),
            Material(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Automation & Operational Rules', style: AppTextStyles.h3),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: Text('Autonomous AI Reorder Triggering', style: AppTextStyles.labelLarge),
                    subtitle: Text('Automatically generate draft POs when SKU reaches safety runaway threshold', style: AppTextStyles.bodySmall),
                    value: _autoReorder,
                    activeTrackColor: AppColors.primary,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (v) => setState(() => _autoReorder = v),
                  ),
                  const Divider(height: 20),
                  SwitchListTile(
                    title: Text('Offline Local Database Synchronization', style: AppTextStyles.labelLarge),
                    subtitle: Text('Cache critical warehouse manifests and barcodes for offline floor operations', style: AppTextStyles.bodySmall),
                    value: _offlineSync,
                    activeTrackColor: AppColors.primary,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (v) => setState(() => _offlineSync = v),
                  ),
                  const Divider(height: 20),
                  SwitchListTile(
                    title: Text('Acoustic Beep Feedback on Scan', style: AppTextStyles.labelLarge),
                    subtitle: Text('Emit audible verification tones upon successful RF barcode label scan', style: AppTextStyles.bodySmall),
                    value: _soundAlerts,
                    activeTrackColor: AppColors.primary,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (v) => setState(() => _soundAlerts = v),
                  ),
                  const Divider(height: 20),
                  SwitchListTile(
                    title: Text('Hardware Laser Scanner Emulation', style: AppTextStyles.labelLarge),
                    subtitle: Text('Capture HID USB and Bluetooth wedge keyboard scanner signals directly', style: AppTextStyles.bodySmall),
                    value: _barcodeLaser,
                    activeTrackColor: AppColors.primary,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (v) => setState(() => _barcodeLaser = v),
                  ),
                ],
              ),
            ),
          ),
          ],
        ),
      ),
    );
  }

  Widget _settingTile(String title, String sub, Widget trailing) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.labelLarge),
              const SizedBox(height: 4),
              Text(sub, style: AppTextStyles.bodySmall),
            ],
          ),
        ),
        const SizedBox(width: 12),
        trailing,
      ],
    );
  }
}

