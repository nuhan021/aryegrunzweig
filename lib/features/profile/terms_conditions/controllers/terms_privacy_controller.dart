import 'package:get/get.dart';
import '../models/legal_models.dart';

class TermsPrivacyController extends GetxController {
  var selectedTab = 0.obs; // 0 = Terms, 1 = Privacy
  var termsContent = <TermsSection>[].obs;
  var privacyContent = <PrivacySection>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadTermsContent();
    _loadPrivacyContent();
  }

  void selectTab(int tabIndex) {
    selectedTab.value = tabIndex;
  }

  void _loadTermsContent() {
    termsContent.addAll([
      TermsSection(
        number: 1,
        title: 'Acceptance of Terms',
        content:
            'By accessing and using CentralVac Pro, you accept and agree to be bound by the terms and provision of this agreement. If you do not agree to abide by the above, please do not use this service.',
      ),
      TermsSection(
        number: 2,
        title: 'Service Description',
        content:
            'CentralVac Pro is a platform connecting users with professional home service providers. We facilitate bookings but do not directly provide the services. All services are performed by independent contractors.',
      ),
      TermsSection(
        number: 3,
        title: 'User Responsibilities',
        content: 'As a user, you agree to:',
        bulletPoints: [
          'Provide accurate booking information',
          'Be present at the scheduled time',
          'Treat service providers with respect',
          'Pay for services as agreed',
        ],
      ),
      TermsSection(
        number: 4,
        title: 'Cancellation Policy',
        content:
            'Cancellations made more than 2 hours before the scheduled appointment are free. Cancellations made within 2 hours may incur a cancellation fee of up to 50% of the service cost.',
      ),
      TermsSection(
        number: 5,
        title: 'Payment Terms',
        content:
            'Payment is processed securely through our platform. All prices are in USD and include applicable taxes unless otherwise stated. We accept major credit cards and digital payment methods.',
      ),
      TermsSection(
        number: 6,
        title: 'Limitation of Liability',
        content:
            'CentralVac Pro acts as a platform only. We are not liable for any damages or losses resulting from services provided by third-party contractors. All service providers carry their own insurance.',
      ),
    ]);
  }

  void _loadPrivacyContent() {
    privacyContent.addAll([
      PrivacySection(
        number: 1,
        title: 'Information We Collect',
        content:
            'We collect information that you provide directly to us, including:',
        bulletPoints: [
          'Name, email address, and phone number',
          'Service addresses and location data',
          'Payment information (securely processed)',
          'Service preferences and history',
        ],
      ),
      PrivacySection(
        number: 2,
        title: 'How We Use Your Information',
        content: 'Your information is used to:',
        bulletPoints: [
          'Facilitate service bookings and communications',
          'Process payments and send receipts',
          'Improve our services and user experience',
          'Send important updates and notifications',
        ],
      ),
      PrivacySection(
        number: 3,
        title: 'Data Sharing',
        content:
            'We share your information only with service providers you book, payment processors, and as required by law. We never sell your personal information to third parties.',
      ),
      PrivacySection(
        number: 4,
        title: 'Data Security',
        content:
            'We use industry-standard encryption and security measures to protect your data. Payment information is processed through PCI-compliant payment processors and is never stored on our servers.',
      ),
      PrivacySection(
        number: 5,
        title: 'Your Rights',
        content: 'You have the right to:',
        bulletPoints: [
          'Access your personal data',
          'Correct inaccurate information',
          'Request deletion of your data',
          'Opt-out of marketing communications',
        ],
      ),
      PrivacySection(
        number: 6,
        title: 'Contact Us',
        content:
            'For privacy-related questions or to exercise your rights, contact us at privacy@centralvacpro.com or call +1 (800) 123-4567.',
      ),
    ]);
  }
}
