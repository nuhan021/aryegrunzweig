import '../../../core/models/operation_result.dart';
import '../../../core/models/response_data.dart';
import '../../../core/services/api_client.dart';
import '../../../core/utils/constants/api_constants.dart';
import '../models/notification_model.dart';

class NotificationsRepository {
  const NotificationsRepository(this._client);
  final ApiClient _client;

  Future<OperationResult<List<Notification>>> list() async {
    final response = await _client.get(ApiConstants.notifications);
    if (!response.isSuccess) return _failure(response);
    try {
      final data = response.responseData as List;
      return OperationResult.success(
        data
            .map(
              (item) =>
                  Notification.fromJson(Map<String, dynamic>.from(item as Map)),
            )
            .toList(growable: false),
        statusCode: response.statusCode,
      );
    } on Object catch (error) {
      return OperationResult.failure(
        statusCode: response.statusCode,
        errorMessage: 'Invalid server response: $error',
      );
    }
  }

  Future<OperationResult<bool>> markAsRead(String id) =>
      _mark('${ApiConstants.notifications}/$id/read');

  Future<OperationResult<bool>> markAllAsRead() =>
      _mark('${ApiConstants.notifications}/read-all');

  Future<OperationResult<bool>> _mark(String path) async {
    final response = await _client.patch(path);
    if (!response.isSuccess) return _failure(response);
    try {
      final data = Map<String, dynamic>.from(response.responseData as Map);
      if (data['success'] is! bool) {
        throw const FormatException('success must be a boolean');
      }
      return OperationResult.success(
        data['success'] as bool,
        statusCode: response.statusCode,
      );
    } on Object catch (error) {
      return OperationResult.failure(
        statusCode: response.statusCode,
        errorMessage: 'Invalid server response: $error',
      );
    }
  }

  OperationResult<T> _failure<T>(ResponseData response) =>
      OperationResult.failure(
        statusCode: response.statusCode,
        errorMessage: response.errorMessage,
      );
}
