import 'package:flutter/foundation.dart';
import '../../core/services/supabase_service.dart';
import '../models/audit_log_model.dart';

/// Repository managing immutable security and compliance audit logs
class AuditRepository {
  final SupabaseService _supabaseService;
  final List<AuditLogModel> _localLogs = [];

  AuditRepository(this._supabaseService) {
    _initializeSeed();
  }

  void _initializeSeed() {
    _localLogs.addAll([
      const AuditLogModel(
        id: 'LOG-001',
        event: 'Stock Adjustment Posted',
        user: 'Ahmed Rahman',
        role: 'Warehouse Mgr',
        entity: 'ADJ-0044 [OFF-0118 -3 reams]',
        ip: '192.168.1.42',
        time: '10 mins ago',
        severity: 'Normal',
      ),
      const AuditLogModel(
        id: 'LOG-002',
        event: 'PO Transmitted to Vendor',
        user: 'Mike Torres',
        role: 'Procurement Off',
        entity: 'PO-2024-0344 (TechPro Ltd)',
        ip: '192.168.1.18',
        time: '34 mins ago',
        severity: 'Normal',
      ),
      const AuditLogModel(
        id: 'LOG-003',
        event: 'User Role Elevation',
        user: 'James Park',
        role: 'SysAdmin',
        entity: 'Modified permissions for Sarah K.',
        ip: '10.0.4.1',
        time: '2 hours ago',
        severity: 'Warning',
      ),
      const AuditLogModel(
        id: 'LOG-004',
        event: 'Bin Mapping Reconfigured',
        user: 'Ahmed Rahman',
        role: 'Warehouse Mgr',
        entity: 'Location A-01-02 allocated ELC-0088',
        ip: '192.168.1.42',
        time: '5 hours ago',
        severity: 'Normal',
      ),
      const AuditLogModel(
        id: 'LOG-005',
        event: 'Failed Authentication Spike',
        user: 'Unknown Host',
        role: 'External',
        entity: '3 incorrect attempts for user nina.rossi',
        ip: '178.62.204.11',
        time: '1 day ago',
        severity: 'Critical',
      ),
    ]);
  }

  Future<List<AuditLogModel>> getAuditLogs() async {
    if (_supabaseService.isOnline.value && _supabaseService.client != null) {
      try {
        final res = await _supabaseService.client!
            .from('audit_logs')
            .select()
            .order('created_at', ascending: false);
        final list = (res as List)
            .map((l) => AuditLogModel.fromJson(l as Map<String, dynamic>))
            .toList();
        if (list.isNotEmpty) {
          _localLogs.clear();
          _localLogs.addAll(list);
          return list;
        }
      } catch (e) {
        debugPrint('[AuditRepository] Supabase audit logs error: $e');
      }
    }
    return List.from(_localLogs);
  }

  Future<void> logEvent({
    required String event,
    required String user,
    required String role,
    required String entity,
    String severity = 'Normal',
  }) async {
    final log = AuditLogModel(
      id: 'LOG-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      event: event,
      user: user,
      role: role,
      entity: entity,
      ip: '192.168.1.55',
      time: 'Just now',
      severity: severity,
    );
    _localLogs.insert(0, log);

    if (_supabaseService.isOnline.value && _supabaseService.client != null) {
      try {
        await _supabaseService.client!.from('audit_logs').insert({
          'action': event,
          'user_name': user,
          'module': role,
          'details': {'entity': entity},
        });
      } catch (e) {
        debugPrint('[AuditRepository] Log event insert error: $e');
      }
    }
  }
}

