import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../core/utils/helpers/app_helper.dart';
import '../../auth/models/auth_models.dart';
import '../../profile/data/profile_repository.dart';
import '../data/commerce_models.dart';
import '../data/commerce_repository.dart';

class ShopProduct {
  const ShopProduct({required this.api});
  final CommerceProduct api;
  String get id => api.id;
  String get name => api.name;
  String get subtitle => api.tagline ?? api.category;
  double get price => api.price.toDouble();
  String? get imageUrl => api.imageUrls.firstOrNull;
}

class CartLine {
  const CartLine({required this.api});
  final CommerceCartItem api;

  CartLine withQuantity(int quantity) => CartLine(
    api: CommerceCartItem(
      id: api.id,
      productId: api.productId,
      quantity: quantity,
      unitPrice: api.unitPrice,
      lineTotal: api.unitPrice * quantity,
      product: api.product,
    ),
  );

  ShopProduct get product => ShopProduct(
    api: CommerceProduct(
      id: api.product.id,
      sku: null,
      name: api.product.name,
      description: api.product.tagline ?? '',
      category: '',
      price: api.unitPrice,
      stock: api.product.stock,
      imageUrls: api.product.imageUrls,
      slug: api.product.slug,
      features: const [],
      specifications: null,
      warranty: null,
      shippingInfo: null,
      isActive: true,
      taxable: api.product.taxable,
      tagline: api.product.tagline,
      inStock: api.product.inStock,
    ),
  );
  int get quantity => api.quantity;
  double get lineTotal => api.lineTotal.toDouble();
}

class ShopController extends GetxController {
  static const int itemsPerPage = 24;

  final CommerceRepository _repository = Get.find<CommerceRepository>();
  final ProfileRepository _profileRepository = Get.find<ProfileRepository>();
  final TextEditingController searchController = TextEditingController();

  final products = <ShopProduct>[].obs;
  final categories = <ProductCategoryCount>[].obs;
  final cart = <CartLine>[].obs;
  final addresses = <AddressResponse>[].obs;
  final currentPage = 1.obs;
  final totalItems = 0.obs;
  final selectedCategory = RxnString();
  final selectedShippingAddressId = RxnString();
  final isLoading = false.obs;
  final isCartLoading = false.obs;
  final isCheckoutLoading = false.obs;
  final isPreviewLoading = false.obs;
  final addingProductIds = <String>{}.obs;
  final updatingCartProductIds = <String>{}.obs;
  final removingCartProductIds = <String>{}.obs;
  final errorMessage = ''.obs;
  final preview = Rxn<CheckoutPreview>();
  final checkoutSession = Rxn<CheckoutSession>();
  final completedOrder = Rxn<CommerceOrder>();
  String? _checkoutIdempotencyKey;
  final _quantitySyncing = <String>{};
  final _confirmedQuantities = <String, int>{};
  int _previewRequestCount = 0;

  int get totalPages =>
      totalItems.value == 0 ? 1 : (totalItems.value / itemsPerPage).ceil();
  List<ShopProduct> get currentPageProducts => products;
  int get cartItemCount => cart.fold(0, (total, line) => total + line.quantity);
  bool isAddingProduct(String productId) =>
      addingProductIds.contains(productId);
  bool isUpdatingCartProduct(String productId) =>
      updatingCartProductIds.contains(productId);
  bool isRemovingCartProduct(String productId) =>
      removingCartProductIds.contains(productId);
  String? cartProductImage(CartLine line) {
    final cartImage = line.product.imageUrl;
    if (cartImage != null && cartImage.trim().isNotEmpty) return cartImage;
    return products
        .firstWhereOrNull((product) => product.id == line.api.productId)
        ?.imageUrl;
  }

  double get subtotal => preview.value?.subtotal.toDouble() ?? 0;
  double get estimatedTax => preview.value?.tax.toDouble() ?? 0;
  double get shippingFee => preview.value?.shippingFee.toDouble() ?? 0;
  double get total => preview.value?.total.toDouble() ?? 0;

