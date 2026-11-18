/// Stock Transfer Model representing inter-warehouse item movements
class StockTransferModel {
  final String id;
  final String source;
  final String destination;
  final String date;
  final int itemsCount;
  final String status;
  final String trackingNumber;
  final String initiatedBy;

  const StockTransferModel({
    required this.id,
    required this.source,
    required this.destination,
    required this.date,
    this.itemsCount = 1,
    this.status = 'Pending',
    this.trackingNumber = '',
    this.initiatedBy = 'Logistics Officer',
  });

  factory StockTransferModel.fromJson(Map<String, dynamic> json) {
    int parsedItems = 1;
    if (json['items'] is int) {
      parsedItems = json['items'];
    } else if (json['items'] is List) {
      parsedItems = (json['items'] as List).length;
    } else if (json['itemsCount'] != null) {
      parsedItems = (json['itemsCount'] as num).toInt();
    }

    return StockTransferModel(
      id: json['id']?.toString() ?? '',
      source: json['source'] ?? json['source_warehouse'] ?? 'WH-Main',
      destination: json['destination'] ?? json['destination_warehouse'] ?? 'WH-East',
      date: json['date'] ?? json['created_at'] ?? DateTime.now().toString().split(' ')[0],
      itemsCount: parsedItems,
      status: json['status'] ?? 'Pending',
      trackingNumber: json['trackingNumber'] ?? json['tracking_number'] ?? 'TRK-0000',
      initiatedBy: json['initiatedBy'] ?? json['initiated_by'] ?? 'Logistics Officer',
    );
  }

  Map<String, dynamic> toJson({bool forSupabase = false}) {
    if (forSupabase) {
      return {
        'id': id,
        'transfer_number': id,
        'status': status,
        'tracking_number': trackingNumber,
      };
    }
    return {
      'id': id,
      'source': source,
      'destination': destination,
      'date': date,
      'items': itemsCount,
      'status': status,
      'trackingNumber': trackingNumber,
      'initiatedBy': initiatedBy,
    };
  }

  StockTransferModel copyWith({
    String? id,
    String? source,
    String? destination,
    String? date,
    int? itemsCount,
    String? status,
    String? trackingNumber,
    String? initiatedBy,
  }) {
    return StockTransferModel(
      id: id ?? this.id,
      source: source ?? this.source,
      destination: destination ?? this.destination,
      date: date ?? this.date,
      itemsCount: itemsCount ?? this.itemsCount,
      status: status ?? this.status,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      initiatedBy: initiatedBy ?? this.initiatedBy,
    );
  }
}

