class TechnicianHomeStats {
  const TechnicianHomeStats({
    required this.firstName,
    required this.jobsToday,
    required this.inProgress,
    required this.completedThisMonth,
    required this.weeklyTasks,
    required this.completedThisWeek,
    required this.totalCompleted,
    required this.upcoming,
    required this.averageRating,
    required this.date,
    required this.timezone,
  });
  factory TechnicianHomeStats.fromJson(Map<String, dynamic> json) =>
      TechnicianHomeStats(
        firstName: _string(json, 'firstName'),
        jobsToday: _int(json, 'jobsToday'),
        inProgress: _int(json, 'inProgress'),
        completedThisMonth: _int(json, 'completedThisMonth'),
        weeklyTasks: _int(json, 'weeklyTasks'),
        completedThisWeek: _int(json, 'completedThisWeek'),
        totalCompleted: _int(json, 'totalCompleted'),
        upcoming: _int(json, 'upcoming'),
        averageRating: _num(json, 'averageRating'),
        date: _string(json, 'date'),
        timezone: _string(json, 'timezone'),
      );
  final String firstName;
  final int jobsToday;
  final int inProgress;
  final int completedThisMonth;
  final int weeklyTasks;
  final int completedThisWeek;
  final int totalCompleted;
  final int upcoming;
  final num averageRating;
  final String date;
  final String timezone;
}

class TechnicianNote {
  const TechnicianNote({
    required this.id,
    required this.requestId,
    required this.text,
    required this.createdAt,
    required this.updatedAt,
  });
  factory TechnicianNote.fromJson(Map<String, dynamic> json) => TechnicianNote(
    id: _string(json, 'id'),
    requestId: _string(json, 'requestId'),
    text: _string(json, 'text'),
    createdAt: _date(json, 'createdAt'),
    updatedAt: _date(json, 'updatedAt'),
  );
  final String id;
  final String requestId;
  final String text;
  final DateTime createdAt;
  final DateTime updatedAt;
}

class TechnicianPartUsed {
  const TechnicianPartUsed({
    required this.name,
    required this.quantity,
    this.unitPrice,
  });
  final String name;
  final int quantity;
  final num? unitPrice;
  Map<String, dynamic> toJson() => {
    'name': name,
    'quantity': quantity,
    if (unitPrice != null) 'unitPrice': unitPrice,
  };
}

class TechnicianReportPayload {
  const TechnicianReportPayload({
    required this.repairStatus,
    required this.workPerformed,
    this.technicianNotes,
    this.partsUsed = const [],
    this.followUpRequired = false,
    this.followUpNotes,
    this.arrivalTime,
    this.departureTime,
  });
  final String repairStatus;
  final String workPerformed;
  final String? technicianNotes;
  final List<TechnicianPartUsed> partsUsed;
  final bool followUpRequired;
  final String? followUpNotes;
  final DateTime? arrivalTime;
  final DateTime? departureTime;

  Map<String, dynamic> toJson() => {
    'repairStatus': repairStatus,
    'workPerformed': workPerformed,
    if (technicianNotes?.trim().isNotEmpty ?? false)
      'technicianNotes': technicianNotes!.trim(),
    'partsUsed': partsUsed.map((item) => item.toJson()).toList(growable: false),
    'followUpRequired': followUpRequired,
    if (followUpNotes?.trim().isNotEmpty ?? false)
      'followUpNotes': followUpNotes!.trim(),
    if (arrivalTime != null)
      'arrivalTime': arrivalTime!.toUtc().toIso8601String(),
    if (departureTime != null)
      'departureTime': departureTime!.toUtc().toIso8601String(),
  };
}

class TechnicianReport {
  const TechnicianReport({
    required this.id,
    required this.requestId,
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
  factory TechnicianReport.fromJson(Map<String, dynamic> json) =>
      TechnicianReport(
        id: _string(json, 'id'),
        requestId: _string(json, 'requestId'),
        repairStatus: _string(json, 'repairStatus'),
        workPerformed: _string(json, 'workPerformed'),
        technicianNotes: _nullableString(json, 'technicianNotes'),
        partsUsed: json['partsUsed'],
        followUpRequired: _bool(json, 'followUpRequired'),
        followUpNotes: _nullableString(json, 'followUpNotes'),
        arrivalTime: _nullableDate(json, 'arrivalTime'),
        departureTime: _nullableDate(json, 'departureTime'),
        customerConfirmedAt: _nullableDate(json, 'customerConfirmedAt'),
        submittedAt: _date(json, 'submittedAt'),
      );
  final String id;
  final String requestId;
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

class TechnicianInletPayload {
  const TechnicianInletPayload({
    required this.floor,
    required this.type,
    required this.quantity,
  });
  final String floor;
  final String type;
  final int quantity;
  Map<String, dynamic> toJson() => {
    'floor': floor,
    'type': type,
    'quantity': quantity,
  };
}

class TechnicianEquipmentPayload {
  const TechnicianEquipmentPayload({
    required this.unitNumber,
    this.manufacturer,
    this.model,
    this.serialNumber,
    this.location,
    this.condition,
    this.additionalFeatures = const [],
    this.inlets = const [],
  });
  final String unitNumber;
  final String? manufacturer;
  final String? model;
  final String? serialNumber;
  final String? location;
  final String? condition;
  final List<String> additionalFeatures;
  final List<TechnicianInletPayload> inlets;
  Map<String, dynamic> toJson() => {
    'unitNumber': unitNumber,
    if (manufacturer?.isNotEmpty ?? false) 'manufacturer': manufacturer,
    if (model?.isNotEmpty ?? false) 'model': model,
    if (serialNumber?.isNotEmpty ?? false) 'serialNumber': serialNumber,
    if (location?.isNotEmpty ?? false) 'location': location,
    if (condition?.isNotEmpty ?? false) 'condition': condition,
    'additionalFeatures': additionalFeatures,
    'inlets': inlets.map((item) => item.toJson()).toList(growable: false),
  };
}

String _string(Map<String, dynamic> json, String key) {
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

num _num(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! num) throw FormatException('$key must be a number');
  return value;
}

int _int(Map<String, dynamic> json, String key) => _num(json, key).toInt();

bool _bool(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! bool) throw FormatException('$key must be a boolean');
  return value;
}

DateTime _date(Map<String, dynamic> json, String key) {
  final parsed = DateTime.tryParse(_string(json, key));
  if (parsed == null) throw FormatException('$key must be a date-time');
  return parsed;
}

DateTime? _nullableDate(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value == null) return null;
  if (value is! String) throw FormatException('$key must be a date-time');
  final parsed = DateTime.tryParse(value);
  if (parsed == null) throw FormatException('$key must be a date-time');
  return parsed;
}
