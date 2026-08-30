enum NotificationType { booking, offer, reminder }

enum NotificationTargetType { serviceRequest, order, conversation, none }

class Notification {
  Notification({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.data,
    required this.readAt,
    required this.createdAt,
  });

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
    id: _requiredString(json, 'id'),
    userId: _requiredString(json, 'userId'),
    title: _requiredString(json, 'title'),
    body: _requiredString(json, 'body'),
    data: _nullableMap(json, 'data'),
    readAt: _nullableDate(json, 'readAt'),
    createdAt: _requiredDate(json, 'createdAt'),
  );

  final String id;
  final String userId;
  final String title;
  final String body;
  final Map<String, dynamic>? data;
  DateTime? readAt;
  final DateTime createdAt;

  bool get isRead => readAt != null;
  String get description => body;

  String? get serviceRequestId =>
      _dataString('serviceRequestId') ?? _dataString('requestId');
  String? get orderId => _dataString('orderId');
  String? get conversationId => _dataString('conversationId');

  NotificationTargetType get targetType {
    if (serviceRequestId != null) return NotificationTargetType.serviceRequest;
    if (orderId != null) return NotificationTargetType.order;
    if (conversationId != null) return NotificationTargetType.conversation;
    return NotificationTargetType.none;
  }

  NotificationType get type {
    final content = '$title $body'.toLowerCase();
    if (content.contains('offer') || content.contains('quote')) {
      return NotificationType.offer;
    }
    if (content.contains('reminder') || content.contains('upcoming')) {
      return NotificationType.reminder;
    }
    return NotificationType.booking;
  }

  String get timestamp {
    final difference = DateTime.now().difference(createdAt.toLocal());
    if (difference.isNegative || difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';
    final local = createdAt.toLocal();
    return '${local.month}/${local.day}/${local.year}';
  }

  String? _dataString(String key) {
    final value = data?[key];
    return value is String && value.isNotEmpty ? value : null;
  }
}

String _requiredString(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! String || value.isEmpty) {
    throw FormatException('$key must be a non-empty string');
  }
  return value;
}

Map<String, dynamic>? _nullableMap(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value == null) return null;
  if (value is! Map) throw FormatException('$key must be an object or null');
  return Map<String, dynamic>.from(value);
}

DateTime _requiredDate(Map<String, dynamic> json, String key) {
  final value = DateTime.tryParse(_requiredString(json, key));
  if (value == null) throw FormatException('$key must be a date-time');
  return value;
}

DateTime? _nullableDate(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value == null) return null;
  if (value is! String) throw FormatException('$key must be a date-time');
  final parsed = DateTime.tryParse(value);
  if (parsed == null) throw FormatException('$key must be a date-time');
  return parsed;
}
