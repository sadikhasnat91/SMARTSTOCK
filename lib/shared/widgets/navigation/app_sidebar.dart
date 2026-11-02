import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_stock/core/theme/app_colors.dart';
import 'package:smart_stock/core/theme/app_text_styles.dart';
import 'package:smart_stock/app/routes/app_routes.dart';

class _NavItem {
  final IconData icon;
  final String label;
  final String route;
  const _NavItem({required this.icon, required this.label, required this.route});
}

class _NavGroup {
  final String label;
  final List<_NavItem> items;
  const _NavGroup({required this.label, required this.items});
}

final _navGroups = [
  _NavGroup(label: 'Overview', items: [
    _NavItem(icon: Icons.dashboard_outlined, label: 'Executive Dashboard', route: AppRoutes.executiveDashboard),
    _NavItem(icon: Icons.inventory_outlined, label: 'Inventory Dashboard', route: AppRoutes.inventoryDashboard),
  ]),
  _NavGroup(label: 'Inventory', items: [
    _NavItem(icon: Icons.category_outlined, label: 'Products', route: AppRoutes.products),
    _NavItem(icon: Icons.label_outline, label: 'Categories', route: AppRoutes.categories),
    _NavItem(icon: Icons.qr_code_outlined, label: 'Barcode Management', route: AppRoutes.barcodeManagement),
    _NavItem(icon: Icons.assessment_outlined, label: 'Inventory Overview', route: AppRoutes.inventoryOverview),
    _NavItem(icon: Icons.swap_horiz_rounded, label: 'Stock Movements', route: AppRoutes.stockMovements),
    _NavItem(icon: Icons.tune_outlined, label: 'Stock Adjustment', route: AppRoutes.stockAdjustment),
  ]),
  _NavGroup(label: 'Warehouse', items: [
    _NavItem(icon: Icons.warehouse_outlined, label: 'Warehouses', route: AppRoutes.warehouses),
    _NavItem(icon: Icons.location_on_outlined, label: 'Locations', route: AppRoutes.locations),
    _NavItem(icon: Icons.compare_arrows_rounded, label: 'Stock Transfers', route: AppRoutes.transfers),
  ]),
  _NavGroup(label: 'Procurement', items: [
    _NavItem(icon: Icons.local_shipping_outlined, label: 'Suppliers', route: AppRoutes.suppliers),
    _NavItem(icon: Icons.request_quote_outlined, label: 'Purchase Requests', route: AppRoutes.purchaseRequests),
    _NavItem(icon: Icons.shopping_cart_outlined, label: 'Purchase Orders', route: AppRoutes.purchaseOrders),
    _NavItem(icon: Icons.move_to_inbox_outlined, label: 'Goods Receiving', route: AppRoutes.goodsReceiving),
  ]),
  _NavGroup(label: 'Sales & Orders', items: [
    _NavItem(icon: Icons.people_outline, label: 'Customers', route: AppRoutes.customers),
    _NavItem(icon: Icons.receipt_long_outlined, label: 'Sales Orders', route: AppRoutes.salesOrders),
    _NavItem(icon: Icons.bookmark_border_rounded, label: 'Reservations', route: AppRoutes.reservations),
    _NavItem(icon: Icons.local_play_outlined, label: 'Order Fulfillment', route: AppRoutes.pickingDashboard),
    _NavItem(icon: Icons.assignment_return_outlined, label: 'Returns', route: AppRoutes.returns),
  ]),
  _NavGroup(label: 'Intelligence', items: [
    _NavItem(icon: Icons.auto_awesome_outlined, label: 'Inventory Intelligence', route: AppRoutes.intelligenceDashboard),
    _NavItem(icon: Icons.timeline_outlined, label: 'Demand Forecasting', route: AppRoutes.demandForecasting),
    _NavItem(icon: Icons.warning_amber_outlined, label: 'Stock-out Risk', route: AppRoutes.stockoutRisk),
    _NavItem(icon: Icons.refresh_outlined, label: 'Smart Reorder', route: AppRoutes.smartReorder),
    _NavItem(icon: Icons.smart_toy_outlined, label: 'AI Assistant', route: AppRoutes.aiAssistant),
  ]),
  _NavGroup(label: 'Analytics', items: [
    _NavItem(icon: Icons.bar_chart_outlined, label: 'Reports', route: AppRoutes.reportsCenter),
    _NavItem(icon: Icons.history_outlined, label: 'Audit Logs', route: AppRoutes.auditLogs),
  ]),
  _NavGroup(label: 'Administration', items: [
    _NavItem(icon: Icons.manage_accounts_outlined, label: 'User Management', route: AppRoutes.userManagement),
    _NavItem(icon: Icons.shield_outlined, label: 'Roles & Permissions', route: AppRoutes.rolesPermissions),
    _NavItem(icon: Icons.notifications_outlined, label: 'Notifications', route: AppRoutes.notifications),
    _NavItem(icon: Icons.settings_outlined, label: 'Settings', route: AppRoutes.settings),
  ]),
];

class AppSidebar extends StatelessWidget {
  final bool collapsed;
  final VoidCallback? onToggle;
  final double? width;
  final bool isDragging;

