import 'dart:convert';

import 'package:aryegrunzweig/core/services/api_client.dart';
import 'package:aryegrunzweig/core/services/session_store.dart';
import 'package:aryegrunzweig/features/services/data/service_request_repository.dart';
import 'package:aryegrunzweig/features/services/data/service_request_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test(
    'list sends the exact Swagger status query and parses requests',
    () async {
      final repository = _repository((request) async {
        expect(request.method, 'GET');
        expect(request.url.path, '/api/service-requests');
        expect(request.url.queryParameters['status'], 'QUOTE_SENT');
        return http.Response(jsonEncode([_minimalRequest]), 200);
      });

      final result = await repository.list(
        status: CustomerRequestStatus.quoteSent,
      );
      expect(result.isSuccess, isTrue);
      expect(result.data!.single.requestNumber, 'SR-1');
    },
  );

  test('quote actions use documented payloads and endpoints', () async {
    var call = 0;
    final repository = _repository((request) async {
      call++;
      if (call == 1) {
        expect(
          request.url.path,
          '/api/service-requests/request-1/quotation/accept',
        );
        expect(jsonDecode(request.body), {
          'acceptTerms': true,
          'termsVersion': '2026-08-17',
        });
        return http.Response(jsonEncode(_quote), 200);
      }
      expect(
        request.url.path,
        '/api/service-requests/request-1/quotation/counteroffers',
      );
      expect(jsonDecode(request.body), {
        'requestedTotal': 175,
        'note': 'Please review',
      });
      return http.Response(jsonEncode(_counteroffer), 201);
    });

    expect(
      (await repository.acceptQuote(
        id: 'request-1',
        termsVersion: '2026-08-17',
      )).isSuccess,
      isTrue,
    );
    expect(
      (await repository.counteroffer(
        id: 'request-1',
        requestedTotal: 175,
        note: 'Please review',
      )).isSuccess,
      isTrue,
    );
  });

  test(
    'service authorization parses hosted Stripe checkout response',
    () async {
      final repository = _repository((request) async {
        expect(
          request.url.path,
          '/api/payments/service-requests/request-1/authorization',
        );
        return http.Response(
          jsonEncode({
            'paymentId': 'payment-1',
            'requestId': 'request-1',
            'checkoutUrl': 'https://checkout.stripe.com/test',
            'checkoutSessionId': 'cs_test',
            'amount': 175,
            'currency': 'cad',
          }),
          201,
        );
      });

      final result = await repository.authorizePayment('request-1');
      expect(result.isSuccess, isTrue);
      expect(result.data!.checkoutUrl, contains('checkout.stripe.com'));
    },
  );
}

ServiceRequestRepository _repository(
  Future<http.Response> Function(http.Request) handler,
) => ServiceRequestRepository(
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

const _minimalRequest = {
  'id': 'request-1',
  'requestNumber': 'SR-1',
  'customerId': 'customer-1',
  'technicianId': null,
  'categoryId': 'category-1',
  'issueId': null,
  'addressId': 'address-1',
  'description': 'Low suction',
  'status': 'QUOTE_SENT',
  'scheduledStart': null,
  'scheduledEnd': null,
  'cancellationReason': null,
  'media': [],
  'quotation': null,
  'report': null,
  'equipment': [],
  'statusHistory': [],
};

const _quote = {
  'id': 'quote-1',
  'quoteNumber': 'QT-1',
  'totalAmount': 192.1,
  'negotiatedTotal': null,
  'status': 'ACCEPTED',
  'validUntil': '2026-09-02T09:00:00.000Z',
  'acceptedAt': '2026-08-30T12:00:00.000Z',
  'notes': null,
  'counteroffers': [],
  'payments': [],
};

const _counteroffer = {
  'id': 'offer-1',
  'quotationId': 'quote-1',
  'customerId': 'customer-1',
  'requestedTotal': 175,
  'note': 'Please review',
  'status': 'PENDING',
  'decidedById': null,
  'decisionNote': null,
  'decidedAt': null,
  'supersededAt': null,
  'createdAt': '2026-08-30T12:00:00.000Z',
  'statusHistory': [],
};
