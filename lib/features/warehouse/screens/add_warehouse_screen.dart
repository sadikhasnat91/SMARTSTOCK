import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/responsive/responsive_layout.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/layouts/app_shell.dart';
import '../../../shared/widgets/buttons/app_button.dart';
import '../../../shared/widgets/inputs/app_text_field.dart';

class AddWarehouseScreen extends StatefulWidget {
  const AddWarehouseScreen({super.key});

  @override
  State<AddWarehouseScreen> createState() => _AddWarehouseScreenState();
}

class _AddWarehouseScreenState extends State<AddWarehouseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _codeCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _managerCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _areaCtrl = TextEditingController();
  String? _selectedType = 'Distribution';

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);

    return AppShell(
      breadcrumbs: const ['Warehouse', 'Warehouses', 'Add Facility'],
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
                        child: Text('Add Facility', style: AppTextStyles.h2, overflow: TextOverflow.ellipsis),
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
                        label: 'Save Warehouse',
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
                    Text('General Facility Attributes', style: AppTextStyles.h3),
                    const SizedBox(height: 20),
                    if (isMobile) ...[
                      AppTextField(
                        label: 'Facility Name *',
                        hint: 'e.g. Northern Hub Regional Warehouse',
                        controller: _nameCtrl,
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 14),
                      AppTextField(
                        label: 'Warehouse Code *',
                        hint: 'e.g. WH-North',
                        controller: _codeCtrl,
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 14),
                      AppDropdownField<String>(
                        label: 'Facility Type',
                        value: _selectedType,
                        items: const [
                          DropdownMenuItem(value: 'Distribution', child: Text('Distribution')),
                          DropdownMenuItem(value: 'Regional', child: Text('Regional')),
                          DropdownMenuItem(value: 'Cold Storage', child: Text('Cold Storage')),
                          DropdownMenuItem(value: 'Bonded Warehouse', child: Text('Bonded Warehouse')),
                        ],
                        onChanged: (v) => setState(() => _selectedType = v),
                      ),
                    ] else
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: AppTextField(
                              label: 'Facility Name *',
                              hint: 'e.g. Northern Hub Regional Warehouse',
                              controller: _nameCtrl,
                              validator: (v) => v!.isEmpty ? 'Required' : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: AppTextField(
                              label: 'Warehouse Code *',
                              hint: 'e.g. WH-North',
                              controller: _codeCtrl,
                              validator: (v) => v!.isEmpty ? 'Required' : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: AppDropdownField<String>(
                              label: 'Facility Type',
                              value: _selectedType,
                              items: const [
                                DropdownMenuItem(value: 'Distribution', child: Text('Distribution')),
                                DropdownMenuItem(value: 'Regional', child: Text('Regional')),
                                DropdownMenuItem(value: 'Cold Storage', child: Text('Cold Storage')),
                                DropdownMenuItem(value: 'Bonded Warehouse', child: Text('Bonded Warehouse')),
                              ],
                              onChanged: (v) => setState(() => _selectedType = v),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'Physical Address *',
                      hint: 'Street, Industrial Zone, City, Postal Code',
                      controller: _addressCtrl,
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    if (isMobile) ...[
                      AppTextField(
                        label: 'Assigned Site Manager *',
                        hint: 'Full name',
                        controller: _managerCtrl,
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 14),
                      AppTextField(
                        label: 'Direct Contact Telephone *',
                        hint: '+880-2-XXXXXXX',
                        controller: _phoneCtrl,
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 14),
                      AppTextField(
                        label: 'Floor Surface Area (m²)',
                        hint: 'e.g. 10000',
                        controller: _areaCtrl,
                        keyboardType: TextInputType.number,
                      ),
                    ] else
                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              label: 'Assigned Site Manager *',
                              hint: 'Full name',
                              controller: _managerCtrl,
                              validator: (v) => v!.isEmpty ? 'Required' : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: AppTextField(
                              label: 'Direct Contact Telephone *',
                              hint: '+880-2-XXXXXXX',
                              controller: _phoneCtrl,
                              validator: (v) => v!.isEmpty ? 'Required' : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: AppTextField(
                              label: 'Floor Surface Area (m²)',
                              hint: 'e.g. 10000',
                              controller: _areaCtrl,
                              keyboardType: TextInputType.number,
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
        'Warehouse Registered',
        'Facility ${_nameCtrl.text} [${_codeCtrl.text}] successfully initialized.',
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
    _codeCtrl.dispose();
    _addressCtrl.dispose();
    _managerCtrl.dispose();
    _phoneCtrl.dispose();
    _areaCtrl.dispose();
    super.dispose();
  }
}

