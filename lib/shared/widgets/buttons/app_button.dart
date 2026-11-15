import 'package:flutter/material.dart';
import 'package:smart_stock/core/theme/app_colors.dart';
import 'package:smart_stock/core/theme/app_text_styles.dart';

enum AppButtonVariant { primary, secondary, outline, ghost, danger }

class AppButton extends StatefulWidget {
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
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.onPressed != null && !widget.loading;
    final (bgGradient, bgColor, fgColor, border, shadows) = _buttonStyling();

    final content = Row(
      mainAxisSize: widget.expanded ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.loading)
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              valueColor: AlwaysStoppedAnimation<Color>(fgColor),
            ),
          )
        else ...[
          if (widget.prefixIcon != null) ...[
            Icon(widget.prefixIcon, size: 16, color: fgColor),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Text(
              widget.label,
              style: AppTextStyles.labelLarge.copyWith(
                color: fgColor,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.1,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          if (widget.suffixIcon != null) ...[
            const SizedBox(width: 8),
            Icon(widget.suffixIcon, size: 16, color: fgColor),
          ],
        ],
      ],
    );

    return SizedBox(
      height: widget.height ?? 40,
      child: MouseRegion(
        onEnter: (_) => isEnabled ? setState(() => _isHovered = true) : null,
        onExit: (_) => isEnabled ? setState(() => _isHovered = false) : null,
        cursor: isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
        child: GestureDetector(
          onTapDown: (_) => isEnabled ? setState(() => _isPressed = true) : null,
          onTapUp: (_) => isEnabled ? setState(() => _isPressed = false) : null,
          onTapCancel: () => isEnabled ? setState(() => _isPressed = false) : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            curve: Curves.easeOutCubic,
            transform: Matrix4.translationValues(
              0,
              _isPressed ? 1.5 : (_isHovered ? -1.5 : 0),
              0,
            ),
            decoration: BoxDecoration(
              gradient: bgGradient,
              color: bgGradient == null ? bgColor : null,
              borderRadius: BorderRadius.circular(10),
              border: border,
              boxShadow: _isPressed
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        offset: const Offset(0, 1),
                        blurRadius: 2,
                      ),
                    ]
                  : (_isHovered
                      ? (shadows?.map((s) => BoxShadow(
                            color: s.color.withValues(alpha: (s.color.a * 1.3).clamp(0.0, 1.0)),
                            offset: Offset(s.offset.dx, s.offset.dy + 2),
                            blurRadius: s.blurRadius + 4,
                            spreadRadius: s.spreadRadius,
                          )).toList() ?? [])
                      : shadows),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: isEnabled ? widget.onPressed : null,
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: content,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  (Gradient?, Color?, Color, Border?, List<BoxShadow>?) _buttonStyling() {
    switch (widget.variant) {
      case AppButtonVariant.primary:
        return (
          _isHovered ? AppColors.primaryGradientElevated : AppColors.primaryGradient,
          null,
          Colors.white,
          Border.all(
            color: Colors.white.withValues(alpha: 0.25),
            width: 1,
          ),
          AppColors.shadow3DButton,
        );
      case AppButtonVariant.secondary:
        return (
          null,
          _isHovered ? const Color(0xFFD8EFE5) : AppColors.primarySurface,
          AppColors.primary,
          Border.all(
            color: AppColors.primary.withValues(alpha: 0.25),
            width: 1,
          ),
          AppColors.shadow3DSubtle,
        );
      case AppButtonVariant.outline:
        return (
          null,
          _isHovered ? const Color(0xFFF9FBFA) : Colors.white,
          AppColors.textPrimary,
          Border.all(
            color: _isHovered ? AppColors.primary : AppColors.border,
            width: 1.2,
          ),
          AppColors.shadow3DSubtle,
        );
      case AppButtonVariant.ghost:
        return (
          null,
          _isHovered ? AppColors.secondaryBackground : Colors.transparent,
          AppColors.textSecondary,
          null,
          null,
        );
      case AppButtonVariant.danger:
        return (
          null,
          _isHovered ? const Color(0xFFFCDADA) : AppColors.dangerSurface,
          AppColors.danger,
          Border.all(
            color: AppColors.danger.withValues(alpha: 0.3),
            width: 1,
          ),
          AppColors.shadow3DSubtle,
        );
    }
  }
}

class AppIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? color;
  final bool active;
  final double size;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.color,
    this.active = false,
    this.size = 36,
  });

  @override
  State<AppIconButton> createState() => _AppIconButtonState();
}

class _AppIconButtonState extends State<AppIconButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.active;
    final iconColor = active
        ? AppColors.primary
        : (widget.color ?? (_isHovered ? AppColors.textPrimary : AppColors.textSecondary));

    final btn = MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: active
              ? AppColors.primarySurface
              : (_isHovered ? AppColors.secondaryBackground : Colors.transparent),
          borderRadius: BorderRadius.circular(10),
          border: active
              ? Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 1)
              : (_isHovered ? Border.all(color: AppColors.border, width: 1) : null),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onPressed,
            borderRadius: BorderRadius.circular(10),
            child: Icon(
              widget.icon,
              size: widget.size * 0.52,
              color: iconColor,
            ),
          ),
        ),
      ),
    );

    if (widget.tooltip != null) {
      return Tooltip(message: widget.tooltip!, child: btn);
    }
    return btn;
  }
}
