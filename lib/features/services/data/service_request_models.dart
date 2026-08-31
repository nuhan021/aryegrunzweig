enum CustomerRequestStatus {
  newRequest('NEW'),
  underReview('UNDER_REVIEW'),
  quoteSent('QUOTE_SENT'),
  accepted('ACCEPTED'),
  scheduled('SCHEDULED'),
  inProgress('IN_PROGRESS'),
  reportSubmitted('REPORT_SUBMITTED'),
  completed('COMPLETED'),
  cancelled('CANCELLED');

  const CustomerRequestStatus(this.wireValue);
  final String wireValue;

  static CustomerRequestStatus fromJson(Object? value) => values.firstWhere(
    (status) => status.wireValue == value,
    orElse: () => throw FormatException('Unknown request status: $value'),
  );
}

enum CustomerRequestGroup { active, scheduled, completed, cancelled }

extension CustomerRequestStatusUi on CustomerRequestStatus {
  CustomerRequestGroup get group => switch (this) {
    CustomerRequestStatus.scheduled => CustomerRequestGroup.scheduled,
    CustomerRequestStatus.completed => CustomerRequestGroup.completed,
    CustomerRequestStatus.cancelled => CustomerRequestGroup.cancelled,
    _ => CustomerRequestGroup.active,
  };

  String get label => switch (this) {
    CustomerRequestStatus.newRequest => 'NEW',
    CustomerRequestStatus.underReview => 'UNDER REVIEW',
    CustomerRequestStatus.quoteSent => 'QUOTE READY',
    CustomerRequestStatus.accepted => 'PAYMENT PENDING',
    CustomerRequestStatus.scheduled => 'SCHEDULED',
    CustomerRequestStatus.inProgress => 'IN PROGRESS',
    CustomerRequestStatus.reportSubmitted => 'REPORT SUBMITTED',
    CustomerRequestStatus.completed => 'COMPLETED',
    CustomerRequestStatus.cancelled => 'CANCELLED',
  };
}

enum CustomerQuoteStatus {
  draft('DRAFT'),
  sent('SENT'),
  viewed('VIEWED'),
  accepted('ACCEPTED'),
  rejected('REJECTED'),
  expired('EXPIRED'),
  cancelled('CANCELLED');

  const CustomerQuoteStatus(this.wireValue);
  final String wireValue;
  static CustomerQuoteStatus fromJson(Object? value) => values.firstWhere(
    (status) => status.wireValue == value,
    orElse: () => throw FormatException('Unknown quote status: $value'),
  );
}

class ServiceCatalogIssue {
  const ServiceCatalogIssue({required this.id, required this.name});
  factory ServiceCatalogIssue.fromJson(Map<String, dynamic> json) =>
      ServiceCatalogIssue(
        id: _requiredString(json, 'id'),
        name: _requiredString(json, 'name'),
      );
  final String id;
  final String name;
}

class ServiceCatalogCategory {
  const ServiceCatalogCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.issues,
  });
  factory ServiceCatalogCategory.fromJson(Map<String, dynamic> json) {
    final issues = _requiredList(json, 'issues');
    return ServiceCatalogCategory(
      id: _requiredString(json, 'id'),
      name: _requiredString(json, 'name'),
      description: _nullableString(json, 'description'),
      issues: issues
          .map((item) => ServiceCatalogIssue.fromJson(_map(item, 'issue')))
          .toList(growable: false),
    );
  }
  final String id;
  final String name;
  final String? description;
  final List<ServiceCatalogIssue> issues;
}

class CreateServiceRequest {
  const CreateServiceRequest({
    required this.categoryId,
    required this.addressId,
    required this.description,
    this.issueId,
    this.preferredDate,
    this.preferredTime,
    this.imagePaths = const [],
    this.videoPaths = const [],
  });
  final String categoryId;
  final String? issueId;
  final String addressId;
  final String description;
  final DateTime? preferredDate;
  final String? preferredTime;
  final List<String> imagePaths;
  final List<String> videoPaths;

  Map<String, String> toFields() => {
    'categoryId': categoryId,
    if (issueId != null) 'issueId': issueId!,
    'addressId': addressId,
    'description': description,
    if (preferredDate != null)
      'preferredDate': preferredDate!.toUtc().toIso8601String(),
    if (preferredTime != null && preferredTime!.isNotEmpty)
      'preferredTime': preferredTime!,
  };
}

