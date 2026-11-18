import 'package:flutter/foundation.dart';
import '../../core/services/supabase_service.dart';
import '../mock/mock_warehouses.dart';
import '../models/warehouse_model.dart';

/// Repository managing warehouses, facility locations, and space allocations.
class WarehouseRepository {
  final SupabaseService _supabaseService;
  final List<WarehouseModel> _localWarehouses = [];

  WarehouseRepository(this._supabaseService) {
    _initializeLocalSeed();
  }

  void _initializeLocalSeed() {
    for (final json in MockWarehouses.warehouses) {
      _localWarehouses.add(WarehouseModel.fromJson(json));
    }
  }

  Future<List<WarehouseModel>> getWarehouses() async {
    if (_supabaseService.isOnline.value && _supabaseService.client != null) {
      try {
        final response = await _supabaseService.client!
            .from('warehouses')
            .select()
            .order('name');
        final list = (response as List)
            .map((w) => WarehouseModel.fromJson(w as Map<String, dynamic>))
            .toList();
        if (list.isNotEmpty) {
          _localWarehouses.clear();
          _localWarehouses.addAll(list);
          return list;
        }
      } catch (e) {
        debugPrint('[WarehouseRepository] Supabase warehouses error: $e');
      }
    }
    return List.from(_localWarehouses);
  }

  Future<WarehouseModel> addWarehouse(WarehouseModel warehouse) async {
    if (_supabaseService.isOnline.value && _supabaseService.client != null) {
      try {
        final response = await _supabaseService.client!
            .from('warehouses')
            .insert(warehouse.toJson(forSupabase: true))
            .select()
            .single();
        final created = WarehouseModel.fromJson(response);
        _localWarehouses.insert(0, created);
        return created;
      } catch (e) {
        debugPrint('[WarehouseRepository] Add warehouse error: $e');
      }
    }
    _localWarehouses.insert(0, warehouse);
    return warehouse;
  }

  Future<WarehouseModel> updateWarehouse(WarehouseModel warehouse) async {
    if (_supabaseService.isOnline.value && _supabaseService.client != null) {
      try {
        final response = await _supabaseService.client!
            .from('warehouses')
            .update(warehouse.toJson(forSupabase: true))
            .eq('id', warehouse.id)
            .select()
            .single();
        final updated = WarehouseModel.fromJson(response);
        final idx = _localWarehouses.indexWhere((w) => w.id == warehouse.id);
        if (idx != -1) _localWarehouses[idx] = updated;
        return updated;
      } catch (e) {
        debugPrint('[WarehouseRepository] Update warehouse error: $e');
      }
    }
    final idx = _localWarehouses.indexWhere((w) => w.id == warehouse.id);
    if (idx != -1) {
      _localWarehouses[idx] = warehouse;
    }
    return warehouse;
  }

  Future<bool> deleteWarehouse(String id) async {
    if (_supabaseService.isOnline.value && _supabaseService.client != null) {
      try {
        await _supabaseService.client!.from('warehouses').delete().eq('id', id);
      } catch (e) {
        debugPrint('[WarehouseRepository] Delete warehouse error: $e');
      }
    }
    _localWarehouses.removeWhere((w) => w.id == id);
    return true;
  }
}

