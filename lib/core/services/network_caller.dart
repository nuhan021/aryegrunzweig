import '../models/response_data.dart';
import 'api_client.dart';

/// Backward-compatible facade for older feature code.
///
/// New repositories should depend directly on [ApiClient].
class NetworkCaller {
  NetworkCaller({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<ResponseData> getRequest(String url, {String? token}) {
    return _apiClient.get(url, tokenOverride: token);
  }

  Future<ResponseData> postRequest(
    String url, {
    Map<String, dynamic>? body,
    String? token,
  }) {
    return _apiClient.post(url, body: body, tokenOverride: token);
  }

  Future<ResponseData> patchRequest(
    String url, {
    Map<String, dynamic>? body,
    String? token,
  }) {
    return _apiClient.patch(url, body: body, tokenOverride: token);
  }

  Future<ResponseData> deleteRequest(
    String url, {
    Map<String, dynamic>? body,
    String? token,
  }) {
    return _apiClient.delete(url, body: body, tokenOverride: token);
  }

  Future<ResponseData> multipartRequest(
    String method,
    String url, {
    Map<String, String> fields = const {},
    List<ApiUploadFile> files = const [],
  }) {
    return _apiClient.multipart(method, url, fields: fields, files: files);
  }

  void close() => _apiClient.close();
}
