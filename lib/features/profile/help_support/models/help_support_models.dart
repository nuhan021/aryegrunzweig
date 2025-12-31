import 'package:flutter/material.dart';

class ContactOption {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color iconBackgroundColor;
  final VoidCallback? onTap;

  ContactOption({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.iconBackgroundColor,
    this.onTap,
  });
}

class FAQ {
  final String id;
  final String question;
  final String answer;

  FAQ({required this.id, required this.question, required this.answer});
}
