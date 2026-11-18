import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/layouts/app_shell.dart';
import '../../../shared/widgets/badges/app_badge.dart';
import '../../../shared/widgets/buttons/app_button.dart';
import '../../../shared/widgets/inputs/app_text_field.dart';
import '../../../app/routes/app_routes.dart';
import '../../../shared/controllers/transfer_controller.dart';

class TransferListScreen extends StatefulWidget {
  const TransferListScreen({super.key});

  @override
  State<TransferListScreen> createState() => _TransferListScreenState();
}

class _TransferListScreenState extends State<TransferListScreen> {
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(() {
      Get.find<TransferController>().searchQuery.value = _searchCtrl.text;
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final transferCtrl = Get.find<TransferController>();

    return AppShell(
      breadcrumbs: const ['Warehouse', 'Stock Transfers'],
      child: Obx(() {
        final list = transferCtrl.filteredTransfers;

        return SingleChildScrollView(
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
                      Text('Inter-Facility Stock Transfers', style: AppTextStyles.h1),
                      const SizedBox(height: 4),
                      Text('Track inventory rebalancing, replenishment transfers, and transit custody chains', style: AppTextStyles.bodySmall),
                    ],
                  ),
                  AppButton(
                    label: 'New Transfer Order',
                    prefixIcon: Icons.add_rounded,
                    onPressed: () => Get.toNamed(AppRoutes.transferCreate),
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
                child: AppSearchField(
                  hint: 'Search transfers by ID, origin, destination, or requester...',
                  controller: _searchCtrl,
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
                    width: 780,
                    child: Column(
                      children: [
                        Container(
                          color: AppColors.secondaryBackground,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          child: Row(
                            children: [
                              Expanded(flex: 2, child: Text('Transfer ID', style: AppTextStyles.labelSmall)),
                              Expanded(flex: 3, child: Text('Source Origin', style: AppTextStyles.labelSmall)),
                              Expanded(flex: 3, child: Text('Target Destination', style: AppTextStyles.labelSmall)),
                              Expanded(flex: 2, child: Text('Items Count', style: AppTextStyles.labelSmall)),
                              Expanded(flex: 2, child: Text('Requested By', style: AppTextStyles.labelSmall)),
                              Expanded(flex: 2, child: Text('Status', style: AppTextStyles.labelSmall)),
                              const SizedBox(width: 80, child: Text('Actions', style: AppTextStyles.labelSmall)),
                            ],
                          ),
                        ),
                        ...list.map((trf) {
                          final trfMap = trf.toJson();
                          return InkWell(
                            onTap: () => Get.toNamed(AppRoutes.transferDetail, arguments: trfMap),
                            hoverColor: AppColors.primarySurface.withValues(alpha: 0.2),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                              decoration: const BoxDecoration(
                                border: Border(bottom: BorderSide(color: AppColors.divider)),
                              ),
                              child: Row(
                                children: [
                                  Expanded(flex: 2, child: Text(trf.id, style: AppTextStyles.mono)),
                                  Expanded(
                                    flex: 3,
                                    child: Row(
                                      children: [
                                        const Icon(Icons.outbox_rounded, size: 16, color: AppColors.danger),
                                        const SizedBox(width: 8),
                                        Expanded(child: Text(trf.source, style: AppTextStyles.bodyMedium, overflow: TextOverflow.ellipsis)),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Row(
                                      children: [
                                        const Icon(Icons.inbox_rounded, size: 16, color: AppColors.success),
                                        const SizedBox(width: 8),
                                        Expanded(child: Text(trf.destination, style: AppTextStyles.bodyMedium, overflow: TextOverflow.ellipsis)),
                                      ],
                                    ),
                                  ),
                                  Expanded(flex: 2, child: Text('${trf.itemsCount} units', style: AppTextStyles.labelSmall)),
                                  Expanded(flex: 2, child: Text(trf.initiatedBy, style: AppTextStyles.caption)),
                                  Expanded(
                                    flex: 2,
                                    child: AppBadge.fromStatus(trf.status),
                                  ),
                                  SizedBox(
                                    width: 80,
                                    child: AppIconButton(
                                      icon: Icons.chevron_right_rounded,
                                      tooltip: 'Open Details',
                                      onPressed: () => Get.toNamed(AppRoutes.transferDetail, arguments: trfMap),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

