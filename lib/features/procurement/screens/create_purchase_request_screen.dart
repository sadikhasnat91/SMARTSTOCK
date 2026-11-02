import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/responsive/responsive_layout.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/layouts/app_shell.dart';
import '../../../shared/widgets/buttons/app_button.dart';
import '../../../shared/widgets/inputs/app_text_field.dart';

class CreatePurchaseRequestScreen extends StatefulWidget {
  const CreatePurchaseRequestScreen({super.key});

  @override
  State<CreatePurchaseRequestScreen> createState() => _CreatePurchaseRequestScreenState();
}

class _CreatePurchaseRequestScreenState extends State<CreatePurchaseRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _deptCtrl = TextEditingController(text: 'Warehouse Operations');
  final _budgetCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  String? _priority = 'High';

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);

    return AppShell(
      breadcrumbs: const ['Procurement', 'Purchase Requests', 'Draft Requisition'],
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
                      AppIconButton(
                        icon: Icons.arrow_back_rounded,
                        tooltip: 'Back',
                        onPressed: () => Get.back(),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text('Draft Requisition', style: AppTextStyles.h2, overflow: TextOverflow.ellipsis),
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
                        label: 'Submit for Sign-off',
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
                    Text('Requisition Header & Financial Allocation', style: AppTextStyles.h3),
                    const SizedBox(height: 20),
                    if (isMobile) ...[
                      AppTextField(
                        label: 'Requisition Purpose / Title *',
                        hint: 'e.g. Q4 Peak Electronics Stock Restocking',
                        controller: _titleCtrl,
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 14),
                      AppDropdownField<String>(
                        label: 'Requisition Priority',
                        value: _priority,
                        items: const [
                          DropdownMenuItem(value: 'Low', child: Text('Low')),
                          DropdownMenuItem(value: 'Medium', child: Text('Medium')),
                          DropdownMenuItem(value: 'High', child: Text('High')),
                          DropdownMenuItem(value: 'Urgent', child: Text('Urgent')),
                        ],
                        onChanged: (v) => setState(() => _priority = v),
                      ),
                    ] else
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: AppTextField(
                              label: 'Requisition Purpose / Title *',
                              hint: 'e.g. Q4 Peak Electronics Stock Restocking',
                              controller: _titleCtrl,
                              validator: (v) => v!.isEmpty ? 'Required' : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: AppDropdownField<String>(
                              label: 'Requisition Priority',
                              value: _priority,
                              items: const [
                                DropdownMenuItem(value: 'Low', child: Text('Low')),
                                DropdownMenuItem(value: 'Medium', child: Text('Medium')),
                                DropdownMenuItem(value: 'High', child: Text('High')),
                                DropdownMenuItem(value: 'Urgent', child: Text('Urgent')),
                              ],
                              onChanged: (v) => setState(() => _priority = v),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 16),
                    if (isMobile) ...[
                      AppTextField(
                        label: 'Charging Department *',
                        controller: _deptCtrl,
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 14),
                      AppTextField(
                        label: 'Estimated Budget Cap (\$)',
                        hint: '0.00',
                        controller: _budgetCtrl,
                        keyboardType: TextInputType.number,
                      ),
                    ] else
                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              label: 'Charging Department *',
                              controller: _deptCtrl,
                              validator: (v) => v!.isEmpty ? 'Required' : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: AppTextField(
                              label: 'Estimated Budget Cap (\$)',
                              hint: '0.00',
                              controller: _budgetCtrl,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'Procurement Business Case & Justification',
                      hint: 'Explain operational need, expected depletion timeline, or client order references...',
                      controller: _notesCtrl,
                      maxLines: 4,
                    ),
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
        'Purchase Request Logged',
        'PR-2024-0089 submitted to Approval Center for review.',
        backgroundColor: AppColors.success,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.back();
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _deptCtrl.dispose();
    _budgetCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }
}

