import 'package:flutter/material.dart';
import 'package:smart_stock/core/theme/app_colors.dart';
import 'package:smart_stock/core/theme/app_text_styles.dart';

class AppTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final IconData? prefixIcon;
  final Widget? suffix;
  final int? maxLines;
  final bool readOnly;
  final VoidCallback? onTap;
  final void Function(String)? onChanged;
  final bool autofocus;

  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffix,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: AppTextStyles.labelMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
        ],
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                offset: const Offset(0, 1),
                blurRadius: 3,
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            validator: validator,
            keyboardType: keyboardType,
            obscureText: obscureText,
            maxLines: maxLines,
            readOnly: readOnly,
            onTap: onTap,
            onChanged: onChanged,
            autofocus: autofocus,
            style: AppTextStyles.bodyMedium,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: prefixIcon != null
                  ? Icon(prefixIcon, size: 18, color: AppColors.textMuted)
                  : null,
              suffixIcon: suffix,
            ),
          ),
        ),
      ],
    );
  }
}

class AppSearchField extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final VoidCallback? onClear;

  const AppSearchField({
    super.key,
    this.hint = 'Search...',
    this.controller,
    this.onChanged,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F1F1A).withValues(alpha: 0.03),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        style: AppTextStyles.bodyMedium,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
          prefixIcon: const Icon(Icons.search_rounded, size: 18, color: AppColors.textMuted),
          suffixIcon: (controller?.text.isNotEmpty ?? false)
              ? IconButton(
                  icon: const Icon(Icons.close_rounded, size: 16, color: AppColors.textMuted),
                  onPressed: onClear,
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
          filled: true,
          fillColor: Colors.transparent,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.8),
          ),
        ),
      ),
    );
  }
}

class AppDropdownField<T> extends StatelessWidget {
  final String? label;
  final String hint;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?)? onChanged;

  const AppDropdownField({
    super.key,
    this.label,
    this.hint = 'Select...',
    this.value,
    required this.items,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: AppTextStyles.labelMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
        ],
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                offset: const Offset(0, 1),
                blurRadius: 3,
              ),
            ],
          ),
          child: DropdownButtonFormField<T>(
            initialValue: value,
            items: items,
            onChanged: onChanged,
            isExpanded: true,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: hint,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            ),
            borderRadius: BorderRadius.circular(12),
            icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: AppColors.textMuted),
            dropdownColor: AppColors.surface,
          ),
        ),
      ],
    );
  }
}