class ServiceMedia {
  const ServiceMedia({
    required this.id,
    required this.kind,
    required this.url,
    required this.mimeType,
  });
  factory ServiceMedia.fromJson(Map<String, dynamic> json) => ServiceMedia(
    id: _requiredString(json, 'id'),
    kind: _requiredString(json, 'kind'),
    url: _requiredString(json, 'url'),
    mimeType: _nullableString(json, 'mimeType'),
  );
  final String id;
  final String kind;
  final String url;
  final String? mimeType;
}

class ServiceStatusHistory {
  const ServiceStatusHistory({
    required this.status,
    required this.note,
    required this.createdAt,
  });
  factory ServiceStatusHistory.fromJson(Map<String, dynamic> json) =>
      ServiceStatusHistory(
        status: CustomerRequestStatus.fromJson(json['status']),
        note: _nullableString(json, 'note'),
        createdAt: _requiredDateTime(json, 'createdAt'),
      );
  final CustomerRequestStatus status;
  final String? note;
  final DateTime createdAt;
}

class QuotePayment {
  const QuotePayment({
    required this.id,
    required this.purpose,
    required this.status,
    required this.amount,
    required this.currency,
    required this.stripeCheckoutSessionId,
    required this.stripePaymentIntentId,
  });
  factory QuotePayment.fromJson(Map<String, dynamic> json) => QuotePayment(
    id: _requiredString(json, 'id'),
    purpose: _requiredString(json, 'purpose'),
    status: _requiredString(json, 'status'),
    amount: _requiredNum(json, 'amount'),
    currency: _requiredString(json, 'currency'),
    stripeCheckoutSessionId: _nullableString(json, 'stripeCheckoutSessionId'),
    stripePaymentIntentId: _nullableString(json, 'stripePaymentIntentId'),
  );
  final String id;
  final String purpose;
  final String status;
  final num amount;
  final String currency;
  final String? stripeCheckoutSessionId;
  final String? stripePaymentIntentId;
}

class QuoteCounterofferStatusHistory {
  const QuoteCounterofferStatusHistory({
    required this.status,
    required this.actorId,
    required this.note,
    required this.createdAt,
  });

  factory QuoteCounterofferStatusHistory.fromJson(Map<String, dynamic> json) =>
      QuoteCounterofferStatusHistory(
        status: _requiredString(json, 'status'),
        actorId: _nullableString(json, 'actorId'),
        note: _nullableString(json, 'note'),
        createdAt: _requiredDateTime(json, 'createdAt'),
      );

  final String status;
  final String? actorId;
  final String? note;
  final DateTime createdAt;
}

class QuoteCounteroffer {
  const QuoteCounteroffer({
    required this.id,
    required this.quotationId,
    required this.customerId,
    required this.requestedTotal,
    required this.note,
    required this.status,
    required this.decisionNote,
    required this.decidedById,
    required this.decidedAt,
    required this.supersededAt,
    required this.createdAt,
    required this.statusHistory,
  });
  factory QuoteCounteroffer.fromJson(Map<String, dynamic> json) =>
      QuoteCounteroffer(
        id: _requiredString(json, 'id'),
        quotationId: _requiredString(json, 'quotationId'),
        customerId: _requiredString(json, 'customerId'),
        requestedTotal: _requiredNum(json, 'requestedTotal'),
        note: _nullableString(json, 'note'),
        status: _requiredString(json, 'status'),
        decisionNote: _nullableString(json, 'decisionNote'),
        decidedById: _nullableString(json, 'decidedById'),
        decidedAt: _nullableDateTime(json, 'decidedAt'),
        supersededAt: _nullableDateTime(json, 'supersededAt'),
        createdAt: _requiredDateTime(json, 'createdAt'),
        statusHistory: _requiredList(json, 'statusHistory')
            .map(
              (item) => QuoteCounterofferStatusHistory.fromJson(
                _map(item, 'counteroffer status history'),
              ),
            )
            .toList(growable: false),
      );
  final String id;
  final String quotationId;
  final String customerId;
  final num requestedTotal;
  final String? note;
  final String status;
  final String? decisionNote;
  final String? decidedById;
  final DateTime? decidedAt;
  final DateTime? supersededAt;
  final DateTime createdAt;
  final List<QuoteCounterofferStatusHistory> statusHistory;
}

