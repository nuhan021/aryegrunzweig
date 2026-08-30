import 'package:get/get.dart';

import '../../../core/utils/helpers/app_helper.dart';
import '../../shop/data/commerce_models.dart';
import '../../shop/data/commerce_repository.dart';
import '../../shop/controller/shop_controller.dart';

enum OrderStatus { processing, shipped, delivered }

class ShopOrder {
  const ShopOrder({required this.api});
  final CommerceOrder api;
  String get id => api.id;
  String get itemName => api.items.firstOrNull?.product.name ?? 'Order';
  String get itemSubtitle => api.items.length > 1
      ? '${api.items.length} products'
      : api.status.wireValue.replaceAll('_', ' ');
  double get price => api.total.toDouble();
  String get orderCode => api.orderNumber;
  DateTime get orderDate => api.createdAt.toLocal();
  OrderStatus get status => switch (api.status) {
    CommerceOrderStatus.shipped => OrderStatus.shipped,
    CommerceOrderStatus.delivered => OrderStatus.delivered,
    _ => OrderStatus.processing,
  };
  String get trackingNumber => api.trackingNumber ?? 'Not assigned';
  String get deliveryAddress => api.shippingAddress.formatted;
  DateTime get estimatedDelivery =>
      api.estimatedDelivery?.toLocal() ?? api.createdAt.toLocal();
  bool get isPaid =>
      api.paidAt != null ||
      const {'AUTHORIZED', 'CAPTURED', 'SUCCEEDED'}.contains(api.paymentStatus);
}

class OrdersController extends GetxController {
  final CommerceRepository _repository = Get.find<CommerceRepository>();
  final selectedTabIndex = 0.obs;
  final orders = <ShopOrder>[].obs;
  final returns = <CommerceReturnRequest>[].obs;
  final isLoading = false.obs;
  final isActionLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadAll();
  }

  Future<void> loadAll() async {
    if (isLoading.value) return;
    isLoading.value = true;
    errorMessage.value = '';
    final orderFuture = _repository.orders(pageSize: 100);
    final returnFuture = _repository.returns();
    final orderResult = await orderFuture;
    final returnResult = await returnFuture;
    if (orderResult.isSuccess && orderResult.data != null) {
      orders.assignAll(
        orderResult.data!.items.map((item) => ShopOrder(api: item)),
      );
    } else {
      errorMessage.value = orderResult.errorMessage;
    }
    if (returnResult.isSuccess && returnResult.data != null) {
      returns.assignAll(returnResult.data!);
    }
    isLoading.value = false;
  }

  void selectTab(int index) => selectedTabIndex.value = index;

  List<ShopOrder> get filteredOrders {
    switch (selectedTabIndex.value) {
      case 1:
        return orders
            .where((order) => order.api.status == CommerceOrderStatus.delivered)
            .toList(growable: false);
      case 2:
        return const [];
      default:
        return orders
            .where((order) => order.api.status != CommerceOrderStatus.delivered)
            .toList(growable: false);
    }
  }

  Future<ShopOrder?> refreshOrder(ShopOrder order) async {
    final result = await _repository.order(order.id);
    if (!result.isSuccess || result.data == null) {
      AppHelperFunctions.showErrorSnackBar(result.errorMessage);
      return null;
    }
    final updated = ShopOrder(api: result.data!);
    final index = orders.indexWhere((item) => item.id == updated.id);
    if (index >= 0) orders[index] = updated;
    return updated;
  }

  Future<bool> cancelOrder(ShopOrder order) async {
    if (!order.api.canCancel || isActionLoading.value) return false;
    isActionLoading.value = true;
    final result = await _repository.cancelOrder(order.id);
    isActionLoading.value = false;
    if (!result.isSuccess || result.data == null) {
      AppHelperFunctions.showErrorSnackBar(result.errorMessage);
      return false;
    }
    await loadAll();
    AppHelperFunctions.showSuccessSnackBar('Order cancelled.');
    return true;
  }

  Future<bool> reorder(ShopOrder order) async {
    final result = await _repository.reorder(order.id);
    if (!result.isSuccess) {
      AppHelperFunctions.showErrorSnackBar(result.errorMessage);
      return false;
    }
    if (Get.isRegistered<ShopController>()) {
      await Get.find<ShopController>().loadCart();
    }
    AppHelperFunctions.showSuccessSnackBar('Items added to your cart.');
    return true;
  }

  Future<bool> requestReturn({
    required ShopOrder order,
    String? orderItemId,
    required String reason,
    String? comments,
  }) async {
    if (!order.api.canReturn || isActionLoading.value) return false;
    isActionLoading.value = true;
    final result = await _repository.requestReturn(
      orderId: order.id,
      orderItemId: orderItemId,
      reason: reason,
      comments: comments,
    );
    isActionLoading.value = false;
    if (!result.isSuccess || result.data == null) {
      AppHelperFunctions.showErrorSnackBar(result.errorMessage);
      return false;
    }
    returns.insert(0, result.data!);
    return true;
  }
}
