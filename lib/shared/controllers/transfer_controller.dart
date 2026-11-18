import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/stock_transfer_model.dart';
import '../../data/repositories/transfer_repository.dart';

/// GetX Controller managing inter-facility stock transfers and dispatch tracking.
class TransferController extends GetxController {
  final TransferRepository _repository;
  TransferController(this._repository);

  final RxList<StockTransferModel> transfers = <StockTransferModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadTransfers();
  }

  Future<void> loadTransfers() async {
    isLoading.value = true;
    try {
      final list = await _repository.getTransfers();
      transfers.assignAll(list);
    } catch (e) {
      debugPrint('[TransferController] Error loading transfers: $e');
    } finally {
      isLoading.value = false;
    }
  }

  List<StockTransferModel> get filteredTransfers {
    final q = searchQuery.value.trim().toLowerCase();
    if (q.isEmpty) return transfers;
    return transfers.where((t) =>
      t.id.toLowerCase().contains(q) ||
      t.source.toLowerCase().contains(q) ||
      t.destination.toLowerCase().contains(q) ||
      t.status.toLowerCase().contains(q) ||
      t.trackingNumber.toLowerCase().contains(q)
    ).toList();
  }

  Future<bool> createTransfer(StockTransferModel transfer) async {
    try {
      final created = await _repository.createTransfer(transfer);
      transfers.insert(0, created);
      Get.snackbar(
        'Transfer Initiated',
        'Stock transfer #${transfer.id} routed from ${transfer.source} to ${transfer.destination}.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF0F172A),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to create transfer: $e');
      return false;
    }
  }

  Future<bool> updateTransferStatus(String id, String newStatus) async {
    try {
      final success = await _repository.updateTransferStatus(id, newStatus);
      if (success) {
        final idx = transfers.indexWhere((t) => t.id == id);
        if (idx != -1) {
          transfers[idx] = transfers[idx].copyWith(status: newStatus);
        }
        Get.snackbar(
          'Transfer Status Updated',
          'Transfer $id is now $newStatus.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF0F172A),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
        return true;
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
    return false;
  }
}

