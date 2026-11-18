/// Category Model representing product taxonomy
class CategoryModel {
  final String id;
  final String name;
  final String slug;
  final String description;
  final int productCount;
  final double totalValue;
  final String status;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    this.description = '',
    this.productCount = 0,
    this.totalValue = 0.0,
    this.status = 'Active',
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'] ?? '',
      productCount: (json['productCount'] ?? json['product_count'] ?? 0).toInt(),
      totalValue: (json['totalValue'] ?? json['total_value'] ?? 0.0).toDouble(),
      status: json['status'] ?? 'Active',
    );
  }

  Map<String, dynamic> toJson({bool forSupabase = false}) {
    if (forSupabase) {
      return {
        'id': id,
        'name': name,
        'slug': slug,
        'description': description,
      };
    }
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'productCount': productCount,
      'totalValue': totalValue,
      'status': status,
    };
  }

  CategoryModel copyWith({
    String? id,
    String? name,
    String? slug,
    String? description,
    int? productCount,
    double? totalValue,
    String? status,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      productCount: productCount ?? this.productCount,
      totalValue: totalValue ?? this.totalValue,
      status: status ?? this.status,
    );
  }
}

