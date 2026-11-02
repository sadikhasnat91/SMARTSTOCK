import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/responsive/responsive_layout.dart';
import '../../../shared/layouts/app_shell.dart';
import '../../../shared/widgets/buttons/app_button.dart';
import '../../../shared/widgets/inputs/app_text_field.dart';
import '../../../data/mock/mock_suppliers.dart';

class CreatePurchaseOrderScreen extends StatefulWidget {
  const CreatePurchaseOrderScreen({super.key});

  @override
  State<CreatePurchaseOrderScreen> createState() => _CreatePurchaseOrderScreenState();
}

class _CreatePurchaseOrderScreenState extends State<CreatePurchaseOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _supplier = 'TechPro Ltd';
  String? _warehouse = 'WH-Main';
  final _deliveryDateCtrl = TextEditingController(text: '2026-11-15');
  final _totalCtrl = TextEditingController(text: '14,200.00');

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);

    return AppShell(
      breadcrumbs: const ['Procurement', 'Purchase Orders', 'Generate PO'],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.contentPadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 12,
                runSpacing: 12,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppButton(
                        label: 'Back',
                        variant: AppButtonVariant.outline,
                        prefixIcon: Icons.arrow_back_rounded,
                        onPressed: () => Get.back(),
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: Text(
                          'Generate Vendor PO',
                          style: AppTextStyles.h2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      AppButton(
                        label: 'Cancel',
                        variant: AppButtonVariant.ghost,
                        onPressed: () => Get.back(),
                      ),
                      AppButton(
                        label: 'Transmit to Vendor',
                        prefixIcon: Icons.send_rounded,
                        onPressed: _submit,
                      ),
                    ],
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Contract & Dispatch Criteria', style: AppTextStyles.h3),
                    const SizedBox(height: 20),
                    if (isMobile) ...[
                      AppDropdownField<String>(
                        label: 'Target Vendor / Supplier *',
                        value: _supplier,
                        items: MockSuppliers.suppliers.map((s) => DropdownMenuItem(
                          value: s['name'] as String,
                          child: Text(s['name'] as String),
                        )).toList(),
                        onChanged: (v) => setState(() => _supplier = v),
                      ),
                      const SizedBox(height: 16),
                      AppDropdownField<String>(
                        label: 'Receiving Warehouse Destination *',
                        value: _warehouse,
                        items: const [
                          DropdownMenuItem(value: 'WH-Main', child: Text('WH-Main (Dhaka DC)')),
                          DropdownMenuItem(value: 'WH-East', child: Text('WH-East (Narayanganj)')),
                          DropdownMenuItem(value: 'WH-West', child: Text('WH-West (Savar)')),
                          DropdownMenuItem(value: 'WH-Cold', child: Text('WH-Cold (Gazipur)')),
                        ],
                        onChanged: (v) => setState(() => _warehouse = v),
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        label: 'Mandated Delivery Deadline',
                        controller: _deliveryDateCtrl,
                        prefixIcon: Icons.calendar_today_rounded,
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        label: 'Total PO Net Commitment Value (\$)',
                        controller: _totalCtrl,
                        prefixIcon: Icons.attach_money_rounded,
                      ),
                    ] else ...[
                      Row(
                        children: [
                          Expanded(
                            child: AppDropdownField<String>(
                              label: 'Target Vendor / Supplier *',
                              value: _supplier,
                              items: MockSuppliers.suppliers.map((s) => DropdownMenuItem(
                                value: s['name'] as String,
                                child: Text(s['name'] as String),
                              )).toList(),
                              onChanged: (v) => setState(() => _supplier = v),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: AppDropdownField<String>(
                              label: 'Receiving Warehouse Destination *',
                              value: _warehouse,
                              items: const [
                                DropdownMenuItem(value: 'WH-Main', child: Text('WH-Main (Dhaka DC)')),
                                DropdownMenuItem(value: 'WH-East', child: Text('WH-East (Narayanganj)')),
                                DropdownMenuItem(value: 'WH-West', child: Text('WH-West (Savar)')),
                                DropdownMenuItem(value: 'WH-Cold', child: Text('WH-Cold (Gazipur)')),
                              ],
                              onChanged: (v) => setState(() => _warehouse = v),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              label: 'Mandated Delivery Deadline',
                              controller: _deliveryDateCtrl,
                              prefixIcon: Icons.calendar_today_rounded,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: AppTextField(
                              label: 'Total PO Net Commitment Value (\$)',
                              controller: _totalCtrl,
                              prefixIcon: Icons.attach_money_rounded,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Get.snackbar(
        'Purchase Order Dispatched',
        'PO-2024-0345 officially issued to $_supplier.',
        backgroundColor: AppColors.success,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.back();
    }
  }

  @override
  void dispose() {
    _deliveryDateCtrl.dispose();
    _totalCtrl.dispose();
    super.dispose();
  }
}

