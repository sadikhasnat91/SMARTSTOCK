import 'package:flutter/material.dart';
import 'package:smart_stock/core/theme/app_colors.dart';
import 'package:smart_stock/core/theme/app_text_styles.dart';
import '../buttons/app_button.dart';

class AppDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget>? actions;
  final double? width;

  const AppDialog({
    super.key,
    required this.title,
    required this.content,
    this.actions,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        width: width ?? 540,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border, width: 1.2),
          boxShadow: AppColors.shadow3DElevated,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 3D Title bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFFCFDFD), Color(0xFFF6FAF8)],
                  ),
                  border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary,
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        title,
                        style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryBackground,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.close_rounded, size: 18, color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              ),
              // Content
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: content,
                ),
              ),
              // Actions
              if (actions != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFBFDFC),
                    border: Border(top: BorderSide(color: AppColors.border, width: 1)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: actions!
                        .expand((w) => [w, const SizedBox(width: 10)])
                        .toList()
                      ..removeLast(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmLabel;
  final bool isDangerous;
  final VoidCallback onConfirm;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmLabel = 'Confirm',
    this.isDangerous = false,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: title,
      width: 440,
      content: Text(
        message,
        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary, height: 1.5),
      ),
      actions: [
        AppButton(
          label: 'Cancel',
          variant: AppButtonVariant.outline,
          onPressed: () => Navigator.of(context).pop(),
        ),
        AppButton(
          label: confirmLabel,
          variant: isDangerous ? AppButtonVariant.danger : AppButtonVariant.primary,
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm();
          },
        ),
      ],
    );
  }
}

class AppEmptyState extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final Widget? action;

  const AppEmptyState({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFFFFFF), Color(0xFFEFF5F2)],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border, width: 1.5),
                boxShadow: AppColors.shadow3DCard,
              ),
              child: Icon(icon, size: 34, color: AppColors.primary),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 380),
              child: Text(
                message,
                style: AppTextStyles.bodySmall.copyWith(height: 1.5),
                textAlign: TextAlign.center,
              ),
            ),
            if (action != null) ...[
              const SizedBox(height: 22),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

class AppLoadingState extends StatelessWidget {
  final String? message;
  const AppLoadingState({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              boxShadow: AppColors.shadow3DCard,
            ),
            child: const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 2.8,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(message!, style: AppTextStyles.bodySmall),
          ],
        ],
      ),
    );
  }
}

class AppBreadcrumbs extends StatelessWidget {
  final List<String> items;

  const AppBreadcrumbs({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    final displayItems = isMobile && items.length > 2
        ? ['...', items[items.length - 2], items.last]
        : items;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: displayItems.asMap().entries.expand((e) {
          final isLast = e.key == displayItems.length - 1;
          return [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isLast ? 10 : 4,
                vertical: isLast ? 4 : 2,
              ),
              decoration: isLast
                  ? BoxDecoration(
                      color: AppColors.primarySurface,
                      borderRadius: BorderRadius.circular(6),
                    )
                  : null,
              child: Text(
                e.value,
                style: isLast
                    ? AppTextStyles.labelSmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      )
                    : AppTextStyles.caption.copyWith(color: AppColors.textMuted),
              ),
            ),
            if (!isLast)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: Icon(Icons.chevron_right_rounded, size: 14, color: AppColors.textMuted),
              ),
          ];
        }).toList(),
      ),
    );
  }
}
