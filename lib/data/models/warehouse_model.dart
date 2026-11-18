/// Warehouse Model representing inventory storage hubs
class WarehouseModel {
  final String id;
  final String code;
  final String name;
  final String type;
  final String address;
  final String manager;
  final String phone;
  final String totalArea;
  final String usedArea;
  final String capacity;
  final int zones;
  final int locations;
  final int products;
  final String status;
  final double lat;
  final double lng;

  const WarehouseModel({
    required this.id,
    required this.code,
    required this.name,
    this.type = 'Distribution',
    this.address = '',
    this.manager = '',
    this.phone = '',
    this.totalArea = '10,000 m²',
    this.usedArea = '6,000 m²',
    this.capacity = '60.0%',
    this.zones = 2,
    this.locations = 50,
    this.products = 0,
    this.status = 'Active',
    this.lat = 23.8103,
    this.lng = 90.4125,
  });

  double get capacityPercentage {
    final clean = capacity.replaceAll('%', '').trim();
    return double.tryParse(clean) ?? 0.0;
  }

  factory WarehouseModel.fromJson(Map<String, dynamic> json) {
    return WarehouseModel(
      id: json['id']?.toString() ?? '',
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? 'Distribution',
      address: json['address'] ?? '',
      manager: json['manager'] ?? '',
      phone: json['phone'] ?? '',
      totalArea: json['totalArea'] ?? json['total_area'] ?? '10,000 m²',
      usedArea: json['usedArea'] ?? json['used_area'] ?? '6,000 m²',
      capacity: json['capacity']?.toString() ?? '60.0%',
      zones: (json['zones'] ?? 2).toInt(),
      locations: (json['locations'] ?? 50).toInt(),
      products: (json['products'] ?? 0).toInt(),
      status: json['status'] ?? 'Active',
      lat: (json['lat'] ?? json['latitude'] ?? 23.8103).toDouble(),
      lng: (json['lng'] ?? json['longitude'] ?? 90.4125).toDouble(),
    );
  }

  Map<String, dynamic> toJson({bool forSupabase = false}) {
    if (forSupabase) {
      return {
        'id': id,
        'code': code,
        'name': name,
        'type': type,
        'address': address,
        'manager': manager,
        'phone': phone,
        'is_active': status == 'Active',
        'latitude': lat,
        'longitude': lng,
      };
    }
    return {
      'id': id,
      'code': code,
      'name': name,
      'type': type,
      'address': address,
      'manager': manager,
      'phone': phone,
      'totalArea': totalArea,
      'usedArea': usedArea,
      'capacity': capacity,
      'zones': zones,
      'locations': locations,
      'products': products,
      'status': status,
      'lat': lat,
      'lng': lng,
    };
  }

  WarehouseModel copyWith({
    String? id,
    String? code,
    String? name,
    String? type,
    String? address,
    String? manager,
    String? phone,
    String? totalArea,
    String? usedArea,
    String? capacity,
    int? zones,
    int? locations,
    int? products,
    String? status,
    double? lat,
    double? lng,
  }) {
    return WarehouseModel(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      type: type ?? this.type,
      address: address ?? this.address,
      manager: manager ?? this.manager,
      phone: phone ?? this.phone,
      totalArea: totalArea ?? this.totalArea,
      usedArea: usedArea ?? this.usedArea,
      capacity: capacity ?? this.capacity,
      zones: zones ?? this.zones,
      locations: locations ?? this.locations,
      products: products ?? this.products,
      status: status ?? this.status,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
    );
  }
}

