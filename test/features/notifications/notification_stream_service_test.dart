import 'package:aryegrunzweig/features/notifications/data/notification_stream_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('SSE stream sends bearer auth and decodes notification data', () async {
    final client = MockClient((request) async {
      expect(request.method, 'GET');
      expect(request.url.path, '/api/notifications/stream');
      expect(request.headers['authorization'], 'Bearer test-token');
      expect(request.headers['accept'], 'text/event-stream');
      return http.Response(
        'id: event-1\n'
        'data: {"id":"notification-1","title":"New message"}\n\n',
        200,
        headers: {'content-type': 'text/event-stream'},
      );
    });
    final service = NotificationStreamService(
      baseUrl: 'https://example.test',
      clientFactory: () => client,
      tokenProvider: () => 'test-token',
    );

    final event = await service.connect().first;
    expect(event['id'], 'notification-1');
    expect(event['title'], 'New message');
  });
}
