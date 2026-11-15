import 'package:flutter/material.dart';
import 'package:smart_stock/core/theme/app_colors.dart';
import 'package:smart_stock/core/theme/app_text_styles.dart';

class KpiCard extends StatefulWidget {
  final String label;
  final String value;
  final String? change;
  final bool? changePositive;
  final String? sub;
  final IconData icon;
  final Color? iconColor;
  final VoidCallback? onTap;

  const KpiCard({
    super.key,
    required this.label,
    required this.value,
    this.change,
    this.changePositive,
    this.sub,
    required this.icon,
    this.iconColor,
    this.onTap,
  });

  @override
  State<KpiCard> createState() => _KpiCardState();
}

class _KpiCardState extends State<KpiCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isPositive = widget.changePositive ?? true;
    final changeColor = isPositive ? AppColors.success : AppColors.danger;
    final iconBaseColor = widget.iconColor ?? AppColors.primary;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          transform: Matrix4.translationValues(0, _isHovered ? -3 : 0, 0),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: _isHovered ? AppColors.cardGradientSubtle : AppColors.cardGradient,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _isHovered
                  ? iconBaseColor.withValues(alpha: 0.35)
                  : AppColors.border,
              width: 1.2,
            ),
            boxShadow: _isHovered ? AppColors.shadow3DElevated : AppColors.shadow3DCard,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.label,
                      style: AppTextStyles.labelMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.1,
                        fontSize: 12.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // 3D Floating Icon Tile
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          iconBaseColor.withValues(alpha: _isHovered ? 0.20 : 0.12),
                          iconBaseColor.withValues(alpha: _isHovered ? 0.10 : 0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: iconBaseColor.withValues(alpha: _isHovered ? 0.35 : 0.15),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: iconBaseColor.withValues(alpha: _isHovered ? 0.25 : 0.10),
                          blurRadius: _isHovered ? 8 : 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      widget.icon,
                      size: 16,
                      color: iconBaseColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.value,
                  style: AppTextStyles.displayMedium.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                  ),
                ),
              ),
              if (widget.change != null) ...[
                const SizedBox(height: 4),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 4,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                      decoration: BoxDecoration(
                        color: changeColor.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isPositive ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                            size: 12,
                            color: changeColor,
                          ),
                          const SizedBox(width: 2.5),
                          Text(
                            widget.change!,
                            style: AppTextStyles.labelSmall.copyWith(
                              color: changeColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (widget.sub != null)
                      Text(
                        widget.sub!,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textMuted,
                          fontSize: 11,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class SectionCard extends StatelessWidget {
  final String? title;
  final Widget? titleTrailing;
  final Widget child;
  final EdgeInsets? padding;

  const SectionCard({
    super.key,
    this.title,
    this.titleTrailing,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1.2),
        boxShadow: AppColors.shadow3DCard,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFFCFDFD), Color(0xFFF7FAF8)],
                  ),
                  border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
                ),
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10,
                  runSpacing: 8,
                  children: [
                    Text(
                      title!,
                      style: AppTextStyles.h4.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                    ),
                    ?titleTrailing,
                  ],
                ),
              ),
            Padding(
              padding: padding ?? EdgeInsets.zero,
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

/// A versatile 3D surface card for modern layered layouts
class Card3D extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Gradient? gradient;
  final double radius;
  final VoidCallback? onTap;
  final List<BoxShadow>? shadows;
  final Border? border;

  const Card3D({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.gradient,
    this.radius = 16,
    this.onTap,
    this.shadows,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: gradient == null ? (color ?? AppColors.surface) : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(radius),
        border: border ?? Border.all(color: AppColors.border, width: 1.2),
        boxShadow: shadows ?? AppColors.shadow3DCard,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(radius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(radius),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );
  }
}