class ServiceEquipmentInlet {
  const ServiceEquipmentInlet({
    required this.id,
    required this.floor,
    required this.type,
    required this.quantity,
  });
  factory ServiceEquipmentInlet.fromJson(Map<String, dynamic> json) =>
      ServiceEquipmentInlet(
        id: _requiredString(json, 'id'),
        floor: _requiredString(json, 'floor'),
        type: _requiredString(json, 'type'),
        quantity: _requiredNum(json, 'quantity'),
      );
  final String id;
  final String floor;
  final String type;
  final num quantity;
}

class ServiceEquipmentMedia {
  const ServiceEquipmentMedia({
    required this.id,
    required this.url,
    required this.mimeType,
    required this.caption,
  });
  factory ServiceEquipmentMedia.fromJson(Map<String, dynamic> json) =>
      ServiceEquipmentMedia(
        id: _requiredString(json, 'id'),
        url: _requiredString(json, 'url'),
        mimeType: _nullableString(json, 'mimeType'),
        caption: _nullableString(json, 'caption'),
      );
  final String id;
  final String url;
  final String? mimeType;
  final String? caption;
}

class ServiceEquipment {
  const ServiceEquipment({
    required this.id,
    required this.customerId,
    required this.requestId,
    required this.unitNumber,
    required this.manufacturer,
    required this.model,
    required this.serialNumber,
    required this.location,
    required this.condition,
    required this.additionalFeatures,
    required this.inlets,
    required this.media,
  });
  factory ServiceEquipment.fromJson(Map<String, dynamic> json) =>
      ServiceEquipment(
        id: _requiredString(json, 'id'),
        customerId: _requiredString(json, 'customerId'),
        requestId: _nullableString(json, 'requestId'),
        unitNumber: _requiredString(json, 'unitNumber'),
        manufacturer: _nullableString(json, 'manufacturer'),
        model: _nullableString(json, 'model'),
        serialNumber: _nullableString(json, 'serialNumber'),
        location: _nullableString(json, 'location'),
        condition: _nullableString(json, 'condition'),
        additionalFeatures: _requiredList(json, 'additionalFeatures')
            .map((item) {
              if (item is! String) {
                throw const FormatException(
                  'additionalFeatures must contain strings',
                );
              }
              return item;
            })
            .toList(growable: false),
        inlets: _requiredList(json, 'inlets')
            .map((item) => ServiceEquipmentInlet.fromJson(_map(item, 'inlet')))
            .toList(growable: false),
        media: _requiredList(json, 'media')
            .map(
              (item) =>
                  ServiceEquipmentMedia.fromJson(_map(item, 'equipment media')),
            )
            .toList(growable: false),
      );
  final String id;
  final String customerId;
  final String? requestId;
  final String unitNumber;
  final String? manufacturer;
  final String? model;
  final String? serialNumber;
  final String? location;
  final String? condition;
  final List<String> additionalFeatures;
  final List<ServiceEquipmentInlet> inlets;
  final List<ServiceEquipmentMedia> media;
}

class CustomerQuote {
  const CustomerQuote({
    required this.id,
    required this.quoteNumber,
    required this.totalAmount,
    required this.negotiatedTotal,
    required this.status,
    required this.validUntil,
    required this.acceptedAt,
    required this.notes,
    required this.counteroffers,
    required this.payments,
  });
  factory CustomerQuote.fromJson(Map<String, dynamic> json) => CustomerQuote(
    id: _requiredString(json, 'id'),
    quoteNumber: _requiredString(json, 'quoteNumber'),
    totalAmount: _requiredNum(json, 'totalAmount'),
    negotiatedTotal: _nullableNum(json, 'negotiatedTotal'),
    status: CustomerQuoteStatus.fromJson(json['status']),
    validUntil: _requiredDateTime(json, 'validUntil'),
    acceptedAt: _nullableDateTime(json, 'acceptedAt'),
    notes: _nullableString(json, 'notes'),
    counteroffers: _optionalList(json, 'counteroffers')
        .map((item) => QuoteCounteroffer.fromJson(_map(item, 'counteroffer')))
        .toList(growable: false),
    payments: _optionalList(json, 'payments')
        .map((item) => QuotePayment.fromJson(_map(item, 'payment')))
        .toList(growable: false),
  );
  final String id;
  final String quoteNumber;
  final num totalAmount;
  final num? negotiatedTotal;
  final CustomerQuoteStatus status;
  final DateTime validUntil;
  final DateTime? acceptedAt;
  final String? notes;
  final List<QuoteCounteroffer> counteroffers;
  final List<QuotePayment> payments;
  num get effectiveTotal => negotiatedTotal ?? totalAmount;
}

