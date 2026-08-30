import '../../auth/models/auth_models.dart';

class ProfileUpdateRequest {
  const ProfileUpdateRequest({
    this.firstName,
    this.lastName,
    this.phone,
    this.company,
    this.avatarPath,
  });

  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? company;
  final String? avatarPath;

  Map<String, dynamic> toJson() => {
    if (firstName != null) 'firstName': firstName,
    if (lastName != null) 'lastName': lastName,
    if (phone != null) 'phone': phone,
    if (company != null) 'company': company,
  };

  Map<String, String> toFields() =>
      toJson().map((key, value) => MapEntry(key, value.toString()));
}

class NotificationPreferencesRequest {
  const NotificationPreferencesRequest({this.email, this.push});

  final bool? email;
  final bool? push;

  Map<String, dynamic> toJson() => {
    if (email != null) 'email': email,
    if (push != null) 'push': push,
  };
}

class TechnicianProfileUpdateRequest {
  const TechnicianProfileUpdateRequest({
    this.serviceArea,
    this.skills,
    this.licenseNumber,
    this.yearsExperience,
    this.bio,
    this.isAvailable,
  });

  final String? serviceArea;
  final List<String>? skills;
  final String? licenseNumber;
  final num? yearsExperience;
  final String? bio;
  final bool? isAvailable;

  Map<String, dynamic> toJson() => {
    if (serviceArea != null) 'serviceArea': serviceArea,
    if (skills != null) 'skills': skills,
    if (licenseNumber != null) 'licenseNumber': licenseNumber,
    if (yearsExperience != null) 'yearsExperience': yearsExperience,
    if (bio != null) 'bio': bio,
    if (isAvailable != null) 'isAvailable': isAvailable,
  };
}

class AddressRequest {
  const AddressRequest({
    required this.line1,
    this.apartment,
    required this.city,
    required this.state,
    required this.zipCode,
    this.country,
    this.latitude,
    this.longitude,
    this.isPrimary,
  });

  final String line1;
  final String? apartment;
  final String city;
  final String state;
  final String zipCode;
  final String? country;
  final num? latitude;
  final num? longitude;
  final bool? isPrimary;

  Map<String, dynamic> toJson() => {
    'line1': line1,
    if (apartment != null) 'apartment': apartment,
    'city': city,
    'state': state,
    'zipCode': zipCode,
    if (country != null) 'country': country,
    if (latitude != null) 'latitude': latitude,
    if (longitude != null) 'longitude': longitude,
    if (isPrimary != null) 'isPrimary': isPrimary,
  };
}

class UserAccountResponse {
  const UserAccountResponse({
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
  });

  factory UserAccountResponse.fromJson(Map<String, dynamic> json) =>
      UserAccountResponse(
        id: _string(json, 'id'),
        role: UserRole.fromJson(_string(json, 'role')),
        email: _string(json, 'email'),
        firstName: _string(json, 'firstName'),
        lastName: _string(json, 'lastName'),
        phone: _nullableString(json, 'phone'),
        avatarUrl: _nullableString(json, 'avatarUrl'),
        company: _nullableString(json, 'company'),
        isActive: _bool(json, 'isActive'),
        termsAcceptedAt: _nullableDate(json, 'termsAcceptedAt'),
        termsVersion: _nullableString(json, 'termsVersion'),
        onboardingCompletedAt: _nullableDate(json, 'onboardingCompletedAt'),
        notificationEmail: _bool(json, 'notificationEmail'),
        notificationPush: _bool(json, 'notificationPush'),
        createdAt: _date(json, 'createdAt'),
        updatedAt: _date(json, 'updatedAt'),
      );

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
}

class UserWithTechnicianResponse {
  const UserWithTechnicianResponse({
    required this.account,
    required this.technician,
  });

  factory UserWithTechnicianResponse.fromJson(Map<String, dynamic> json) {
    final technician = json['technician'];
    if (technician != null && technician is! Map) {
      throw const FormatException('technician invalid');
    }
    return UserWithTechnicianResponse(
      account: UserAccountResponse.fromJson(json),
      technician: technician == null
          ? null
          : TechnicianProfileResponse.fromJson(
              Map<String, dynamic>.from(technician),
            ),
    );
  }

  final UserAccountResponse account;
  final TechnicianProfileResponse? technician;
}

enum PaymentPurpose {
  order('ORDER'),
  quotation('QUOTATION');

  const PaymentPurpose(this.wireValue);
  final String wireValue;

  factory PaymentPurpose.fromJson(String value) =>
      PaymentPurpose.values.firstWhere(
        (item) => item.wireValue == value,
        orElse: () =>
            throw FormatException('Unsupported payment purpose: $value'),
      );
}

enum PaymentStatus {
  pending('PENDING'),
  processing('PROCESSING'),
  authorized('AUTHORIZED'),
  captured('CAPTURED'),
  voided('VOIDED'),
  failed('FAILED'),
  succeeded('SUCCEEDED'),
  canceled('CANCELED'),
  expired('EXPIRED'),
  refunded('REFUNDED'),
  partiallyRefunded('PARTIALLY_REFUNDED');

