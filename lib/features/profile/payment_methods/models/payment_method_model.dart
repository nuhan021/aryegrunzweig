import 'package:flutter/material.dart';

enum CardType { visa, mastercard, amex }

class PaymentMethod {
  final String id;
  final String cardNumber;
  final String cardHolder;
  final String expiryDate;
  final CardType type;
  bool isDefault;

  PaymentMethod({
    required this.id,
    required this.cardNumber,
    required this.cardHolder,
    required this.expiryDate,
    required this.type,
    this.isDefault = false,
  });

  String get maskedCardNumber {
    if (cardNumber.length >= 4) {
      return '•••• •••• •••• ${cardNumber.substring(cardNumber.length - 4)}';
    }
    return cardNumber;
  }

  String get cardTypeString {
    switch (type) {
      case CardType.visa:
        return 'VISA';
      case CardType.mastercard:
        return 'MASTERCARD';
      case CardType.amex:
        return 'AMERICAN EXPRESS';
    }
  }

  Color get gradientStart {
    switch (type) {
      case CardType.visa:
        return const Color(0xFF1A73E8);
      case CardType.mastercard:
        return const Color(0xFFFF9F43);
      case CardType.amex:
        return const Color(0xFF00CFE8);
    }
  }

  Color get gradientEnd {
    switch (type) {
      case CardType.visa:
        return const Color(0xCC1A73E8);
      case CardType.mastercard:
        return const Color(0xCCFF9F43);
      case CardType.amex:
        return const Color(0xCC00CFE8);
    }
  }
}
