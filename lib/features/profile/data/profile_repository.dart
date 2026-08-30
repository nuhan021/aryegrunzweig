import '../../../core/models/operation_result.dart';
import '../../../core/models/response_data.dart';
import '../../../core/services/api_client.dart';
import '../../../core/utils/constants/api_constants.dart';
import '../../auth/models/auth_models.dart';
import 'profile_models.dart';

class ProfileRepository {
  const ProfileRepository(this._client);

  final ApiClient _client;

  Future<OperationResult<UserProfileResponse>> getProfile() async => _parseMap(
    await _client.get(ApiConstants.profile),
    UserProfileResponse.fromJson,
  );

  Future<OperationResult<UserAccountResponse>> updateProfile(
    ProfileUpdateRequest request,
  ) async {
    final avatarPath = request.avatarPath;
    final response = avatarPath == null
        ? await _client.patch(ApiConstants.profile, body: request.toJson())
        : await _client.multipart(
            'PATCH',
            ApiConstants.profile,
            fields: request.toFields(),
            files: [ApiUploadFile(field: 'avatar', path: avatarPath)],
          );
    return _parseMap(response, UserAccountResponse.fromJson);
  }

  Future<OperationResult<UserAccountResponse>> updatePreferences(
    NotificationPreferencesRequest request,
  ) async => _parseMap(
    await _client.patch(
      ApiConstants.notificationPreferences,
      body: request.toJson(),
    ),
    UserAccountResponse.fromJson,
  );

  Future<OperationResult<UserWithTechnicianResponse>> updateTechnician(
    TechnicianProfileUpdateRequest request,
  ) async => _parseMap(
    await _client.patch(ApiConstants.technicianProfile, body: request.toJson()),
    UserWithTechnicianResponse.fromJson,
  );

  Future<OperationResult<List<AddressResponse>>> getAddresses() async =>
      _parseList(
        await _client.get(ApiConstants.addresses),
        AddressResponse.fromJson,
      );

  Future<OperationResult<AddressResponse>> addAddress(
    AddressRequest request,
  ) async => _parseMap(
    await _client.post(ApiConstants.addresses, body: request.toJson()),
    AddressResponse.fromJson,
  );

  Future<OperationResult<AddressResponse>> updateAddress(
    String id,
    AddressRequest request,
  ) async => _parseMap(
    await _client.patch(
      '${ApiConstants.addresses}/$id',
      body: request.toJson(),
    ),
    AddressResponse.fromJson,
  );

  Future<OperationResult<SuccessResponse>> deleteAddress(String id) async =>
      _parseMap(
        await _client.delete('${ApiConstants.addresses}/$id'),
        SuccessResponse.fromJson,
      );

  Future<OperationResult<List<PaymentResponse>>> getPayments() async =>
      _parseList(
        await _client.get(ApiConstants.paymentHistory),
        PaymentResponse.fromJson,
      );

  Future<OperationResult<StripePaymentResponse>> getPayment(String id) async =>
      _parseMap(
        await _client.get('${ApiConstants.payments}/$id'),
        StripePaymentResponse.fromJson,
      );

  Future<OperationResult<InvoiceResponse>> getInvoice(String id) async =>
      _parseMap(
        await _client.get('${ApiConstants.payments}/$id/invoice'),
        InvoiceResponse.fromJson,
      );

  Future<OperationResult<SuccessResponse>> submitContact(
    ContactRequest request,
  ) async => _parseMap(
    await _client.post(
      ApiConstants.contact,
      body: request.toJson(),
      authenticated: false,
    ),
    SuccessResponse.fromJson,
  );

  Future<OperationResult<PublicSettingsResponse>> getPublicSettings() async =>
      _parseMap(
        await _client.get(ApiConstants.publicSettings, authenticated: false),
        PublicSettingsResponse.fromJson,
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
    } on FormatException {
      return OperationResult.failure(
        statusCode: response.statusCode,
        errorMessage: 'The server returned an invalid response.',
      );
    }
  }

  OperationResult<List<T>> _parseList<T>(
    ResponseData response,
    T Function(Map<String, dynamic>) parser,
  ) {
    if (!response.isSuccess) return _failure(response);
    final body = response.responseData;
    if (body is! List || body.any((item) => item is! Map)) {
      return OperationResult.failure(
        statusCode: response.statusCode,
        errorMessage: 'The server returned an invalid response.',
      );
    }
    try {
      return OperationResult.success(
        body
            .cast<Map>()
            .map((item) => parser(Map<String, dynamic>.from(item)))
            .toList(growable: false),
        statusCode: response.statusCode,
      );
    } on FormatException {
      return OperationResult.failure(
        statusCode: response.statusCode,
        errorMessage: 'The server returned an invalid response.',
      );
    }
  }

  OperationResult<T> _failure<T>(ResponseData response) =>
      OperationResult.failure(
        statusCode: response.statusCode,
        errorMessage: response.errorMessage,
      );
}
