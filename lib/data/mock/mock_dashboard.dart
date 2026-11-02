class MockDashboardData {
  static final kpiCards = [
    {
      'label': 'Total Revenue',
      'value': '\$284,920',
      'change': '+12.4%',
      'changePositive': true,
      'sub': 'vs last month',
      'icon': 'trending_up',
    },
    {
      'label': 'Total Orders',
      'value': '1,842',
      'change': '+8.7%',
      'changePositive': true,
      'sub': 'vs last month',
      'icon': 'shopping_bag',
    },
    {
      'label': 'Inventory Value',
      'value': '\$1.24M',
      'change': '-2.1%',
      'changePositive': false,
      'sub': 'vs last month',
      'icon': 'inventory_2',
    },
    {
      'label': 'Low Stock Items',
      'value': '23',
      'change': '+5',
      'changePositive': false,
      'sub': 'needs attention',
      'icon': 'warning_amber',
    },
    {
      'label': 'Active Suppliers',
      'value': '48',
      'change': '+2',
      'changePositive': true,
      'sub': 'this month',
      'icon': 'local_shipping',
    },
    {
      'label': 'Fulfillment Rate',
      'value': '97.2%',
      'change': '+1.3%',
      'changePositive': true,
      'sub': 'vs last month',
      'icon': 'check_circle',
    },
  ];

  static final revenueChart = [
    {'month': 'Jun', 'revenue': 198000, 'target': 210000},
    {'month': 'Jul', 'revenue': 221000, 'target': 215000},
    {'month': 'Aug', 'revenue': 235000, 'target': 225000},
    {'month': 'Sep', 'revenue': 248000, 'target': 240000},
    {'month': 'Oct', 'revenue': 263000, 'target': 255000},
    {'month': 'Nov', 'revenue': 284920, 'target': 270000},
  ];

  static final inventoryDistribution = [
    {'category': 'Electronics', 'value': 34.5, 'count': 428},
    {'category': 'Office Supplies', 'value': 21.2, 'count': 312},
    {'category': 'Furniture', 'value': 18.7, 'count': 156},
    {'category': 'Packaging', 'value': 14.1, 'count': 203},
    {'category': 'Tools', 'value': 11.5, 'count': 97},
  ];

  static final lowStockAlerts = [
    {
      'sku': 'ELC-0042',
      'name': 'USB-C Hub 7-in-1',
      'stock': 4,
      'minStock': 20,
      'category': 'Electronics',
      'warehouse': 'WH-Main',
    },
    {
      'sku': 'OFF-0118',
      'name': 'Premium A4 Paper Ream',
      'stock': 12,
      'minStock': 50,
      'category': 'Office Supplies',
      'warehouse': 'WH-East',
    },
    {
      'sku': 'PKG-0033',
      'name': 'Bubble Wrap Roll (50m)',
      'stock': 3,
      'minStock': 15,
      'category': 'Packaging',
      'warehouse': 'WH-Main',
    },
    {
      'sku': 'ELC-0071',
      'name': 'Wireless Keyboard MX',
      'stock': 6,
      'minStock': 25,
      'category': 'Electronics',
      'warehouse': 'WH-West',
    },
    {
      'sku': 'TLS-0009',
      'name': 'Precision Screwdriver Set',
      'stock': 2,
      'minStock': 10,
      'category': 'Tools',
      'warehouse': 'WH-Main',
    },
  ];

  static final recentActivities = [
    {
      'type': 'order',
      'title': 'Sales Order #SO-2024-0891 created',
      'sub': 'Customer: Apex Corp · \$4,200',
      'time': '5 min ago',
      'color': 'info',
    },
    {
      'type': 'receiving',
      'title': 'Goods received for PO-2024-0344',
      'sub': 'Supplier: TechPro Ltd · 128 items',
      'time': '22 min ago',
      'color': 'success',
    },
    {
      'type': 'alert',
      'title': 'Low stock alert: USB-C Hub 7-in-1',
      'sub': 'Stock: 4 units · Min: 20 units',
      'time': '1 hr ago',
      'color': 'warning',
    },
    {
      'type': 'transfer',
      'title': 'Stock transfer TRF-0093 approved',
      'sub': 'WH-Main → WH-East · 45 items',
      'time': '2 hr ago',
      'color': 'primary',
    },
    {
      'type': 'return',
      'title': 'Return RET-0028 processed',
      'sub': 'Customer: Nova Systems · 3 items',
      'time': '4 hr ago',
      'color': 'danger',
    },
    {
      'type': 'user',
      'title': 'New supplier Lumina Corp added',
      'sub': 'Added by: Sarah K.',
      'time': '6 hr ago',
      'color': 'primary',
    },
  ];

  static final recentTransactions = [
    {
      'id': 'SO-2024-0891',
      'type': 'Sale',
      'customer': 'Apex Corp',
      'amount': '\$4,200',
      'status': 'Processing',
      'date': 'Nov 1, 2026',
    },
    {
      'id': 'PO-2024-0344',
      'type': 'Purchase',
      'customer': 'TechPro Ltd',
      'amount': '\$12,800',
      'status': 'Received',
      'date': 'Nov 1, 2026',
    },
    {
      'id': 'SO-2024-0890',
      'type': 'Sale',
      'customer': 'BluePeak Inc',
      'amount': '\$7,650',
      'status': 'Shipped',
      'date': 'Oct 31, 2026',
    },
    {
      'id': 'SO-2024-0889',
      'type': 'Sale',
      'customer': 'Meridian Group',
      'amount': '\$2,100',
      'status': 'Delivered',
      'date': 'Oct 31, 2026',
    },
    {
      'id': 'PO-2024-0343',
      'type': 'Purchase',
      'customer': 'SupplyCo Global',
      'amount': '\$5,440',
      'status': 'Pending',
      'date': 'Oct 30, 2026',
    },
  ];
}

