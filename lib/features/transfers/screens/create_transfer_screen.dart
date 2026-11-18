import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/responsive/responsive_layout.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/layouts/app_shell.dart';
import '../../../shared/widgets/buttons/app_button.dart';
import '../../../shared/widgets/inputs/app_text_field.dart';
import '../../../data/mock/mock_products.dart';
import '../../../shared/controllers/transfer_controller.dart';
import '../../../data/models/stock_transfer_model.dart';

class CreateTransferScreen extends StatefulWidget {
  const CreateTransferScreen({super.key});

  @override
  State<CreateTransferScreen> createState() => _CreateTransferScreenState();
}

class _CreateTransferScreenState extends State<CreateTransferScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _from = 'WH-Main';
  String? _to = 'WH-East';
  String? _selectedSku = 'ELC-0042';
  final _qtyCtrl = TextEditingController(text: '15');
  final _carrierCtrl = TextEditingController(text: 'Apex Internal Logistics');

  final _warehouses = ['WH-Main', 'WH-East', 'WH-West', 'WH-Cold'];

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);

    return AppShell(
      breadcrumbs: const ['Warehouse', 'Stock Transfers', 'New Transfer Request'],
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
                        child: Text('Initiate Transfer', style: AppTextStyles.h2, overflow: TextOverflow.ellipsis),
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
                        label: 'Submit Transfer',
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
                    Text('Transfer Route Routing', style: AppTextStyles.h3),
                    const SizedBox(height: 20),
                    if (isMobile) ...[
                      AppDropdownField<String>(
                        label: 'Origin Dispatch Warehouse *',
                        value: _from,
                        items: _warehouses.map((w) => DropdownMenuItem(value: w, child: Text(w))).toList(),
                        onChanged: (v) => setState(() => _from = v),
                      ),
                      const SizedBox(height: 12),
                      const Center(child: Icon(Icons.arrow_downward_rounded, color: AppColors.textMuted)),
                      const SizedBox(height: 12),
                      AppDropdownField<String>(
                        label: 'Destination Receiving Warehouse *',
                        value: _to,
                        items: _warehouses.map((w) => DropdownMenuItem(value: w, child: Text(w))).toList(),
                        onChanged: (v) => setState(() => _to = v),
                      ),
                    ] else
                      Row(
                        children: [
                          Expanded(
                            child: AppDropdownField<String>(
                              label: 'Origin Dispatch Warehouse *',
                              value: _from,
                              items: _warehouses.map((w) => DropdownMenuItem(value: w, child: Text(w))).toList(),
                              onChanged: (v) => setState(() => _from = v),
                            ),
                          ),
                          const SizedBox(width: 20),
                          const Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Icon(Icons.arrow_forward_rounded, color: AppColors.textMuted),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: AppDropdownField<String>(
                              label: 'Destination Receiving Warehouse *',
                              value: _to,
                              items: _warehouses.map((w) => DropdownMenuItem(value: w, child: Text(w))).toList(),
                              onChanged: (v) => setState(() => _to = v),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 20),
                    if (isMobile) ...[
                      AppDropdownField<String>(
                        label: 'Item to Transfer *',
                        value: _selectedSku,
                        items: MockProducts.products.map((p) => DropdownMenuItem(
                          value: p['sku'] as String,
                          child: Text('${p['sku']} - ${p['name']}', overflow: TextOverflow.ellipsis),
                        )).toList(),
                        onChanged: (v) => setState(() => _selectedSku = v),
                      ),
                      const SizedBox(height: 14),
                      AppTextField(
                        label: 'Transfer Quantity *',
                        hint: 'e.g. 20',
                        controller: _qtyCtrl,
                        keyboardType: TextInputType.number,
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 14),
                      AppTextField(
                        label: 'Designated Carrier / Driver',
                        controller: _carrierCtrl,
                      ),
                    ] else
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: AppDropdownField<String>(
                              label: 'Item to Transfer *',
                              value: _selectedSku,
                              items: MockProducts.products.map((p) => DropdownMenuItem(
                                value: p['sku'] as String,
                                child: Text('${p['sku']} - ${p['name']}', overflow: TextOverflow.ellipsis),
                              )).toList(),
                              onChanged: (v) => setState(() => _selectedSku = v),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: AppTextField(
                              label: 'Transfer Quantity *',
                              hint: 'e.g. 20',
                              controller: _qtyCtrl,
                              keyboardType: TextInputType.number,
                              validator: (v) => v!.isEmpty ? 'Required' : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: AppTextField(
                              label: 'Designated Carrier / Driver',
                              controller: _carrierCtrl,
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

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final transferCtrl = Get.find<TransferController>();
      final newTransfer = StockTransferModel(
        id: 'TRF-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        source: _from ?? 'WH-Main',
        destination: _to ?? 'WH-East',
        date: DateTime.now().toString().split(' ')[0],
        itemsCount: int.tryParse(_qtyCtrl.text.trim()) ?? 1,
        status: 'In Transit',
        trackingNumber: 'TRK-${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}',
        initiatedBy: 'Ahmed Rahman (Logistics)',
      );

      final success = await transferCtrl.createTransfer(newTransfer);
      if (success) {
        Get.back();
      }
    }
  }

  @override
  void dispose() {
    _qtyCtrl.dispose();
    _carrierCtrl.dispose();
    super.dispose();
  }
}

