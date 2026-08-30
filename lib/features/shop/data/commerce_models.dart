enum CommerceOrderStatus {
  paymentPending('PAYMENT_PENDING'),
  placed('PLACED'),
  paid('PAID'),
  processing('PROCESSING'),
  shipped('SHIPPED'),
  delivered('DELIVERED'),
  cancelled('CANCELLED'),
  paymentFailed('PAYMENT_FAILED'),
  refunded('REFUNDED');

  const CommerceOrderStatus(this.wireValue);
  final String wireValue;

  static CommerceOrderStatus fromJson(Object? value) => values.firstWhere(
    (item) => item.wireValue == value,
    orElse: () => throw FormatException('Unknown order status: $value'),
  );
}

enum CommerceReturnStatus {
  requested('REQUESTED'),
  approved('APPROVED'),
  rejected('REJECTED'),
  received('RECEIVED'),
  refunded('REFUNDED');

  const CommerceReturnStatus(this.wireValue);
  final String wireValue;
  static CommerceReturnStatus fromJson(Object? value) => values.firstWhere(
    (item) => item.wireValue == value,
    orElse: () => throw FormatException('Unknown return status: $value'),
  );
}

class ProductCategoryCount {
  const ProductCategoryCount({required this.name, required this.count});
  factory ProductCategoryCount.fromJson(Map<String, dynamic> json) =>
      ProductCategoryCount(
        name: _string(json, 'name'),
        count: _integer(json, 'count'),
      );
  final String name;
  final int count;
}

class CommerceProduct {
  const CommerceProduct({
    required this.id,
    required this.sku,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.stock,
    required this.imageUrls,
    required this.slug,
    required this.features,
    required this.specifications,
    required this.warranty,
    required this.shippingInfo,
    required this.isActive,
    required this.taxable,
    required this.tagline,
    required this.inStock,
    this.relatedProducts = const [],
  });

  factory CommerceProduct.fromJson(Map<String, dynamic> json) =>
      CommerceProduct(
        id: _string(json, 'id'),
        sku: _nullableString(json, 'sku'),
        name: _string(json, 'name'),
        description: _string(json, 'description'),
        category: _string(json, 'category'),
        price: _number(json, 'price'),
        stock: _integer(json, 'stock'),
        imageUrls: _strings(json, 'imageUrls'),
        slug: _nullableString(json, 'slug'),
        features: _strings(json, 'features'),
        specifications: json['specifications'] == null
            ? null
            : _map(json['specifications'], 'specifications'),
        warranty: _nullableString(json, 'warranty'),
        shippingInfo: _nullableString(json, 'shippingInfo'),
        isActive: _boolean(json, 'isActive'),
        taxable: _boolean(json, 'taxable'),
        tagline: _nullableString(json, 'tagline'),
        inStock: _boolean(json, 'inStock'),
        relatedProducts: _optionalList(json, 'relatedProducts')
            .map((item) => CommerceProduct.fromJson(_map(item, 'product')))
            .toList(growable: false),
      );

  final String id;
  final String? sku;
  final String name;
  final String description;
  final String category;
  final num price;
  final int stock;
  final List<String> imageUrls;
  final String? slug;
  final List<String> features;
  final Map<String, dynamic>? specifications;
  final String? warranty;
  final String? shippingInfo;
  final bool isActive;
  final bool taxable;
  final String? tagline;
  final bool inStock;
  final List<CommerceProduct> relatedProducts;
}

class ProductPage {
  const ProductPage({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  });
  factory ProductPage.fromJson(Map<String, dynamic> json) => ProductPage(
    items: _list(json, 'items')
        .map((item) => CommerceProduct.fromJson(_map(item, 'product')))
        .toList(growable: false),
    total: _integer(json, 'total'),
    page: _integer(json, 'page'),
    pageSize: _integer(json, 'pageSize'),
  );
  final List<CommerceProduct> items;
  final int total;
  final int page;
  final int pageSize;
}

