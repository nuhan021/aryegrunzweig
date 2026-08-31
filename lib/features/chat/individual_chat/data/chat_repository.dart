import '../../../../core/models/operation_result.dart';
import '../../../../core/models/response_data.dart';
import '../../../../core/services/api_client.dart';
import '../../../../core/utils/constants/api_constants.dart';
import '../models/chat_message_model.dart';

class ChatRepository {
  const ChatRepository(this._client);
  final ApiClient _client;

  Future<OperationResult<List<ChatMessage>>> messages(
    String conversationId, {
    required String? currentUserId,
  }) async {
    final response = await _client.get(
      '${ApiConstants.conversations}/$conversationId/messages',
    );
    if (!response.isSuccess) return _failure(response);
    try {
      return OperationResult.success(
        (response.responseData as List)
            .map(
              (item) => ChatMessage.fromJson(
                Map<String, dynamic>.from(item as Map),
                currentUserId: currentUserId,
              ),
            )
            .toList(growable: false),
        statusCode: response.statusCode,
      );
    } on Object catch (error) {
      return _invalid(response, error);
    }
  }

  Future<OperationResult<ChatMessage>> send({
    required String conversationId,
    required String? currentUserId,
    String body = '',
    String? imagePath,
  }) async {
    final response = await _client.multipart(
      'POST',
      '${ApiConstants.conversations}/$conversationId/messages',
      fields: {if (body.trim().isNotEmpty) 'body': body.trim()},
      files: [
        if (imagePath != null) ApiUploadFile(field: 'images', path: imagePath),
      ],
    );
    if (!response.isSuccess) return _failure(response);
    try {
      return OperationResult.success(
        ChatMessage.fromJson(
          Map<String, dynamic>.from(response.responseData as Map),
          currentUserId: currentUserId,
        ),
        statusCode: response.statusCode,
      );
    } on Object catch (error) {
      return _invalid(response, error);
    }
  }

  Future<OperationResult<bool>> markRead(String conversationId) async {
    final response = await _client.patch(
      '${ApiConstants.conversations}/$conversationId/read',
    );
    if (!response.isSuccess) return _failure(response);
    try {
      final json = Map<String, dynamic>.from(response.responseData as Map);
      if (json['success'] is! bool) {
        throw const FormatException('success must be a boolean');
      }
      return OperationResult.success(
        json['success'] as bool,
        statusCode: response.statusCode,
      );
    } on Object catch (error) {
      return _invalid(response, error);
    }
  }

  OperationResult<T> _invalid<T>(ResponseData response, Object error) =>
      OperationResult.failure(
        statusCode: response.statusCode,
        errorMessage: 'Invalid server response: $error',
      );

  OperationResult<T> _failure<T>(ResponseData response) =>
      OperationResult.failure(
        statusCode: response.statusCode,
        errorMessage: response.errorMessage,
      );
}
