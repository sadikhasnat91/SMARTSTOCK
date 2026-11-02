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
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 1024;
    final isMobile = width < 600;

    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
      ),
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 20),
      child: Row(
        children: [
          // Drawer toggle button for Mobile and Tablet
          if (!isDesktop) ...[
            Builder(
              builder: (ctx) => IconButton(
                icon: const Icon(Icons.menu_rounded, color: AppColors.textPrimary, size: 22),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                onPressed: () {
                  Scaffold.of(ctx).openDrawer();
                },
              ),
            ),
            const SizedBox(width: 8),
          ],
          // Breadcrumbs
          Expanded(
            child: AppBreadcrumbs(items: breadcrumbs),
          ),
          const SizedBox(width: 8),
          // Global search on desktop only
          if (isDesktop) ...[
            SizedBox(
              width: 240,
              child: const AppSearchField(hint: 'Search anything...'),
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
          // Notifications
          _NotificationButton(),
          const SizedBox(width: 4),
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
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
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
            decoration: const BoxDecoration(
              color: AppColors.danger,
              shape: BoxShape.circle,
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
      offset: const Offset(0, 44),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: compact ? 6 : 8, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: AppColors.primary,
              child: Text(
                'AR',
                style: AppTextStyles.labelSmall.copyWith(color: Colors.white, fontSize: 11),
              ),
            ),
            if (!compact) ...[
              const SizedBox(width: 8),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ahmed Rahman', style: AppTextStyles.labelSmall.copyWith(fontSize: 12)),
                  Text('Warehouse Manager', style: AppTextStyles.caption.copyWith(fontSize: 10)),
                ],
              ),
              const SizedBox(width: 8),
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
              Text('Sign Out', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.danger)),
            ],
          ),
        ),
      ],
      onSelected: (value) {
        if (value == 'logout') {
          Get.toNamed(AppRoutes.login);
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