class CommerceCartProduct {
  const CommerceCartProduct({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.imageUrls,
    required this.slug,
    required this.tagline,
    required this.inStock,
    required this.taxable,
  });
  factory CommerceCartProduct.fromJson(Map<String, dynamic> json) =>
      CommerceCartProduct(
        id: _string(json, 'id'),
        name: _string(json, 'name'),
        price: _number(json, 'price'),
        stock: _integer(json, 'stock'),
        imageUrls: _strings(json, 'imageUrls'),
        slug: _nullableString(json, 'slug'),
        tagline: _nullableString(json, 'tagline'),
        inStock: _boolean(json, 'inStock'),
        taxable: _boolean(json, 'taxable'),
      );
  final String id;
  final String name;
  final num price;
  final int stock;
  final List<String> imageUrls;
  final String? slug;
  final String? tagline;
  final bool inStock;
  final bool taxable;
}

class CommerceCartItem {
  const CommerceCartItem({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    required this.lineTotal,
    required this.product,
  });
  factory CommerceCartItem.fromJson(Map<String, dynamic> json) =>
      CommerceCartItem(
        id: _string(json, 'id'),
        productId: _string(json, 'productId'),
        quantity: _integer(json, 'quantity'),
        unitPrice: _number(json, 'unitPrice'),
        lineTotal: _number(json, 'lineTotal'),
        product: CommerceCartProduct.fromJson(_object(json, 'product')),
      );
  final String id;
  final String productId;
  final int quantity;
  final num unitPrice;
  final num lineTotal;
  final CommerceCartProduct product;
}

class CommerceCart {
  const CommerceCart({
    required this.id,
    required this.customerId,
    required this.items,
    required this.itemCount,
    required this.currency,
    required this.subtotal,
    required this.tax,
    required this.shippingFee,
    required this.total,
    required this.taxRate,
  });
  factory CommerceCart.fromJson(Map<String, dynamic> json) => CommerceCart(
    id: _string(json, 'id'),
    customerId: _string(json, 'customerId'),
    items: _list(json, 'items')
        .map((item) => CommerceCartItem.fromJson(_map(item, 'cart item')))
        .toList(growable: false),
    itemCount: _integer(json, 'itemCount'),
    currency: _string(json, 'currency'),
    subtotal: _number(json, 'subtotal'),
    tax: _number(json, 'tax'),
    shippingFee: _number(json, 'shippingFee'),
    total: _number(json, 'total'),
    taxRate: _number(json, 'taxRate'),
  );
  final String id;
  final String customerId;
  final List<CommerceCartItem> items;
  final int itemCount;
  final String currency;
  final num subtotal;
  final num tax;
  final num shippingFee;
  final num total;
  final num taxRate;
}

class CheckoutPreviewItem {
  const CheckoutPreviewItem({
    required this.productId,
    required this.name,
    required this.quantity,
    required this.unitPrice,
    required this.lineTotal,
    required this.taxable,
    required this.inStock,
    required this.availableStock,
    required this.tagline,
    required this.imageUrls,
  });
  factory CheckoutPreviewItem.fromJson(Map<String, dynamic> json) =>
      CheckoutPreviewItem(
        productId: _string(json, 'productId'),
        name: _string(json, 'name'),
        quantity: _integer(json, 'quantity'),
        unitPrice: _number(json, 'unitPrice'),
        lineTotal: _number(json, 'lineTotal'),
        taxable: _boolean(json, 'taxable'),
        inStock: _boolean(json, 'inStock'),
        availableStock: _integer(json, 'availableStock'),
        tagline: _nullableString(json, 'tagline'),
        imageUrls: _strings(json, 'imageUrls'),
      );
  final String productId;
  final String name;
  final int quantity;
  final num unitPrice;
  final num lineTotal;
  final bool taxable;
  final bool inStock;
  final int availableStock;
  final String? tagline;
  final List<String> imageUrls;
}