  const AppSidebar({
    super.key,
    this.collapsed = false,
    this.onToggle,
    this.width,
    this.isDragging = false,
  });

  @override
  Widget build(BuildContext context) {
    final currentRoute = Get.currentRoute;
    final effectiveWidth = width ?? (collapsed ? 64.0 : 250.0);

    return AnimatedContainer(
      duration: isDragging ? Duration.zero : const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      width: effectiveWidth,
      decoration: const BoxDecoration(
        color: AppColors.sidebarBackground,
        border: Border(right: BorderSide(color: Color(0xFF1E3028), width: 1)),
      ),
      child: ClipRect(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 170;

            return Column(
              children: [
                // Logo area
                SizedBox(
                  height: 60,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: isCompact ? 8 : 16),
                    child: isCompact
                        ? Center(
                            child: InkWell(
                              onTap: onToggle,
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.inventory_2_rounded, size: 18, color: Colors.white),
                              ),
                            ),
                          )
                        : Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.inventory_2_rounded, size: 18, color: Colors.white),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'SmartStock',
                                      style: AppTextStyles.h4.copyWith(color: Colors.white),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      'v1.0.0',
                                      style: AppTextStyles.caption.copyWith(color: AppColors.sidebarGroupLabel),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 6),
                              InkWell(
                                onTap: onToggle,
                                borderRadius: BorderRadius.circular(6),
                                child: const Padding(
                                  padding: EdgeInsets.all(6),
                                  child: Icon(Icons.menu_rounded, size: 18, color: AppColors.sidebarText),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                const Divider(color: Color(0xFF1E3028), height: 1),
                // Nav groups
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    children: _navGroups.map((group) {
                      return _SidebarGroup(
                        group: group,
                        collapsed: isCompact,
                        currentRoute: currentRoute,
                      );
                    }).toList(),
                  ),
                ),
                const Divider(color: Color(0xFF1E3028), height: 1),
                // Profile section
                Padding(
                  padding: EdgeInsets.all(isCompact ? 8 : 12),
                  child: InkWell(
                    onTap: () => Get.toNamed(AppRoutes.profile),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: isCompact ? 4 : 8, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.sidebarHoverBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: isCompact
                          ? Center(
                              child: CircleAvatar(
                                radius: 14,
                                backgroundColor: AppColors.primary,
                                child: Text(
                                  'AR',
                                  style: AppTextStyles.labelSmall.copyWith(color: Colors.white, fontSize: 11),
                                ),
                              ),
                            )
                          : Row(
                              children: [
                                CircleAvatar(
                                  radius: 14,
                                  backgroundColor: AppColors.primary,
                                  child: Text(
                                    'AR',
                                    style: AppTextStyles.labelSmall.copyWith(color: Colors.white, fontSize: 11),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Ahmed Rahman',
                                        style: AppTextStyles.labelSmall.copyWith(color: Colors.white),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        'Warehouse Manager',
                                        style: AppTextStyles.caption.copyWith(color: AppColors.sidebarGroupLabel),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.more_horiz_rounded, size: 16, color: AppColors.sidebarText),
                              ],
                            ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SidebarGroup extends StatelessWidget {
  final _NavGroup group;
  final bool collapsed;
  final String currentRoute;

  const _SidebarGroup({
    required this.group,
    required this.collapsed,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!collapsed)
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 16, bottom: 4, right: 16),
            child: Text(
              group.label.toUpperCase(),
              style: AppTextStyles.caption.copyWith(
                color: AppColors.sidebarGroupLabel,
                letterSpacing: 0.8,
                fontSize: 10,
              ),
            ),
          )
        else
          const SizedBox(height: 12),
        ...group.items.map((item) => _SidebarNavItem(
              item: item,
              collapsed: collapsed,
              isActive: currentRoute == item.route,
            )),
      ],
    );
  }
}

class _SidebarNavItem extends StatelessWidget {
  final _NavItem item;
  final bool collapsed;
  final bool isActive;

  const _SidebarNavItem({
    required this.item,
    required this.collapsed,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: collapsed ? item.label : '',
      preferBelow: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
        child: InkWell(
          onTap: () => Get.toNamed(item.route),
          borderRadius: BorderRadius.circular(7),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: EdgeInsets.symmetric(
              horizontal: collapsed ? 0 : 10,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: isActive ? AppColors.sidebarActiveBg : Colors.transparent,
              borderRadius: BorderRadius.circular(7),
            ),
            child: collapsed
                ? Center(
                    child: Icon(
                      item.icon,
                      size: 20,
                      color: isActive ? AppColors.primary : AppColors.sidebarText,
                    ),
                  )
                : Row(
                    children: [
                      Icon(
                        item.icon,
                        size: 18,
                        color: isActive ? AppColors.primary : AppColors.sidebarText,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          item.label,
                          style: AppTextStyles.labelMedium.copyWith(
                            color: isActive ? AppColors.sidebarActiveText : AppColors.sidebarText,
                            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isActive)
                        Container(
                          width: 5,
                          height: 5,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

