/// User Model representing staff and operators in SmartStock
class UserModel {
  final String id;
  final String name;
  final String email;
  final String role; // Admin, Warehouse Manager, Inventory Clerk, Procurement Officer, Sales Rep
  final String department;
  final String status;
  final String avatar;
  final String phone;
  final String lastLogin;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.department = 'Operations',
    this.status = 'Active',
    this.avatar = '',
    this.phone = '',
    this.lastLogin = 'Today',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? json['full_name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'Inventory Clerk',
      department: json['department'] ?? 'Operations',
      status: json['status'] ?? 'Active',
      avatar: json['avatar'] ?? json['avatar_url'] ?? '',
      phone: json['phone'] ?? '',
      lastLogin: json['lastLogin'] ?? json['last_sign_in_at'] ?? 'Today',
    );
  }

  Map<String, dynamic> toJson({bool forSupabase = false}) {
    if (forSupabase) {
      return {
        'id': id,
        'full_name': name,
        'email': email,
        'role': role,
        'department': department,
        'is_active': status == 'Active',
        'avatar_url': avatar,
        'phone': phone,
      };
    }
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'department': department,
      'status': status,
      'avatar': avatar,
      'phone': phone,
      'lastLogin': lastLogin,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    String? department,
    String? status,
    String? avatar,
    String? phone,
    String? lastLogin,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      department: department ?? this.department,
      status: status ?? this.status,
      avatar: avatar ?? this.avatar,
      phone: phone ?? this.phone,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }
}