class CheckoutAddress {
  const CheckoutAddress({
    required this.id,
    required this.line1,
    required this.apartment,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    required this.isPrimary,
  });
  factory CheckoutAddress.fromJson(Map<String, dynamic> json) =>
      CheckoutAddress(
        id: _string(json, 'id'),
        line1: _string(json, 'line1'),
        apartment: _nullableString(json, 'apartment'),
        city: _string(json, 'city'),
        state: _string(json, 'state'),
        zipCode: _string(json, 'zipCode'),
        country: _string(json, 'country'),
        isPrimary: _boolean(json, 'isPrimary'),
      );
  final String id;
  final String line1;
  final String? apartment;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final bool isPrimary;
}

class CheckoutPreview {
  const CheckoutPreview({
    required this.source,
    required this.items,
    required this.itemCount,
    required this.subtotal,
    required this.tax,
    required this.shippingFee,
    required this.total,
    required this.taxRate,
    required this.currency,
    required this.shippingAddress,
  });
  factory CheckoutPreview.fromJson(Map<String, dynamic> json) =>
      CheckoutPreview(
        source: _string(json, 'source'),
        items: _list(json, 'items')
            .map((item) => CheckoutPreviewItem.fromJson(_map(item, 'item')))
            .toList(growable: false),
        itemCount: _integer(json, 'itemCount'),
        subtotal: _number(json, 'subtotal'),
        tax: _number(json, 'tax'),
        shippingFee: _number(json, 'shippingFee'),
        total: _number(json, 'total'),
        taxRate: _number(json, 'taxRate'),
        currency: _string(json, 'currency'),
        shippingAddress: json['shippingAddress'] == null
            ? null
            : CheckoutAddress.fromJson(
                _map(json['shippingAddress'], 'shippingAddress'),
              ),
      );
  final String source;
  final List<CheckoutPreviewItem> items;
  final int itemCount;
  final num subtotal;
  final num tax;
  final num shippingFee;
  final num total;
  final num taxRate;
  final String currency;
  final CheckoutAddress? shippingAddress;
}

class CheckoutSession {
  const CheckoutSession({
    required this.paymentId,
    required this.orderId,
    required this.checkoutSessionId,
    required this.checkoutUrl,
    required this.currency,
    required this.amount,
  });
  factory CheckoutSession.fromJson(Map<String, dynamic> json) =>
      CheckoutSession(
        paymentId: _string(json, 'paymentId'),
        orderId: _string(json, 'orderId'),
        checkoutSessionId: _string(json, 'checkoutSessionId'),
        checkoutUrl: _string(json, 'checkoutUrl'),
        currency: _string(json, 'currency'),
        amount: _number(json, 'amount'),
      );
  final String paymentId;
  final String orderId;
  final String checkoutSessionId;
  final String checkoutUrl;
  final String currency;
  final num amount;
}

class OrderAddress {
  const OrderAddress({
    required this.line1,
    required this.apartment,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
  });
  factory OrderAddress.fromJson(Map<String, dynamic> json) => OrderAddress(
    line1: _string(json, 'line1'),
    apartment: _nullableString(json, 'apartment'),
    city: _string(json, 'city'),
    state: _string(json, 'state'),
    zipCode: _string(json, 'zipCode'),
    country: _nullableString(json, 'country') ?? '',
  );
  final String line1;
  final String? apartment;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  String get formatted => [
    line1,
    if (apartment?.isNotEmpty ?? false) apartment!,
    city,
    state,
    zipCode,
    country,
  ].where((item) => item.isNotEmpty).join(', ');
}

class OrderProduct {
  const OrderProduct({
    required this.id,
    required this.name,
    required this.imageUrls,
    required this.slug,
  });
  factory OrderProduct.fromJson(Map<String, dynamic> json) => OrderProduct(
    id: _string(json, 'id'),
    name: _string(json, 'name'),
    imageUrls: _strings(json, 'imageUrls'),
    slug: _nullableString(json, 'slug'),
  );
  final String id;
  final String name;
  final List<String> imageUrls;
  final String? slug;
}

