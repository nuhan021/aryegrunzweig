enum UserRole {
  customer('CUSTOMER'),
  technician('TECHNICIAN'),
  admin('ADMIN');

  const UserRole(this.wireValue);
  final String wireValue;

  factory UserRole.fromJson(String value) {
    return UserRole.values.firstWhere(
      (role) => role.wireValue == value.toUpperCase(),
      orElse: () => throw FormatException('Unsupported user role: $value'),
    );
  }
}

enum TechnicianVerificationStatus {
  pendingVerification('PENDING_VERIFICATION'),
  verified('VERIFIED'),
  rejected('REJECTED');

  const TechnicianVerificationStatus(this.wireValue);
  final String wireValue;

  factory TechnicianVerificationStatus.fromJson(String value) {
    return TechnicianVerificationStatus.values.firstWhere(
      (status) => status.wireValue == value.toUpperCase(),
      orElse: () => throw FormatException(
        'Unsupported technician verification status: $value',
      ),
    );
  }
}

class AuthenticatedUser {
  const AuthenticatedUser({
    required this.id,
    required this.email,
    required this.role,
  });

  factory AuthenticatedUser.fromJson(Map<String, dynamic> json) {
    return AuthenticatedUser(
      id: _requiredString(json, 'id'),
      email: _requiredString(json, 'email'),
      role: UserRole.fromJson(_requiredString(json, 'role')),
    );
  }

  final String id;
  final String email;
  final UserRole role;
}

class AuthSessionResponse {
  const AuthSessionResponse({
    required this.accessToken,
    required this.user,
    required this.refreshToken,
  });

  factory AuthSessionResponse.fromJson(Map<String, dynamic> json) {
    return AuthSessionResponse(
      accessToken: _requiredString(json, 'accessToken'),
      user: AuthenticatedUser.fromJson(_requiredMap(json, 'user')),
      refreshToken: _requiredString(json, 'refreshToken'),
    );
  }

  final String accessToken;
  final AuthenticatedUser user;
  final String refreshToken;
}

class VerifyEmailResponse {
  const VerifyEmailResponse({
    required this.success,
    required this.accessToken,
    required this.user,
    required this.refreshToken,
  });

  factory VerifyEmailResponse.fromJson(Map<String, dynamic> json) {
    return VerifyEmailResponse(
      success: _requiredBool(json, 'success'),
      accessToken: _requiredString(json, 'accessToken'),
      user: AuthenticatedUser.fromJson(_requiredMap(json, 'user')),
      refreshToken: _requiredString(json, 'refreshToken'),
    );
  }

  AuthSessionResponse get session => AuthSessionResponse(
    accessToken: accessToken,
    user: user,
    refreshToken: refreshToken,
  );

  final bool success;
  final String accessToken;
  final AuthenticatedUser user;
  final String refreshToken;
}

class SignupResponse {
  const SignupResponse({
    required this.emailVerificationRequired,
    required this.message,
  });

  factory SignupResponse.fromJson(Map<String, dynamic> json) {
    return SignupResponse(
      emailVerificationRequired: _requiredBool(
        json,
        'emailVerificationRequired',
      ),
      message: _requiredString(json, 'message'),
    );
  }

  final bool emailVerificationRequired;
  final String message;
}

class MessageResponse {
  const MessageResponse({required this.message});

  factory MessageResponse.fromJson(Map<String, dynamic> json) {
    return MessageResponse(message: _requiredString(json, 'message'));
  }

  final String message;
}

class SuccessResponse {
  const SuccessResponse({required this.success});

  factory SuccessResponse.fromJson(Map<String, dynamic> json) {
    return SuccessResponse(success: _requiredBool(json, 'success'));
  }

  final bool success;
}

class CustomerSignupRequest {
  const CustomerSignupRequest({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.address,
    this.apartment,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.acceptTerms,
    required this.termsVersion,
  });

  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String phone;
  final String address;
  final String? apartment;
  final String city;
  final String state;
  final String zipCode;
  final bool acceptTerms;
  final String termsVersion;

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    'firstName': firstName,
    'lastName': lastName,
    'phone': phone,
    'address': address,
    if (apartment != null && apartment!.isNotEmpty) 'apartment': apartment,
    'city': city,
    'state': state,
    'zipCode': zipCode,
    'acceptTerms': acceptTerms,
    'termsVersion': termsVersion,
  };
}

