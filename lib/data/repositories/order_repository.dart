import 'package:flutter/foundation.dart';
import '../../core/services/supabase_service.dart';
import '../mock/mock_orders.dart';
import '../mock/mock_suppliers.dart';
import '../models/customer_model.dart';
import '../models/sales_order_model.dart';
import '../models/purchase_order_model.dart';

/// Repository managing commercial operations: Customers, Sales Orders, and Purchase Orders.
class OrderRepository {
  final SupabaseService _supabaseService;

  final List<CustomerModel> _localCustomers = [];
  final List<SalesOrderModel> _localSalesOrders = [];
  final List<PurchaseOrderModel> _localPurchaseOrders = [];
  final List<Map<String, dynamic>> _localPurchaseRequests = [];

  OrderRepository(this._supabaseService) {
    _initializeLocalSeed();
  }

  void _initializeLocalSeed() {
    for (final json in MockOrders.customers) {
      _localCustomers.add(CustomerModel.fromJson(json));
    }
    for (final json in MockOrders.salesOrders) {
      _localSalesOrders.add(SalesOrderModel.fromJson(json));
    }
    for (final json in MockSuppliers.purchaseOrders) {
      _localPurchaseOrders.add(PurchaseOrderModel.fromJson(json));
    }
    _localPurchaseRequests.addAll(MockSuppliers.purchaseRequests);
  }

  // --- Customers ---
  Future<List<CustomerModel>> getCustomers() async {
    if (_supabaseService.isOnline.value && _supabaseService.client != null) {
      try {
        final response = await _supabaseService.client!
            .from('customers')
            .select()
            .order('name');
        final list = (response as List)
            .map((c) => CustomerModel.fromJson(c as Map<String, dynamic>))
            .toList();
        if (list.isNotEmpty) {
          _localCustomers.clear();
          _localCustomers.addAll(list);
          return list;
        }
      } catch (e) {
        debugPrint('[OrderRepository] Supabase customers error: $e');
      }
    }
    return List.from(_localCustomers);
  }

  Future<CustomerModel> addCustomer(CustomerModel customer) async {
    if (_supabaseService.isOnline.value && _supabaseService.client != null) {
      try {
        final response = await _supabaseService.client!
            .from('customers')
            .insert(customer.toJson(forSupabase: true))
            .select()
            .single();
        final created = CustomerModel.fromJson(response);
        _localCustomers.insert(0, created);
        return created;
      } catch (e) {
        debugPrint('[OrderRepository] Add customer error: $e');
      }
    }
    _localCustomers.insert(0, customer);
    return customer;
  }

  // --- Sales Orders ---
  Future<List<SalesOrderModel>> getSalesOrders() async {
    if (_supabaseService.isOnline.value && _supabaseService.client != null) {
      try {
        final response = await _supabaseService.client!
            .from('sales_orders')
            .select()
            .order('order_date', ascending: false);
        final list = (response as List)
            .map((s) => SalesOrderModel.fromJson(s as Map<String, dynamic>))
            .toList();
        if (list.isNotEmpty) {
          _localSalesOrders.clear();
          _localSalesOrders.addAll(list);
          return list;
        }
      } catch (e) {
        debugPrint('[OrderRepository] Supabase sales orders error: $e');
      }
    }
    return List.from(_localSalesOrders);
  }

  Future<SalesOrderModel> createSalesOrder(SalesOrderModel order) async {
    if (_supabaseService.isOnline.value && _supabaseService.client != null) {
      try {
        final response = await _supabaseService.client!
            .from('sales_orders')
            .insert(order.toJson(forSupabase: true))
            .select()
            .single();
        final created = SalesOrderModel.fromJson(response);
        _localSalesOrders.insert(0, created);
        return created;
      } catch (e) {
        debugPrint('[OrderRepository] Create sales order error: $e');
      }
    }
    _localSalesOrders.insert(0, order);
    return order;
  }

  Future<bool> updateSalesOrderStatus(String id, String newStatus) async {
    final idx = _localSalesOrders.indexWhere((o) => o.id == id);
    if (idx != -1) {
      _localSalesOrders[idx] = _localSalesOrders[idx].copyWith(status: newStatus);
      if (_supabaseService.isOnline.value && _supabaseService.client != null) {
        try {
          await _supabaseService.client!
              .from('sales_orders')
              .update({'status': newStatus})
              .eq('id', id);
        } catch (e) {
          debugPrint('[OrderRepository] Update sales order error: $e');
        }
      }
      return true;
    }
    return false;
  }

  // --- Purchase Orders ---
  Future<List<PurchaseOrderModel>> getPurchaseOrders() async {
    if (_supabaseService.isOnline.value && _supabaseService.client != null) {
      try {
        final response = await _supabaseService.client!
            .from('purchase_orders')
            .select()
            .order('order_date', ascending: false);
        final list = (response as List)
            .map((p) => PurchaseOrderModel.fromJson(p as Map<String, dynamic>))
            .toList();
        if (list.isNotEmpty) {
          _localPurchaseOrders.clear();
          _localPurchaseOrders.addAll(list);
          return list;
        }
      } catch (e) {
        debugPrint('[OrderRepository] Supabase purchase orders error: $e');
      }
    }
    return List.from(_localPurchaseOrders);
  }

  Future<PurchaseOrderModel> createPurchaseOrder(PurchaseOrderModel order) async {
    if (_supabaseService.isOnline.value && _supabaseService.client != null) {
      try {
        final response = await _supabaseService.client!
            .from('purchase_orders')
            .insert(order.toJson(forSupabase: true))
            .select()
            .single();
        final created = PurchaseOrderModel.fromJson(response);
        _localPurchaseOrders.insert(0, created);
        return created;
      } catch (e) {
        debugPrint('[OrderRepository] Create purchase order error: $e');
      }
    }
    _localPurchaseOrders.insert(0, order);
    return order;
  }

  Future<bool> updatePurchaseOrderStatus(String id, String newStatus) async {
    final idx = _localPurchaseOrders.indexWhere((p) => p.id == id);
    if (idx != -1) {
      _localPurchaseOrders[idx] = _localPurchaseOrders[idx].copyWith(status: newStatus);
      return true;
    }
    return false;
  }

  // --- Purchase Requests ---
  List<Map<String, dynamic>> getPurchaseRequests() => List.from(_localPurchaseRequests);

  void addPurchaseRequest(Map<String, dynamic> req) {
    _localPurchaseRequests.insert(0, req);
  }

  bool updatePurchaseRequestStatus(String id, String status) {
    final idx = _localPurchaseRequests.indexWhere((r) => r['id'] == id);
    if (idx != -1) {
      _localPurchaseRequests[idx]['status'] = status;
      return true;
    }
    return false;
  }
}
