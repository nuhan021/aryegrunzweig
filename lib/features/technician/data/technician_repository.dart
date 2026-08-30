import '../../../core/models/operation_result.dart';
import '../../../core/models/response_data.dart';
import '../../../core/services/api_client.dart';
import '../../../core/utils/constants/api_constants.dart';
import '../../services/data/service_request_models.dart';
import 'technician_models.dart';

class TechnicianRepository {
  const TechnicianRepository(this._client);
  final ApiClient _client;

  Future<OperationResult<TechnicianHomeStats>> homeStats({
    String timezone = 'America/Toronto',
  }) async => _parseMap(
    await _client.get(
      ApiConstants.technicianHomeStats,
      queryParameters: {'timezone': timezone},
    ),
    TechnicianHomeStats.fromJson,
  );

  Future<OperationResult<List<CustomerServiceRequest>>> jobs({
    CustomerRequestStatus? status,
  }) async => _parseList(
    await _client.get(
      ApiConstants.technicianRequests,
      queryParameters: {if (status != null) 'status': status.wireValue},
    ),
    CustomerServiceRequest.fromJson,
  );

  Future<OperationResult<CustomerServiceRequest>> job(String id) async =>
      _parseMap(
        await _client.get('${ApiConstants.technicianRequests}/$id'),
        CustomerServiceRequest.fromJson,
      );

  Future<OperationResult<CustomerServiceRequest>> startJob(
    String id, {
    String? note,
  }) async => _parseMap(
    await _client.patch(
      '${ApiConstants.technicianRequests}/$id/status',
      body: {
        'status': 'IN_PROGRESS',
        if (note?.trim().isNotEmpty ?? false) 'note': note!.trim(),
      },
    ),
    CustomerServiceRequest.fromJson,
  );

  Future<OperationResult<TechnicianNote?>> note(String id) async {
    final response = await _client.get(
      '${ApiConstants.technicianRequests}/$id/note',
    );
    if (response.statusCode == 404) {
      return OperationResult.success(null, statusCode: response.statusCode);
    }
    return _parseMap(response, TechnicianNote.fromJson);
  }

  Future<OperationResult<TechnicianNote>> createNote(
    String id,
    String text,
  ) async => _parseMap(
    await _client.post(
      '${ApiConstants.technicianRequests}/$id/note',
      body: {'text': text.trim()},
    ),
    TechnicianNote.fromJson,
  );

  Future<OperationResult<TechnicianNote>> updateNote(
    String id,
    String text,
  ) async => _parseMap(
    await _client.patch(
      '${ApiConstants.technicianRequests}/$id/note',
      body: {'text': text.trim()},
    ),
    TechnicianNote.fromJson,
  );

  Future<OperationResult<ServiceMedia>> uploadMedia({
    required String id,
    required String kind,
    required String filePath,
  }) async => _parseMap(
    await _client.multipart(
      'POST',
      '${ApiConstants.technicianRequests}/$id/media',
      fields: {'kind': kind},
      files: [ApiUploadFile(field: 'file', path: filePath)],
    ),
    ServiceMedia.fromJson,
  );

  Future<OperationResult<List<ServiceEquipment>>> equipment(String id) async =>
      _parseList(
        await _client.get('${ApiConstants.technicianRequests}/$id/equipment'),
        ServiceEquipment.fromJson,
      );

  Future<OperationResult<ServiceEquipment>> createEquipment(
    String id,
    TechnicianEquipmentPayload payload,
  ) async => _parseMap(
    await _client.post(
      '${ApiConstants.technicianRequests}/$id/equipment',
      body: payload.toJson(),
    ),
    ServiceEquipment.fromJson,
  );

  Future<OperationResult<ServiceEquipment>> updateEquipment({
    required String id,
    required String equipmentId,
    required TechnicianEquipmentPayload payload,
  }) async => _parseMap(
    await _client.patch(
      '${ApiConstants.technicianRequests}/$id/equipment/$equipmentId',
      body: payload.toJson(),
    ),
    ServiceEquipment.fromJson,
  );

  Future<OperationResult<TechnicianReport?>> report(String id) async {
    final response = await _client.get(
      '${ApiConstants.technicianRequests}/$id/report',
    );
    if (response.statusCode == 404) {
      return OperationResult.success(null, statusCode: response.statusCode);
    }
    return _parseMap(response, TechnicianReport.fromJson);
  }

  Future<OperationResult<TechnicianReport>> createReport(
    String id,
    TechnicianReportPayload payload,
  ) async => _parseMap(
    await _client.post(
      '${ApiConstants.technicianRequests}/$id/report',
      body: payload.toJson(),
    ),
    TechnicianReport.fromJson,
  );

  Future<OperationResult<TechnicianReport>> updateReport(
    String id,
    TechnicianReportPayload payload,
  ) async => _parseMap(
    await _client.patch(
      '${ApiConstants.technicianRequests}/$id/report',
      body: payload.toJson(),
    ),
    TechnicianReport.fromJson,
  );

  OperationResult<T> _parseMap<T>(
    ResponseData response,
    T Function(Map<String, dynamic>) parser,
  ) {
    if (!response.isSuccess) return _failure(response);
    try {
      return OperationResult.success(
        parser(Map<String, dynamic>.from(response.responseData as Map)),
        statusCode: response.statusCode,
      );
    } on Object catch (error) {
      return OperationResult.failure(
        statusCode: response.statusCode,
        errorMessage: 'Invalid server response: $error',
      );
    }
  }

  OperationResult<List<T>> _parseList<T>(
    ResponseData response,
    T Function(Map<String, dynamic>) parser,
  ) {
    if (!response.isSuccess) return _failure(response);
    try {
      return OperationResult.success(
        (response.responseData as List)
            .map((item) => parser(Map<String, dynamic>.from(item as Map)))
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

  OperationResult<T> _failure<T>(ResponseData response) =>
      OperationResult.failure(
        statusCode: response.statusCode,
        errorMessage: response.errorMessage,
      );
}
