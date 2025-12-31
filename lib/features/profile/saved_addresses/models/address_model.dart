import 'package:flutter/material.dart';

class Address {
  final String id;
  final String label;
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final AddressType type;
  final Color iconBackgroundColor;

  Address({
    required this.id,
    required this.label,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.type,
    required this.iconBackgroundColor,
  });

  String get fullAddress => '$city, $state $zipCode';

  @override
  String toString() => '$label - $street, $fullAddress';
}

enum AddressType {
  home,
  work,
  other;

  IconData get icon {
    switch (this) {
      case AddressType.home:
        return Icons.home;
      case AddressType.work:
        return Icons.business_center;
      case AddressType.other:
        return Icons.location_on;
    }
  }
}
