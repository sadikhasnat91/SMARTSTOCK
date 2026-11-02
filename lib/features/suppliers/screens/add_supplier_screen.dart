import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/responsive/responsive_layout.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/layouts/app_shell.dart';
import '../../../shared/widgets/buttons/app_button.dart';
import '../../../shared/widgets/inputs/app_text_field.dart';

class AddSupplierScreen extends StatefulWidget {
  const AddSupplierScreen({super.key});

  @override
  State<AddSupplierScreen> createState() => _AddSupplierScreenState();
}

class _AddSupplierScreenState extends State<AddSupplierScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _contactCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _countryCtrl = TextEditingController(text: 'Bangladesh');
  String? _category = 'Electronics';
  String? _terms = 'Net 30';

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);

    return AppShell(
      breadcrumbs: const ['Procurement', 'Suppliers', 'Add Supplier'],
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
                        child: Text('Add Supplier', style: AppTextStyles.h2, overflow: TextOverflow.ellipsis),
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
                        label: 'Save Supplier',
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
                    Text('Vendor Profile & SLA Parameters', style: AppTextStyles.h3),
                    const SizedBox(height: 20),
                    if (isMobile) ...[
                      AppTextField(
                        label: 'Supplier Corporate Legal Name *',
                        hint: 'e.g. Pacific Components Ltd',
                        controller: _nameCtrl,
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 14),
                      AppDropdownField<String>(
                        label: 'Primary Supply Category',
                        value: _category,
                        items: const [
                          DropdownMenuItem(value: 'Electronics', child: Text('Electronics')),
                          DropdownMenuItem(value: 'Office Supplies', child: Text('Office Supplies')),
                          DropdownMenuItem(value: 'Furniture', child: Text('Furniture')),
                          DropdownMenuItem(value: 'Packaging', child: Text('Packaging')),
                          DropdownMenuItem(value: 'Tools', child: Text('Tools')),
                        ],
                        onChanged: (v) => setState(() => _category = v),
                      ),
                    ] else
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: AppTextField(
                              label: 'Supplier Corporate Legal Name *',
                              hint: 'e.g. Pacific Components Ltd',
                              controller: _nameCtrl,
                              validator: (v) => v!.isEmpty ? 'Required' : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: AppDropdownField<String>(
                              label: 'Primary Supply Category',
                              value: _category,
                              items: const [
                                DropdownMenuItem(value: 'Electronics', child: Text('Electronics')),
                                DropdownMenuItem(value: 'Office Supplies', child: Text('Office Supplies')),
                                DropdownMenuItem(value: 'Furniture', child: Text('Furniture')),
                                DropdownMenuItem(value: 'Packaging', child: Text('Packaging')),
                                DropdownMenuItem(value: 'Tools', child: Text('Tools')),
                              ],
                              onChanged: (v) => setState(() => _category = v),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 16),
                    if (isMobile) ...[
                      AppTextField(
                        label: 'Primary Contact Person *',
                        hint: 'Full Name',
                        controller: _contactCtrl,
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 14),
                      AppTextField(
                        label: 'Official Email *',
                        hint: 'orders@vendor.com',
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 14),
                      AppTextField(
                        label: 'Telephone Number *',
                        hint: '+1-555-XXXX',
                        controller: _phoneCtrl,
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),
                    ] else
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
                              label: 'Official Email *',
                              hint: 'orders@vendor.com',
                              controller: _emailCtrl,
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) => v!.isEmpty ? 'Required' : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: AppTextField(
                              label: 'Telephone Number *',
                              hint: '+1-555-XXXX',
                              controller: _phoneCtrl,
                              validator: (v) => v!.isEmpty ? 'Required' : null,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 16),
                    if (isMobile) ...[
                      AppTextField(
                        label: 'Country of Incorporation',
                        controller: _countryCtrl,
                      ),
                      const SizedBox(height: 14),
                      AppDropdownField<String>(
                        label: 'Credit & Payment Terms',
                        value: _terms,
                        items: const [
                          DropdownMenuItem(value: 'Net 15', child: Text('Net 15')),
                          DropdownMenuItem(value: 'Net 30', child: Text('Net 30')),
                          DropdownMenuItem(value: 'Net 45', child: Text('Net 45')),
                          DropdownMenuItem(value: 'Net 60', child: Text('Net 60')),
                          DropdownMenuItem(value: 'Advance Payment', child: Text('Advance Payment')),
                        ],
                        onChanged: (v) => setState(() => _terms = v),
                      ),
                    ] else
                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              label: 'Country of Incorporation',
                              controller: _countryCtrl,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: AppDropdownField<String>(
                              label: 'Credit & Payment Terms',
                              value: _terms,
                              items: const [
                                DropdownMenuItem(value: 'Net 15', child: Text('Net 15')),
                                DropdownMenuItem(value: 'Net 30', child: Text('Net 30')),
                                DropdownMenuItem(value: 'Net 45', child: Text('Net 45')),
                                DropdownMenuItem(value: 'Net 60', child: Text('Net 60')),
                                DropdownMenuItem(value: 'Advance Payment', child: Text('Advance Payment')),
                              ],
                              onChanged: (v) => setState(() => _terms = v),
                            ),
                          ),
                        ],
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
        'Supplier Enrolled',
        'Vendor ${_nameCtrl.text} added to procurement directory.',
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
    _countryCtrl.dispose();
    super.dispose();
  }
}

