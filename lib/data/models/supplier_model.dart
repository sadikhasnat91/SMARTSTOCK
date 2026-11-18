/// Supplier Model representing vendors & procurement partners
class SupplierModel {
  final String id;
  final String name;
  final String contact;
  final String email;
  final String phone;
  final String country;
  final String category;
  final double rating;
  final int totalOrders;
  final String totalValue;
  final String onTimeDelivery;
  final String qualityScore;
  final String status;
  final String paymentTerms;
  final String leadTime;

  const SupplierModel({
    required this.id,
    required this.name,
    this.contact = '',
    this.email = '',
    this.phone = '',
    this.country = 'United States',
    this.category = 'General',
    this.rating = 4.5,
    this.totalOrders = 0,
    this.totalValue = '\$0',
    this.onTimeDelivery = '95.0%',
    this.qualityScore = '95.0%',
    this.status = 'Active',
    this.paymentTerms = 'Net 30',
    this.leadTime = '7-10 days',
  });

  factory SupplierModel.fromJson(Map<String, dynamic> json) {
    return SupplierModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      contact: json['contact'] ?? json['contact_person'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      country: json['country'] ?? 'United States',
      category: json['category'] ?? 'General',
      rating: (json['rating'] ?? 4.5).toDouble(),
      totalOrders: (json['totalOrders'] ?? json['total_orders'] ?? 0).toInt(),
      totalValue: json['totalValue']?.toString() ?? json['total_value']?.toString() ?? '\$0',
      onTimeDelivery: json['onTimeDelivery']?.toString() ?? json['on_time_delivery']?.toString() ?? '95.0%',
      qualityScore: json['qualityScore']?.toString() ?? json['quality_score']?.toString() ?? '95.0%',
      status: json['status'] ?? 'Active',
      paymentTerms: json['paymentTerms'] ?? json['payment_terms'] ?? 'Net 30',
      leadTime: json['leadTime'] ?? json['lead_time'] ?? '7-10 days',
    );
  }

  Map<String, dynamic> toJson({bool forSupabase = false}) {
    if (forSupabase) {
      return {
        'id': id,
        'name': name,
        'contact_person': contact,
        'email': email,
        'phone': phone,
        'country': country,
        'rating': rating,
        'is_active': status == 'Active',
        'payment_terms': paymentTerms,
      };
    }
    return {
      'id': id,
      'name': name,
      'contact': contact,
      'email': email,
      'phone': phone,
      'country': country,
      'category': category,
      'rating': rating,
      'totalOrders': totalOrders,
      'totalValue': totalValue,
      'onTimeDelivery': onTimeDelivery,
      'qualityScore': qualityScore,
      'status': status,
      'paymentTerms': paymentTerms,
      'leadTime': leadTime,
    };
  }

  SupplierModel copyWith({
    String? id,
    String? name,
    String? contact,
    String? email,
    String? phone,
    String? country,
    String? category,
    double? rating,
    int? totalOrders,
    String? totalValue,
    String? onTimeDelivery,
    String? qualityScore,
    String? status,
    String? paymentTerms,
    String? leadTime,
  }) {
    return SupplierModel(
      id: id ?? this.id,
      name: name ?? this.name,
      contact: contact ?? this.contact,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      country: country ?? this.country,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      totalOrders: totalOrders ?? this.totalOrders,
      totalValue: totalValue ?? this.totalValue,
      onTimeDelivery: onTimeDelivery ?? this.onTimeDelivery,
      qualityScore: qualityScore ?? this.qualityScore,
      status: status ?? this.status,
      paymentTerms: paymentTerms ?? this.paymentTerms,
      leadTime: leadTime ?? this.leadTime,
    );
  }
}