class CustomerServiceReport {
  const CustomerServiceReport({
    required this.id,
    required this.repairStatus,
    required this.workPerformed,
    required this.technicianNotes,
    required this.partsUsed,
    required this.followUpRequired,
    required this.followUpNotes,
    required this.arrivalTime,
    required this.departureTime,
    required this.customerConfirmedAt,
    required this.submittedAt,
  });
  factory CustomerServiceReport.fromJson(Map<String, dynamic> json) =>
      CustomerServiceReport(
        id: _requiredString(json, 'id'),
        repairStatus: _requiredString(json, 'repairStatus'),
        workPerformed: _requiredString(json, 'workPerformed'),
        technicianNotes: _nullableString(json, 'technicianNotes'),
        partsUsed: json['partsUsed'],
        followUpRequired: _requiredBool(json, 'followUpRequired'),
        followUpNotes: _nullableString(json, 'followUpNotes'),
        arrivalTime: _nullableDateTime(json, 'arrivalTime'),
        departureTime: _nullableDateTime(json, 'departureTime'),
        customerConfirmedAt: _nullableDateTime(json, 'customerConfirmedAt'),
        submittedAt: _requiredDateTime(json, 'submittedAt'),
      );
  final String id;
  final String repairStatus;
  final String workPerformed;
  final String? technicianNotes;
  final Object? partsUsed;
  final bool followUpRequired;
  final String? followUpNotes;
  final DateTime? arrivalTime;
  final DateTime? departureTime;
  final DateTime? customerConfirmedAt;
  final DateTime submittedAt;
}

class ServiceRequestCustomer {
  const ServiceRequestCustomer({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
  });

  factory ServiceRequestCustomer.fromJson(Map<String, dynamic> json) =>
      ServiceRequestCustomer(
        id: _requiredString(json, 'id'),
        firstName: _requiredString(json, 'firstName'),
        lastName: _requiredString(json, 'lastName'),
        email: _requiredString(json, 'email'),
        phone: _nullableString(json, 'phone'),
      );

  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? phone;
}

class ServiceRequestAddress {
  const ServiceRequestAddress({
    required this.id,
    required this.line1,
    required this.apartment,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    required this.isPrimary,
  });

  factory ServiceRequestAddress.fromJson(Map<String, dynamic> json) =>
      ServiceRequestAddress(
        id: _requiredString(json, 'id'),
        line1: _requiredString(json, 'line1'),
        apartment: _nullableString(json, 'apartment'),
        city: _requiredString(json, 'city'),
        state: _requiredString(json, 'state'),
        zipCode: _requiredString(json, 'zipCode'),
        country: _requiredString(json, 'country'),
        isPrimary: _requiredBool(json, 'isPrimary'),
      );

  final String id;
  final String line1;
  final String? apartment;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final bool isPrimary;
}

