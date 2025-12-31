class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String content;
  final DateTime timestamp;
  final bool isOwn;
  final MessageType type;
  final bool isRead;
  final String? imagePath; // Local file path for images

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.timestamp,
    required this.isOwn,
    this.type = MessageType.text,
    this.isRead = true,
    this.imagePath,
  });

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
