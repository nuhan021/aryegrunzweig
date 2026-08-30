import '../../../core/models/operation_result.dart';
import '../../../core/models/response_data.dart';
import '../../../core/services/api_client.dart';
import '../../../core/utils/constants/api_constants.dart';
import 'commerce_models.dart';

class CommerceRepository {
  const CommerceRepository(this._client);
  final ApiClient _client;

  Future<OperationResult<List<ProductCategoryCount>>> categories() async =>
      _parseList(
        await _client.get(ApiConstants.productCategories, authenticated: false),
        ProductCategoryCount.fromJson,
      );

  Future<OperationResult<ProductPage>> products({
    String? search,
    String? category,
    num? minPrice,
    num? maxPrice,
    bool inStockOnly = false,
    String sort = 'popularity',
    int page = 1,
    int pageSize = 24,
  }) async => _parseMap(
    await _client.get(
      ApiConstants.products,
      authenticated: false,
      queryParameters: {
        if (search?.trim().isNotEmpty ?? false) 'search': search!.trim(),
        if (category?.isNotEmpty ?? false) 'category': category,
        if (minPrice != null) 'minPrice': minPrice,
        if (maxPrice != null) 'maxPrice': maxPrice,
        if (inStockOnly) 'inStockOnly': true,
        'sort': sort,
        'page': page,
        'pageSize': pageSize,
      },
    ),
    ProductPage.fromJson,
  );

  Future<OperationResult<CommerceProduct>> product(String idOrSlug) async =>
      _parseMap(
        await _client.get(
          '${ApiConstants.products}/$idOrSlug',
          authenticated: false,
        ),
        CommerceProduct.fromJson,
      );

  Future<OperationResult<CommerceCart>> getCart() async =>
      _parseMap(await _client.get(ApiConstants.cart), CommerceCart.fromJson);

  Future<OperationResult<CommerceCart>> addCartItem(
    String productId,
    int quantity,
  ) async => _parseMap(
    await _client.post(
      '${ApiConstants.cart}/items',
      body: {'productId': productId, 'quantity': quantity},
    ),
    CommerceCart.fromJson,
  );

  Future<OperationResult<CommerceCart>> updateCartItem(
    String productId,
    int quantity,
  ) async => _parseMap(
    await _client.patch(
      '${ApiConstants.cart}/items/$productId',
      body: {'quantity': quantity},
    ),
    CommerceCart.fromJson,
  );

  Future<OperationResult<CommerceCart>> removeCartItem(
    String productId,
  ) async => _parseMap(
    await _client.delete('${ApiConstants.cart}/items/$productId'),
    CommerceCart.fromJson,
  );

  Future<OperationResult<void>> clearCart() async {
    final response = await _client.delete(ApiConstants.cart);
    if (!response.isSuccess) return _failure(response);
    return OperationResult.success(null, statusCode: response.statusCode);
  }

  Future<OperationResult<CheckoutPreview>> preview({
    required String shippingAddressId,
    List<({String productId, int quantity})>? items,
  }) async => _parseMap(
    await _client.post(
      ApiConstants.checkoutPreview,
      body: {
        if (items != null)
          'items': items
              .map(
                (item) => {
                  'productId': item.productId,
                  'quantity': item.quantity,
                },
              )
              .toList(growable: false),
        'shippingAddressId': shippingAddressId,
      },
    ),
    CheckoutPreview.fromJson,
  );

  Future<OperationResult<CheckoutSession>> checkoutCart({
    required String shippingAddressId,
    required String idempotencyKey,
  }) async => _parseMap(
    await _client.post(
      ApiConstants.checkoutCart,
      body: {
        'shippingAddressId': shippingAddressId,
        'idempotencyKey': idempotencyKey,
      },
    ),
    CheckoutSession.fromJson,
  );

