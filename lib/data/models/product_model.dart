/// Product Model representing inventory items in SmartStock
/// Compatible with Supabase PostgreSQL schema and local state.
class ProductModel {
  final String id;
  final String sku;
  final String name;
  final String category;
  final String brand;
  final String unit;
  final double costPrice;
  final double sellingPrice;
  final int stock;
  final int minStock;
  final int maxStock;
  final String warehouse;
  final String status;
  final String barcode;
  final String description;
  final double weight;
  final String dimensions;
  final List<String> tags;

  const ProductModel({
    required this.id,
    required this.sku,
    required this.name,
    required this.category,
    this.brand = '',
    this.unit = 'PCS',
    required this.costPrice,
    required this.sellingPrice,
    required this.stock,
    this.minStock = 10,
    this.maxStock = 100,
    this.warehouse = 'WH-Main',
    this.status = 'In Stock',
    this.barcode = '',
    this.description = '',
    this.weight = 0.0,
    this.dimensions = '',
    this.tags = const [],
  });

  /// Dynamic status based on stock levels
  String get computedStatus {
    if (stock <= 0) return 'Out of Stock';
    if (stock <= (minStock * 0.3).ceil()) return 'Critical';
    if (stock <= minStock) return 'Low Stock';
    return 'In Stock';
  }

  double get marginPercent {
    if (sellingPrice <= 0) return 0.0;
    return ((sellingPrice - costPrice) / sellingPrice) * 100;
  }

  double get totalStockValue => stock * costPrice;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id']?.toString() ?? '',
      sku: json['sku'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? json['category_id'] ?? 'General',
      brand: json['brand'] ?? '',
      unit: json['unit'] ?? 'PCS',
      costPrice: (json['costPrice'] ?? json['cost_price'] ?? 0.0).toDouble(),
      sellingPrice: (json['sellingPrice'] ?? json['selling_price'] ?? 0.0).toDouble(),
      stock: (json['stock'] ?? json['current_stock'] ?? 0).toInt(),
      minStock: (json['minStock'] ?? json['min_stock'] ?? 10).toInt(),
      maxStock: (json['maxStock'] ?? json['max_stock'] ?? 100).toInt(),
      warehouse: json['warehouse'] ?? json['warehouse_id'] ?? 'WH-Main',
      status: json['status'] ?? 'In Stock',
      barcode: json['barcode'] ?? '',
      description: json['description'] ?? '',
      weight: (json['weight'] ?? 0.0).toDouble(),
      dimensions: json['dimensions'] ?? '',
      tags: json['tags'] != null ? List<String>.from(json['tags']) : <String>[],
    );
  }

  Map<String, dynamic> toJson({bool forSupabase = false}) {
    if (forSupabase) {
      return {
        'id': id,
        'sku': sku,
        'name': name,
        'category': category,
        'brand': brand,
        'unit': unit,
        'cost_price': costPrice,
        'selling_price': sellingPrice,
        'stock': stock,
        'min_stock': minStock,
        'max_stock': maxStock,
        'warehouse_code': warehouse.isNotEmpty ? warehouse : 'WH-Main',
        'status': computedStatus,
        'barcode': barcode,
        'description': description,
        'weight': weight,
        'dimensions': dimensions,
        'tags': tags,
      };
    }
    return {
      'id': id,
      'sku': sku,
      'name': name,
      'category': category,
      'brand': brand,
      'unit': unit,
      'costPrice': costPrice,
      'sellingPrice': sellingPrice,
      'stock': stock,
      'minStock': minStock,
      'maxStock': maxStock,
      'warehouse': warehouse,
      'status': computedStatus,
      'barcode': barcode,
      'description': description,
      'weight': weight,
      'dimensions': dimensions,
      'tags': tags,
    };
  }

  ProductModel copyWith({
    String? id,
    String? sku,
    String? name,
    String? category,
    String? brand,
    String? unit,
    double? costPrice,
    double? sellingPrice,
    int? stock,
    int? minStock,
    int? maxStock,
    String? warehouse,
    String? status,
    String? barcode,
    String? description,
    double? weight,
    String? dimensions,
    List<String>? tags,
  }) {
    return ProductModel(
      id: id ?? this.id,
      sku: sku ?? this.sku,
      name: name ?? this.name,
      category: category ?? this.category,
      brand: brand ?? this.brand,
      unit: unit ?? this.unit,
      costPrice: costPrice ?? this.costPrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      stock: stock ?? this.stock,
      minStock: minStock ?? this.minStock,
      maxStock: maxStock ?? this.maxStock,
      warehouse: warehouse ?? this.warehouse,
      status: status ?? this.status,
      barcode: barcode ?? this.barcode,
      description: description ?? this.description,
      weight: weight ?? this.weight,
      dimensions: dimensions ?? this.dimensions,
      tags: tags ?? this.tags,
    );
  }
}

