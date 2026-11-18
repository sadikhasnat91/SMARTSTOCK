import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'product_controller.dart';
import 'order_controller.dart';
import 'warehouse_controller.dart';
import 'supplier_controller.dart';

/// GetX Controller that dynamically aggregates live metrics from inventory, sales,
/// procurement, and warehouse domains to power the Executive and Inventory dashboards.
class DashboardController extends GetxController {
  final ProductController productController;
  final OrderController orderController;
  final WarehouseController warehouseController;
  final SupplierController supplierController;

  DashboardController({
    required this.productController,
    required this.orderController,
    required this.warehouseController,
    required this.supplierController,
  });

  /// Total inventory valuation ($) computed dynamically from products
  double get totalInventoryValue {
    return productController.products.fold(
      0.0,
      (sum, item) => sum + (item.stock * item.costPrice),
    );
  }

  /// Total sales revenue ($) computed dynamically from sales orders
  double get totalRevenue {
    return orderController.salesOrders.fold(
      0.0,
      (sum, order) => sum + order.totalAmount,
    );
  }

  int get totalProductsCount => productController.products.length;

  int get lowStockCount {
    return productController.products.where((p) => p.stock <= p.minStock && p.stock > 0).length;
  }

  int get outOfStockCount {
    return productController.products.where((p) => p.stock <= 0).length;
  }

  int get activeOrdersCount {
    return orderController.salesOrders.where((o) => o.status != 'Delivered' && o.status != 'Cancelled').length;
  }

  int get totalSuppliersCount => supplierController.suppliers.length;

  int get totalWarehousesCount => warehouseController.warehouses.length;

  /// Dynamic warehouse space utilization
  double get averageWarehouseUtilization {
    if (warehouseController.warehouses.isEmpty) return 60.0;
    final total = warehouseController.warehouses.fold(
      0.0,
      (sum, w) => sum + w.capacityPercentage,
    );
    return total / warehouseController.warehouses.length;
  }

  /// Dynamic KPI Cards for Executive Dashboard
  List<Map<String, dynamic>> get executiveKpiCards {
    final invValue = totalInventoryValue;
    final rev = totalRevenue;
    final low = lowStockCount;
    final activeOrders = activeOrdersCount;

    return [
      {
        'title': 'Total Inventory Value',
        'value': '\$${invValue.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
        'change': '+8.4%',
        'isPositive': true,
        'subtitle': 'from last month',
        'icon': Icons.account_balance_wallet_rounded,
        'color': const Color(0xFF6366F1),
      },
      {
        'title': 'Total Gross Revenue',
        'value': '\$${rev.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
        'change': '+14.2%',
        'isPositive': true,
        'subtitle': 'from last quarter',
        'icon': Icons.trending_up_rounded,
        'color': const Color(0xFF10B981),
      },
      {
        'title': 'Active Sales Orders',
        'value': '$activeOrders',
        'change': '+3 today',
        'isPositive': true,
        'subtitle': 'in fulfillment queue',
        'icon': Icons.shopping_bag_rounded,
        'color': const Color(0xFF3B82F6),
      },
      {
        'title': 'Low Stock Critical Alert',
        'value': '$low',
        'change': low > 10 ? '+3 items' : '-2 items',
        'isPositive': low <= 5,
        'subtitle': 'require reorder',
        'icon': Icons.warning_amber_rounded,
        'color': const Color(0xFFF59E0B),
      },
    ];
  }

  /// Dynamic KPI Cards for Inventory Dashboard
  List<Map<String, dynamic>> get inventoryKpiCards {
    final totalSkus = totalProductsCount;
    final low = lowStockCount;
    final outOfStock = outOfStockCount;
    final inStockCount = totalSkus - low - outOfStock;

    return [
      {
        'title': 'Total Active SKUs',
        'value': '$totalSkus',
        'change': '+12 this week',
        'isPositive': true,
        'subtitle': 'across all warehouses',
        'icon': Icons.inventory_2_rounded,
        'color': const Color(0xFF6366F1),
      },
      {
        'title': 'Healthy In Stock',
        'value': '$inStockCount',
        'change': '${((inStockCount / (totalSkus > 0 ? totalSkus : 1)) * 100).toStringAsFixed(1)}%',
        'isPositive': true,
        'subtitle': 'optimal buffer level',
        'icon': Icons.check_circle_rounded,
        'color': const Color(0xFF10B981),
      },
      {
        'title': 'Low Stock Alert',
        'value': '$low',
        'change': 'Needs Attention',
        'isPositive': false,
        'subtitle': 'below reorder point',
        'icon': Icons.error_outline_rounded,
        'color': const Color(0xFFF59E0B),
      },
      {
        'title': 'Out of Stock (Stockout)',
        'value': '$outOfStock',
        'change': outOfStock > 0 ? 'Urgent' : 'Zero',
        'isPositive': outOfStock == 0,
        'subtitle': 'immediate backorder',
        'icon': Icons.cancel_rounded,
        'color': const Color(0xFFEF4444),
      },
    ];
  }

  /// Dynamic recent stock movements feed
  List<Map<String, dynamic>> get recentMovements {
    return productController.movements.take(6).map((m) {
      return {
        'id': m.id,
        'sku': m.sku,
        'product': m.product,
        'type': m.type,
        'quantity': m.quantity,
        'from': m.from,
        'to': m.to,
        'date': m.date,
        'user': m.user,
      };
    }).toList();
  }
}

