import 'dart:convert';

import 'package:aryegrunzweig/core/services/api_client.dart';
import 'package:aryegrunzweig/core/services/session_store.dart';
import 'package:aryegrunzweig/features/profile/data/profile_models.dart';
import 'package:aryegrunzweig/features/profile/data/profile_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('profile update uses ProfileFormDto text fields', () async {
    final repository = _repository((request) async {
      expect(request.method, 'PATCH');
      expect(request.url.path, '/api/users/me');
      expect(jsonDecode(request.body), {
        'firstName': 'Sarah',
        'lastName': 'Thompson',
        'phone': '+1 514 555 0100',
        'company': 'Central Care',
      });
      return http.Response(jsonEncode(_userResponse), 200);
    });

    final result = await repository.updateProfile(
      const ProfileUpdateRequest(
        firstName: 'Sarah',
        lastName: 'Thompson',
        phone: '+1 514 555 0100',
        company: 'Central Care',
      ),
    );

    expect(result.isSuccess, isTrue);
    expect(result.data!.email, 'sarah@example.com');
  });

  test('technician availability uses TechnicianProfileDto endpoint', () async {
    final repository = _repository((request) async {
      expect(request.url.path, '/api/users/me/technician');
      expect(jsonDecode(request.body), {'isAvailable': false});
      return http.Response(
        jsonEncode({
          ..._userResponse,
          'role': 'TECHNICIAN',
          'technician': _technicianResponse,
        }),
        200,
      );
    });

    final result = await repository.updateTechnician(
      const TechnicianProfileUpdateRequest(isAvailable: false),
    );

    expect(result.isSuccess, isTrue);
    expect(result.data!.technician!.verificationStatus.wireValue, 'VERIFIED');
  });

  test('address CRUD uses Swagger paths and AddressDto body', () async {
    var call = 0;
    final repository = _repository((request) async {
      call++;
      if (call == 1) {
        expect(request.method, 'POST');
        expect(request.url.path, '/api/users/me/addresses');
        expect(jsonDecode(request.body)['line1'], '123 Main Street');
        return http.Response(jsonEncode(_addressResponse), 201);
      }
      expect(request.method, 'PATCH');
      expect(request.url.path, '/api/users/me/addresses/address-1');
      return http.Response(jsonEncode(_addressResponse), 200);
    });
    const body = AddressRequest(
      line1: '123 Main Street',
      city: 'Toronto',
      state: 'ON',
      zipCode: 'M5V 2T6',
    );

    expect((await repository.addAddress(body)).isSuccess, isTrue);
    expect(
      (await repository.updateAddress('address-1', body)).isSuccess,
      isTrue,
    );
  });

  test('preferences uses exact endpoint and email/push keys', () async {
    final repository = _repository((request) async {
      expect(request.method, 'PATCH');
      expect(request.url.path, '/api/users/me/preferences');
      expect(jsonDecode(request.body), {'email': false, 'push': true});
      return http.Response(jsonEncode(_userResponse), 200);
    });

    final result = await repository.updatePreferences(
      const NotificationPreferencesRequest(email: false, push: true),
    );

    expect(result.isSuccess, isTrue);
    expect(result.data!.notificationEmail, isTrue);
  });

  test('payment history parses a direct Swagger array response', () async {
    final repository = _repository((request) async {
      expect(request.url.path, '/api/users/me/payments');
      return http.Response(jsonEncode([_paymentResponse]), 200);
    });

    final result = await repository.getPayments();

    expect(result.isSuccess, isTrue);
    expect(result.data!.single.status, PaymentStatus.succeeded);
  });

  test('public contact request does not send bearer authorization', () async {
    final repository = _repository((request) async {
      expect(request.url.path, '/api/contact');
      expect(request.headers['authorization'], isNull);
      expect(jsonDecode(request.body)['message'], 'I need help');
      return http.Response('{"success":true}', 201);
    }, accessToken: 'private-token');

    final result = await repository.submitContact(
      const ContactRequest(
        fullName: 'Sarah Thompson',
        email: 'sarah@example.com',
        message: 'I need help',
      ),
    );

    expect(result.isSuccess, isTrue);
  });
}

ProfileRepository _repository(
  Future<http.Response> Function(http.Request) handler, {
  String? accessToken,
}) => ProfileRepository(
  ApiClient(
    baseUrl: 'https://example.test',
    sessionStore: _TestSessionStore(accessToken: accessToken),
    httpClient: MockClient(handler),
  ),
);

const _addressResponse = {
  'id': 'address-1',
  'userId': 'user-1',
  'line1': '123 Main Street',
  'apartment': null,
  'city': 'Toronto',
  'state': 'ON',
  'zipCode': 'M5V 2T6',
  'country': 'Canada',
  'latitude': null,
  'longitude': null,
  'isPrimary': true,
};

const _userResponse = {
  'id': 'user-1',
  'role': 'CUSTOMER',
  'email': 'sarah@example.com',
  'firstName': 'Sarah',
  'lastName': 'Thompson',
  'phone': null,
  'avatarUrl': null,
  'company': null,
  'isActive': true,
  'termsAcceptedAt': null,
  'termsVersion': null,
  'onboardingCompletedAt': null,
  'notificationEmail': true,
  'notificationPush': false,
  'createdAt': '2026-08-29T10:00:00.000Z',
  'updatedAt': '2026-08-29T10:00:00.000Z',
};

const _paymentResponse = {
  'id': 'payment-1',
  'userId': 'user-1',
  'quotationId': null,
  'orderId': 'order-1',
  'purpose': 'ORDER',
  'provider': 'stripe',
  'providerReference': null,
  'currency': 'cad',
  'stripeCheckoutSessionId': null,
  'stripePaymentIntentId': null,
  'amount': 349,
  'status': 'SUCCEEDED',
  'createdAt': '2026-08-29T10:00:00.000Z',
  'updatedAt': '2026-08-29T10:00:00.000Z',
  'quotation': null,
  'order': {'id': 'order-1', 'orderNumber': 'CC-3084'},
};

const _technicianResponse = {
  'id': 'technician-1',
  'userId': 'user-1',
  'employeeId': null,
  'serviceArea': 'Greater Montreal',
  'skills': ['Repair'],
  'licenseNumber': null,
  'yearsExperience': 6,
  'bio': null,
  'rating': 4.9,
  'isAvailable': false,
  'verificationStatus': 'VERIFIED',
  'verificationNotes': null,
};

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
