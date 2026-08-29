import 'package:get/get.dart';

enum OrderStatus { processing, shipped, delivered }

class ShopOrder {
  ShopOrder({
    required this.id,
    required this.itemName,
    required this.itemSubtitle,
    required this.price,
    required this.orderCode,
    required this.orderDate,
    required this.status,
    required this.trackingNumber,
    required this.deliveryAddress,
    required this.estimatedDelivery,
    required this.isPaid,
  });

  final String id;
  final String itemName;
  final String itemSubtitle;
  final double price;
  final String orderCode;
  final DateTime orderDate;
  final OrderStatus status;
  final String trackingNumber;
  final String deliveryAddress;
  final DateTime estimatedDelivery;
  final bool isPaid;
}

class OrdersController extends GetxController {
  var selectedTabIndex = 0.obs;

  final List<ShopOrder> orders = [
    ShopOrder(
      id: 'O1',
      itemName: 'Elite 500 Performance',
      itemSubtitle: 'Quiet-flow technology',
      price: 349.00,
      orderCode: 'CC-3084',
      orderDate: DateTime(2026, 7, 29),
      status: OrderStatus.shipped,
      trackingNumber: 'TRK82910394',
      deliveryAddress: '123 Aura Lane, California, 90001, United States',
      estimatedDelivery: DateTime(2026, 8, 8),
      isPaid: true,
    ),
    ShopOrder(
      id: 'O2',
      itemName: 'Modern Wall Inlets',
      itemSubtitle: 'Set of 5 Premium Finishes',
      price: 145.00,
      orderCode: 'CC-2977',
      orderDate: DateTime(2026, 7, 10),
      status: OrderStatus.delivered,
      trackingNumber: 'TRK71029581',
      deliveryAddress: '123 Aura Lane, California, 90001, United States',
      estimatedDelivery: DateTime(2026, 7, 18),
      isPaid: true,
    ),
  ];

  void selectTab(int index) => selectedTabIndex.value = index;

  List<ShopOrder> get filteredOrders {
    switch (selectedTabIndex.value) {
      case 1:
        return orders.where((o) => o.status == OrderStatus.delivered).toList();
      case 2:
        return const [];
      default:
        return orders.where((o) => o.status != OrderStatus.delivered).toList();
    }
  }
}
