import 'package:flutter/material.dart';

class ProfileMenuItem {
  final String label;
  final IconData icon;
  final Color iconBackgroundColor;
  final Color textColor;
  final VoidCallback onTap;

  ProfileMenuItem({
    required this.label,
    required this.icon,
    required this.iconBackgroundColor,
    required this.textColor,
    required this.onTap,
  });
}