  const PaymentStatus(this.wireValue);
  final String wireValue;

  factory PaymentStatus.fromJson(String value) =>
      PaymentStatus.values.firstWhere(
        (item) => item.wireValue == value,
        orElse: () =>
            throw FormatException('Unsupported payment status: $value'),
      );
}

class PaymentResponse {
  const PaymentResponse({
    required this.id,
    required this.userId,
    required this.quotationId,
    required this.orderId,
    required this.purpose,
    required this.provider,
    required this.providerReference,
    required this.currency,
    required this.stripeCheckoutSessionId,
    required this.stripePaymentIntentId,
    required this.amount,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.quotation,
    required this.order,
  });

  factory PaymentResponse.fromJson(Map<String, dynamic> json) =>
      PaymentResponse(
        id: _string(json, 'id'),
        userId: _string(json, 'userId'),
        quotationId: _nullableString(json, 'quotationId'),
        orderId: _nullableString(json, 'orderId'),
        purpose: PaymentPurpose.fromJson(_string(json, 'purpose')),
        provider: _string(json, 'provider'),
        providerReference: _nullableString(json, 'providerReference'),
        currency: _string(json, 'currency'),
        stripeCheckoutSessionId: _nullableString(
          json,
          'stripeCheckoutSessionId',
        ),
        stripePaymentIntentId: _nullableString(json, 'stripePaymentIntentId'),
        amount: _number(json, 'amount'),
        status: PaymentStatus.fromJson(_string(json, 'status')),
        createdAt: _date(json, 'createdAt'),
        updatedAt: _date(json, 'updatedAt'),
        quotation: _nullableMap(json, 'quotation'),
        order: _nullableMap(json, 'order'),
      );

  final String id;
  final String userId;
  final String? quotationId;
  final String? orderId;
  final PaymentPurpose purpose;
  final String provider;
  final String? providerReference;
  final String currency;
  final String? stripeCheckoutSessionId;
  final String? stripePaymentIntentId;
  final num amount;
  final PaymentStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? quotation;
  final Map<String, dynamic>? order;

  String get reference => purpose == PaymentPurpose.order
      ? (order?['orderNumber']?.toString() ?? orderId ?? id)
      : (quotation?['quoteNumber']?.toString() ?? quotationId ?? id);
}

class StripePaymentResponse {
  const StripePaymentResponse({
    required this.id,
    required this.purpose,
    required this.status,
    required this.amount,
    required this.currency,
    required this.stripeCheckoutSessionId,
    required this.stripePaymentIntentId,
  });

  factory StripePaymentResponse.fromJson(Map<String, dynamic> json) =>
      StripePaymentResponse(
        id: _string(json, 'id'),
        purpose: PaymentPurpose.fromJson(_string(json, 'purpose')),
        status: _string(json, 'status'),
        amount: _number(json, 'amount'),
        currency: _string(json, 'currency'),
        stripeCheckoutSessionId: _nullableString(
          json,
          'stripeCheckoutSessionId',
        ),
        stripePaymentIntentId: _nullableString(json, 'stripePaymentIntentId'),
      );

  final String id;
  final PaymentPurpose purpose;
  final String status;
  final num amount;
  final String currency;
  final String? stripeCheckoutSessionId;
  final String? stripePaymentIntentId;
}

class InvoiceParty {
  const InvoiceParty({
    required this.name,
    required this.addressLines,
    required this.email,
    required this.logoUrl,
  });

  factory InvoiceParty.fromJson(Map<String, dynamic> json) => InvoiceParty(
    name: _string(json, 'name'),
    addressLines: _stringList(json, 'addressLines'),
    email: _nullableString(json, 'email'),
    logoUrl: _nullableString(json, 'logoUrl'),
  );

  final String name;
  final List<String> addressLines;
  final String? email;
  final String? logoUrl;
}

class InvoiceLineItem {
  const InvoiceLineItem({
    required this.name,
    required this.description,
    required this.quantity,
    required this.price,
  });

  factory InvoiceLineItem.fromJson(Map<String, dynamic> json) =>
      InvoiceLineItem(
        name: _string(json, 'name'),
        description: _nullableString(json, 'description'),
        quantity: _string(json, 'quantity'),
        price: _number(json, 'price'),
      );

  final String name;
  final String? description;
  final String quantity;
  final num price;
}

class InvoiceServiceOverview {
  const InvoiceServiceOverview({
    required this.serviceType,
    required this.technician,
    required this.serviceDate,
    required this.duration,
  });

  factory InvoiceServiceOverview.fromJson(Map<String, dynamic> json) =>
      InvoiceServiceOverview(
        serviceType: _string(json, 'serviceType'),
        technician: _string(json, 'technician'),
        serviceDate: _string(json, 'serviceDate'),
        duration: _string(json, 'duration'),
      );

  final String serviceType;
  final String technician;
  final String serviceDate;
  final String duration;
}

