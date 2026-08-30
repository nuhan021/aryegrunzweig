import '../../../core/models/operation_result.dart';
import '../../../core/models/response_data.dart';
import '../../../core/services/api_client.dart';
import '../../../core/utils/constants/api_constants.dart';
import 'service_request_models.dart';

class ServiceRequestRepository {
  const ServiceRequestRepository(this._client);
  final ApiClient _client;

  Future<OperationResult<List<ServiceCatalogCategory>>> getCatalog() async =>
      _parseList(
        await _client.get(ApiConstants.serviceRequestCatalog),
        ServiceCatalogCategory.fromJson,
      );

  Future<OperationResult<CustomerServiceRequest>> create(
    CreateServiceRequest request,
  ) async {
    final files = <ApiUploadFile>[
      ...request.imagePaths.map(
        (path) => ApiUploadFile(field: 'images', path: path),
      ),
      ...request.videoPaths.map(
        (path) => ApiUploadFile(field: 'videos', path: path),
      ),
    ];
    return _parseMap(
      await _client.multipart(
        'POST',
        ApiConstants.serviceRequests,
        fields: request.toFields(),
        files: files,
      ),
      CustomerServiceRequest.fromJson,
    );
  }

  Future<OperationResult<ServiceMedia>> addMedia({
    required String requestId,
    required String kind,
    String? filePath,
    String? url,
    String? mimeType,
  }) async => _parseMap(
    await _client.multipart(
      'POST',
      '${ApiConstants.serviceRequests}/$requestId/media',
      fields: {
        'kind': kind,
        if (url != null) 'url': url,
        if (mimeType != null) 'mimeType': mimeType,
      },
      files: filePath == null
          ? const []
          : [ApiUploadFile(field: 'file', path: filePath)],
    ),
    ServiceMedia.fromJson,
  );

  Future<OperationResult<List<CustomerServiceRequest>>> list({
    CustomerRequestStatus? status,
  }) async => _parseList(
    await _client.get(
      ApiConstants.serviceRequests,
      queryParameters: {if (status != null) 'status': status.wireValue},
    ),
    CustomerServiceRequest.fromJson,
  );

  Future<OperationResult<CustomerServiceRequest>> getOne(String id) async =>
      _parseMap(
        await _client.get('${ApiConstants.serviceRequests}/$id'),
        CustomerServiceRequest.fromJson,
      );

  Future<OperationResult<CustomerServiceRequest>> cancel(
    String id,
    String reason,
  ) async => _parseMap(
    await _client.post(
      '${ApiConstants.serviceRequests}/$id/cancel',
      body: {'reason': reason},
    ),
    CustomerServiceRequest.fromJson,
  );

  Future<OperationResult<CustomerQuote>> acceptQuote({
    required String id,
    required String termsVersion,
  }) async => _parseMap(
    await _client.post(
      '${ApiConstants.serviceRequests}/$id/quotation/accept',
      body: {'acceptTerms': true, 'termsVersion': termsVersion},
    ),
    CustomerQuote.fromJson,
  );

  Future<OperationResult<QuoteCounteroffer>> counteroffer({
    required String id,
    required num requestedTotal,
    String? note,
  }) async => _parseMap(
    await _client.post(
      '${ApiConstants.serviceRequests}/$id/quotation/counteroffers',
      body: {
        'requestedTotal': requestedTotal,
        if (note != null && note.isNotEmpty) 'note': note,
      },
    ),
    QuoteCounteroffer.fromJson,
  );

  Future<OperationResult<List<QuoteCounteroffer>>> counteroffers(
    String id,
  ) async => _parseList(
    await _client.get(
      '${ApiConstants.serviceRequests}/$id/quotation/counteroffers',
    ),
    QuoteCounteroffer.fromJson,
  );

  Future<OperationResult<CustomerQuote>> rejectQuote(
    String id, {
    String? reason,
  }) async => _parseMap(
    await _client.post(
      '${ApiConstants.serviceRequests}/$id/quotation/reject',
      body: {if (reason != null && reason.isNotEmpty) 'reason': reason},
    ),
    CustomerQuote.fromJson,
  );

  Future<OperationResult<ServiceAuthorization>> authorizePayment(
    String id,
  ) async => _parseMap(
    await _client.post(
      '${ApiConstants.servicePaymentAuthorization}/$id/authorization',
    ),
    ServiceAuthorization.fromJson,
  );

  Future<OperationResult<ServicePaymentStatus>> paymentStatus(
    String id,
  ) async => _parseMap(
    await _client.get('${ApiConstants.payments}/$id'),
    ServicePaymentStatus.fromJson,
  );

  Future<OperationResult<CustomerServiceReport>> confirmReport(
    String id,
  ) async => _parseMap(
    await _client.post(
      '${ApiConstants.serviceRequests}/$id/report/customer-confirm',
    ),
    CustomerServiceReport.fromJson,
  );

  OperationResult<T> _parseMap<T>(
    ResponseData response,
    T Function(Map<String, dynamic>) parser,
  ) {
    if (!response.isSuccess) return _failure(response);
    if (response.responseData is! Map) {
      return OperationResult.failure(
        statusCode: response.statusCode,
        errorMessage: 'The server returned an invalid response.',
      );
    }
    try {
      return OperationResult.success(
        parser(Map<String, dynamic>.from(response.responseData as Map)),
        statusCode: response.statusCode,
      );
    } on FormatException catch (error) {
      return OperationResult.failure(
        statusCode: response.statusCode,
        errorMessage: 'Invalid server response: ${error.message}',
      );
    }
  }

  OperationResult<List<T>> _parseList<T>(
    ResponseData response,
    T Function(Map<String, dynamic>) parser,
  ) {
    if (!response.isSuccess) return _failure(response);
    if (response.responseData is! List) {
      return OperationResult.failure(
        statusCode: response.statusCode,
        errorMessage: 'The server returned an invalid response.',
      );
    }
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
