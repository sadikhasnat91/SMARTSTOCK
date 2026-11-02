import 'package:flutter/material.dart';
import 'package:smart_stock/core/theme/app_colors.dart';
import 'package:smart_stock/core/theme/app_text_styles.dart';

enum AppBadgeVariant { success, warning, danger, info, primary, neutral, purple }

class AppBadge extends StatelessWidget {
  final String label;
  final AppBadgeVariant variant;
  final bool dot;

  const AppBadge({
    super.key,
    required this.label,
    this.variant = AppBadgeVariant.neutral,
    this.dot = false,
  });

  factory AppBadge.fromStatus(String status) {
    final map = {
      'active': AppBadgeVariant.success,
      'in stock': AppBadgeVariant.success,
      'received': AppBadgeVariant.success,
      'delivered': AppBadgeVariant.success,
      'completed': AppBadgeVariant.success,
      'approved': AppBadgeVariant.success,
      'paid': AppBadgeVariant.success,
      'low stock': AppBadgeVariant.warning,
      'pending': AppBadgeVariant.warning,
      'pending approval': AppBadgeVariant.warning,
      'in progress': AppBadgeVariant.warning,
      'processing': AppBadgeVariant.info,
      'confirmed': AppBadgeVariant.info,
      'converted to po': AppBadgeVariant.info,
      'in transit': AppBadgeVariant.info,
      'shipped': AppBadgeVariant.info,
      'draft': AppBadgeVariant.neutral,
      'inactive': AppBadgeVariant.neutral,
      'refunded': AppBadgeVariant.neutral,
      'probationary': AppBadgeVariant.warning,
      'critical': AppBadgeVariant.danger,
      'cancelled': AppBadgeVariant.danger,
      'out of stock': AppBadgeVariant.danger,
      'high': AppBadgeVariant.warning,
      'urgent': AppBadgeVariant.danger,
      'normal': AppBadgeVariant.neutral,
    };
    final variant = map[status.toLowerCase()] ?? AppBadgeVariant.neutral;
    return AppBadge(label: status, variant: variant);
  }

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = _colors();
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dot ? 8 : 10,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: fg.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dot) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: fg,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 5),
          ],
          Flexible(
            child: Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(color: fg, fontSize: 11),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  (Color, Color) _colors() {
    return switch (variant) {
      AppBadgeVariant.success => (AppColors.successSurface, AppColors.success),
      AppBadgeVariant.warning => (AppColors.warningSurface, AppColors.warning),
      AppBadgeVariant.danger => (AppColors.dangerSurface, AppColors.danger),
      AppBadgeVariant.info => (AppColors.infoSurface, AppColors.info),
      AppBadgeVariant.primary => (AppColors.primarySurface, AppColors.primary),
      AppBadgeVariant.purple => (const Color(0xFFF0ECFF), const Color(0xFF7C5CFC)),
      AppBadgeVariant.neutral => (AppColors.secondaryBackground, AppColors.textSecondary),
    };
  }
}

