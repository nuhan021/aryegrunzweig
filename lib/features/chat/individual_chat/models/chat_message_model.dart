class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.timestamp,
    required this.isOwn,
    required this.isRead,
    required this.attachments,
  });

  factory ChatMessage.fromJson(
    Map<String, dynamic> json, {
    required String? currentUserId,
  }) {
    final sender = _requiredMap(json, 'sender');
    final senderId = _requiredString(json, 'senderId');
    return ChatMessage(
      id: _requiredString(json, 'id'),
      conversationId: _requiredString(json, 'conversationId'),
      senderId: senderId,
      senderName:
          '${_requiredString(sender, 'firstName')} ${_requiredString(sender, 'lastName')}'
              .trim(),
      content: _requiredString(json, 'body', allowEmpty: true),
      timestamp: _requiredDate(json, 'createdAt').toLocal(),
      isOwn: currentUserId != null && senderId == currentUserId,
      isRead: json['readAt'] != null,
      attachments: _attachments(json['attachments']),
    );
  }

  final String id;
  final String conversationId;
  final String senderId;
  final String senderName;
  final String content;
  final DateTime timestamp;
  final bool isOwn;
  final bool isRead;
  final List<String> attachments;

  MessageType get type => attachments.isEmpty
      ? MessageType.text
      : _isImageUrl(attachments.first)
      ? MessageType.image
      : MessageType.file;
  String? get imagePath => type == MessageType.image ? attachments.first : null;

  String getFormattedTime() {
    final minute = timestamp.minute.toString().padLeft(2, '0');
    final period = timestamp.hour >= 12 ? 'PM' : 'AM';
    final displayHour = timestamp.hour > 12
        ? timestamp.hour - 12
        : (timestamp.hour == 0 ? 12 : timestamp.hour);
    return '${displayHour.toString().padLeft(2, '0')}:$minute $period';
  }
}

enum MessageType { text, image, file }

List<String> _attachments(Object? value) {
  if (value == null) return const [];
  if (value is! List) throw const FormatException('attachments must be a list');
  return value
      .map((item) {
        if (item is! Map) {
          throw const FormatException('attachment must be an object');
        }
        return _requiredString(Map<String, dynamic>.from(item), 'url');
      })
      .toList(growable: false);
}

bool _isImageUrl(String value) => RegExp(
  r'\.(png|jpe?g|gif|webp|heic)(\?|$)',
  caseSensitive: false,
).hasMatch(value);

Map<String, dynamic> _requiredMap(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! Map) throw FormatException('$key must be an object');
  return Map<String, dynamic>.from(value);
}

String _requiredString(
  Map<String, dynamic> json,
  String key, {
  bool allowEmpty = false,
}) {
  final value = json[key];
  if (value is! String || (!allowEmpty && value.isEmpty)) {
    throw FormatException('$key must be a string');
  }
  return value;
}

DateTime _requiredDate(Map<String, dynamic> json, String key) {
  final value = DateTime.tryParse(_requiredString(json, key));
  if (value == null) throw FormatException('$key must be a date-time');
  return value;
}