class CustomerServiceRequest {
  const CustomerServiceRequest({
    required this.id,
    required this.requestNumber,
    required this.customerId,
    required this.technicianId,
    required this.categoryId,
    required this.issueId,
    required this.addressId,
    required this.description,
    required this.status,
    required this.scheduledStart,
    required this.scheduledEnd,
    required this.cancellationReason,
    required this.customer,
    required this.address,
    required this.media,
    required this.quotation,
    required this.report,
    required this.equipment,
    required this.statusHistory,
  });
  factory CustomerServiceRequest.fromJson(Map<String, dynamic> json) =>
      CustomerServiceRequest(
        id: _requiredString(json, 'id'),
        requestNumber: _requiredString(json, 'requestNumber'),
        customerId: _requiredString(json, 'customerId'),
        technicianId: _nullableString(json, 'technicianId'),
        categoryId: _requiredString(json, 'categoryId'),
        issueId: _nullableString(json, 'issueId'),
        addressId: _requiredString(json, 'addressId'),
        description: _requiredString(json, 'description'),
        status: CustomerRequestStatus.fromJson(json['status']),
        scheduledStart: _nullableDateTime(json, 'scheduledStart'),
        scheduledEnd: _nullableDateTime(json, 'scheduledEnd'),
        cancellationReason: _nullableString(json, 'cancellationReason'),
        customer: json['customer'] == null
            ? null
            : ServiceRequestCustomer.fromJson(
                _map(json['customer'], 'customer'),
              ),
        address: json['address'] == null
            ? null
            : ServiceRequestAddress.fromJson(_map(json['address'], 'address')),
        media: _requiredList(json, 'media')
            .map((item) => ServiceMedia.fromJson(_map(item, 'media')))
            .toList(growable: false),
        quotation: json['quotation'] == null
            ? null
            : CustomerQuote.fromJson(_map(json['quotation'], 'quotation')),
        report: json['report'] == null
            ? null
            : CustomerServiceReport.fromJson(_map(json['report'], 'report')),
        equipment: _requiredList(json, 'equipment')
            .map((item) => ServiceEquipment.fromJson(_map(item, 'equipment')))
            .toList(growable: false),
        statusHistory: _requiredList(json, 'statusHistory')
            .map((item) => ServiceStatusHistory.fromJson(_map(item, 'history')))
            .toList(growable: false),
      );
  final String id;
  final String requestNumber;
  final String customerId;
  final String? technicianId;
  final String categoryId;
  final String? issueId;
  final String addressId;
  final String description;
  final CustomerRequestStatus status;
  final DateTime? scheduledStart;
  final DateTime? scheduledEnd;
  final String? cancellationReason;
  final ServiceRequestCustomer? customer;
  final ServiceRequestAddress? address;
  final List<ServiceMedia> media;
  final CustomerQuote? quotation;
  final CustomerServiceReport? report;
  final List<ServiceEquipment> equipment;
  final List<ServiceStatusHistory> statusHistory;
  DateTime? get createdAt =>
      statusHistory.isEmpty ? null : statusHistory.first.createdAt;
}

class ServiceAuthorization {
  const ServiceAuthorization({
    required this.paymentId,
    required this.requestId,
    required this.checkoutUrl,
    required this.checkoutSessionId,
    required this.amount,
    required this.currency,
  });
  factory ServiceAuthorization.fromJson(Map<String, dynamic> json) =>
      ServiceAuthorization(
        paymentId: _requiredString(json, 'paymentId'),
        requestId: _requiredString(json, 'requestId'),
        checkoutUrl: _nullableString(json, 'checkoutUrl'),
        checkoutSessionId: _nullableString(json, 'checkoutSessionId'),
        amount: _requiredNum(json, 'amount'),
        currency: _requiredString(json, 'currency'),
      );
  final String paymentId;
  final String requestId;
  final String? checkoutUrl;
  final String? checkoutSessionId;
  final num amount;
  final String currency;
}

class ServicePaymentStatus {
  const ServicePaymentStatus({
    required this.id,
    required this.purpose,
    required this.status,
    required this.amount,
    required this.currency,
    required this.stripeCheckoutSessionId,
    required this.stripePaymentIntentId,
  });
  factory ServicePaymentStatus.fromJson(Map<String, dynamic> json) =>
      ServicePaymentStatus(
        id: _requiredString(json, 'id'),
        purpose: _requiredString(json, 'purpose'),
        status: _requiredString(json, 'status'),
        amount: _requiredNum(json, 'amount'),
        currency: _requiredString(json, 'currency'),
        stripeCheckoutSessionId: _nullableString(
          json,
          'stripeCheckoutSessionId',
        ),
        stripePaymentIntentId: _nullableString(json, 'stripePaymentIntentId'),
      );
  final String id;
  final String purpose;
  final String status;
  final num amount;
  final String currency;
  final String? stripeCheckoutSessionId;
  final String? stripePaymentIntentId;
}

Map<String, dynamic> _map(Object? value, String label) {
  if (value is! Map) throw FormatException('$label must be an object');
  return Map<String, dynamic>.from(value);
}

List<dynamic> _requiredList(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! List) throw FormatException('$key must be a list');
  return value;
}

List<dynamic> _optionalList(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value == null) return const [];
  if (value is! List) throw FormatException('$key must be a list');
  return value;
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

bool _requiredBool(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! bool) throw FormatException('$key must be a boolean');
  return value;
}

DateTime _requiredDateTime(Map<String, dynamic> json, String key) {
  final value = _requiredString(json, key);
  final parsed = DateTime.tryParse(value);
  if (parsed == null) throw FormatException('$key must be a date-time');
  return parsed;
}

DateTime? _nullableDateTime(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value == null) return null;
  if (value is! String) {
    throw FormatException('$key must be a date-time or null');
  }
  final parsed = DateTime.tryParse(value);
  if (parsed == null) throw FormatException('$key must be a date-time or null');
  return parsed;
}
