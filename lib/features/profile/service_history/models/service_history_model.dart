import 'package:flutter/material.dart';

class ServiceHistory {
  final String id;
  final String title;
  final String category;
  final ServiceStatus status;
  final double price;
  final DateTime date;
  final IconData categoryIcon;

  ServiceHistory({
    required this.id,
    required this.title,
    required this.category,
    required this.status,
    required this.price,
    required this.date,
    required this.categoryIcon,
  });

  String get formattedDate {
    final month = _getMonthName(date.month);
    return '$month ${date.day}, ${date.year}';
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}

enum ServiceStatus {
  completed,
  cancelled;

  IconData get icon {
    switch (this) {
      case ServiceStatus.completed:
        return Icons.check_circle;
      case ServiceStatus.cancelled:
        return Icons.cancel;
    }
  }

  Color get color {
    switch (this) {
      case ServiceStatus.completed:
        return const Color(0xFF28C76F);
      case ServiceStatus.cancelled:
        return const Color(0xFFFB2C36);
    }
  }
}