class InvoiceResponse {
  const InvoiceResponse({
    required this.paymentId,
    required this.invoiceNumber,
    required this.date,
    required this.statusLabel,
    required this.paymentStatus,
    required this.purpose,
    required this.currency,
    required this.vendor,
    required this.billTo,
    required this.service,
    required this.lineItems,
    required this.notes,
    required this.subtotal,
    required this.serviceCharges,
    required this.tax,
    required this.taxPercent,
    required this.total,
  });

  factory InvoiceResponse.fromJson(Map<String, dynamic> json) =>
      InvoiceResponse(
        paymentId: _string(json, 'paymentId'),
        invoiceNumber: _string(json, 'invoiceNumber'),
        date: _string(json, 'date'),
        statusLabel: _string(json, 'statusLabel'),
        paymentStatus: _string(json, 'paymentStatus'),
        purpose: PaymentPurpose.fromJson(_string(json, 'purpose')),
        currency: _string(json, 'currency'),
        vendor: InvoiceParty.fromJson(_map(json, 'vendor')),
        billTo: InvoiceParty.fromJson(_map(json, 'billTo')),
        service: _nullableMap(json, 'service') == null
            ? null
            : InvoiceServiceOverview.fromJson(_nullableMap(json, 'service')!),
        lineItems: _mapList(
          json,
          'lineItems',
        ).map(InvoiceLineItem.fromJson).toList(growable: false),
        notes: _nullableString(json, 'notes'),
        subtotal: _number(json, 'subtotal'),
        serviceCharges: _number(json, 'serviceCharges'),
        tax: _number(json, 'tax'),
        taxPercent: _number(json, 'taxPercent'),
        total: _number(json, 'total'),
      );

  final String paymentId;
  final String invoiceNumber;
  final String date;
  final String statusLabel;
  final String paymentStatus;
  final PaymentPurpose purpose;
  final String currency;
  final InvoiceParty vendor;
  final InvoiceParty billTo;
  final InvoiceServiceOverview? service;
  final List<InvoiceLineItem> lineItems;
  final String? notes;
  final num subtotal;
  final num serviceCharges;
  final num tax;
  final num taxPercent;
  final num total;
}

class ContactRequest {
  const ContactRequest({
    required this.fullName,
    required this.email,
    this.phone,
    this.service,
    required this.message,
  });

  final String fullName;
  final String email;
  final String? phone;
  final String? service;
  final String message;

  Map<String, dynamic> toJson() => {
    'fullName': fullName,
    'email': email,
    if (phone != null) 'phone': phone,
    if (service != null) 'service': service,
    'message': message,
  };
}

class PublicSettingsResponse {
  const PublicSettingsResponse({
    required this.businessName,
    required this.officePhone,
    required this.supportEmail,
    required this.businessAddress,
    required this.serviceArea,
    required this.logoUrl,
    required this.landingHeroImageUrl,
  });

  factory PublicSettingsResponse.fromJson(Map<String, dynamic> json) =>
      PublicSettingsResponse(
        businessName: _nullableString(json, 'businessName'),
        officePhone: _nullableString(json, 'officePhone'),
        supportEmail: _nullableString(json, 'supportEmail'),
        businessAddress: _nullableString(json, 'businessAddress'),
        serviceArea: _nullableString(json, 'serviceArea'),
        logoUrl: _nullableString(json, 'logoUrl'),
        landingHeroImageUrl: _nullableString(json, 'landingHeroImageUrl'),
      );

  final String? businessName;
  final String? officePhone;
  final String? supportEmail;
  final String? businessAddress;
  final String? serviceArea;
  final String? logoUrl;
  final String? landingHeroImageUrl;
}

String _string(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! String || value.isEmpty) throw FormatException('$key invalid');
  return value;
}

String? _nullableString(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value == null) return null;
  if (value is! String) throw FormatException('$key invalid');
  return value;
}

bool _bool(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! bool) throw FormatException('$key invalid');
  return value;
}

num _number(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! num) throw FormatException('$key invalid');
  return value;
}

DateTime _date(Map<String, dynamic> json, String key) {
  final value = DateTime.tryParse(_string(json, key));
  if (value == null) throw FormatException('$key invalid');
  return value;
}

DateTime? _nullableDate(Map<String, dynamic> json, String key) {
  final value = _nullableString(json, key);
  if (value == null) return null;
  final date = DateTime.tryParse(value);
  if (date == null) throw FormatException('$key invalid');
  return date;
}

Map<String, dynamic> _map(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! Map) throw FormatException('$key invalid');
  return Map<String, dynamic>.from(value);
}

Map<String, dynamic>? _nullableMap(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value == null) return null;
  if (value is! Map) throw FormatException('$key invalid');
  return Map<String, dynamic>.from(value);
}

List<Map<String, dynamic>> _mapList(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! List || value.any((item) => item is! Map)) {
    throw FormatException('$key invalid');
  }
  return value
      .cast<Map>()
      .map((item) => Map<String, dynamic>.from(item))
      .toList(growable: false);
}

List<String> _stringList(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! List || value.any((item) => item is! String)) {
    throw FormatException('$key invalid');
  }
  return value.cast<String>().toList(growable: false);
}
