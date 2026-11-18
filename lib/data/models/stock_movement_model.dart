/// Stock Movement Model representing all historical inventory transactions
class StockMovementModel {
  final String id;
  final String sku;
  final String product;
  final String type; // Inbound, Outbound, Transfer, Adjustment
  final int quantity;
  final String from;
  final String to;
  final String date;
  final String user;
  final String reference;

  const StockMovementModel({
    required this.id,
    required this.sku,
    required this.product,
    required this.type,
    required this.quantity,
    this.from = '-',
    this.to = '-',
    required this.date,
    this.user = 'System Admin',
    this.reference = '',
  });

  factory StockMovementModel.fromJson(Map<String, dynamic> json) {
    return StockMovementModel(
      id: json['id']?.toString() ?? '',
      sku: json['sku'] ?? '',
      product: json['product'] ?? json['product_name'] ?? '',
      type: json['type'] ?? json['movement_type'] ?? 'Adjustment',
      quantity: (json['quantity'] ?? 0).toInt(),
      from: json['from'] ?? json['source_location'] ?? '-',
      to: json['to'] ?? json['destination_location'] ?? '-',
      date: json['date'] ?? json['created_at'] ?? DateTime.now().toString().split('.')[0],
      user: json['user'] ?? json['created_by'] ?? 'System Admin',
      reference: json['reference'] ?? json['reference_number'] ?? '',
    );
  }

  Map<String, dynamic> toJson({bool forSupabase = false}) {
    if (forSupabase) {
      return {
        'id': id,
        'movement_type': type,
        'quantity': quantity,
        'source_location': from,
        'destination_location': to,
        'reference_number': reference,
      };
    }
    return {
      'id': id,
      'sku': sku,
      'product': product,
      'type': type,
      'quantity': quantity,
      'from': from,
      'to': to,
      'date': date,
      'user': user,
      'reference': reference,
    };
  }
}

