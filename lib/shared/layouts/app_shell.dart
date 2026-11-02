import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_stock/core/responsive/responsive_layout.dart';
import 'package:smart_stock/shared/widgets/navigation/app_sidebar.dart';
import 'package:smart_stock/shared/widgets/navigation/app_topbar.dart';
import 'package:smart_stock/shared/controllers/sidebar_controller.dart';
import 'package:smart_stock/core/theme/app_colors.dart';

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
                        // Subtle continuous divider border
                        Container(
                          width: 1,
                          height: double.infinity,
                          color: const Color(0xFF1E3028),
                        ),
                        // Sleek grab handle pill indicator on hover/drag
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 150),
                          opacity: (isHovering || isDragging) ? 1.0 : 0.0,
                          child: Container(
                            width: 3,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(2),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.4),
                                  blurRadius: 4,
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
      drawer: Drawer(
        width: 250,
        backgroundColor: Colors.transparent,
        child: AppSidebar(collapsed: false),
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppTopbar(breadcrumbs: widget.breadcrumbs),
      ),
      body: widget.child,
    );
  }

  Widget _buildMobile() {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const Drawer(
        width: 260,
        backgroundColor: Colors.transparent,
        child: AppSidebar(collapsed: false),
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppTopbar(breadcrumbs: widget.breadcrumbs),
      ),
      body: SafeArea(child: widget.child),
    );
  }
}