class CommerceOrderItem {
  const CommerceOrderItem({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    required this.product,
  });
  factory CommerceOrderItem.fromJson(Map<String, dynamic> json) =>
      CommerceOrderItem(
        id: _string(json, 'id'),
        productId: _string(json, 'productId'),
        quantity: _integer(json, 'quantity'),
        unitPrice: _number(json, 'unitPrice'),
        product: OrderProduct.fromJson(_object(json, 'product')),
      );
  final String id;
  final String productId;
  final int quantity;
  final num unitPrice;
  final OrderProduct product;
}

class OrderTimelineStep {
  const OrderTimelineStep({
    required this.key,
    required this.label,
    required this.completed,
    required this.current,
    required this.at,
  });
  factory OrderTimelineStep.fromJson(Map<String, dynamic> json) =>
      OrderTimelineStep(
        key: _string(json, 'key'),
        label: _string(json, 'label'),
        completed: _boolean(json, 'completed'),
        current: _boolean(json, 'current'),
        at: _nullableDate(json, 'at'),
      );
  final String key;
  final String label;
  final bool completed;
  final bool current;
  final DateTime? at;
}

class OrderStatusHistory {
  const OrderStatusHistory({
    required this.status,
    required this.note,
    required this.createdAt,
  });
  factory OrderStatusHistory.fromJson(Map<String, dynamic> json) =>
      OrderStatusHistory(
        status: CommerceOrderStatus.fromJson(json['status']),
        note: _nullableString(json, 'note'),
        createdAt: _date(json, 'createdAt'),
      );
  final CommerceOrderStatus status;
  final String? note;
  final DateTime createdAt;
}

class CommerceReturnRequest {
  const CommerceReturnRequest({
    required this.id,
    required this.orderId,
    required this.status,
    required this.orderItemId,
    required this.reason,
    required this.comments,
    required this.resolution,
    required this.adminNotes,
    required this.returnLabelUrl,
    required this.createdAt,
    this.orderNumber,
    this.orderStatus,
  });
  factory CommerceReturnRequest.fromJson(Map<String, dynamic> json) =>
      CommerceReturnRequest(
        id: _string(json, 'id'),
        orderId: _string(json, 'orderId'),
        status: CommerceReturnStatus.fromJson(json['status']),
        orderItemId: _nullableString(json, 'orderItemId'),
        reason: _string(json, 'reason'),
        comments: _nullableString(json, 'comments'),
        resolution: _nullableString(json, 'resolution'),
        adminNotes: _nullableString(json, 'adminNotes'),
        returnLabelUrl: _nullableString(json, 'returnLabelUrl'),
        createdAt: _date(json, 'createdAt'),
        orderNumber: _nullableString(json, 'orderNumber'),
        orderStatus: json['orderStatus'] == null
            ? null
            : CommerceOrderStatus.fromJson(json['orderStatus']),
      );
  final String id;
  final String orderId;
  final CommerceReturnStatus status;
  final String? orderItemId;
  final String reason;
  final String? comments;
  final String? resolution;
  final String? adminNotes;
  final String? returnLabelUrl;
  final DateTime createdAt;
  final String? orderNumber;
  final CommerceOrderStatus? orderStatus;
}

