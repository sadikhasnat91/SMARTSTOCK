import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/responsive/responsive_layout.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/layouts/app_shell.dart';
import '../../../shared/widgets/badges/app_badge.dart';
import '../../../shared/widgets/buttons/app_button.dart';
import '../../../shared/widgets/inputs/app_text_field.dart';
import '../../../shared/widgets/dialogs/app_dialog.dart';
import '../../../data/mock/mock_products.dart';

class BarcodeManagementScreen extends StatefulWidget {
  const BarcodeManagementScreen({super.key});

  @override
  State<BarcodeManagementScreen> createState() => _BarcodeManagementScreenState();
}

class _BarcodeManagementScreenState extends State<BarcodeManagementScreen> {
  final _searchCtrl = TextEditingController();
  String _selectedFormat = 'Code 128';
  List<Map<String, dynamic>> _items = [];

  @override
  void initState() {
    super.initState();
    _items = MockProducts.products;
  }

  void _filter(String query) {
    setState(() {
      _items = MockProducts.products.where((p) {
        final q = query.toLowerCase();
        return (p['name'] as String).toLowerCase().contains(q) ||
            (p['sku'] as String).toLowerCase().contains(q) ||
            (p['barcode'] as String).contains(q);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);

    return AppShell(
      breadcrumbs: const ['Inventory', 'Barcode Management'],
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
                    Text('Barcode & Label Management', style: AppTextStyles.h1),
                    const SizedBox(height: 4),
                    Text('Generate, scan verification, and batch print barcode labels', style: AppTextStyles.bodySmall),
                  ],
                ),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    AppButton(
                      label: 'Batch Print',
                      variant: AppButtonVariant.outline,
                      prefixIcon: Icons.print_outlined,
                      onPressed: () {
                        Get.snackbar(
                          'Print Spooler',
                          'Queueing ${_items.length} barcode labels to default thermal printer',
                          backgroundColor: AppColors.primary,
                          colorText: Colors.white,
                        );
                      },
                    ),
                    AppButton(
                      label: 'Scan Barcode',
                      prefixIcon: Icons.qr_code_scanner_rounded,
                      onPressed: () => _showScanModal(context),
                    ),
                  ],
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
              child: isMobile
                  ? Column(
                      children: [
                        AppSearchField(
                          hint: 'Search SKU, Product, or Barcode...',
                          controller: _searchCtrl,
                          onChanged: _filter,
                        ),
                        const SizedBox(height: 12),
                        AppDropdownField<String>(
                          label: null,
                          value: _selectedFormat,
                          items: const [
                            DropdownMenuItem(value: 'Code 128', child: Text('Code 128')),
                            DropdownMenuItem(value: 'EAN-13', child: Text('EAN-13')),
                            DropdownMenuItem(value: 'QR Code', child: Text('QR Code')),
                            DropdownMenuItem(value: 'DataMatrix', child: Text('DataMatrix')),
                          ],
                          onChanged: (v) => setState(() => _selectedFormat = v ?? 'Code 128'),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: AppSearchField(
                            hint: 'Search by SKU, Product Name, or Barcode numeric...',
                            controller: _searchCtrl,
                            onChanged: _filter,
                          ),
                        ),
                        const SizedBox(width: 16),
                        SizedBox(
                          width: 180,
                          child: AppDropdownField<String>(
                            label: null,
                            value: _selectedFormat,
                            items: const [
                              DropdownMenuItem(value: 'Code 128', child: Text('Code 128')),
                              DropdownMenuItem(value: 'EAN-13', child: Text('EAN-13')),
                              DropdownMenuItem(value: 'QR Code', child: Text('QR Code')),
                              DropdownMenuItem(value: 'DataMatrix', child: Text('DataMatrix')),
                            ],
                            onChanged: (v) => setState(() => _selectedFormat = v ?? 'Code 128'),
                          ),
                        ),
                      ],
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
                  width: 900,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        decoration: const BoxDecoration(
                          color: AppColors.secondaryBackground,
                          border: Border(bottom: BorderSide(color: AppColors.border)),
                        ),
                        child: Row(
                          children: [
                            Expanded(flex: 3, child: Text('Product / Item', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('SKU', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 3, child: Text('Barcode Representation', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Standard Format', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 2, child: Text('Status', style: AppTextStyles.labelSmall)),
                            const SizedBox(width: 120, child: Text('Actions', style: AppTextStyles.labelSmall)),
                          ],
                        ),
                      ),
                      ..._items.map((prod) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide(color: AppColors.divider)),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(prod['name'] as String, style: AppTextStyles.labelLarge),
                                      Text(prod['category'] as String, style: AppTextStyles.caption),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(prod['sku'] as String, style: AppTextStyles.mono),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: AppColors.secondaryBackground,
                                          borderRadius: BorderRadius.circular(6),
                                          border: Border.all(color: AppColors.border),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(Icons.line_weight_rounded, size: 20, color: AppColors.textPrimary),
                                            const SizedBox(width: 8),
                                            Text(prod['barcode'] as String, style: AppTextStyles.mono.copyWith(letterSpacing: 1.2)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(_selectedFormat, style: AppTextStyles.bodySmall),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: AppBadge(label: 'Verified', variant: AppBadgeVariant.success, dot: true),
                                ),
                                SizedBox(
                                  width: 120,
                                  child: Row(
                                    children: [
                                      AppIconButton(
                                        icon: Icons.print_rounded,
                                        tooltip: 'Print Label',
                                        onPressed: () {
                                          Get.snackbar(
                                            'Label Dispatched',
                                            'Printing 1 label for ${prod['sku']}',
                                            snackPosition: SnackPosition.BOTTOM,
                                          );
                                        },
                                      ),
                                      AppIconButton(
                                        icon: Icons.download_rounded,
                                        tooltip: 'Download SVG/PNG',
                                        onPressed: () {},
                                      ),
                                      AppIconButton(
                                        icon: Icons.refresh_rounded,
                                        tooltip: 'Regenerate Code',
                                        onPressed: () {},
                                      ),
                                    ],
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

  void _showScanModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AppDialog(
        title: 'Barcode Reader Simulation',
        content: Column(
          children: [
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.qr_code_scanner_rounded, size: 84, color: AppColors.primaryLight),
                  Positioned(
                    bottom: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      color: Colors.black54,
                      child: Text('Simulated Laser Sensor Ready', style: AppTextStyles.caption.copyWith(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const AppTextField(
              label: 'Manual Barcode Entry / Scanner Input',
              hint: 'Scan or type 13-digit barcode...',
              prefixIcon: Icons.keyboard_alt_outlined,
            ),
          ],
        ),
        actions: [
          AppButton(
            label: 'Close',
            variant: AppButtonVariant.outline,
            onPressed: () => Navigator.pop(context),
          ),
          AppButton(
            label: 'Lookup Item',
            prefixIcon: Icons.search_rounded,
            onPressed: () {
              Navigator.pop(context);
              Get.snackbar('Product Found', 'USB-C Hub 7-in-1 [ELC-0042] in WH-Main A-01-02');
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }
}

