import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/response_data.dart';
import '../utils/constants/api_constants.dart';
import 'session_store.dart';

typedef SessionExpiredCallback = FutureOr<void> Function();

class ApiUploadFile {
  const ApiUploadFile({required this.field, required this.path, this.filename});

  final String field;
  final String path;
  final String? filename;
}

class ApiClient {
  ApiClient({
    http.Client? httpClient,
    SessionStore? sessionStore,
    this.baseUrl = ApiConstants.baseUrl,
    this.timeout = const Duration(seconds: 20),
    this.onSessionExpired,
  }) : _httpClient = httpClient ?? http.Client(),
       _sessionStore = sessionStore ?? const SecureSessionStore();

  final http.Client _httpClient;
  final SessionStore _sessionStore;
  final String baseUrl;
  final Duration timeout;
  final SessionExpiredCallback? onSessionExpired;

  Future<bool>? _refreshInFlight;

  Future<ResponseData> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    bool authenticated = true,
    String? tokenOverride,
  }) {
    return request(
      'GET',
      path,
      queryParameters: queryParameters,
      headers: headers,
      authenticated: authenticated,
      tokenOverride: tokenOverride,
    );
  }

  Future<ResponseData> post(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    bool authenticated = true,
    String? tokenOverride,
  }) {
    return request(
      'POST',
      path,
      body: body,
      queryParameters: queryParameters,
      headers: headers,
      authenticated: authenticated,
      tokenOverride: tokenOverride,
    );
  }

  Future<ResponseData> patch(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    bool authenticated = true,
    String? tokenOverride,
  }) {
    return request(
      'PATCH',
      path,
      body: body,
      queryParameters: queryParameters,
      headers: headers,
      authenticated: authenticated,
      tokenOverride: tokenOverride,
    );
  }

  Future<ResponseData> delete(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    bool authenticated = true,
    String? tokenOverride,
  }) {
    return request(
      'DELETE',
      path,
      body: body,
      queryParameters: queryParameters,
      headers: headers,
      authenticated: authenticated,
      tokenOverride: tokenOverride,
    );
  }

  Future<ResponseData> request(
    String method,
    String path, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    bool authenticated = true,
    String? tokenOverride,
    bool allowRefresh = true,
  }) async {
    final uri = _buildUri(path, queryParameters);
    final request = http.Request(method.toUpperCase(), uri);
    request.headers.addAll(
      _buildHeaders(
        authenticated: authenticated,
        tokenOverride: tokenOverride,
        additionalHeaders: headers,
      ),
    );
    if (body != null) request.body = jsonEncode(body);

    final response = await _send(request);
    if (response.statusCode == 401 && authenticated && allowRefresh) {
      if (_canRefresh) {
        final refreshed = await _refreshSession();
        if (refreshed) {
          return this.request(
            method,
            path,
            body: body,
            queryParameters: queryParameters,
            headers: headers,
            authenticated: authenticated,
            allowRefresh: false,
          );
        }
      } else {
        await _expireSession();
      }
    }
    return response;
  }

  Future<ResponseData> multipart(
    String method,
    String path, {
    Map<String, String> fields = const {},
    List<ApiUploadFile> files = const [],
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    bool authenticated = true,
    bool allowRefresh = true,
  }) async {
    final request = http.MultipartRequest(
      method.toUpperCase(),
      _buildUri(path, queryParameters),
    );
    request.headers.addAll(
      _buildHeaders(
        authenticated: authenticated,
        additionalHeaders: headers,
        includeContentType: false,
      ),
    );
    request.fields.addAll(fields);
    for (final file in files) {
      request.files.add(
        await http.MultipartFile.fromPath(
          file.field,
          file.path,
          filename: file.filename,
        ),
      );
    }

    final response = await _send(request);
    if (response.statusCode == 401 && authenticated && allowRefresh) {
      if (_canRefresh) {
        final refreshed = await _refreshSession();
        if (refreshed) {
          return multipart(
            method,
            path,
            fields: fields,
            files: files,
            queryParameters: queryParameters,
            headers: headers,
            authenticated: authenticated,
            allowRefresh: false,
          );
        }
      } else {
        await _expireSession();
      }
    }
    return response;
  }

  void close() => _httpClient.close();

  Uri _buildUri(String path, Map<String, dynamic>? queryParameters) {
    final baseUri = Uri.tryParse(path)?.hasScheme == true
        ? Uri.parse(path)
        : Uri.parse('$baseUrl${path.startsWith('/') ? path : '/$path'}');
    if (queryParameters == null || queryParameters.isEmpty) return baseUri;

    final query = <String, String>{...baseUri.queryParameters};
    for (final entry in queryParameters.entries) {
      final value = entry.value;
      if (value != null) query[entry.key] = value.toString();
    }
    return baseUri.replace(queryParameters: query);
  }

  Map<String, String> _buildHeaders({
    required bool authenticated,
    String? tokenOverride,
    Map<String, String>? additionalHeaders,
    bool includeContentType = true,
  }) {
    final headers = <String, String>{'Accept': 'application/json'};
    if (includeContentType) headers['Content-Type'] = 'application/json';

    if (authenticated) {
      final token = tokenOverride ?? _sessionStore.accessToken;
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = token.startsWith('Bearer ')
            ? token
            : 'Bearer $token';
      }
    }
    if (additionalHeaders != null) headers.addAll(additionalHeaders);
    return headers;
  }

  bool get _canRefresh => _sessionStore.refreshToken?.isNotEmpty ?? false;

  Future<bool> _refreshSession() {
    final runningRefresh = _refreshInFlight;
    if (runningRefresh != null) return runningRefresh;

    final refresh = _performRefresh();
    _refreshInFlight = refresh;
    return refresh.whenComplete(() => _refreshInFlight = null);
  }

  Future<bool> _performRefresh() async {
    final refreshToken = _sessionStore.refreshToken;
    if (refreshToken == null || refreshToken.isEmpty) return false;

    final response = await request(
      'POST',
      ApiConstants.refreshToken,
      body: {'refreshToken': refreshToken},
      authenticated: false,
      allowRefresh: false,
    );
    if (!response.isSuccess || response.responseData is! Map) {
      await _expireSession();
      return false;
    }

    final payload = _unwrapMap(response.responseData as Map);
    final accessToken = payload['accessToken']?.toString();
    final newRefreshToken = payload['refreshToken']?.toString();
    final user = payload['user'] is Map ? payload['user'] as Map : null;
    if (accessToken == null || accessToken.isEmpty) {
      await _expireSession();
      return false;
    }

    await _sessionStore.saveSession(
      accessToken: accessToken,
      refreshToken: newRefreshToken?.isNotEmpty == true
          ? newRefreshToken!
          : refreshToken,
      userId: user?['id']?.toString() ?? _sessionStore.userId,
      userRole: user?['role']?.toString() ?? _sessionStore.userRole,
    );
    return true;
  }

  Future<void> _expireSession() async {
    await _sessionStore.clear();
    await onSessionExpired?.call();
  }

  Future<ResponseData> _send(http.BaseRequest request) async {
    if (kDebugMode) {
      debugPrint('${request.method} ${request.url}');
    }
    try {
      final streamed = await _httpClient.send(request).timeout(timeout);
      final response = await http.Response.fromStream(streamed);
      return _toResponseData(response);
    } on TimeoutException {
      return const ResponseData(
        isSuccess: false,
        statusCode: 408,
        errorMessage: 'Request timed out. Please try again.',
        responseData: null,
      );
    } on http.ClientException {
      return const ResponseData(
        isSuccess: false,
        statusCode: 0,
        errorMessage:
            'Unable to connect. Please check your internet connection.',
        responseData: null,
      );
    } catch (_) {
      return const ResponseData(
        isSuccess: false,
        statusCode: 0,
        errorMessage: 'An unexpected network error occurred.',
        responseData: null,
      );
    }
  }

  ResponseData _toResponseData(http.Response response) {
    final decoded = _decodeBody(response.body);
    final isSuccess = response.statusCode >= 200 && response.statusCode < 300;
    return ResponseData(
      isSuccess: isSuccess,
      statusCode: response.statusCode,
      errorMessage: isSuccess ? '' : _extractErrorMessage(decoded),
      responseData: decoded,
    );
  }

  dynamic _decodeBody(String body) {
    if (body.trim().isEmpty) return null;
    try {
      return jsonDecode(body);
    } on FormatException {
      return body;
    }
  }

  String _extractErrorMessage(dynamic body) {
    if (body is String && body.isNotEmpty) return body;
    if (body is Map) {
      final message = body['message'] ?? body['error'];
      if (message is List) return message.join(', ');
      if (message != null && message.toString().isNotEmpty) {
        return message.toString();
      }
      final sources = body['errorSources'];
      if (sources is List) {
        final messages = sources
            .map((source) => source is Map ? source['message'] : source)
            .where((message) => message != null)
            .join(', ');
        if (messages.isNotEmpty) return messages;
      }
    }
    return 'Request failed. Please try again.';
  }

  Map<dynamic, dynamic> _unwrapMap(Map<dynamic, dynamic> body) {
    final data = body['data'];
    return data is Map ? data : body;
  }
}
