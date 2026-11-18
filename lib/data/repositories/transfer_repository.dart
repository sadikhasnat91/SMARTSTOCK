import 'package:flutter/foundation.dart';
import '../../core/services/supabase_service.dart';
import '../mock/mock_warehouses.dart';
import '../models/stock_transfer_model.dart';

/// Repository managing inter-warehouse stock transfers.
class TransferRepository {
  final SupabaseService _supabaseService;
  final List<StockTransferModel> _localTransfers = [];

  TransferRepository(this._supabaseService) {
    _initializeLocalSeed();
  }

  void _initializeLocalSeed() {
    for (final json in MockWarehouses.transfers) {
      _localTransfers.add(StockTransferModel.fromJson(json));
    }
  }

  Future<List<StockTransferModel>> getTransfers() async {
    if (_supabaseService.isOnline.value && _supabaseService.client != null) {
      try {
        final response = await _supabaseService.client!
            .from('stock_transfers')
            .select()
            .order('created_at', ascending: false);
        final list = (response as List)
            .map((t) => StockTransferModel.fromJson(t as Map<String, dynamic>))
            .toList();
        if (list.isNotEmpty) {
          _localTransfers.clear();
          _localTransfers.addAll(list);
          return list;
        }
      } catch (e) {
        debugPrint('[TransferRepository] Supabase transfers error: $e');
      }
    }
    return List.from(_localTransfers);
  }

  Future<StockTransferModel> createTransfer(StockTransferModel transfer) async {
    if (_supabaseService.isOnline.value && _supabaseService.client != null) {
      try {
        final response = await _supabaseService.client!
            .from('stock_transfers')
            .insert(transfer.toJson(forSupabase: true))
            .select()
            .single();
        final created = StockTransferModel.fromJson(response);
        _localTransfers.insert(0, created);
        return created;
      } catch (e) {
        debugPrint('[TransferRepository] Create transfer error: $e');
      }
    }
    _localTransfers.insert(0, transfer);
    return transfer;
  }

  Future<bool> updateTransferStatus(String id, String newStatus) async {
    final idx = _localTransfers.indexWhere((t) => t.id == id);
    if (idx != -1) {
      _localTransfers[idx] = _localTransfers[idx].copyWith(status: newStatus);
      return true;
    }
    return false;
  }
}
