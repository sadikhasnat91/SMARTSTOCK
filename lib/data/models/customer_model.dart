/// Customer Model representing buyers and enterprise clients
class CustomerModel {
  final String id;
  final String name;
  final String contact;
  final String email;
  final String phone;
  final String country;
  final String type;
  final int totalOrders;
  final String totalValue;
  final String lastOrder;
  final String status;
  final String creditLimit;
  final String paymentTerms;

  const CustomerModel({
    required this.id,
    required this.name,
    this.contact = '',
    this.email = '',
    this.phone = '',
    this.country = 'United States',
    this.type = 'Business',
    this.totalOrders = 0,
    this.totalValue = '\$0',
    this.lastOrder = 'Recent',
    this.status = 'Active',
    this.creditLimit = '\$25,000',
    this.paymentTerms = 'Net 30',
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      contact: json['contact'] ?? json['contact_person'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      country: json['country'] ?? 'United States',
      type: json['type'] ?? 'Business',
      totalOrders: (json['totalOrders'] ?? json['total_orders'] ?? 0).toInt(),
      totalValue: json['totalValue']?.toString() ?? json['total_value']?.toString() ?? '\$0',
      lastOrder: json['lastOrder'] ?? json['last_order'] ?? 'Recent',
      status: json['status'] ?? 'Active',
      creditLimit: json['creditLimit'] ?? json['credit_limit'] ?? '\$25,000',
      paymentTerms: json['paymentTerms'] ?? json['payment_terms'] ?? 'Net 30',
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
        'type': type,
        'is_active': status == 'Active',
      };
    }
    return {
      'id': id,
      'name': name,
      'contact': contact,
      'email': email,
      'phone': phone,
      'country': country,
      'type': type,
      'totalOrders': totalOrders,
      'totalValue': totalValue,
      'lastOrder': lastOrder,
      'status': status,
      'creditLimit': creditLimit,
      'paymentTerms': paymentTerms,
    };
  }

  CustomerModel copyWith({
    String? id,
    String? name,
    String? contact,
    String? email,
    String? phone,
    String? country,
    String? type,
    int? totalOrders,
    String? totalValue,
    String? lastOrder,
    String? status,
    String? creditLimit,
    String? paymentTerms,
  }) {
    return CustomerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      contact: contact ?? this.contact,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      country: country ?? this.country,
      type: type ?? this.type,
      totalOrders: totalOrders ?? this.totalOrders,
      totalValue: totalValue ?? this.totalValue,
      lastOrder: lastOrder ?? this.lastOrder,
      status: status ?? this.status,
      creditLimit: creditLimit ?? this.creditLimit,
      paymentTerms: paymentTerms ?? this.paymentTerms,
    );
  }
}

