import '../../../core/models/operation_result.dart';
import '../../../core/models/response_data.dart';
import '../../../core/services/api_client.dart';
import '../../../core/utils/constants/api_constants.dart';
import '../models/auth_models.dart';

class AuthRepository {
  const AuthRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<OperationResult<SignupResponse>> signupCustomer(
    CustomerSignupRequest request,
  ) async {
    final response = await _apiClient.post(
      ApiConstants.customerSignup,
      body: request.toJson(),
      authenticated: false,
    );
    return _parse(response, SignupResponse.fromJson);
  }

  Future<OperationResult<SignupResponse>> signupTechnician(
    TechnicianSignupRequest request,
  ) async {
    final response = await _apiClient.post(
      ApiConstants.technicianSignup,
      body: request.toJson(),
      authenticated: false,
    );
    return _parse(response, SignupResponse.fromJson);
  }

  Future<OperationResult<AuthSessionResponse>> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.login,
      body: {'email': email, 'password': password},
      authenticated: false,
    );
    return _parse(response, AuthSessionResponse.fromJson);
  }

  Future<OperationResult<VerifyEmailResponse>> verifyEmail({
    required String email,
    required String otp,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.verifyEmail,
      body: {'email': email, 'otp': otp},
      authenticated: false,
    );
    return _parse(response, VerifyEmailResponse.fromJson);
  }

  Future<OperationResult<MessageResponse>> resendVerification(
    String email,
  ) async {
    final response = await _apiClient.post(
      ApiConstants.resendVerification,
      body: {'email': email},
      authenticated: false,
    );
    return _parse(response, MessageResponse.fromJson);
  }

  Future<OperationResult<MessageResponse>> forgotPassword(String email) async {
    final response = await _apiClient.post(
      ApiConstants.forgotPassword,
      body: {'email': email},
      authenticated: false,
    );
    return _parse(response, MessageResponse.fromJson);
  }

  Future<OperationResult<SuccessResponse>> resetPassword({
    required String email,
    required String otp,
    required String password,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.resetPassword,
      body: {'email': email, 'otp': otp, 'password': password},
      authenticated: false,
    );
    return _parse(response, SuccessResponse.fromJson);
  }

  Future<OperationResult<UserProfileResponse>> getCurrentUser() async {
    final response = await _apiClient.get(ApiConstants.currentUser);
    return _parse(response, UserProfileResponse.fromJson);
  }

  Future<OperationResult<SuccessResponse>> completeOnboarding() async {
    final response = await _apiClient.post(ApiConstants.completeOnboarding);
    return _parse(response, SuccessResponse.fromJson);
  }

  Future<OperationResult<SuccessResponse>> logout(String refreshToken) async {
    final response = await _apiClient.post(
      ApiConstants.logout,
      body: {'refreshToken': refreshToken},
      authenticated: false,
    );
    return _parse(response, SuccessResponse.fromJson);
  }

  OperationResult<T> _parse<T>(
    ResponseData response,
    T Function(Map<String, dynamic> json) fromJson,
  ) {
    if (!response.isSuccess) {
      return OperationResult.failure(
        statusCode: response.statusCode,
        errorMessage: response.errorMessage,
      );
    }
    if (response.responseData is! Map) {
      return OperationResult.failure(
        statusCode: response.statusCode,
        errorMessage: 'The server returned an invalid response.',
      );
    }
    try {
      return OperationResult.success(
        fromJson(Map<String, dynamic>.from(response.responseData as Map)),
        statusCode: response.statusCode,
      );
    } on FormatException {
      return OperationResult.failure(
        statusCode: response.statusCode,
        errorMessage: 'The server returned an invalid response.',
      );
    }
  }
}
