import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Secure, in-memory-cached session storage.
///
/// Call [init] once before `runApp`. The synchronous getters are safe after
/// initialization and keep request header creation inexpensive.
class StorageService {
  StorageService._();

  static const String _accessTokenKey = 'session_access_token';
  static const String _refreshTokenKey = 'session_refresh_token';
  static const String _userIdKey = 'session_user_id';
  static const String _userRoleKey = 'session_user_role';

  static const String _legacyTokenKey = 'token';
  static const String _legacyUserIdKey = 'userId';

  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  static String? _accessToken;
  static String? _refreshToken;
  static String? _userId;
  static String? _userRole;
  static bool _initialized = false;

  static String? get accessToken => _accessToken;
  static String? get refreshToken => _refreshToken;
  static String? get userId => _userId;
  static String? get userRole => _userRole;
  static String? get token => _accessToken;
  static bool get isInitialized => _initialized;

  static bool hasToken() =>
      (_accessToken?.isNotEmpty ?? false) ||
      (_refreshToken?.isNotEmpty ?? false);

  static Future<void> init() async {
    _accessToken = await _secureStorage.read(key: _accessTokenKey);
    _refreshToken = await _secureStorage.read(key: _refreshTokenKey);
    _userId = await _secureStorage.read(key: _userIdKey);
    _userRole = await _secureStorage.read(key: _userRoleKey);
    await _migrateLegacySession();
    _initialized = true;
  }

  static Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    String? userId,
    String? userRole,
  }) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    _userId = userId ?? _userId;
    _userRole = userRole?.toUpperCase() ?? _userRole;

    await Future.wait([
      _secureStorage.write(key: _accessTokenKey, value: _accessToken),
      _secureStorage.write(key: _refreshTokenKey, value: _refreshToken),
      _writeOrDelete(_userIdKey, _userId),
      _writeOrDelete(_userRoleKey, _userRole),
    ]);
  }

  static Future<void> updateIdentity({String? userId, String? userRole}) async {
    _userId = userId ?? _userId;
    _userRole = userRole?.toUpperCase() ?? _userRole;
    await Future.wait([
      _writeOrDelete(_userIdKey, _userId),
      _writeOrDelete(_userRoleKey, _userRole),
    ]);
  }

  /// Backward-compatible helper for older callers that only have one token.
  static Future<void> saveToken(String token, String id) async {
    await saveSession(
      accessToken: token,
      refreshToken: _refreshToken ?? '',
      userId: id,
    );
  }

  static Future<void> logoutUser() async {
    _accessToken = null;
    _refreshToken = null;
    _userId = null;
    _userRole = null;
    await Future.wait([
      _secureStorage.delete(key: _accessTokenKey),
      _secureStorage.delete(key: _refreshTokenKey),
      _secureStorage.delete(key: _userIdKey),
      _secureStorage.delete(key: _userRoleKey),
    ]);
  }

  static Future<void> _migrateLegacySession() async {
    if (_accessToken != null) return;

    final preferences = await SharedPreferences.getInstance();
    final legacyToken = preferences.getString(_legacyTokenKey);
    if (legacyToken == null || legacyToken.isEmpty) return;

    _accessToken = legacyToken;
    _userId ??= preferences.getString(_legacyUserIdKey);
    await Future.wait([
      _secureStorage.write(key: _accessTokenKey, value: _accessToken),
      _writeOrDelete(_userIdKey, _userId),
      preferences.remove(_legacyTokenKey),
      preferences.remove(_legacyUserIdKey),
    ]);
  }

  static Future<void> _writeOrDelete(String key, String? value) {
    if (value == null || value.isEmpty) {
      return _secureStorage.delete(key: key);
    }
    return _secureStorage.write(key: key, value: value);
  }
}
