import 'dart:convert';

import 'package:aryegrunzweig/core/models/page_data.dart';
import 'package:aryegrunzweig/core/services/api_client.dart';
import 'package:aryegrunzweig/core/services/session_service.dart';
import 'package:aryegrunzweig/core/services/session_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('ApiClient', () {
    test('sends bearer auth, query parameters, and JSON body', () async {
      final store = _FakeSessionStore(accessToken: 'access-token');
      final client = ApiClient(
        baseUrl: 'https://example.test',
        sessionStore: store,
        httpClient: MockClient((request) async {
          expect(request.method, 'PATCH');
          expect(request.url.path, '/api/resource');
          expect(request.url.queryParameters['page'], '2');
          expect(request.headers['authorization'], 'Bearer access-token');
          expect(jsonDecode(request.body), {'name': 'Updated'});
          return http.Response('{"id":"one"}', 201);
        }),
      );

      final response = await client.patch(
        '/api/resource',
        queryParameters: {'page': 2},
        body: {'name': 'Updated'},
      );

      expect(response.isSuccess, isTrue);
      expect(response.statusCode, 201);
      expect(response.responseData, {'id': 'one'});
    });

    test('treats an empty 204 response as successful', () async {
      final client = ApiClient(
        baseUrl: 'https://example.test',
        sessionStore: _FakeSessionStore(),
        httpClient: MockClient((_) async => http.Response('', 204)),
      );

      final response = await client.delete(
        '/api/resource',
        authenticated: false,
      );

      expect(response.isSuccess, isTrue);
      expect(response.statusCode, 204);
      expect(response.responseData, isNull);
    });

    test('refreshes once after 401 and retries with the new token', () async {
      final store = _FakeSessionStore(
        accessToken: 'expired-token',
        refreshToken: 'refresh-token',
        userRole: 'CUSTOMER',
      );
      var protectedCalls = 0;
      var refreshCalls = 0;
      final client = ApiClient(
        baseUrl: 'https://example.test',
        sessionStore: store,
        httpClient: MockClient((request) async {
          if (request.url.path == '/api/auth/refresh') {
            refreshCalls++;
            expect(jsonDecode(request.body), {'refreshToken': 'refresh-token'});
            return http.Response(
              jsonEncode({
                'accessToken': 'new-token',
                'refreshToken': 'new-refresh-token',
                'user': {'id': 'user-1', 'role': 'CUSTOMER'},
              }),
              201,
            );
          }

          protectedCalls++;
          if (request.headers['authorization'] == 'Bearer expired-token') {
            return http.Response('{"message":"Unauthorized"}', 401);
          }
          expect(request.headers['authorization'], 'Bearer new-token');
          return http.Response('{"ok":true}', 200);
        }),
      );

      final response = await client.get('/api/protected');

      expect(response.isSuccess, isTrue);
      expect(protectedCalls, 2);
      expect(refreshCalls, 1);
      expect(store.accessToken, 'new-token');
      expect(store.refreshToken, 'new-refresh-token');
    });

    test('normalizes validation message lists', () async {
      final client = ApiClient(
        baseUrl: 'https://example.test',
        sessionStore: _FakeSessionStore(),
        httpClient: MockClient(
          (_) async => http.Response(
            '{"message":["Email is invalid","Password is required"]}',
            400,
          ),
        ),
      );

      final response = await client.post('/api/public', authenticated: false);

      expect(response.isSuccess, isFalse);
      expect(response.errorMessage, 'Email is invalid, Password is required');
    });

    test(
      'clears and announces an expired session without a refresh token',
      () async {
        final store = _FakeSessionStore(accessToken: 'expired-token');
        var expiryEvents = 0;
        final client = ApiClient(
          baseUrl: 'https://example.test',
          sessionStore: store,
          onSessionExpired: () => expiryEvents++,
          httpClient: MockClient(
            (_) async => http.Response('{"message":"Unauthorized"}', 401),
          ),
        );

        final response = await client.get('/api/protected');

        expect(response.statusCode, 401);
        expect(store.wasCleared, isTrue);
        expect(expiryEvents, 1);
      },
    );
  });

  test('PageData maps pagination metadata and items', () {
    final page = PageData<String>.fromJson({
      'items': [
        {'name': 'One'},
        {'name': 'Two'},
      ],
      'total': 3,
      'page': 1,
      'pageSize': 2,
    }, (item) => item['name']! as String);

    expect(page.items, ['One', 'Two']);
    expect(page.hasNextPage, isTrue);
    expect(page.isEmpty, isFalse);
  });

  group('SessionService', () {
    test('hydrates the cached identity from auth/me', () async {
      final store = _FakeSessionStore(
        accessToken: 'access-token',
        refreshToken: 'refresh-token',
      );
      final client = ApiClient(
        baseUrl: 'https://example.test',
        sessionStore: store,
        httpClient: MockClient(
          (_) async =>
              http.Response('{"id":"tech-1","role":"TECHNICIAN"}', 200),
        ),
      );

      final result = await SessionService(
        apiClient: client,
        sessionStore: store,
      ).bootstrap();

      expect(result.status, SessionBootstrapStatus.authenticated);
      expect(result.role, 'TECHNICIAN');
      expect(store.userId, 'tech-1');
      expect(store.userRole, 'TECHNICIAN');
    });

    test('uses a cached mobile role when bootstrap is offline', () async {
      final store = _FakeSessionStore(
        accessToken: 'access-token',
        refreshToken: 'refresh-token',
        userRole: 'CUSTOMER',
      );
      final client = ApiClient(
        baseUrl: 'https://example.test',
        sessionStore: store,
        httpClient: MockClient((_) async {
          throw http.ClientException('offline');
        }),
      );

      final result = await SessionService(
        apiClient: client,
        sessionStore: store,
      ).bootstrap();

      expect(result.status, SessionBootstrapStatus.authenticatedOffline);
      expect(result.role, 'CUSTOMER');
      expect(store.wasCleared, isFalse);
    });

    test('keeps an unverified technician out of the technician home', () async {
      final store = _FakeSessionStore(
        accessToken: 'access-token',
        refreshToken: 'refresh-token',
      );
      final client = ApiClient(
        baseUrl: 'https://example.test',
        sessionStore: store,
        httpClient: MockClient(
          (_) async => http.Response(
            '{"id":"tech-1","role":"TECHNICIAN","technician":{"verificationStatus":"PENDING_VERIFICATION"}}',
            200,
          ),
        ),
      );

      final result = await SessionService(
        apiClient: client,
        sessionStore: store,
      ).bootstrap();

      expect(result.isAuthenticated, isTrue);
      expect(result.canOpenRoleHome, isFalse);
      expect(result.technicianVerificationStatus, 'PENDING_VERIFICATION');
    });
  });
}

class _FakeSessionStore implements SessionStore {
  _FakeSessionStore({this.accessToken, this.refreshToken, this.userRole});

  @override
  String? accessToken;

  @override
  String? refreshToken;

  @override
  String? userId;

  @override
  String? userRole;

  bool wasCleared = false;

  @override
  Future<void> clear() async {
    wasCleared = true;
    accessToken = null;
    refreshToken = null;
    userId = null;
    userRole = null;
  }

  @override
  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    String? userId,
    String? userRole,
  }) async {
    this.accessToken = accessToken;
    this.refreshToken = refreshToken;
    this.userId = userId ?? this.userId;
    this.userRole = userRole ?? this.userRole;
  }

  @override
  Future<void> updateIdentity({String? userId, String? userRole}) async {
    this.userId = userId ?? this.userId;
    this.userRole = userRole ?? this.userRole;
  }
}
