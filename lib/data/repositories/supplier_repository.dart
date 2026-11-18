import 'package:flutter/foundation.dart';
import '../../core/services/supabase_service.dart';
import '../mock/mock_suppliers.dart';
import '../models/supplier_model.dart';

/// Repository managing procurement suppliers and vendor performance metrics.
class SupplierRepository {
  final SupabaseService _supabaseService;
  final List<SupplierModel> _localSuppliers = [];

  SupplierRepository(this._supabaseService) {
    _initializeLocalSeed();
  }

  void _initializeLocalSeed() {
    for (final json in MockSuppliers.suppliers) {
      _localSuppliers.add(SupplierModel.fromJson(json));
    }
  }

  Future<List<SupplierModel>> getSuppliers() async {
    if (_supabaseService.isOnline.value && _supabaseService.client != null) {
      try {
        final response = await _supabaseService.client!
            .from('suppliers')
            .select()
            .order('name');
        final list = (response as List)
            .map((s) => SupplierModel.fromJson(s as Map<String, dynamic>))
            .toList();
        if (list.isNotEmpty) {
          _localSuppliers.clear();
          _localSuppliers.addAll(list);
          return list;
        }
      } catch (e) {
        debugPrint('[SupplierRepository] Supabase suppliers error: $e');
      }
    }
    return List.from(_localSuppliers);
  }

  Future<SupplierModel> addSupplier(SupplierModel supplier) async {
    if (_supabaseService.isOnline.value && _supabaseService.client != null) {
      try {
        final response = await _supabaseService.client!
            .from('suppliers')
            .insert(supplier.toJson(forSupabase: true))
            .select()
            .single();
        final created = SupplierModel.fromJson(response);
        _localSuppliers.insert(0, created);
        return created;
      } catch (e) {
        debugPrint('[SupplierRepository] Add supplier error: $e');
      }
    }
    _localSuppliers.insert(0, supplier);
    return supplier;
  }

  Future<SupplierModel> updateSupplier(SupplierModel supplier) async {
    if (_supabaseService.isOnline.value && _supabaseService.client != null) {
      try {
        final response = await _supabaseService.client!
            .from('suppliers')
            .update(supplier.toJson(forSupabase: true))
            .eq('id', supplier.id)
            .select()
            .single();
        final updated = SupplierModel.fromJson(response);
        final idx = _localSuppliers.indexWhere((s) => s.id == supplier.id);
        if (idx != -1) _localSuppliers[idx] = updated;
        return updated;
      } catch (e) {
        debugPrint('[SupplierRepository] Update supplier error: $e');
      }
    }
    final idx = _localSuppliers.indexWhere((s) => s.id == supplier.id);
    if (idx != -1) {
      _localSuppliers[idx] = supplier;
    }
    return supplier;
  }

  Future<bool> deleteSupplier(String id) async {
    if (_supabaseService.isOnline.value && _supabaseService.client != null) {
      try {
        await _supabaseService.client!.from('suppliers').delete().eq('id', id);
      } catch (e) {
        debugPrint('[SupplierRepository] Delete supplier error: $e');
      }
    }
    _localSuppliers.removeWhere((s) => s.id == id);
    return true;
  }
}

