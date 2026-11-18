/// Sales Order Model representing customer purchase orders
class SalesOrderModel {
  final String id;
  final String customer;
  final String customerId;
  final String date;
  final int itemsCount;
  final double totalAmount;
  final String status;
  final String paymentStatus;
  final String warehouse;
  final String priority;

  const SalesOrderModel({
    required this.id,
    required this.customer,
    this.customerId = '',
    required this.date,
    this.itemsCount = 1,
    required this.totalAmount,
    this.status = 'Pending',
    this.paymentStatus = 'Unpaid',
    this.warehouse = 'WH-Main',
    this.priority = 'Standard',
  });

  String get formattedTotal => '\$${totalAmount.toStringAsFixed(2)}';

  factory SalesOrderModel.fromJson(Map<String, dynamic> json) {
    // Parse total amount which might be double or formatted string like "\$4,250"
    double parsedTotal = 0.0;
    if (json['total'] != null) {
      if (json['total'] is num) {
        parsedTotal = (json['total'] as num).toDouble();
      } else {
        final clean = json['total'].toString().replaceAll('\$', '').replaceAll(',', '').trim();
        parsedTotal = double.tryParse(clean) ?? 0.0;
      }
    } else if (json['total_amount'] != null) {
      parsedTotal = (json['total_amount'] as num).toDouble();
    } else if (json['totalAmount'] != null) {
      parsedTotal = (json['totalAmount'] as num).toDouble();
    }

    int parsedItems = 1;
    if (json['items'] is int) {
      parsedItems = json['items'];
    } else if (json['items'] is List) {
      parsedItems = (json['items'] as List).length;
    } else if (json['itemsCount'] != null) {
      parsedItems = (json['itemsCount'] as num).toInt();
    }

    return SalesOrderModel(
      id: json['id']?.toString() ?? '',
      customer: json['customer'] ?? json['customer_name'] ?? 'General Customer',
      customerId: json['customerId'] ?? json['customer_id'] ?? '',
      date: json['date'] ?? json['order_date'] ?? DateTime.now().toString().split(' ')[0],
      itemsCount: parsedItems,
      totalAmount: parsedTotal,
      status: json['status'] ?? 'Pending',
      paymentStatus: json['paymentStatus'] ?? json['payment_status'] ?? 'Unpaid',
      warehouse: json['warehouse'] ?? json['warehouse_id'] ?? 'WH-Main',
      priority: json['priority'] ?? 'Standard',
    );
  }

  Map<String, dynamic> toJson({bool forSupabase = false}) {
    if (forSupabase) {
      return {
        'id': id,
        'order_number': id,
        'total_amount': totalAmount,
        'status': status,
        'payment_status': paymentStatus,
        'order_date': date,
      };
    }
    return {
      'id': id,
      'customer': customer,
      'customerId': customerId,
      'date': date,
      'items': itemsCount,
      'total': formattedTotal,
      'status': status,
      'paymentStatus': paymentStatus,
      'warehouse': warehouse,
      'priority': priority,
    };
  }

  SalesOrderModel copyWith({
    String? id,
    String? customer,
    String? customerId,
    String? date,
    int? itemsCount,
    double? totalAmount,
    String? status,
    String? paymentStatus,
    String? warehouse,
    String? priority,
  }) {
    return SalesOrderModel(
      id: id ?? this.id,
      customer: customer ?? this.customer,
      customerId: customerId ?? this.customerId,
      date: date ?? this.date,
      itemsCount: itemsCount ?? this.itemsCount,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      warehouse: warehouse ?? this.warehouse,
      priority: priority ?? this.priority,
    );
  }
}

