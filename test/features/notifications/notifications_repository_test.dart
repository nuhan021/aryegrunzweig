import 'dart:convert';

import 'package:aryegrunzweig/core/services/api_client.dart';
import 'package:aryegrunzweig/core/services/session_store.dart';
import 'package:aryegrunzweig/features/notifications/data/notifications_repository.dart';
import 'package:aryegrunzweig/features/notifications/models/notification_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('list parses the direct Swagger notification array', () async {
    final repository = _repository((request) async {
      expect(request.method, 'GET');
      expect(request.url.path, '/api/notifications');
      return http.Response(jsonEncode([_notification]), 200);
    });

    final result = await repository.list();
    expect(result.isSuccess, isTrue);
    expect(result.data!.single.title, 'Technician assigned');
    expect(result.data!.single.isRead, isFalse);
    expect(result.data!.single.serviceRequestId, 'request-1');
  });

  test('read one and read all use documented PATCH endpoints', () async {
    var call = 0;
    final repository = _repository((request) async {
      call++;
      expect(request.method, 'PATCH');
      expect(
        request.url.path,
        call == 1
            ? '/api/notifications/notification-1/read'
            : '/api/notifications/read-all',
      );
      return http.Response(jsonEncode({'success': true}), 200);
    });

    expect((await repository.markAsRead('notification-1')).data, isTrue);
    expect((await repository.markAllAsRead()).data, isTrue);
  });

  test('notification data resolves every supported deep-link key', () {
    Notification fromData(Map<String, dynamic> data) =>
        Notification.fromJson({..._notification, 'data': data});

    expect(
      fromData({'requestId': 'legacy-request'}).serviceRequestId,
      'legacy-request',
    );
    expect(
      fromData({'orderId': 'order-1'}).targetType,
      NotificationTargetType.order,
    );
    expect(
      fromData({'conversationId': 'conversation-1'}).targetType,
      NotificationTargetType.conversation,
    );
  });
}

NotificationsRepository _repository(
  Future<http.Response> Function(http.Request) handler,
) => NotificationsRepository(
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
  String? userId = 'user-1';
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

const _notification = {
  'id': 'notification-1',
  'userId': 'user-1',
  'title': 'Technician assigned',
  'body': 'A technician has been assigned to your service request.',
  'data': {'serviceRequestId': 'request-1'},
  'readAt': null,
  'createdAt': '2026-08-30T10:00:00.000Z',
};
