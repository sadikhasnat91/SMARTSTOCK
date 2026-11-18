import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/product_model.dart';
import '../../data/models/category_model.dart';
import '../../data/models/stock_movement_model.dart';
import '../../data/repositories/product_repository.dart';

/// GetX Controller managing all inventory products, categories, stock levels, and search filters.
class ProductController extends GetxController {
  final ProductRepository _repository;
  ProductController(this._repository);

  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxList<StockMovementModel> movements = <StockMovementModel>[].obs;

  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedCategory = 'All Categories'.obs;
  final RxString selectedWarehouse = 'All Warehouses'.obs;
  final RxString selectedStatus = 'All Status'.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      final pList = await _repository.getProducts();
      final cList = await _repository.getCategories();
      final mList = await _repository.getStockMovements();

      products.assignAll(pList);
      categories.assignAll(cList);
      movements.assignAll(mList);
    } catch (e) {
      debugPrint('[ProductController] loadData error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Dynamic multi-criteria search and filter
  List<ProductModel> get filteredProducts {
    return products.where((item) {
      final query = searchQuery.value.trim().toLowerCase();
      final matchesSearch = query.isEmpty ||
          item.name.toLowerCase().contains(query) ||
          item.sku.toLowerCase().contains(query) ||
          item.barcode.toLowerCase().contains(query) ||
          item.brand.toLowerCase().contains(query);

      final matchesCategory = selectedCategory.value == 'All Categories' ||
          item.category.toLowerCase() == selectedCategory.value.toLowerCase();

      final matchesWarehouse = selectedWarehouse.value == 'All Warehouses' ||
          item.warehouse.toLowerCase() == selectedWarehouse.value.toLowerCase();

      final matchesStatus = selectedStatus.value == 'All Status' ||
          item.computedStatus.toLowerCase() == selectedStatus.value.toLowerCase();

      return matchesSearch && matchesCategory && matchesWarehouse && matchesStatus;
    }).toList();
  }

  /// Create new product
  Future<bool> addProduct(ProductModel product) async {
    isSubmitting.value = true;
    try {
      final created = await _repository.addProduct(product);
      // Insert at beginning of local reactive list
      products.removeWhere((p) => p.id == created.id);
      products.insert(0, created);

      Get.snackbar(
        'Product Created',
        '${created.name} was successfully saved to the database.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF10B981),
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle_outline, color: Colors.white),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
      );
      return true;
    } catch (e) {
      debugPrint('[ProductController] addProduct error: $e');
      Get.snackbar(
        'Database Error',
        'Failed to save product to database: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
        icon: const Icon(Icons.error_outline, color: Colors.white),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 5),
      );
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  /// Update existing product
  Future<bool> updateProduct(ProductModel product) async {
    isSubmitting.value = true;
    try {
      final updated = await _repository.updateProduct(product);
      final idx = products.indexWhere((p) => p.id == product.id);
      if (idx != -1) {
        products[idx] = updated;
      }
      Get.snackbar(
        'Product Updated',
        '${product.name} was successfully updated.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF10B981),
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle_outline, color: Colors.white),
        margin: const EdgeInsets.all(16),
      );
      return true;
    } catch (e) {
      Get.snackbar(
        'Update Error',
        'Failed to update product: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  /// Delete product
  Future<bool> deleteProduct(String id) async {
    try {
      await _repository.deleteProduct(id);
      products.removeWhere((p) => p.id == id);
      Get.snackbar(
        'Product Removed',
        'The product has been removed from inventory.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF0F172A),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete product: $e');
      return false;
    }
  }

  /// Adjust stock level
  Future<bool> adjustStock({
    required String productId,
    required int newStock,
    required String reason,
    String user = 'Ahmed Rahman',
  }) async {
    try {
      final success = await _repository.adjustStock(
        productId: productId,
        newStock: newStock,
        reason: reason,
        user: user,
      );
      if (success) {
        final idx = products.indexWhere((p) => p.id == productId);
        if (idx != -1) {
          products[idx] = products[idx].copyWith(stock: newStock);
        }
        // Refresh movements
        final mList = await _repository.getStockMovements();
        movements.assignAll(mList);

        Get.snackbar(
          'Stock Adjusted',
          'Inventory level updated to $newStock units.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF0F172A),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
        return true;
      }
    } catch (e) {
      Get.snackbar('Adjustment Failed', e.toString());
    }
    return false;
  }

  /// Barcode lookup helper
  ProductModel? lookupByBarcode(String barcode) {
    if (barcode.trim().isEmpty) return null;
    try {
      return products.firstWhere(
        (p) => p.barcode.trim() == barcode.trim() || p.sku.toLowerCase() == barcode.trim().toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  /// Add new Category
  Future<bool> addCategory({required String name, required String description}) async {
    try {
      final slug = name.toLowerCase().replaceAll(' ', '-');
      final newCat = CategoryModel(
        id: 'CAT-${categories.length + 1}',
        name: name,
        slug: slug,
        description: description,
        productCount: 0,
        totalValue: 0.0,
      );
      final created = await _repository.addCategory(newCat);
      categories.add(created);
      Get.snackbar(
        'Category Added',
        'Category $name created successfully.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF10B981),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to add category: $e');
      return false;
    }
  }
}
