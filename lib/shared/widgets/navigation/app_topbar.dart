import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_stock/core/theme/app_colors.dart';
import 'package:smart_stock/core/theme/app_text_styles.dart';
import 'package:smart_stock/app/routes/app_routes.dart';
import 'package:smart_stock/shared/widgets/buttons/app_button.dart';
import 'package:smart_stock/shared/widgets/inputs/app_text_field.dart';
import 'package:smart_stock/shared/widgets/dialogs/app_dialog.dart';

class AppTopbar extends StatelessWidget implements PreferredSizeWidget {
  final List<String> breadcrumbs;
  final List<Widget>? actions;

  const AppTopbar({
    super.key,
    required this.breadcrumbs,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 1024;
    final isMobile = width < 600;

    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(bottom: BorderSide(color: AppColors.border, width: 1)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F1F1A).withValues(alpha: 0.03),
            offset: const Offset(0, 3),
            blurRadius: 10,
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 20),
      child: Row(
        children: [
          // Drawer toggle button for Mobile and Tablet
          if (!isDesktop) ...[
            Builder(
              builder: (ctx) => Container(
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: AppColors.secondaryBackground,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  icon: const Icon(Icons.menu_rounded, color: AppColors.textPrimary, size: 22),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 38, minHeight: 38),
                  onPressed: () {
                    Scaffold.of(ctx).openDrawer();
                  },
                ),
              ),
            ),
          ],
          // Breadcrumbs
          Expanded(
            child: AppBreadcrumbs(items: breadcrumbs),
          ),
          const SizedBox(width: 12),
          // Additional custom page actions
          if (actions != null) ...[
            ...actions!,
            const SizedBox(width: 8),
          ],
          // Global search on desktop
          if (isDesktop) ...[
            SizedBox(
              width: 250,
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  const AppSearchField(hint: 'Search anything...'),
                  Positioned(
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryBackground,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: AppColors.border, width: 1),
                      ),
                      child: Text(
                        '⌘K',
                        style: AppTextStyles.caption.copyWith(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
          ] else ...[
            AppIconButton(
              icon: Icons.search_rounded,
              tooltip: 'Search',
              onPressed: () {},
            ),
            const SizedBox(width: 4),
          ],
          // AI Assistant Quick Pill
          if (isDesktop) ...[
            InkWell(
              onTap: () => Get.toNamed(AppRoutes.aiAssistant),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFEBF7F2), Color(0xFFDEF2EB)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.25), width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.auto_awesome_rounded, size: 15, color: AppColors.primary),
                    const SizedBox(width: 5),
                    Text(
                      'AI Assistant',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
          // Notifications
          _NotificationButton(),
          const SizedBox(width: 8),
          // Profile menu
          _ProfileMenu(compact: isMobile),
        ],
      ),
    );
  }
}

class _NotificationButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        InkWell(
          onTap: () => Get.toNamed(AppRoutes.notifications),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.secondaryBackground,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border, width: 1),
            ),
            child: const Icon(
              Icons.notifications_outlined,
              size: 20,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Positioned(
          top: 6,
          right: 6,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.danger,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.danger.withValues(alpha: 0.6),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileMenu extends StatelessWidget {
  final bool compact;
  const _ProfileMenu({this.compact = false});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      offset: const Offset(0, 48),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: compact ? 6 : 10, vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.border, width: 1.2),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              offset: const Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(1.5),
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                radius: 14,
                backgroundColor: AppColors.surface,
                child: Text(
                  'SH',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            if (!compact) ...[
              const SizedBox(width: 8),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sadik Hasnat',
                    style: AppTextStyles.labelSmall.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    'Admin',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textMuted,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 6),
              const Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: AppColors.textMuted),
            ],
          ],
        ),
      ),
      itemBuilder: (context) => [
        _menuItem(Icons.person_outline, 'My Profile', AppRoutes.profile),
        _menuItem(Icons.settings_outlined, 'Settings', AppRoutes.settings),
        _menuItem(Icons.notifications_outlined, 'Notifications', AppRoutes.notifications),
        const PopupMenuDivider(),
        PopupMenuItem<String>(
          value: 'logout',
          child: Row(
            children: [
              const Icon(Icons.logout_rounded, size: 16, color: AppColors.danger),
              const SizedBox(width: 10),
              Text(
                'Sign Out',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.danger,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
      onSelected: (value) {
        if (value == 'logout') {
          Get.offAllNamed(AppRoutes.login);
        } else {
          Get.toNamed(value);
        }
      },
    );
  }

  PopupMenuItem<String> _menuItem(IconData icon, String label, String route) {
    return PopupMenuItem<String>(
      value: route,
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 10),
          Text(label, style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }
}