class TechnicianSignupRequest extends CustomerSignupRequest {
  const TechnicianSignupRequest({
    required super.email,
    required super.password,
    required super.firstName,
    required super.lastName,
    required super.phone,
    required super.address,
    super.apartment,
    required super.city,
    required super.state,
    required super.zipCode,
    required super.acceptTerms,
    required super.termsVersion,
    required this.serviceArea,
    required this.skills,
    this.employeeId,
    this.licenseNumber,
    this.yearsExperience,
    this.bio,
  });

  final String serviceArea;
  final List<String> skills;
  final String? employeeId;
  final String? licenseNumber;
  final num? yearsExperience;
  final String? bio;

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'serviceArea': serviceArea,
    'skills': skills,
    if (employeeId != null && employeeId!.isNotEmpty) 'employeeId': employeeId,
    if (licenseNumber != null && licenseNumber!.isNotEmpty)
      'licenseNumber': licenseNumber,
    if (yearsExperience != null) 'yearsExperience': yearsExperience,
    if (bio != null && bio!.isNotEmpty) 'bio': bio,
  };
}

class AddressResponse {
  const AddressResponse({
    required this.id,
    required this.userId,
    required this.line1,
    required this.apartment,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.isPrimary,
  });

  factory AddressResponse.fromJson(Map<String, dynamic> json) {
    return AddressResponse(
      id: _requiredString(json, 'id'),
      userId: _requiredString(json, 'userId'),
      line1: _requiredString(json, 'line1'),
      apartment: _nullableString(json, 'apartment'),
      city: _requiredString(json, 'city'),
      state: _requiredString(json, 'state'),
      zipCode: _requiredString(json, 'zipCode'),
      country: _requiredString(json, 'country'),
      latitude: _nullableNum(json, 'latitude'),
      longitude: _nullableNum(json, 'longitude'),
      isPrimary: _requiredBool(json, 'isPrimary'),
    );
  }

  final String id;
  final String userId;
  final String line1;
  final String? apartment;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final num? latitude;
  final num? longitude;
  final bool isPrimary;
}

class TechnicianProfileResponse {
  const TechnicianProfileResponse({
    required this.id,
    required this.userId,
    required this.employeeId,
    required this.serviceArea,
    required this.skills,
    required this.licenseNumber,
    required this.yearsExperience,
    required this.bio,
    required this.rating,
    required this.isAvailable,
    required this.verificationStatus,
    required this.verificationNotes,
  });

  factory TechnicianProfileResponse.fromJson(Map<String, dynamic> json) {
    final skills = json['skills'];
    if (skills is! List) throw const FormatException('skills must be a list');
    if (skills.any((skill) => skill is! String)) {
      throw const FormatException('skills must contain only strings');
    }
    return TechnicianProfileResponse(
      id: _requiredString(json, 'id'),
      userId: _requiredString(json, 'userId'),
      employeeId: _nullableString(json, 'employeeId'),
      serviceArea: _requiredString(json, 'serviceArea'),
      skills: skills.cast<String>().toList(growable: false),
      licenseNumber: _nullableString(json, 'licenseNumber'),
      yearsExperience: _nullableNum(json, 'yearsExperience'),
      bio: _nullableString(json, 'bio'),
      rating: _requiredNum(json, 'rating'),
      isAvailable: _requiredBool(json, 'isAvailable'),
      verificationStatus: TechnicianVerificationStatus.fromJson(
        _requiredString(json, 'verificationStatus'),
      ),
      verificationNotes: _nullableString(json, 'verificationNotes'),
    );
  }

  final String id;
  final String userId;
  final String? employeeId;
  final String serviceArea;
  final List<String> skills;
  final String? licenseNumber;
  final num? yearsExperience;
  final String? bio;
  final num rating;
  final bool isAvailable;
  final TechnicianVerificationStatus verificationStatus;
  final String? verificationNotes;
}

