/// Purchase Order Model representing supplier procurement contracts
class PurchaseOrderModel {
  final String id;
  final String supplier;
  final String supplierId;
  final String date;
  final String expectedDate;
  final int itemsCount;
  final double totalCost;
  final String status;
  final String paymentStatus;
  final String warehouse;

  const PurchaseOrderModel({
    required this.id,
    required this.supplier,
    this.supplierId = '',
    required this.date,
    this.expectedDate = '',
    this.itemsCount = 1,
    required this.totalCost,
    this.status = 'Pending Approval',
    this.paymentStatus = 'Unpaid',
    this.warehouse = 'WH-Main',
  });

  String get formattedTotal => '\$${totalCost.toStringAsFixed(2)}';

  factory PurchaseOrderModel.fromJson(Map<String, dynamic> json) {
    double parsedTotal = 0.0;
    if (json['total'] != null) {
      if (json['total'] is num) {
        parsedTotal = (json['total'] as num).toDouble();
      } else {
        final clean = json['total'].toString().replaceAll('\$', '').replaceAll(',', '').trim();
        parsedTotal = double.tryParse(clean) ?? 0.0;
      }
    } else if (json['total_cost'] != null) {
      parsedTotal = (json['total_cost'] as num).toDouble();
    } else if (json['totalCost'] != null) {
      parsedTotal = (json['totalCost'] as num).toDouble();
    }

    int parsedItems = 1;
    if (json['items'] is int) {
      parsedItems = json['items'];
    } else if (json['items'] is List) {
      parsedItems = (json['items'] as List).length;
    } else if (json['itemsCount'] != null) {
      parsedItems = (json['itemsCount'] as num).toInt();
    }

    return PurchaseOrderModel(
      id: json['id']?.toString() ?? '',
      supplier: json['supplier'] ?? json['supplier_name'] ?? 'General Supplier',
      supplierId: json['supplierId'] ?? json['supplier_id'] ?? '',
      date: json['date'] ?? json['order_date'] ?? DateTime.now().toString().split(' ')[0],
      expectedDate: json['expectedDate'] ?? json['expected_delivery'] ?? '',
      itemsCount: parsedItems,
      totalCost: parsedTotal,
      status: json['status'] ?? 'Pending Approval',
      paymentStatus: json['paymentStatus'] ?? json['payment_status'] ?? 'Unpaid',
      warehouse: json['warehouse'] ?? json['warehouse_id'] ?? 'WH-Main',
    );
  }

  Map<String, dynamic> toJson({bool forSupabase = false}) {
    if (forSupabase) {
      return {
        'id': id,
        'po_number': id,
        'total_cost': totalCost,
        'status': status,
        'order_date': date,
        'expected_delivery': expectedDate,
      };
    }
    return {
      'id': id,
      'supplier': supplier,
      'supplierId': supplierId,
      'date': date,
      'expectedDate': expectedDate,
      'items': itemsCount,
      'total': formattedTotal,
      'status': status,
      'paymentStatus': paymentStatus,
      'warehouse': warehouse,
    };
  }

  PurchaseOrderModel copyWith({
    String? id,
    String? supplier,
    String? supplierId,
    String? date,
    String? expectedDate,
    int? itemsCount,
    double? totalCost,
    String? status,
    String? paymentStatus,
    String? warehouse,
  }) {
    return PurchaseOrderModel(
      id: id ?? this.id,
      supplier: supplier ?? this.supplier,
      supplierId: supplierId ?? this.supplierId,
      date: date ?? this.date,
      expectedDate: expectedDate ?? this.expectedDate,
      itemsCount: itemsCount ?? this.itemsCount,
      totalCost: totalCost ?? this.totalCost,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      warehouse: warehouse ?? this.warehouse,
    );
  }
}

