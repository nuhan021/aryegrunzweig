import 'dart:convert';

import 'package:aryegrunzweig/core/services/api_client.dart';
import 'package:aryegrunzweig/core/services/session_store.dart';
import 'package:aryegrunzweig/features/chat/individual_chat/data/chat_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('messages parses Swagger response and marks own sender', () async {
    final repository = _repository((request) async {
      expect(request.method, 'GET');
      expect(request.url.path, '/api/conversations/conversation-1/messages');
      return http.Response(jsonEncode([_message]), 200);
    });

    final result = await repository.messages(
      'conversation-1',
      currentUserId: 'user-1',
    );
    expect(result.isSuccess, isTrue);
    expect(result.data!.single.isOwn, isTrue);
    expect(result.data!.single.attachments.single, contains('photo.jpg'));
  });

  test(
    'text message uses multipart endpoint and parses created message',
    () async {
      final repository = _repository((request) async {
        expect(request.method, 'POST');
        expect(request.url.path, '/api/conversations/conversation-1/messages');
        expect(
          request.headers['content-type'],
          contains('multipart/form-data'),
        );
        expect(request.body, contains('Hello from the app'));
        return http.Response(
          jsonEncode({..._message, 'body': 'Hello from the app'}),
          201,
        );
      });

      final result = await repository.send(
        conversationId: 'conversation-1',
        currentUserId: 'user-1',
        body: 'Hello from the app',
      );
      expect(result.isSuccess, isTrue);
      expect(result.data!.content, 'Hello from the app');
    },
  );

  test('mark read uses the exact Swagger endpoint', () async {
    final repository = _repository((request) async {
      expect(request.method, 'PATCH');
      expect(request.url.path, '/api/conversations/conversation-1/read');
      return http.Response(jsonEncode({'success': true}), 200);
    });

    expect((await repository.markRead('conversation-1')).data, isTrue);
  });
}

ChatRepository _repository(
  Future<http.Response> Function(http.Request) handler,
) => ChatRepository(
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

const _message = {
  'id': 'message-1',
  'conversationId': 'conversation-1',
  'senderId': 'user-1',
  'body': 'Photo attached',
  'attachments': [
    {'url': 'https://uploads.example.com/chat/photo.jpg'},
  ],
  'readAt': null,
  'createdAt': '2026-08-30T10:00:00.000Z',
  'sender': {
    'id': 'user-1',
    'firstName': 'Alex',
    'lastName': 'Morgan',
    'avatarUrl': null,
  },
};