class UserProfileResponse {
  const UserProfileResponse({
    required this.id,
    required this.role,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.avatarUrl,
    required this.company,
    required this.isActive,
    required this.termsAcceptedAt,
    required this.termsVersion,
    required this.onboardingCompletedAt,
    required this.notificationEmail,
    required this.notificationPush,
    required this.createdAt,
    required this.updatedAt,
    required this.addresses,
    required this.technician,
  });

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    final addresses = json['addresses'];
    if (addresses is! List) {
      throw const FormatException('addresses must be a list');
    }
    if (addresses.any((address) => address is! Map)) {
      throw const FormatException('addresses must contain only objects');
    }
    final technicianJson = json['technician'];
    if (technicianJson != null && technicianJson is! Map) {
      throw const FormatException('technician must be an object or null');
    }
    return UserProfileResponse(
      id: _requiredString(json, 'id'),
      role: UserRole.fromJson(_requiredString(json, 'role')),
      email: _requiredString(json, 'email'),
      firstName: _requiredString(json, 'firstName'),
      lastName: _requiredString(json, 'lastName'),
      phone: _nullableString(json, 'phone'),
      avatarUrl: _nullableString(json, 'avatarUrl'),
      company: _nullableString(json, 'company'),
      isActive: _requiredBool(json, 'isActive'),
      termsAcceptedAt: _nullableDateTime(json, 'termsAcceptedAt'),
      termsVersion: _nullableString(json, 'termsVersion'),
      onboardingCompletedAt: _nullableDateTime(json, 'onboardingCompletedAt'),
      notificationEmail: _requiredBool(json, 'notificationEmail'),
      notificationPush: _requiredBool(json, 'notificationPush'),
      createdAt: _requiredDateTime(json, 'createdAt'),
      updatedAt: _requiredDateTime(json, 'updatedAt'),
      addresses: addresses
          .cast<Map>()
          .map(
            (address) =>
                AddressResponse.fromJson(Map<String, dynamic>.from(address)),
          )
          .toList(growable: false),
      technician: technicianJson == null
          ? null
          : TechnicianProfileResponse.fromJson(
              Map<String, dynamic>.from(technicianJson as Map),
            ),
    );
  }

  final String id;
  final UserRole role;
  final String email;
  final String firstName;
  final String lastName;
  final String? phone;
  final String? avatarUrl;
  final String? company;
  final bool isActive;
  final DateTime? termsAcceptedAt;
  final String? termsVersion;
  final DateTime? onboardingCompletedAt;
  final bool notificationEmail;
  final bool notificationPush;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<AddressResponse> addresses;
  final TechnicianProfileResponse? technician;
}

String _requiredString(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! String || value.isEmpty) {
    throw FormatException('$key must be a non-empty string');
  }
  return value;
}

String? _nullableString(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value == null) return null;
  if (value is! String) throw FormatException('$key must be a string or null');
  return value;
}

bool _requiredBool(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! bool) throw FormatException('$key must be a boolean');
  return value;
}

num _requiredNum(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! num) throw FormatException('$key must be a number');
  return value;
}

num? _nullableNum(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value == null) return null;
  if (value is! num) throw FormatException('$key must be a number or null');
  return value;
}

Map<String, dynamic> _requiredMap(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! Map) throw FormatException('$key must be an object');
  return Map<String, dynamic>.from(value);
}

DateTime _requiredDateTime(Map<String, dynamic> json, String key) {
  final value = _requiredString(json, key);
  final parsed = DateTime.tryParse(value);
  if (parsed == null) throw FormatException('$key must be an ISO date-time');
  return parsed;
}

DateTime? _nullableDateTime(Map<String, dynamic> json, String key) {
  final value = _nullableString(json, key);
  if (value == null) return null;
  final parsed = DateTime.tryParse(value);
  if (parsed == null) throw FormatException('$key must be an ISO date-time');
  return parsed;
}
