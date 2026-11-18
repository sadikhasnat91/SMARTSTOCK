import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/supplier_model.dart';
import '../../data/repositories/supplier_repository.dart';

/// GetX Controller managing procurement vendors and vendor ratings.
class SupplierController extends GetxController {
  final SupplierRepository _repository;
  SupplierController(this._repository);

  final RxList<SupplierModel> suppliers = <SupplierModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadSuppliers();
  }

  Future<void> loadSuppliers() async {
    isLoading.value = true;
    try {
      final list = await _repository.getSuppliers();
      suppliers.assignAll(list);
    } catch (e) {
      debugPrint('[SupplierController] Error loading suppliers: $e');
    } finally {
      isLoading.value = false;
    }
  }

  List<SupplierModel> get filteredSuppliers {
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) return suppliers;
    return suppliers.where((s) {
      return s.name.toLowerCase().contains(query) ||
          s.contact.toLowerCase().contains(query) ||
          s.category.toLowerCase().contains(query) ||
          s.country.toLowerCase().contains(query);
    }).toList();
  }

  Future<bool> addSupplier(SupplierModel supplier) async {
    try {
      final created = await _repository.addSupplier(supplier);
      suppliers.insert(0, created);
      Get.snackbar(
        'Supplier Enrolled',
        'Vendor ${supplier.name} added to procurement registry.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF0F172A),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to add supplier: $e');
      return false;
    }
  }

  Future<bool> updateSupplier(SupplierModel supplier) async {
    try {
      final updated = await _repository.updateSupplier(supplier);
      final idx = suppliers.indexWhere((s) => s.id == supplier.id);
      if (idx != -1) {
        suppliers[idx] = updated;
      }
      Get.snackbar(
        'Supplier Updated',
        'Vendor profile saved.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF0F172A),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to update supplier: $e');
      return false;
    }
  }

  Future<bool> deleteSupplier(String id) async {
    try {
      await _repository.deleteSupplier(id);
      suppliers.removeWhere((s) => s.id == id);
      Get.snackbar(
        'Supplier Removed',
        'Vendor removed from registry.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF0F172A),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete supplier: $e');
      return false;
    }
  }
}

