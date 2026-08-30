import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../auth/controller/auth_controller.dart';
import '../../data/profile_models.dart';
import '../../data/profile_repository.dart';
import '../models/help_support_models.dart';

class HelpSupportController extends GetxController {
  final ProfileRepository _repository = Get.find<ProfileRepository>();

  final contactOptions = <ContactOption>[].obs;
  final faqs = <FAQ>[].obs;
  final isSubmitting = false.obs;
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final serviceController = TextEditingController();
  final messageController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    final profile = Get.find<AuthController>().currentProfile.value;
    if (profile != null) {
      fullNameController.text = '${profile.firstName} ${profile.lastName}'
          .trim();
      emailController.text = profile.email;
      phoneController.text = profile.phone ?? '';
    }
    _loadPublicSettings();
    _loadFaqs();
  }

  Future<void> _loadPublicSettings() async {
    final result = await _repository.getPublicSettings();
    final settings = result.data;
    contactOptions.assignAll([
      ContactOption(
        id: 'phone',
        title: 'Call Us',
        description: settings?.officePhone ?? 'Phone not available',
        icon: Icons.phone,
        iconBackgroundColor: const Color(0x1428C76F),
        onTap: () => Get.snackbar(
          'Office phone',
          settings?.officePhone ?? 'Phone not available',
        ),
      ),
      ContactOption(
        id: 'email',
        title: 'Email Support',
        description: settings?.supportEmail ?? 'Email not available',
        icon: Icons.mail_outline,
        iconBackgroundColor: const Color(0x14FF9F43),
        onTap: () => Get.snackbar(
          'Support email',
          settings?.supportEmail ?? 'Email not available',
        ),
      ),
    ]);
  }

  Future<void> submitContact() async {
    final name = fullNameController.text.trim();
    final email = emailController.text.trim();
    final message = messageController.text.trim();
    if (name.isEmpty || email.isEmpty || message.isEmpty) {
      Get.snackbar('Error', 'Name, email, and message are required.');
      return;
    }
    if (isSubmitting.value) return;
    isSubmitting.value = true;
    final result = await _repository.submitContact(
      ContactRequest(
        fullName: name,
        email: email,
        phone: _optional(phoneController.text),
        service: _optional(serviceController.text),
        message: message,
      ),
    );
    isSubmitting.value = false;
    if (result.isSuccess && result.data?.success == true) {
      messageController.clear();
      Get.snackbar('Success', 'Your message has been sent.');
    } else {
      Get.snackbar('Error', result.errorMessage);
    }
  }

  String? _optional(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  void _loadFaqs() {
    faqs.assignAll([
      FAQ(
        id: '1',
        question: 'How do I book a service?',
        answer: 'Browse service categories and follow the booking steps.',
      ),
      FAQ(
        id: '2',
        question: 'How do I change an address?',
        answer: 'Open Profile, then Saved Addresses.',
      ),
    ]);
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    serviceController.dispose();
    messageController.dispose();
    super.onClose();
  }
}
