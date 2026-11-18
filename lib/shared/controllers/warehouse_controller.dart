import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/warehouse_model.dart';
import '../../data/repositories/warehouse_repository.dart';

/// GetX Controller managing warehouses, storage capacity, and locations.
class WarehouseController extends GetxController {
  final WarehouseRepository _repository;
  WarehouseController(this._repository);

  final RxList<WarehouseModel> warehouses = <WarehouseModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadWarehouses();
  }

  Future<void> loadWarehouses() async {
    isLoading.value = true;
    try {
      final list = await _repository.getWarehouses();
      warehouses.assignAll(list);
    } catch (e) {
      debugPrint('[WarehouseController] Error loading warehouses: $e');
    } finally {
      isLoading.value = false;
    }
  }

  List<WarehouseModel> get filteredWarehouses {
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) return warehouses;
    return warehouses.where((w) {
      return w.name.toLowerCase().contains(query) ||
          w.code.toLowerCase().contains(query) ||
          w.address.toLowerCase().contains(query) ||
          w.manager.toLowerCase().contains(query);
    }).toList();
  }

  Future<bool> addWarehouse(WarehouseModel warehouse) async {
    try {
      final created = await _repository.addWarehouse(warehouse);
      warehouses.add(created);
      Get.snackbar(
        'Warehouse Created',
        'Facility ${warehouse.name} (${warehouse.code}) has been added.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF0F172A),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to create warehouse: $e');
      return false;
    }
  }

  Future<bool> updateWarehouse(WarehouseModel warehouse) async {
    try {
      final updated = await _repository.updateWarehouse(warehouse);
      final idx = warehouses.indexWhere((w) => w.id == warehouse.id);
      if (idx != -1) {
        warehouses[idx] = updated;
      }
      Get.snackbar(
        'Warehouse Updated',
        'Facility details saved.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF0F172A),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to update warehouse: $e');
      return false;
    }
  }

  Future<bool> deleteWarehouse(String id) async {
    try {
      await _repository.deleteWarehouse(id);
      warehouses.removeWhere((w) => w.id == id);
      Get.snackbar(
        'Warehouse Removed',
        'Facility has been deleted.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF0F172A),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete warehouse: $e');
      return false;
    }
  }
}

