import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/customer_model.dart';
import '../../data/models/sales_order_model.dart';
import '../../data/models/purchase_order_model.dart';
import '../../data/repositories/order_repository.dart';

/// GetX Controller managing commercial sales orders, purchase orders, and customers.
class OrderController extends GetxController {
  final OrderRepository _repository;
  OrderController(this._repository);

  final RxList<CustomerModel> customers = <CustomerModel>[].obs;
  final RxList<SalesOrderModel> salesOrders = <SalesOrderModel>[].obs;
  final RxList<PurchaseOrderModel> purchaseOrders = <PurchaseOrderModel>[].obs;
  final RxList<Map<String, dynamic>> purchaseRequests = <Map<String, dynamic>>[].obs;

  final RxBool isLoading = false.obs;
  final RxString salesSearchQuery = ''.obs;
  final RxString purchaseSearchQuery = ''.obs;
  final RxString customerSearchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      final cList = await _repository.getCustomers();
      final sList = await _repository.getSalesOrders();
      final pList = await _repository.getPurchaseOrders();
      final rList = _repository.getPurchaseRequests();

      customers.assignAll(cList);
      salesOrders.assignAll(sList);
      purchaseOrders.assignAll(pList);
      purchaseRequests.assignAll(rList);
    } catch (e) {
      debugPrint('[OrderController] loadData error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  List<SalesOrderModel> get filteredSalesOrders {
    final q = salesSearchQuery.value.trim().toLowerCase();
    if (q.isEmpty) return salesOrders;
    return salesOrders.where((o) =>
      o.id.toLowerCase().contains(q) ||
      o.customer.toLowerCase().contains(q) ||
      o.status.toLowerCase().contains(q)
    ).toList();
  }

  List<PurchaseOrderModel> get filteredPurchaseOrders {
    final q = purchaseSearchQuery.value.trim().toLowerCase();
    if (q.isEmpty) return purchaseOrders;
    return purchaseOrders.where((p) =>
      p.id.toLowerCase().contains(q) ||
      p.supplier.toLowerCase().contains(q) ||
      p.status.toLowerCase().contains(q)
    ).toList();
  }

  List<CustomerModel> get filteredCustomers {
    final q = customerSearchQuery.value.trim().toLowerCase();
    if (q.isEmpty) return customers;
    return customers.where((c) =>
      c.name.toLowerCase().contains(q) ||
      c.contact.toLowerCase().contains(q) ||
      c.email.toLowerCase().contains(q)
    ).toList();
  }

  Future<bool> addCustomer(CustomerModel customer) async {
    try {
      final created = await _repository.addCustomer(customer);
      customers.insert(0, created);
      Get.snackbar(
        'Customer Added',
        'Customer ${customer.name} registered.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF0F172A),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to add customer: $e');
      return false;
    }
  }

  Future<bool> createSalesOrder(SalesOrderModel order) async {
    try {
      final created = await _repository.createSalesOrder(order);
      salesOrders.insert(0, created);
      Get.snackbar(
        'Sales Order Created',
        'Order #${order.id} for ${order.customer} successfully placed.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF0F172A),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to create sales order: $e');
      return false;
    }
  }

  Future<bool> updateSalesOrderStatus(String id, String newStatus) async {
    try {
      final success = await _repository.updateSalesOrderStatus(id, newStatus);
      if (success) {
        final idx = salesOrders.indexWhere((o) => o.id == id);
        if (idx != -1) {
          salesOrders[idx] = salesOrders[idx].copyWith(status: newStatus);
        }
        Get.snackbar(
          'Order Status Updated',
          'Sales Order $id is now $newStatus.',
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

  Future<bool> createPurchaseOrder(PurchaseOrderModel order) async {
    try {
      final created = await _repository.createPurchaseOrder(order);
      purchaseOrders.insert(0, created);
      Get.snackbar(
        'Purchase Order Transmitted',
        'PO #${order.id} sent to ${order.supplier}.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF0F172A),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to create purchase order: $e');
      return false;
    }
  }

  Future<bool> updatePurchaseOrderStatus(String id, String newStatus) async {
    try {
      final success = await _repository.updatePurchaseOrderStatus(id, newStatus);
      if (success) {
        final idx = purchaseOrders.indexWhere((p) => p.id == id);
        if (idx != -1) {
          purchaseOrders[idx] = purchaseOrders[idx].copyWith(status: newStatus);
        }
        Get.snackbar(
          'PO Status Updated',
          'PO $id is now $newStatus.',
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

  void addPurchaseRequest(Map<String, dynamic> req) {
    _repository.addPurchaseRequest(req);
    purchaseRequests.insert(0, req);
    Get.snackbar(
      'Purchase Request Submitted',
      'Request for ${req['item'] ?? 'item'} submitted for executive approval.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF0F172A),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
    );
  }

  void approvePurchaseRequest(String id) {
    final success = _repository.updatePurchaseRequestStatus(id, 'Approved');
    if (success) {
      final idx = purchaseRequests.indexWhere((r) => r['id'] == id);
      if (idx != -1) {
        final updated = Map<String, dynamic>.from(purchaseRequests[idx]);
        updated['status'] = 'Approved';
        purchaseRequests[idx] = updated;
      }
      Get.snackbar(
        'Request Approved',
        'Purchase request $id has been authorized.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF0F172A),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    }
  }
}