  String? lastOrderId;
  double lastOrderSubtotal = 0;
  double lastOrderTax = 0;
  double lastOrderTotal = 0;
  List<CartLine> lastOrderLines = const [];
  DateTime? lastOrderDeliveryDate;

  @override
  void onInit() {
    super.onInit();
    loadInitial();
  }

  Future<void> loadInitial() async {
    await Future.wait([
      loadProducts(),
      loadCategories(),
      loadCart(),
      loadAddresses(),
    ]);
    if (cart.isNotEmpty && selectedShippingAddressId.value != null) {
      await loadPreview();
    }
  }

  Future<void> loadProducts({int? page}) async {
    if (isLoading.value) return;
    isLoading.value = true;
    errorMessage.value = '';
    final result = await _repository.products(
      search: searchController.text,
      category: selectedCategory.value,
      page: page ?? currentPage.value,
      pageSize: itemsPerPage,
    );
    isLoading.value = false;
    if (!result.isSuccess || result.data == null) {
      errorMessage.value = result.errorMessage;
      return;
    }
    currentPage.value = result.data!.page;
    totalItems.value = result.data!.total;
    products.assignAll(
      result.data!.items.map((item) => ShopProduct(api: item)),
    );
  }

  Future<void> loadCategories() async {
    final result = await _repository.categories();
    if (result.isSuccess && result.data != null) {
      categories.assignAll(result.data!);
    }
  }

  Future<void> search() async {
    currentPage.value = 1;
    await loadProducts(page: 1);
  }

  Future<void> selectCategory(String? category) async {
    selectedCategory.value = category;
    await search();
  }

  Future<void> goToPage(int page) async {
    if (page < 1 || page > totalPages || page == currentPage.value) return;
    await loadProducts(page: page);
  }

  List<ShopProduct> relatedProducts(ShopProduct current, {int count = 4}) =>
      current.api.relatedProducts
          .map((item) => ShopProduct(api: item))
          .take(count)
          .toList(growable: false);

  Future<ShopProduct?> loadProductDetails(ShopProduct product) async {
    final result = await _repository.product(product.api.slug ?? product.id);
    if (!result.isSuccess || result.data == null) {
      AppHelperFunctions.showErrorSnackBar(result.errorMessage);
      return null;
    }
    return ShopProduct(api: result.data!);
  }

  Future<void> loadCart() async {
    isCartLoading.value = true;
    final result = await _repository.getCart();
    isCartLoading.value = false;
    if (result.isSuccess && result.data != null) _setCart(result.data!);
  }

  Future<bool> addToCart(ShopProduct product, {int quantity = 1}) async {
    if (isAddingProduct(product.id)) return false;
    addingProductIds.add(product.id);
    try {
      final result = await _repository.addCartItem(product.id, quantity);
      if (!result.isSuccess || result.data == null) {
        AppHelperFunctions.showErrorSnackBar(result.errorMessage);
        return false;
      }
      _setCart(result.data!);
      AppHelperFunctions.showSuccessSnackBar(
        quantity == 1
            ? '${product.name} added to your cart.'
            : '$quantity × ${product.name} added to your cart.',
      );
      return true;
    } finally {
      addingProductIds.remove(product.id);
    }
  }

  Future<void> incrementQuantity(CartLine line) async {
    final current = _cartLine(line.api.productId);
    if (current == null || current.quantity >= current.api.product.stock) {
      return;
    }
    await _updateQuantity(current, current.quantity + 1);
  }

  Future<void> decrementQuantity(CartLine line) async {
    final current = _cartLine(line.api.productId);
    if (current != null && current.quantity > 1) {
      await _updateQuantity(current, current.quantity - 1);
    }
  }

