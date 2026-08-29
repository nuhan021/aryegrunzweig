import '../utils/constants/api_constants.dart';
import 'api_client.dart';
import 'session_store.dart';
import 'storage_service.dart';

enum SessionBootstrapStatus {
  unauthenticated,
  authenticated,
  authenticatedOffline,
}

class SessionBootstrapResult {
  const SessionBootstrapResult({required this.status, this.role});

  final SessionBootstrapStatus status;
  final String? role;

  bool get isAuthenticated =>
      status == SessionBootstrapStatus.authenticated ||
      status == SessionBootstrapStatus.authenticatedOffline;
}

class SessionService {
  SessionService({ApiClient? apiClient, SessionStore? sessionStore})
    : _sessionStore = sessionStore ?? const SecureSessionStore(),
      _apiClient =
          apiClient ??
          ApiClient(sessionStore: sessionStore ?? const SecureSessionStore());

  final ApiClient _apiClient;
  final SessionStore _sessionStore;

  Future<SessionBootstrapResult> bootstrap() async {
    if (!StorageService.isInitialized && _sessionStore is SecureSessionStore) {
      await StorageService.init();
    }

    if (!_hasStoredSession) {
      return const SessionBootstrapResult(
        status: SessionBootstrapStatus.unauthenticated,
      );
    }

    final response = await _apiClient.get(ApiConstants.currentUser);
    if (response.isSuccess && response.responseData is Map) {
      final profile = _unwrapMap(response.responseData as Map);
      final role = profile['role']?.toString().toUpperCase();
      final userId = profile['id']?.toString();
      if (_isMobileRole(role)) {
        await _sessionStore.updateIdentity(userId: userId, userRole: role);
        return SessionBootstrapResult(
          status: SessionBootstrapStatus.authenticated,
          role: role,
        );
      }
      await _sessionStore.clear();
      return const SessionBootstrapResult(
        status: SessionBootstrapStatus.unauthenticated,
      );
    }

    if (response.isNetworkError && _isMobileRole(_sessionStore.userRole)) {
      return SessionBootstrapResult(
        status: SessionBootstrapStatus.authenticatedOffline,
        role: _sessionStore.userRole,
      );
    }

    if (response.statusCode == 401 || response.statusCode == 403) {
      await _sessionStore.clear();
    }
    return const SessionBootstrapResult(
      status: SessionBootstrapStatus.unauthenticated,
    );
  }

  bool get _hasStoredSession =>
      (_sessionStore.accessToken?.isNotEmpty ?? false) ||
      (_sessionStore.refreshToken?.isNotEmpty ?? false);

  bool _isMobileRole(String? role) =>
      role == 'CUSTOMER' || role == 'TECHNICIAN';

  Map<dynamic, dynamic> _unwrapMap(Map<dynamic, dynamic> body) {
    final data = body['data'];
    return data is Map ? data : body;
  }
}
