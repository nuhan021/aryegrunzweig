import 'storage_service.dart';

abstract interface class SessionStore {
  String? get accessToken;
  String? get refreshToken;
  String? get userId;
  String? get userRole;

  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    String? userId,
    String? userRole,
  });

  Future<void> updateIdentity({String? userId, String? userRole});

  Future<void> clear();
}

class SecureSessionStore implements SessionStore {
  const SecureSessionStore();

  @override
  String? get accessToken => StorageService.accessToken;

  @override
  String? get refreshToken => StorageService.refreshToken;

  @override
  String? get userId => StorageService.userId;

  @override
  String? get userRole => StorageService.userRole;

  @override
  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    String? userId,
    String? userRole,
  }) {
    return StorageService.saveSession(
      accessToken: accessToken,
      refreshToken: refreshToken,
      userId: userId,
      userRole: userRole,
    );
  }

  @override
  Future<void> updateIdentity({String? userId, String? userRole}) {
    return StorageService.updateIdentity(userId: userId, userRole: userRole);
  }

  @override
  Future<void> clear() => StorageService.logoutUser();
}
