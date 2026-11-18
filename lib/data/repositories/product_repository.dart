import 'package:flutter/foundation.dart';
import '../../core/services/supabase_service.dart';
import '../mock/mock_products.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';
import '../models/stock_movement_model.dart';

/// Repository managing inventory products, categories, stock adjustments, and movements.
/// Interfaces with Supabase PostgreSQL as primary source of truth,
/// and falls back gracefully to a reactive in-memory store if offline.
class ProductRepository {
  final SupabaseService _supabaseService;

  // In-memory reactive seed store (used only when Supabase is unreachable or offline)
  final List<ProductModel> _localProducts = [];
  final List<CategoryModel> _localCategories = [];
  final List<StockMovementModel> _localMovements = [];

  ProductRepository(this._supabaseService) {
    _initializeLocalSeed();
  }

  void _initializeLocalSeed() {
    for (final json in MockProducts.products) {
      _localProducts.add(ProductModel.fromJson(json));
    }
    for (final json in MockProducts.categories) {
      _localCategories.add(CategoryModel.fromJson(json));
    }
    for (final json in MockProducts.stockMovements) {
      _localMovements.add(StockMovementModel.fromJson(json));
    }
  }

  /// Fetch all products: always attempts to query Supabase first.
  Future<List<ProductModel>> getProducts() async {
    if (_supabaseService.isOnline.value && _supabaseService.client != null) {
      try {
        final response = await _supabaseService.client!
            .from('products')
            .select()
            .order('created_at', ascending: false);
        final list = (response as List)
            .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
            .toList();
        
        // Sync local cache with database
        _localProducts.clear();
        _localProducts.addAll(list);
        return list;
      } catch (e) {
        debugPrint('[ProductRepository] Supabase fetch error: $e. Falling back to local store.');
      }
    }
    return List.from(_localProducts);
  }

  /// Add new product to Supabase. Throws on error if online so UI can display proper error feedback.
  Future<ProductModel> addProduct(ProductModel product) async {
    if (_supabaseService.isOnline.value && _supabaseService.client != null) {
      final data = product.toJson(forSupabase: true);
      debugPrint('[ProductRepository] Inserting product to Supabase: $data');
      final response = await _supabaseService.client!
          .from('products')
          .insert(data)
          .select()
          .single();
      final created = ProductModel.fromJson(response);
      _localProducts.insert(0, created);
      return created;
    }

    _localProducts.insert(0, product);
    return product;
  }

  /// Update existing product
  Future<ProductModel> updateProduct(ProductModel product) async {
    if (_supabaseService.isOnline.value && _supabaseService.client != null) {
      final data = product.toJson(forSupabase: true);
      final response = await _supabaseService.client!
          .from('products')
          .update(data)
          .eq('id', product.id)
          .select()
          .single();
      final updated = ProductModel.fromJson(response);
      final idx = _localProducts.indexWhere((p) => p.id == product.id);
      if (idx != -1) _localProducts[idx] = updated;
      return updated;
    }
    final idx = _localProducts.indexWhere((p) => p.id == product.id);
    if (idx != -1) {
      _localProducts[idx] = product;
    }
    return product;
  }

  /// Delete product
  Future<bool> deleteProduct(String id) async {
    if (_supabaseService.isOnline.value && _supabaseService.client != null) {
      await _supabaseService.client!.from('products').delete().eq('id', id);
    }
    _localProducts.removeWhere((p) => p.id == id);
    return true;
  }

  /// Adjust stock level & log movement
  Future<bool> adjustStock({
    required String productId,
    required int newStock,
    required String reason,
    required String user,
  }) async {
    final idx = _localProducts.indexWhere((p) => p.id == productId);
    if (idx == -1) return false;

    final current = _localProducts[idx];
    final diff = newStock - current.stock;
    final updated = current.copyWith(stock: newStock);
    await updateProduct(updated);

    // Record movement
    final movement = StockMovementModel(
      id: 'SM-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      sku: current.sku,
      product: current.name,
      type: diff >= 0 ? 'Adjustment (+)' : 'Adjustment (-)',
      quantity: diff.abs(),
      from: current.warehouse,
      to: current.warehouse,
      date: 'Just now',
      user: user,
      reference: 'ADJ-$reason',
    );
    _localMovements.insert(0, movement);

    if (_supabaseService.isOnline.value && _supabaseService.client != null) {
      try {
        await _supabaseService.client!.from('stock_movements').insert({
          'product_id': productId,
          'movement_type': 'Adjustment',
          'quantity': diff.abs(),
          'notes': reason,
        });
      } catch (e) {
        debugPrint('[ProductRepository] Stock movement insert error: $e');
      }
    }

    return true;
  }

  /// Get categories
  Future<List<CategoryModel>> getCategories() async {
    if (_supabaseService.isOnline.value && _supabaseService.client != null) {
      try {
        final response = await _supabaseService.client!
            .from('categories')
            .select()
            .order('name');
        final list = (response as List)
            .map((c) => CategoryModel.fromJson(c as Map<String, dynamic>))
            .toList();
        if (list.isNotEmpty) {
          _localCategories.clear();
          _localCategories.addAll(list);
          return list;
        }
      } catch (e) {
        debugPrint('[ProductRepository] Supabase categories error: $e');
      }
    }
    return List.from(_localCategories);
  }

  /// Add category
  Future<CategoryModel> addCategory(CategoryModel category) async {
    if (_supabaseService.isOnline.value && _supabaseService.client != null) {
      final response = await _supabaseService.client!
          .from('categories')
          .insert(category.toJson(forSupabase: true))
          .select()
          .single();
      final created = CategoryModel.fromJson(response);
      _localCategories.insert(0, created);
      return created;
    }
    _localCategories.insert(0, category);
    return category;
  }

  /// Get stock movements
  Future<List<StockMovementModel>> getStockMovements() async {
    return List.from(_localMovements);
  }
}
