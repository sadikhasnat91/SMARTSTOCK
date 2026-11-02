import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/responsive/responsive_layout.dart';
import '../../../shared/layouts/app_shell.dart';
import '../../../shared/widgets/buttons/app_button.dart';
import '../../../shared/widgets/inputs/app_text_field.dart';
import '../../../data/mock/mock_orders.dart';

class CreateSalesOrderScreen extends StatefulWidget {
  const CreateSalesOrderScreen({super.key});

  @override
  State<CreateSalesOrderScreen> createState() => _CreateSalesOrderScreenState();
}

class _CreateSalesOrderScreenState extends State<CreateSalesOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _customer = 'Apex Corporation';
  String? _warehouse = 'WH-Main';
  final _reqDateCtrl = TextEditingController(text: '2026-11-08');
  final _totalCtrl = TextEditingController(text: '4,200.00');

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);

    return AppShell(
      breadcrumbs: const ['Sales & Orders', 'Sales Orders', 'Create Order'],
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
                          'Draft New Sales Order',
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
                        label: 'Allocate Stock',
                        prefixIcon: Icons.check_circle_rounded,
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
                    Text('Customer & Dispatch Details', style: AppTextStyles.h3),
                    const SizedBox(height: 20),
                    if (isMobile) ...[
                      AppDropdownField<String>(
                        label: 'Corporate Client *',
                        value: _customer,
                        items: MockOrders.customers.map((c) => DropdownMenuItem(
                          value: c['name'] as String,
                          child: Text(c['name'] as String),
                        )).toList(),
                        onChanged: (v) => setState(() => _customer = v),
                      ),
                      const SizedBox(height: 16),
                      AppDropdownField<String>(
                        label: 'Fulfillment Origin Hub *',
                        value: _warehouse,
                        items: const [
                          DropdownMenuItem(value: 'WH-Main', child: Text('WH-Main (Dhaka DC)')),
                          DropdownMenuItem(value: 'WH-East', child: Text('WH-East (Narayanganj)')),
                          DropdownMenuItem(value: 'WH-West', child: Text('WH-West (Savar)')),
                        ],
                        onChanged: (v) => setState(() => _warehouse = v),
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        label: 'Required Delivery Date',
                        controller: _reqDateCtrl,
                        prefixIcon: Icons.calendar_today_rounded,
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        label: 'Order Total Net Value (\$)',
                        controller: _totalCtrl,
                        prefixIcon: Icons.attach_money_rounded,
                      ),
                    ] else ...[
                      Row(
                        children: [
                          Expanded(
                            child: AppDropdownField<String>(
                              label: 'Corporate Client *',
                              value: _customer,
                              items: MockOrders.customers.map((c) => DropdownMenuItem(
                                value: c['name'] as String,
                                child: Text(c['name'] as String),
                              )).toList(),
                              onChanged: (v) => setState(() => _customer = v),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: AppDropdownField<String>(
                              label: 'Fulfillment Origin Hub *',
                              value: _warehouse,
                              items: const [
                                DropdownMenuItem(value: 'WH-Main', child: Text('WH-Main (Dhaka DC)')),
                                DropdownMenuItem(value: 'WH-East', child: Text('WH-East (Narayanganj)')),
                                DropdownMenuItem(value: 'WH-West', child: Text('WH-West (Savar)')),
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
                              label: 'Required Delivery Date',
                              controller: _reqDateCtrl,
                              prefixIcon: Icons.calendar_today_rounded,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: AppTextField(
                              label: 'Order Total Net Value (\$)',
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
        'Sales Order Created',
        'SO-2024-0892 confirmed. Stock reserved at $_warehouse.',
        backgroundColor: AppColors.success,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.back();
    }
  }

  @override
  void dispose() {
    _reqDateCtrl.dispose();
    _totalCtrl.dispose();
    super.dispose();
  }
}

