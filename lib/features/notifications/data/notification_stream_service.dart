import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/services/storage_service.dart';
import '../../../core/utils/constants/api_constants.dart';

typedef HttpClientFactory = http.Client Function();
typedef AccessTokenProvider = String? Function();

class NotificationStreamService {
  const NotificationStreamService({
    HttpClientFactory? clientFactory,
    AccessTokenProvider? tokenProvider,
    this.baseUrl = ApiConstants.baseUrl,
  }) : _clientFactory = clientFactory ?? _defaultClient,
       _tokenProvider = tokenProvider ?? _defaultToken;

  final HttpClientFactory _clientFactory;
  final AccessTokenProvider _tokenProvider;
  final String baseUrl;

  Stream<Map<String, dynamic>> connect() async* {
    var retryDelay = const Duration(seconds: 1);
    String? lastEventId;
    while (true) {
      final token = _tokenProvider();
      if (token == null || token.isEmpty) return;
      final client = _clientFactory();
      try {
        final request =
            http.Request(
                'GET',
                Uri.parse('$baseUrl${ApiConstants.notificationStream}'),
              )
              ..headers['Accept'] = 'text/event-stream'
              ..headers['Cache-Control'] = 'no-cache'
              ..headers['Authorization'] = token.startsWith('Bearer ')
                  ? token
                  : 'Bearer $token';
        if (lastEventId != null) {
          request.headers['Last-Event-ID'] = lastEventId;
        }
        final response = await client.send(request);
        if (response.statusCode != 200) {
          throw http.ClientException(
            'Notification stream returned ${response.statusCode}',
          );
        }
        retryDelay = const Duration(seconds: 1);
        final dataLines = <String>[];
        await for (final line
            in response.stream
                .transform(utf8.decoder)
                .transform(const LineSplitter())) {
          if (line.startsWith('id:')) {
            lastEventId = line.substring(3).trim();
          } else if (line.startsWith('data:')) {
            dataLines.add(line.substring(5).trimLeft());
          } else if (line.isEmpty && dataLines.isNotEmpty) {
            final decoded = jsonDecode(dataLines.join('\n'));
            dataLines.clear();
            if (decoded is Map) {
              yield Map<String, dynamic>.from(decoded);
            }
          }
        }
        if (dataLines.isNotEmpty) {
          final decoded = jsonDecode(dataLines.join('\n'));
          if (decoded is Map) yield Map<String, dynamic>.from(decoded);
        }
      } on Object {
        // The stream reconnects below with capped exponential backoff.
      } finally {
        client.close();
      }
      await Future<void>.delayed(retryDelay);
      final nextSeconds = (retryDelay.inSeconds * 2).clamp(1, 30);
      retryDelay = Duration(seconds: nextSeconds);
    }
  }

  static http.Client _defaultClient() => http.Client();
  static String? _defaultToken() => StorageService.accessToken;
}