  Future<OperationResult<CheckoutSession>> checkoutItems({
    required List<({String productId, int quantity})> items,
    required String shippingAddressId,
    required String idempotencyKey,
  }) async => _parseMap(
    await _client.post(
      ApiConstants.checkoutOrders,
      body: {
        'items': items
            .map(
              (item) => {
                'productId': item.productId,
                'quantity': item.quantity,
              },
            )
            .toList(growable: false),
        'shippingAddressId': shippingAddressId,
        'idempotencyKey': idempotencyKey,
      },
    ),
    CheckoutSession.fromJson,
  );

  Future<OperationResult<OrderPage>> orders({
    String group = 'all',
    CommerceOrderStatus? status,
    String? search,
    int page = 1,
    int pageSize = 25,
  }) async => _parseMap(
    await _client.get(
      ApiConstants.orders,
      queryParameters: {
        'group': group,
        if (status != null) 'status': status.wireValue,
        if (search?.trim().isNotEmpty ?? false) 'search': search!.trim(),
        'page': page,
        'pageSize': pageSize,
      },
    ),
    OrderPage.fromJson,
  );

  Future<OperationResult<CommerceOrder>> order(String id) async => _parseMap(
    await _client.get('${ApiConstants.orders}/$id'),
    CommerceOrder.fromJson,
  );

  Future<OperationResult<CommerceOrder>> cancelOrder(String id) async =>
      _parseMap(
        await _client.post('${ApiConstants.orders}/$id/cancel'),
        CommerceOrder.fromJson,
      );

  Future<OperationResult<CommerceCart>> reorder(String id) async => _parseMap(
    await _client.post('${ApiConstants.orders}/$id/reorder'),
    CommerceCart.fromJson,
  );

  Future<OperationResult<CommerceReturnRequest>> requestReturn({
    required String orderId,
    String? orderItemId,
    required String reason,
    String? comments,
  }) async => _parseMap(
    await _client.post(
      '${ApiConstants.orders}/$orderId/return',
      body: {
        if (orderItemId != null) 'orderItemId': orderItemId,
        'reason': reason,
        if (comments?.trim().isNotEmpty ?? false) 'comments': comments!.trim(),
      },
    ),
    CommerceReturnRequest.fromJson,
  );

  Future<OperationResult<List<CommerceReturnRequest>>> orderReturns(
    String orderId,
  ) async => _parseList(
    await _client.get('${ApiConstants.orders}/$orderId/returns'),
    CommerceReturnRequest.fromJson,
  );

  Future<OperationResult<List<CommerceReturnRequest>>> returns() async =>
      _parseList(
        await _client.get('${ApiConstants.orders}/returns'),
        CommerceReturnRequest.fromJson,
      );

  OperationResult<T> _parseMap<T>(
    ResponseData response,
    T Function(Map<String, dynamic>) parser,
  ) {
    if (!response.isSuccess) return _failure(response);
    try {
      return OperationResult.success(
        parser(Map<String, dynamic>.from(response.responseData as Map)),
        statusCode: response.statusCode,
      );
    } on Object catch (error) {
      return OperationResult.failure(
        statusCode: response.statusCode,
        errorMessage: 'Invalid server response: $error',
      );
    }
  }

  OperationResult<List<T>> _parseList<T>(
    ResponseData response,
    T Function(Map<String, dynamic>) parser,
  ) {
    if (!response.isSuccess) return _failure(response);
    try {
      return OperationResult.success(
        (response.responseData as List)
            .map((item) => parser(Map<String, dynamic>.from(item as Map)))
            .toList(growable: false),
        statusCode: response.statusCode,
      );
    } on Object catch (error) {
      return OperationResult.failure(
        statusCode: response.statusCode,
        errorMessage: 'Invalid server response: $error',
      );
    }
  }

  OperationResult<T> _failure<T>(ResponseData response) =>
      OperationResult.failure(
        statusCode: response.statusCode,
        errorMessage: response.errorMessage,
      );
}