class CommerceOrder {
  const CommerceOrder({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.subtotal,
    required this.tax,
    required this.shippingFee,
    required this.total,
    required this.trackingNumber,
    required this.carrier,
    required this.estimatedDelivery,
    required this.paidAt,
    required this.paymentStatus,
    required this.shippingAddress,
    required this.timeline,
    required this.canCancel,
    required this.canReturn,
    required this.items,
    required this.statusHistory,
    required this.returnRequests,
    required this.createdAt,
  });
  factory CommerceOrder.fromJson(Map<String, dynamic> json) => CommerceOrder(
    id: _string(json, 'id'),
    orderNumber: _string(json, 'orderNumber'),
    status: CommerceOrderStatus.fromJson(json['status']),
    subtotal: _number(json, 'subtotal'),
    tax: _number(json, 'tax'),
    shippingFee: _number(json, 'shippingFee'),
    total: _number(json, 'total'),
    trackingNumber: _nullableString(json, 'trackingNumber'),
    carrier: _nullableString(json, 'carrier'),
    estimatedDelivery: _nullableDate(json, 'estimatedDelivery'),
    paidAt: _nullableDate(json, 'paidAt'),
    paymentStatus: _nullableString(json, 'paymentStatus'),
    shippingAddress: OrderAddress.fromJson(_object(json, 'shippingAddress')),
    timeline: _list(json, 'timeline')
        .map((item) => OrderTimelineStep.fromJson(_map(item, 'timeline step')))
        .toList(growable: false),
    canCancel: _boolean(json, 'canCancel'),
    canReturn: _boolean(json, 'canReturn'),
    items: _list(json, 'items')
        .map((item) => CommerceOrderItem.fromJson(_map(item, 'order item')))
        .toList(growable: false),
    statusHistory: _list(json, 'statusHistory')
        .map((item) => OrderStatusHistory.fromJson(_map(item, 'history')))
        .toList(growable: false),
    returnRequests: _list(json, 'returnRequests')
        .map((item) => CommerceReturnRequest.fromJson(_map(item, 'return')))
        .toList(growable: false),
    createdAt: _date(json, 'createdAt'),
  );
  final String id;
  final String orderNumber;
  final CommerceOrderStatus status;
  final num subtotal;
  final num tax;
  final num shippingFee;
  final num total;
  final String? trackingNumber;
  final String? carrier;
  final DateTime? estimatedDelivery;
  final DateTime? paidAt;
  final String? paymentStatus;
  final OrderAddress shippingAddress;
  final List<OrderTimelineStep> timeline;
  final bool canCancel;
  final bool canReturn;
  final List<CommerceOrderItem> items;
  final List<OrderStatusHistory> statusHistory;
  final List<CommerceReturnRequest> returnRequests;
  final DateTime createdAt;
}

class OrderPage {
  const OrderPage({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  });
  factory OrderPage.fromJson(Map<String, dynamic> json) => OrderPage(
    items: _list(json, 'items')
        .map((item) => CommerceOrder.fromJson(_map(item, 'order')))
        .toList(growable: false),
    total: _integer(json, 'total'),
    page: _integer(json, 'page'),
    pageSize: _integer(json, 'pageSize'),
  );
  final List<CommerceOrder> items;
  final int total;
  final int page;
  final int pageSize;
}

Map<String, dynamic> _map(Object? value, String label) {
  if (value is! Map) throw FormatException('$label must be an object');
  return Map<String, dynamic>.from(value);
}

Map<String, dynamic> _object(Map<String, dynamic> json, String key) =>
    _map(json[key], key);

List<dynamic> _list(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! List) throw FormatException('$key must be a list');
  return value;
}

List<dynamic> _optionalList(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value == null) return const [];
  if (value is! List) throw FormatException('$key must be a list');
  return value;
}

List<String> _strings(Map<String, dynamic> json, String key) => _list(json, key)
    .map((value) {
      if (value is! String) throw FormatException('$key must contain strings');
      return value;
    })
    .toList(growable: false);

String _string(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! String || value.isEmpty) {
    throw FormatException('$key must be a non-empty string');
  }
  return value;
}

String? _nullableString(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value == null) return null;
  if (value is! String) throw FormatException('$key must be a string or null');
  return value;
}

num _number(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! num) throw FormatException('$key must be a number');
  return value;
}

int _integer(Map<String, dynamic> json, String key) =>
    _number(json, key).toInt();

bool _boolean(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! bool) throw FormatException('$key must be a boolean');
  return value;
}

DateTime _date(Map<String, dynamic> json, String key) {
  final parsed = DateTime.tryParse(_string(json, key));
  if (parsed == null) throw FormatException('$key must be a date-time');
  return parsed;
}

DateTime? _nullableDate(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value == null) return null;
  if (value is! String) throw FormatException('$key must be a date-time');
  final parsed = DateTime.tryParse(value);
  if (parsed == null) throw FormatException('$key must be a date-time');
  return parsed;
}
