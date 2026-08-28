import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShopProduct {
  ShopProduct({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.price,
  });

  final String id;
  final String name;
  final String subtitle;
  final double price;
}

class CartLine {
  CartLine({required this.product, int quantity = 1})
    : quantity = quantity.obs;

  final ShopProduct product;
  final RxInt quantity;

  double get lineTotal => product.price * quantity.value;
}

class ShopController extends GetxController {
  static const int itemsPerPage = 8;
  static const double taxRate = 0.08;

  final TextEditingController searchController = TextEditingController();

  final List<ShopProduct> _allProducts = List.generate(
    56,
    (index) => ShopProduct(
      id: 'P${index + 1}',
      name: 'Modern Wall Inlets',
      subtitle: 'Set of 5 Premium Finishes',
      price: 145.00,
    ),
  );

  var currentPage = 1.obs;

  int get totalPages => (_allProducts.length / itemsPerPage).ceil();

  List<ShopProduct> get currentPageProducts {
    final start = (currentPage.value - 1) * itemsPerPage;
    final end = min(start + itemsPerPage, _allProducts.length);
    return _allProducts.sublist(start, end);
  }

  void goToPage(int page) {
    if (page < 1 || page > totalPages) return;
    currentPage.value = page;
  }

  List<ShopProduct> relatedProducts(ShopProduct current, {int count = 4}) {
    return _allProducts.where((p) => p.id != current.id).take(count).toList();
  }

  var cart = <CartLine>[].obs;

  void addToCart(ShopProduct product, {int quantity = 1}) {
    cart
      ..clear()
      ..add(CartLine(product: product, quantity: quantity));
  }

  void incrementQuantity(CartLine line) => line.quantity.value++;

  void decrementQuantity(CartLine line) {
    if (line.quantity.value > 1) line.quantity.value--;
  }

  void removeFromCart(CartLine line) => cart.remove(line);

  double get subtotal =>
      cart.fold(0, (sum, line) => sum + line.lineTotal);

  double get estimatedTax => subtotal * taxRate;

  double get total => subtotal + estimatedTax;

  // --- Checkout form ---
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController apartmentController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController zipController = TextEditingController();
  var saveAddress = false.obs;

  void toggleSaveAddress() => saveAddress.value = !saveAddress.value;

  String get shippingAddressSummary {
    final parts = [
      apartmentController.text,
      cityController.text,
      stateController.text,
      zipController.text,
    ].where((part) => part.trim().isNotEmpty).join(', ');
    return parts.isEmpty ? 'Not provided' : parts;
  }

  // --- Last placed order (for success screen) ---
  String? lastOrderId;
  double lastOrderSubtotal = 0;
  double lastOrderTax = 0;
  double lastOrderTotal = 0;
  List<CartLine> lastOrderLines = [];
  DateTime? lastOrderDeliveryDate;

  void placeOrder() {
    lastOrderId = 'AP-${10000 + Random().nextInt(89999)}';
    lastOrderSubtotal = subtotal;
    lastOrderTax = estimatedTax;
    lastOrderTotal = total;
    lastOrderLines = List.of(cart);
    lastOrderDeliveryDate = DateTime.now().add(const Duration(days: 7));
  }
}
