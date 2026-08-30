import 'dart:convert';

import 'package:aryegrunzweig/core/services/api_client.dart';
import 'package:aryegrunzweig/core/services/session_store.dart';
import 'package:aryegrunzweig/features/shop/data/commerce_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('product listing sends documented filters and parses page', () async {
    final repository = _repository((request) async {
      expect(request.url.path, '/api/catalog/products');
      expect(request.url.queryParameters, containsPair('search', 'filter'));
      expect(request.url.queryParameters, containsPair('page', '2'));
      expect(request.headers.containsKey('Authorization'), isFalse);
      return http.Response(
        jsonEncode({
          'items': [_product],
          'total': 30,
          'page': 2,
          'pageSize': 24,
        }),
        200,
      );
    });
    final result = await repository.products(search: 'filter', page: 2);
    expect(result.isSuccess, isTrue);
    expect(result.data!.items.single.name, 'HEPA Filter');
  });

  test('cart CRUD uses product id and server totals', () async {
    var call = 0;
    final repository = _repository((request) async {
      call++;
      if (call == 1) {
        expect(request.method, 'POST');
        expect(request.url.path, '/api/cart/items');
        expect(jsonDecode(request.body), {
          'productId': 'product-1',
          'quantity': 2,
        });
      } else {
        expect(request.method, 'PATCH');
        expect(request.url.path, '/api/cart/items/product-1');
        expect(jsonDecode(request.body), {'quantity': 3});
      }
      return http.Response(jsonEncode(_cart), call == 1 ? 201 : 200);
    });
    expect((await repository.addCartItem('product-1', 2)).data!.tax, 14.97);
    expect((await repository.updateCartItem('product-1', 3)).isSuccess, isTrue);
  });

  test(
    'preview and checkout send saved address and stable idempotency key',
    () async {
      var call = 0;
      final repository = _repository((request) async {
        call++;
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        expect(body['shippingAddressId'], 'address-1');
        if (call == 1) {
          expect(request.url.path, '/api/checkout/preview');
          return http.Response(jsonEncode(_preview), 200);
        }
        expect(request.url.path, '/api/checkout/cart');
        expect(body['idempotencyKey'], 'uuid-1');
        return http.Response(jsonEncode(_checkout), 201);
      });
      expect(
        (await repository.preview(shippingAddressId: 'address-1')).data!.total,
        114.95,
      );
      final checkout = await repository.checkoutCart(
        shippingAddressId: 'address-1',
        idempotencyKey: 'uuid-1',
      );
      expect(checkout.data!.checkoutUrl, contains('checkout.stripe.com'));
    },
  );

  test(
    'customer order actions use documented paths and return payload',
    () async {
      var call = 0;
      final repository = _repository((request) async {
        call++;
        if (call == 1) {
          expect(request.url.path, '/api/orders/order-1/cancel');
          return http.Response(jsonEncode(_order), 200);
        }
        expect(request.url.path, '/api/orders/order-1/return');
        expect(jsonDecode(request.body), {
          'orderItemId': 'item-1',
          'reason': 'Damaged',
          'comments': 'Box crushed',
        });
        return http.Response(jsonEncode(_returnRequest), 201);
      });
      expect(
        (await repository.cancelOrder('order-1')).data!.canCancel,
        isFalse,
      );
      final returned = await repository.requestReturn(
        orderId: 'order-1',
        orderItemId: 'item-1',
        reason: 'Damaged',
        comments: 'Box crushed',
      );
      expect(returned.data!.status.wireValue, 'REQUESTED');
    },
  );
}

CommerceRepository _repository(
  Future<http.Response> Function(http.Request) handler,
) => CommerceRepository(
  ApiClient(
    baseUrl: 'https://example.test',
    sessionStore: _FakeSessionStore(),
    httpClient: MockClient(handler),
  ),
);

class _FakeSessionStore implements SessionStore {
  @override
  String? accessToken = 'access-token';
  @override
  String? refreshToken;
  @override
  String? userId = 'customer-1';
  @override
  String? userRole = 'CUSTOMER';
  @override
  Future<void> clear() async {}
  @override
  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    String? userId,
    String? userRole,
  }) async {}
  @override
  Future<void> updateIdentity({String? userId, String? userRole}) async {}
}

const _product = {
  'id': 'product-1',
  'sku': 'FILTER-1',
  'name': 'HEPA Filter',
  'description': 'Replacement filter',
  'category': 'Filters',
  'price': 49.99,
  'stock': 20,
  'imageUrls': <String>[],
  'slug': 'hepa-filter',
  'features': <String>[],
  'specifications': null,
  'warranty': null,
  'shippingInfo': null,
  'isActive': true,
  'taxable': true,
  'tagline': null,
  'inStock': true,
};

const _cartProduct = {
  'id': 'product-1',
  'name': 'HEPA Filter',
  'price': 49.99,
  'stock': 20,
  'imageUrls': <String>[],
  'slug': 'hepa-filter',
  'tagline': null,
  'inStock': true,
  'taxable': true,
};

const _cart = {
  'id': 'cart-1',
  'customerId': 'customer-1',
  'items': [
    {
      'id': 'cart-item-1',
      'productId': 'product-1',
      'quantity': 2,
      'unitPrice': 49.99,
      'lineTotal': 99.98,
      'product': _cartProduct,
    },
  ],
  'itemCount': 2,
  'currency': 'cad',
  'subtotal': 99.98,
  'tax': 14.97,
  'shippingFee': 0,
  'total': 114.95,
  'taxRate': 0.14975,
};

const _preview = {
  'source': 'cart',
  'items': <Map<String, dynamic>>[],
  'itemCount': 2,
  'subtotal': 99.98,
  'tax': 14.97,
  'shippingFee': 0,
  'total': 114.95,
  'taxRate': 0.14975,
  'currency': 'cad',
  'shippingAddress': null,
};

const _checkout = {
  'paymentId': 'payment-1',
  'orderId': 'order-1',
  'checkoutSessionId': 'cs_test',
  'checkoutUrl': 'https://checkout.stripe.com/test',
  'currency': 'cad',
  'amount': 114.95,
};

const _returnRequest = {
  'id': 'return-1',
  'orderId': 'order-1',
  'status': 'REQUESTED',
  'orderItemId': 'item-1',
  'reason': 'Damaged',
  'comments': 'Box crushed',
  'resolution': null,
  'adminNotes': null,
  'returnLabelUrl': null,
  'createdAt': '2026-08-30T10:00:00.000Z',
};

const _order = {
  'id': 'order-1',
  'orderNumber': 'CC-1',
  'status': 'CANCELLED',
  'subtotal': 99.98,
  'tax': 14.97,
  'shippingFee': 0,
  'total': 114.95,
  'trackingNumber': null,
  'carrier': null,
  'estimatedDelivery': null,
  'paidAt': null,
  'paymentStatus': 'CANCELED',
  'shippingAddress': {
    'line1': '123 Main St',
    'apartment': null,
    'city': 'Toronto',
    'state': 'ON',
    'zipCode': 'M5V 2T6',
    'country': 'Canada',
  },
  'timeline': <Map<String, dynamic>>[],
  'canCancel': false,
  'canReturn': false,
  'items': <Map<String, dynamic>>[],
  'statusHistory': <Map<String, dynamic>>[],
  'returnRequests': <Map<String, dynamic>>[],
  'createdAt': '2026-08-30T10:00:00.000Z',
};
