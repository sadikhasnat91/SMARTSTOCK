import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_stock/core/responsive/responsive_layout.dart';
import 'package:smart_stock/shared/widgets/navigation/app_sidebar.dart';
import 'package:smart_stock/shared/widgets/navigation/app_topbar.dart';
import 'package:smart_stock/shared/controllers/sidebar_controller.dart';
import 'package:smart_stock/core/theme/app_colors.dart';
import 'package:smart_stock/core/theme/app_text_styles.dart';
import 'package:smart_stock/app/routes/app_routes.dart';

class AppShell extends StatefulWidget {
  final Widget child;
  final List<String> breadcrumbs;
  final List<Widget>? topbarActions;

  const AppShell({
    super.key,
    required this.child,
    required this.breadcrumbs,
    this.topbarActions,
  });

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  SidebarController get _sidebarCtrl {
    if (Get.isRegistered<SidebarController>()) {
      return Get.find<SidebarController>();
    }
    return Get.put(SidebarController(), permanent: true);
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      desktop: _buildDesktop(),
      tablet: _buildTablet(),
      mobile: _buildMobile(),
    );
  }

  Widget _buildDesktop() {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        final currentWidth = _sidebarCtrl.sidebarWidth.value;
        final isCollapsed = _sidebarCtrl.isCollapsed.value;
        final isDragging = _sidebarCtrl.isDragging.value;
        final isHovering = _sidebarCtrl.isHoveringHandle.value;

        return Row(
          children: [
            AppSidebar(
              width: currentWidth,
              collapsed: isCollapsed,
              isDragging: isDragging,
              onToggle: () => _sidebarCtrl.toggle(),
            ),
            // Draggable splitter handle for desktop/PC
            MouseRegion(
              cursor: SystemMouseCursors.resizeColumn,
              onEnter: (_) => _sidebarCtrl.isHoveringHandle.value = true,
              onExit: (_) => _sidebarCtrl.isHoveringHandle.value = false,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onDoubleTap: () => _sidebarCtrl.toggle(),
                onHorizontalDragStart: (_) {
                  _sidebarCtrl.isDragging.value = true;
                },
                onHorizontalDragUpdate: (details) {
                  _sidebarCtrl.addDelta(details.delta.dx);
                },
                onHorizontalDragEnd: (_) {
                  _sidebarCtrl.isDragging.value = false;
                },
                child: Tooltip(
                  message: 'Drag to resize sidebar • Double-click to toggle',
                  waitDuration: const Duration(milliseconds: 600),
                  child: SizedBox(
                    width: 8,
                    height: double.infinity,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Continuous divider line
                        Container(
                          width: 1,
                          height: double.infinity,
                          color: const Color(0xFF1E3028),
                        ),
                        // Sleek glowing pill grab indicator on hover/drag
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 150),
                          opacity: (isHovering || isDragging) ? 1.0 : 0.0,
                          child: Container(
                            width: 3.5,
                            height: 48,
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(2),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.5),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  AppTopbar(
                    breadcrumbs: widget.breadcrumbs,
                    actions: widget.topbarActions,
                  ),
                  Expanded(
                    child: widget.child,
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildTablet() {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const Drawer(
        width: 250,
        backgroundColor: Colors.transparent,
        child: AppSidebar(collapsed: false),
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: AppTopbar(
          breadcrumbs: widget.breadcrumbs,
          actions: widget.topbarActions,
        ),
      ),
      body: widget.child,
    );
  }

  Widget _buildMobile() {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const Drawer(
        width: 270,
        backgroundColor: Colors.transparent,
        child: AppSidebar(collapsed: false),
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: AppTopbar(
          breadcrumbs: widget.breadcrumbs,
          actions: widget.topbarActions,
        ),
      ),
      body: SafeArea(
        child: widget.child,
      ),
      bottomNavigationBar: _buildMobileBottomBar(context),
    );
  }

  Widget _buildMobileBottomBar(BuildContext context) {
    final currentRoute = Get.currentRoute;

    final tabs = [
      (Icons.dashboard_rounded, 'Overview', AppRoutes.executiveDashboard),
      (Icons.inventory_2_rounded, 'Inventory', AppRoutes.products),
      (Icons.receipt_long_rounded, 'Orders', AppRoutes.salesOrders),
      (Icons.auto_awesome_rounded, 'AI Intel', AppRoutes.intelligenceDashboard),
    ];

    return Builder(
      builder: (scaffoldCtx) => Container(
        height: 60,
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: const Border(top: BorderSide(color: AppColors.border, width: 1)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F1F1A).withValues(alpha: 0.05),
              offset: const Offset(0, -3),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          children: [
            ...tabs.map((tab) {
              final isSelected = currentRoute == tab.$3;
              return Expanded(
                child: InkWell(
                  onTap: () => Get.toNamed(tab.$3),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          tab.$1,
                          size: 20,
                          color: isSelected ? AppColors.primary : AppColors.textMuted,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          tab.$2,
                          style: AppTextStyles.labelSmall.copyWith(
                            fontSize: 10,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected ? AppColors.primary : AppColors.textMuted,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            // Menu drawer button
            Expanded(
              child: InkWell(
                onTap: () {
                  Scaffold.of(scaffoldCtx).openDrawer();
                },
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.menu_rounded,
                        size: 20,
                        color: AppColors.textMuted,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Menu',
                        style: AppTextStyles.labelSmall.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textMuted,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
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
}
