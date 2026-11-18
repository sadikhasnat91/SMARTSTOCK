/// Audit Log Model representing system audit trail events
class AuditLogModel {
  final String id;
  final String event;
  final String user;
  final String role;
  final String entity;
  final String ip;
  final String time;
  final String severity; // Normal, Warning, Critical

  const AuditLogModel({
    required this.id,
    required this.event,
    required this.user,
    this.role = 'Staff',
    this.entity = '',
    this.ip = '127.0.0.1',
    required this.time,
    this.severity = 'Normal',
  });

  factory AuditLogModel.fromJson(Map<String, dynamic> json) {
    return AuditLogModel(
      id: json['id']?.toString() ?? '',
      event: json['event'] ?? json['action'] ?? '',
      user: json['user'] ?? json['user_name'] ?? 'System',
      role: json['role'] ?? 'Staff',
      entity: json['entity'] ?? json['details']?.toString() ?? '',
      ip: json['ip'] ?? json['ip_address'] ?? '127.0.0.1',
      time: json['time'] ?? json['created_at'] ?? 'Just now',
      severity: json['severity'] ?? 'Normal',
    );
  }

  Map<String, dynamic> toJson({bool forSupabase = false}) {
    if (forSupabase) {
      return {
        'id': id,
        'action': event,
        'user_name': user,
        'module': role,
        'details': {'entity': entity},
        'ip_address': ip,
      };
    }
    return {
      'id': id,
      'event': event,
      'user': user,
      'role': role,
      'entity': entity,
      'ip': ip,
      'time': time,
      'severity': severity,
    };
  }
}