  Future<void> _updateQuantity(CartLine line, int quantity) async {
    final productId = line.api.productId;
    _confirmedQuantities.putIfAbsent(productId, () => line.quantity);
    _replaceCartQuantity(productId, quantity);
    _checkoutIdempotencyKey = null;
    checkoutSession.value = null;

    if (_quantitySyncing.contains(productId)) return;
    _quantitySyncing.add(productId);
    updatingCartProductIds.add(productId);
    try {
      while (true) {
        final current = _cartLine(productId);
        if (current == null) return;
        final requestedQuantity = current.quantity;
        final result = await _repository.updateCartItem(
          productId,
          requestedQuantity,
        );
        if (!result.isSuccess || result.data == null) {
          final confirmed = _confirmedQuantities[productId];
          if (confirmed != null) _replaceCartQuantity(productId, confirmed);
          AppHelperFunctions.showErrorSnackBar(result.errorMessage);
          return;
        }

        _confirmedQuantities[productId] = requestedQuantity;
        if (_cartLine(productId)?.quantity != requestedQuantity) continue;

        _setCart(result.data!);
        await loadPreview();
        return;
      }
    } finally {
      _quantitySyncing.remove(productId);
      _confirmedQuantities.remove(productId);
      updatingCartProductIds.remove(productId);
    }
  }

  CartLine? _cartLine(String productId) =>
      cart.firstWhereOrNull((line) => line.api.productId == productId);

  void _replaceCartQuantity(String productId, int quantity) {
    final index = cart.indexWhere((line) => line.api.productId == productId);
    if (index < 0) return;
    cart[index] = cart[index].withQuantity(quantity);
  }

  Future<void> removeFromCart(CartLine line) async {
    final productId = line.api.productId;
    if (isRemovingCartProduct(productId)) return;
    removingCartProductIds.add(productId);
    try {
      final result = await _repository.removeCartItem(productId);
      if (!result.isSuccess || result.data == null) {
        AppHelperFunctions.showErrorSnackBar(result.errorMessage);
        return;
      }
      _setCart(result.data!);
      if (cart.isNotEmpty) {
        await loadPreview();
      } else {
        preview.value = null;
      }
    } finally {
      removingCartProductIds.remove(productId);
    }
  }

  Future<void> clearCart() async {
    final result = await _repository.clearCart();
    if (!result.isSuccess) {
      AppHelperFunctions.showErrorSnackBar(result.errorMessage);
      return;
    }
    cart.clear();
    preview.value = null;
    _checkoutIdempotencyKey = null;
    checkoutSession.value = null;
  }

  void _setCart(CommerceCart value) {
    cart.assignAll(value.items.map((item) => CartLine(api: item)));
    _checkoutIdempotencyKey = null;
    checkoutSession.value = null;
  }

  Future<void> loadAddresses() async {
    final result = await _profileRepository.getAddresses();
    if (!result.isSuccess || result.data == null) return;
    addresses.assignAll(result.data!);
    final primary = addresses.firstWhereOrNull((item) => item.isPrimary);
    selectedShippingAddressId.value = primary?.id ?? addresses.firstOrNull?.id;
  }

  Future<void> selectShippingAddress(String id) async {
    selectedShippingAddressId.value = id;
    await loadPreview();
  }

  Future<bool> loadPreview() async {
    final addressId = selectedShippingAddressId.value;
    if (addressId == null || cart.isEmpty) return false;
    _previewRequestCount++;
    isPreviewLoading.value = true;
    try {
      final result = await _repository.preview(shippingAddressId: addressId);
      if (!result.isSuccess || result.data == null) {
        AppHelperFunctions.showErrorSnackBar(result.errorMessage);
        return false;
      }
      preview.value = result.data;
      return true;
    } finally {
      _previewRequestCount--;
      isPreviewLoading.value = _previewRequestCount > 0;
    }
  }

