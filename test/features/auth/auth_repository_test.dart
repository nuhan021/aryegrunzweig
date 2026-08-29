import 'dart:convert';

import 'package:aryegrunzweig/core/services/api_client.dart';
import 'package:aryegrunzweig/core/services/session_store.dart';
import 'package:aryegrunzweig/features/auth/data/auth_repository.dart';
import 'package:aryegrunzweig/features/auth/models/auth_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('login uses the Swagger endpoint, body, and direct response', () async {
    final client = ApiClient(
      baseUrl: 'https://example.test',
      sessionStore: _TestSessionStore(accessToken: 'must-not-be-sent'),
      httpClient: MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.url.path, '/api/auth/login');
        expect(request.headers['authorization'], isNull);
        expect(jsonDecode(request.body), {
          'email': 'sarah@example.com',
          'password': 'password123',
        });
        return http.Response(
          jsonEncode({
            'accessToken': 'access',
            'refreshToken': 'refresh',
            'user': {
              'id': 'user-1',
              'email': 'sarah@example.com',
              'role': 'CUSTOMER',
            },
          }),
          201,
        );
      }),
    );

    final result = await AuthRepository(
      client,
    ).login(email: 'sarah@example.com', password: 'password123');

    expect(result.isSuccess, isTrue);
    expect(result.data!.user.role, UserRole.customer);
  });

  test(
    'technician signup posts TechnicianSignupDto endpoint and payload',
    () async {
      final client = ApiClient(
        baseUrl: 'https://example.test',
        sessionStore: _TestSessionStore(),
        httpClient: MockClient((request) async {
          expect(request.url.path, '/api/auth/technician/signup');
          final body = jsonDecode(request.body) as Map<String, dynamic>;
          expect(body['serviceArea'], 'Montreal');
          expect(body['skills'], ['Repair']);
          return http.Response(
            '{"emailVerificationRequired":true,"message":"Verify email"}',
            201,
          );
        }),
      );

      final result = await AuthRepository(client).signupTechnician(
        const TechnicianSignupRequest(
          email: 'marc@example.com',
          password: 'password123',
          firstName: 'Marc',
          lastName: 'Anderson',
          phone: '+1 5145550188',
          address: '55 Park Avenue',
          city: 'Montreal',
          state: 'QC',
          zipCode: 'H2X 1Y4',
          acceptTerms: true,
          termsVersion: '2026-08-17',
          serviceArea: 'Montreal',
          skills: ['Repair'],
        ),
      );

      expect(result.isSuccess, isTrue);
      expect(result.data!.emailVerificationRequired, isTrue);
    },
  );
}

class _TestSessionStore implements SessionStore {
  _TestSessionStore({this.accessToken});

  @override
  String? accessToken;
  @override
  String? refreshToken;
  @override
  String? userId;
  @override
  String? userRole;

  @override
  Future<void> clear() async {
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
    this.userId = userId;
    this.userRole = userRole;
  }

  @override
  Future<void> updateIdentity({String? userId, String? userRole}) async {
    this.userId = userId ?? this.userId;
    this.userRole = userRole ?? this.userRole;
  }
}
