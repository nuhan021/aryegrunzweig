import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../models/help_support_models.dart';

class HelpSupportController extends GetxController {
  var contactOptions = <ContactOption>[].obs;
  var faqs = <FAQ>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadContactOptions();
    _loadFAQs();
  }

  void _loadContactOptions() {
    contactOptions.addAll([
      ContactOption(
        id: '1',
        title: 'Live Chat',
        description: 'Chat with our support team',
        icon: Icons.chat_bubble_outline,
        iconBackgroundColor: const Color(0x141A73E8),
        onTap: () {
          Get.snackbar('Live Chat', 'Opening live chat...');
        },
      ),
      ContactOption(
        id: '2',
        title: 'Call Us',
        description: '+1 (800) 123-4567',
        icon: Icons.phone,
        iconBackgroundColor: const Color(0x1428C76F),
        onTap: () {
          Get.snackbar('Call', 'Opening dialer...');
        },
      ),
      ContactOption(
        id: '3',
        title: 'Email Support',
        description: 'support@centralvacpro.com',
        icon: Icons.mail_outline,
        iconBackgroundColor: const Color(0x14FF9F43),
        onTap: () {
          Get.snackbar('Email', 'Opening email...');
        },
      ),
    ]);
  }

  void _loadFAQs() {
    faqs.addAll([
      FAQ(
        id: '1',
        question: 'How do I book a service?',
        answer:
            'Simply browse our categories, select a service, and follow the booking steps.',
      ),
      FAQ(
        id: '2',
        question: 'Can I cancel or reschedule?',
        answer:
            'Yes, you can cancel or reschedule up to 2 hours before your appointment.',
      ),
      FAQ(
        id: '3',
        question: 'How are technicians verified?',
        answer:
            'All technicians undergo background checks and are fully licensed and insured.',
      ),
      FAQ(
        id: '4',
        question: 'What if I need to change my address?',
        answer:
            'You can update your address in the Profile section under Saved Addresses.',
      ),
    ]);
  }
}
