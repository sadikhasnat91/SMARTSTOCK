import 'package:flutter/material.dart';
import 'package:smart_stock/core/theme/app_colors.dart';
import 'package:smart_stock/core/theme/app_text_styles.dart';

enum AppButtonVariant { primary, secondary, outline, ghost, danger }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool loading;
  final bool expanded;
  final double? height;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.prefixIcon,
    this.suffixIcon,
    this.loading = false,
    this.expanded = false,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final (bg, fg, border) = _colors();
    final child = Row(
      mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (loading)
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(fg),
            ),
          )
        else ...[
          if (prefixIcon != null) ...[
            Icon(prefixIcon, size: 16, color: fg),
            const SizedBox(width: 7),
          ],
          Flexible(
            child: Text(
              label,
              style: AppTextStyles.labelLarge.copyWith(color: fg),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          if (suffixIcon != null) ...[
            const SizedBox(width: 7),
            Icon(suffixIcon, size: 16, color: fg),
          ],
        ],
      ],
    );

    return SizedBox(
      height: height ?? 38,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: loading ? null : onPressed,
          borderRadius: BorderRadius.circular(8),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(8),
              border: border != null ? Border.all(color: border, width: 1) : null,
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  (Color, Color, Color?) _colors() {
    return switch (variant) {
      AppButtonVariant.primary => (AppColors.primary, Colors.white, null),
      AppButtonVariant.secondary => (AppColors.primarySurface, AppColors.primary, AppColors.primarySurface),
      AppButtonVariant.outline => (Colors.white, AppColors.textPrimary, AppColors.border),
      AppButtonVariant.ghost => (Colors.transparent, AppColors.textSecondary, null),
      AppButtonVariant.danger => (AppColors.dangerSurface, AppColors.danger, AppColors.dangerSurface),
    };
  }
}

class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? color;
  final bool active;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.color,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    final btn = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: active ? AppColors.primarySurface : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 18,
            color: active ? AppColors.primary : (color ?? AppColors.textSecondary),
          ),
        ),
      ),
    );
    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: btn);
    }
    return btn;
  }
}