  Future<CheckoutSession?> placeOrder() async {
    if (isCheckoutLoading.value) return null;
    final addressId = selectedShippingAddressId.value;
    if (addressId == null) {
      AppHelperFunctions.showErrorSnackBar(
        'Add and select a saved shipping address first.',
      );
      return null;
    }
    if (cart.isEmpty) {
      AppHelperFunctions.showErrorSnackBar('Your cart is empty.');
      return null;
    }
    isCheckoutLoading.value = true;
    try {
      if (!await loadPreview()) return null;
      final result = await _repository.checkoutCart(
        shippingAddressId: addressId,
        idempotencyKey: _checkoutIdempotencyKey ??= const Uuid().v4(),
      );
      if (!result.isSuccess || result.data == null) {
        AppHelperFunctions.showErrorSnackBar(result.errorMessage);
        return null;
      }
      checkoutSession.value = result.data;
      lastOrderId = result.data!.orderId;
      lastOrderSubtotal = subtotal;
      lastOrderTax = estimatedTax;
      lastOrderTotal = total;
      lastOrderLines = List<CartLine>.of(cart);
      return result.data;
    } finally {
      isCheckoutLoading.value = false;
    }
  }

  Future<CommerceOrder?> refreshCheckoutOrder() async {
    final orderId = checkoutSession.value?.orderId;
    if (orderId == null) return null;
    final result = await _repository.order(orderId);
    if (!result.isSuccess || result.data == null) {
      AppHelperFunctions.showErrorSnackBar(result.errorMessage);
      return null;
    }
    final order = result.data!;
    completedOrder.value = order;
    lastOrderId = order.orderNumber;
    lastOrderSubtotal = order.subtotal.toDouble();
    lastOrderTax = order.tax.toDouble();
    lastOrderTotal = order.total.toDouble();
    lastOrderDeliveryDate = order.estimatedDelivery?.toLocal();
    return order;
  }

  bool isOrderPaid(CommerceOrder order) {
    final paymentStatus = order.paymentStatus?.trim().toUpperCase();
    return order.paidAt != null ||
        const {
          'PAID',
          'AUTHORIZED',
          'CAPTURED',
          'SUCCEEDED',
          'SUCCESS',
        }.contains(paymentStatus) ||
        const {
          CommerceOrderStatus.paid,
          CommerceOrderStatus.processing,
          CommerceOrderStatus.shipped,
          CommerceOrderStatus.delivered,
        }.contains(order.status);
  }

  Future<CommerceOrder?> waitForCheckoutPayment({
    int attempts = 6,
    Duration interval = const Duration(seconds: 2),
  }) async {
    CommerceOrder? latest;
    for (var attempt = 0; attempt < attempts; attempt++) {
      latest = await refreshCheckoutOrder();
      if (latest != null && isOrderPaid(latest)) return latest;
      if (attempt < attempts - 1) await Future<void>.delayed(interval);
    }
    return latest;
  }

  Future<void> finishPaidCheckout(CommerceOrder order) async {
    completedOrder.value = order;
    cart.clear();
    preview.value = null;
    checkoutSession.value = null;
    _checkoutIdempotencyKey = null;

    final result = await _repository.clearCart();
    if (!result.isSuccess) {
      AppHelperFunctions.showErrorSnackBar(
        'Payment succeeded, but the cart could not be cleared. Pull to refresh and try again.',
      );
    }
  }

  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final apartmentController = TextEditingController();
  final countryController = TextEditingController();
  final stateController = TextEditingController();
  final cityController = TextEditingController();
  final zipController = TextEditingController();
  final saveAddress = false.obs;
  void toggleSaveAddress() => saveAddress.toggle();
  String get shippingAddressSummary => preview.value?.shippingAddress == null
      ? 'Not provided'
      : [
          preview.value!.shippingAddress!.line1,
          preview.value!.shippingAddress!.city,
          preview.value!.shippingAddress!.state,
          preview.value!.shippingAddress!.zipCode,
        ].join(', ');
}
