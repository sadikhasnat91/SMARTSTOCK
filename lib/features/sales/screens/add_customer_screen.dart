import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/responsive/responsive_layout.dart';
import '../../../shared/layouts/app_shell.dart';
import '../../../shared/widgets/buttons/app_button.dart';
import '../../../shared/widgets/inputs/app_text_field.dart';

class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({super.key});

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _contactCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _creditCtrl = TextEditingController(text: '25,000');
  String? _type = 'Enterprise';

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);

    return AppShell(
      breadcrumbs: const ['Sales & Orders', 'Customers', 'Register Account'],
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
                          'Onboard Customer',
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
                        label: 'Create Account',
                        prefixIcon: Icons.check_circle_outline,
                        onPressed: _save,
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
                    Text('Enterprise Profile & Credit Facility', style: AppTextStyles.h3),
                    const SizedBox(height: 20),
                    if (isMobile) ...[
                      AppTextField(
                        label: 'Company Name *',
                        hint: 'e.g. Apex Global Industries Ltd',
                        controller: _nameCtrl,
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      AppDropdownField<String>(
                        label: 'Customer Classification',
                        value: _type,
                        items: const [
                          DropdownMenuItem(value: 'Enterprise', child: Text('Enterprise')),
                          DropdownMenuItem(value: 'Business', child: Text('Business (Mid-tier)')),
                          DropdownMenuItem(value: 'Retailer', child: Text('Retailer')),
                        ],
                        onChanged: (v) => setState(() => _type = v),
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        label: 'Primary Contact Person *',
                        hint: 'Full Name',
                        controller: _contactCtrl,
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        label: 'Billing Email Address *',
                        hint: 'billing@company.com',
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        label: 'Phone Contact *',
                        hint: '+1-555-XXXX',
                        controller: _phoneCtrl,
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),
                    ] else ...[
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: AppTextField(
                              label: 'Company Name *',
                              hint: 'e.g. Apex Global Industries Ltd',
                              controller: _nameCtrl,
                              validator: (v) => v!.isEmpty ? 'Required' : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: AppDropdownField<String>(
                              label: 'Customer Classification',
                              value: _type,
                              items: const [
                                DropdownMenuItem(value: 'Enterprise', child: Text('Enterprise')),
                                DropdownMenuItem(value: 'Business', child: Text('Business (Mid-tier)')),
                                DropdownMenuItem(value: 'Retailer', child: Text('Retailer')),
                              ],
                              onChanged: (v) => setState(() => _type = v),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              label: 'Primary Contact Person *',
                              hint: 'Full Name',
                              controller: _contactCtrl,
                              validator: (v) => v!.isEmpty ? 'Required' : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: AppTextField(
                              label: 'Billing Email Address *',
                              hint: 'billing@company.com',
                              controller: _emailCtrl,
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) => v!.isEmpty ? 'Required' : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: AppTextField(
                              label: 'Phone Contact *',
                              hint: '+1-555-XXXX',
                              controller: _phoneCtrl,
                              validator: (v) => v!.isEmpty ? 'Required' : null,
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'Approved Credit Limit Cap (\$)',
                      controller: _creditCtrl,
                      prefixIcon: Icons.credit_card_rounded,
                      keyboardType: TextInputType.number,
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

  void _save() {
    if (_formKey.currentState!.validate()) {
      Get.snackbar(
        'Account Registered',
        'Customer ${_nameCtrl.text} added to sales directory.',
        backgroundColor: AppColors.success,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.back();
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _contactCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _creditCtrl.dispose();
    super.dispose();
  }
}

