import 'package:flutter/foundation.dart';
import '../../core/services/supabase_service.dart';
import '../models/user_model.dart';

/// Repository managing user authentication, sessions, and security roles.
class AuthRepository {
  final SupabaseService _supabaseService;

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  AuthRepository(this._supabaseService) {
    // Default demo authenticated user for immediate out-of-the-box viva evaluation
    _currentUser = const UserModel(
      id: 'USR-001',
      name: 'Ahmed Rahman',
      email: 'admin@smartstock.io',
      role: 'Admin',
      department: 'Executive Operations',
      avatar: 'AR',
      phone: '+880 1712-345678',
      lastLogin: 'Active Now',
    );
  }

  Future<bool> signIn({required String email, required String password}) async {
    if (_supabaseService.isOnline.value && _supabaseService.client != null) {
      try {
        final res = await _supabaseService.client!.auth.signInWithPassword(
          email: email,
          password: password,
        );
        if (res.user != null) {
          _currentUser = UserModel(
            id: res.user!.id,
            name: res.user!.userMetadata?['full_name'] ?? email.split('@')[0],
            email: email,
            role: res.user!.userMetadata?['role'] ?? 'Admin',
          );
          return true;
        }
      } catch (e) {
        debugPrint('[AuthRepository] Supabase auth error: $e');
      }
    }

    // Local / Viva Demo login fallback:
    if (email.isNotEmpty && password.isNotEmpty) {
      String role = 'Admin';
      String name = 'Ahmed Rahman';
      if (email.contains('warehouse') || email.contains('mgr')) {
        role = 'Warehouse Manager';
        name = 'Sarah Khan';
      } else if (email.contains('procure')) {
        role = 'Procurement Officer';
        name = 'Mike Torres';
      } else if (email.contains('sales')) {
        role = 'Sales Representative';
        name = 'David Chen';
      }

      _currentUser = UserModel(
        id: 'USR-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
        name: name,
        email: email,
        role: role,
        department: role.contains('Manager') ? 'Logistics' : 'Operations',
      );
      return true;
    }
    return false;
  }

  Future<void> signOut() async {
    if (_supabaseService.isOnline.value && _supabaseService.client != null) {
      try {
        await _supabaseService.client!.auth.signOut();
      } catch (e) {
        debugPrint('[AuthRepository] Supabase sign out error: $e');
      }
    }
    _currentUser = null;
  }
}

