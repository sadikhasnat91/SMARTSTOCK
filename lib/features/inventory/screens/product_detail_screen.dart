import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_stock/core/responsive/responsive_layout.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/layouts/app_shell.dart';
import '../../../shared/widgets/badges/app_badge.dart';
import '../../../shared/widgets/buttons/app_button.dart';
import '../../../data/mock/mock_products.dart';
import '../../../app/routes/app_routes.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final product = (Get.arguments as Map<String, dynamic>?) ?? MockProducts.products.first;
    final isDesktop = ResponsiveLayout.isDesktop(context);

    return AppShell(
      breadcrumbs: ['Inventory', 'Products', product['name'] as String],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.contentPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: [
                AppButton(
                  label: 'Back',
                  variant: AppButtonVariant.outline,
                  prefixIcon: Icons.arrow_back_rounded,
                  onPressed: () => Get.back(),
                ),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    AppButton(
                      label: 'Adjust Stock',
                      variant: AppButtonVariant.outline,
                      prefixIcon: Icons.tune_outlined,
                      onPressed: () => Get.toNamed(AppRoutes.stockAdjustment),
                    ),
                    AppButton(
                      label: 'Edit Product',
                      prefixIcon: Icons.edit_outlined,
                      onPressed: () => Get.toNamed(AppRoutes.productEdit, arguments: product),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (isDesktop)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left: product info
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        _buildInfoCard(product),
                        const SizedBox(height: 16),
                        _buildPricingCard(product),
                        const SizedBox(height: 16),
                        _buildTagsCard(product),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  // Right: stock info
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        _buildStockCard(product),
                        const SizedBox(height: 16),
                        _buildActivityCard(),
                      ],
                    ),
                  ),
                ],
              )
            else
              Column(
                children: [
                  _buildInfoCard(product),
                  const SizedBox(height: 16),
                  _buildPricingCard(product),
                  const SizedBox(height: 16),
                  _buildStockCard(product),
                  const SizedBox(height: 16),
                  _buildTagsCard(product),
                  const SizedBox(height: 16),
                  _buildActivityCard(),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(Map<String, dynamic> product) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Product header
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                width: 72, height: 72,
                decoration: BoxDecoration(
                  color: AppColors.secondaryBackground,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Icon(Icons.inventory_2_outlined, size: 32, color: AppColors.textMuted),
              ),
              const SizedBox(width: 16),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(product['name'] as String, style: AppTextStyles.h2),
                const SizedBox(height: 4),
                Text('${product['brand']} · ${product['category']}', style: AppTextStyles.bodySmall),
                const SizedBox(height: 8),
                AppBadge.fromStatus(product['status'] as String),
              ])),
            ]),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              _DetailRow('SKU', product['sku'] as String, mono: true),
              _DetailRow('Barcode', product['barcode'] as String, mono: true),
              _DetailRow('Category', product['category'] as String),
              _DetailRow('Brand', product['brand'] as String),
              _DetailRow('Unit', product['unit'] as String),
              _DetailRow('Weight', '${product['weight']} kg'),
              _DetailRow('Dimensions', product['dimensions'] as String),
            ]),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Description', style: AppTextStyles.labelMedium),
              const SizedBox(height: 8),
              Text(product['description'] as String, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary, height: 1.6)),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingCard(Map<String, dynamic> product) {
    final cost = product['costPrice'] as double;
    final sell = product['sellingPrice'] as double;
    final margin = ((sell - cost) / sell * 100).toStringAsFixed(1);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Pricing', style: AppTextStyles.h4),
        const SizedBox(height: 16),
        Row(children: [
          _PriceBox(label: 'Cost Price', value: '\$${cost.toStringAsFixed(2)}', color: AppColors.textSecondary),
          const SizedBox(width: 12),
          _PriceBox(label: 'Selling Price', value: '\$${sell.toStringAsFixed(2)}', color: AppColors.primary),
          const SizedBox(width: 12),
          _PriceBox(label: 'Margin', value: '$margin%', color: AppColors.success),
        ]),
      ]),
    );
  }

  Widget _buildTagsCard(Map<String, dynamic> product) {
    final tags = product['tags'] as List<dynamic>;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Tags', style: AppTextStyles.h4),
        const SizedBox(height: 12),
        Wrap(spacing: 8, runSpacing: 8, children: tags.map((t) => AppBadge(label: t as String, variant: AppBadgeVariant.primary)).toList()),
      ]),
    );
  }

  Widget _buildStockCard(Map<String, dynamic> product) {
    final stock = product['stock'] as int;
    final minStock = product['minStock'] as int;
    final maxStock = product['maxStock'] as int;
    final pct = (stock / maxStock).clamp(0.0, 1.0);
    final isLow = stock < minStock;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Stock Information', style: AppTextStyles.h4),
        const SizedBox(height: 16),
        _DetailRow('Current Stock', '$stock ${product['unit']}'),
        _DetailRow('Min Stock Level', '$minStock ${product['unit']}'),
        _DetailRow('Max Stock Level', '$maxStock ${product['unit']}'),
        _DetailRow('Warehouse', product['warehouse'] as String),
        const SizedBox(height: 16),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Stock Level', style: AppTextStyles.labelMedium),
          Text('${(pct * 100).toStringAsFixed(0)}%', style: AppTextStyles.labelSmall.copyWith(color: isLow ? AppColors.danger : AppColors.success)),
        ]),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: pct,
            backgroundColor: AppColors.secondaryBackground,
            valueColor: AlwaysStoppedAnimation<Color>(isLow ? AppColors.danger : AppColors.primary),
            minHeight: 8,
          ),
        ),
        const SizedBox(height: 4),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Min: $minStock', style: AppTextStyles.caption),
          Text('Max: $maxStock', style: AppTextStyles.caption),
        ]),
        if (isLow) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.warningSurface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
            ),
            child: Row(children: [
              const Icon(Icons.warning_amber_rounded, size: 16, color: AppColors.warning),
              const SizedBox(width: 8),
              Expanded(child: Text('Stock is below minimum level. Consider reordering.', style: AppTextStyles.caption.copyWith(color: AppColors.warning))),
            ]),
          ),
        ],
      ]),
    );
  }

  Widget _buildActivityCard() {
    final movements = MockProducts.stockMovements.take(3).toList();
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text('Recent Movements', style: AppTextStyles.h4),
        ),
        const Divider(height: 1),
        ...movements.map((m) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(children: [
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(
                color: m['type'] == 'Inbound' ? AppColors.successSurface : m['type'] == 'Outbound' ? AppColors.dangerSurface : AppColors.infoSurface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                m['type'] == 'Inbound' ? Icons.add_circle_outline : m['type'] == 'Outbound' ? Icons.remove_circle_outline : Icons.swap_horiz_rounded,
                size: 16,
                color: m['type'] == 'Inbound' ? AppColors.success : m['type'] == 'Outbound' ? AppColors.danger : AppColors.info,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(m['reference'] as String, style: AppTextStyles.labelSmall),
              Text(m['date'] as String, style: AppTextStyles.caption),
            ])),
            Text('${m['type'] == 'Outbound' ? '-' : '+'}${(m['qty'] as int).abs()} units', style: AppTextStyles.labelSmall.copyWith(
              color: m['type'] == 'Outbound' ? AppColors.danger : AppColors.success,
            )),
          ]),
        )),
      ]),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool mono;
  const _DetailRow(this.label, this.value, {this.mono = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(label, style: AppTextStyles.caption),
          ),
          Expanded(
            child: Text(
              value,
              style: mono ? AppTextStyles.mono.copyWith(fontSize: 13) : AppTextStyles.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _PriceBox({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(value, style: AppTextStyles.h3.copyWith(color: color)),
            ),
            const SizedBox(height: 4),
            Text(label, style: AppTextStyles.caption, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}

