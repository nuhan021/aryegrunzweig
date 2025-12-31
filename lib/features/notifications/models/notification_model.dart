enum NotificationType { booking, offer, reminder }

class Notification {
  final String id;
  final String title;
  final String description;
  final NotificationType type;
  final String timestamp;
  bool isRead;

  Notification({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.timestamp,
    this.isRead = false,
  });

  // Get icon based on type
  String get iconType {
    switch (type) {
      case NotificationType.booking:
        return 'check';
      case NotificationType.offer:
        return 'gift';
      case NotificationType.reminder:
        return 'bell';
    }
  }

  // Get background color based on type
  String get backgroundColor {
    switch (type) {
      case NotificationType.booking:
        return '0xFFE4F1FF';
      case NotificationType.offer:
        return '0xFFFFF4E6';
      case NotificationType.reminder:
        return '0xFFE8F5FF';
    }
  }

  // Get icon background color
  String get iconBackgroundColor {
    switch (type) {
      case NotificationType.booking:
        return '0x1428C76F';
      case NotificationType.offer:
        return '0x147367F0';
      case NotificationType.reminder:
        return '0x1400CFE8';
    }
  }
}
