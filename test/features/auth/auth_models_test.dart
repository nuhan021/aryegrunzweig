import 'package:aryegrunzweig/features/auth/models/auth_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Swagger auth request models', () {
    test('customer signup serializes only SignupDto fields', () {
      const request = CustomerSignupRequest(
        email: 'sarah@example.com',
        password: 'password123',
        firstName: 'Sarah',
        lastName: 'Thompson',
        phone: '+1 5145550100',
        address: '1842 Maplewood Drive',
        city: 'Westmount',
        state: 'QC',
        zipCode: 'H3Z 2B2',
        acceptTerms: true,
        termsVersion: '2026-08-17',
      );

      expect(request.toJson(), {
        'email': 'sarah@example.com',
        'password': 'password123',
        'firstName': 'Sarah',
        'lastName': 'Thompson',
        'phone': '+1 5145550100',
        'address': '1842 Maplewood Drive',
        'city': 'Westmount',
        'state': 'QC',
        'zipCode': 'H3Z 2B2',
        'acceptTerms': true,
        'termsVersion': '2026-08-17',
      });
    });

    test('technician signup includes TechnicianSignupDto fields', () {
      const request = TechnicianSignupRequest(
        email: 'marc@example.com',
        password: 'password123',
        firstName: 'Marc',
        lastName: 'Anderson',
        phone: '+1 5145550188',
        address: '55 Park Avenue',
        apartment: '2A',
        city: 'Montreal',
        state: 'QC',
        zipCode: 'H2X 1Y4',
        acceptTerms: true,
        termsVersion: '2026-08-17',
        serviceArea: 'Greater Montreal',
        skills: ['Repair', 'Installation'],
        employeeId: 'TECH-1048',
        licenseNumber: 'LIC-100',
        yearsExperience: 6,
        bio: 'Field technician',
      );

      expect(request.toJson(), containsPair('serviceArea', 'Greater Montreal'));
      expect(request.toJson()['skills'], ['Repair', 'Installation']);
      expect(request.toJson()['yearsExperience'], 6);
      expect(request.toJson()['apartment'], '2A');
    });
  });

  group('Swagger auth response models', () {
    test('parses direct login response and role', () {
      final response = AuthSessionResponse.fromJson({
        'accessToken': 'access',
        'refreshToken': 'refresh',
        'user': {
          'id': 'user-1',
          'email': 'marc@example.com',
          'role': 'TECHNICIAN',
        },
      });

      expect(response.user.role, UserRole.technician);
      expect(response.refreshToken, 'refresh');
    });

    test(
      'parses UserProfileResponse nullable fields and verification status',
      () {
        final response = UserProfileResponse.fromJson({
          'id': 'user-1',
          'role': 'TECHNICIAN',
          'email': 'marc@example.com',
          'firstName': 'Marc',
          'lastName': 'Anderson',
          'phone': null,
          'avatarUrl': null,
          'company': null,
          'isActive': true,
          'termsAcceptedAt': '2026-08-17T10:00:00.000Z',
          'termsVersion': '2026-08-17',
          'onboardingCompletedAt': null,
          'notificationEmail': true,
          'notificationPush': false,
          'createdAt': '2026-08-17T10:00:00.000Z',
          'updatedAt': '2026-08-18T10:00:00.000Z',
          'addresses': [
            {
              'id': 'address-1',
              'userId': 'user-1',
              'line1': '55 Park Avenue',
              'apartment': null,
              'city': 'Montreal',
              'state': 'QC',
              'zipCode': 'H2X 1Y4',
              'country': 'CA',
              'latitude': null,
              'longitude': null,
              'isPrimary': true,
            },
          ],
          'technician': {
            'id': 'tech-1',
            'userId': 'user-1',
            'employeeId': null,
            'serviceArea': 'Greater Montreal',
            'skills': ['Repair'],
            'licenseNumber': null,
            'yearsExperience': null,
            'bio': null,
            'rating': 4.9,
            'isAvailable': true,
            'verificationStatus': 'PENDING_VERIFICATION',
            'verificationNotes': null,
          },
        });

        expect(response.phone, isNull);
        expect(response.addresses.single.apartment, isNull);
        expect(
          response.technician!.verificationStatus,
          TechnicianVerificationStatus.pendingVerification,
        );
      },
    );

    test('rejects OTP responses with the wrong Swagger shape', () {
      expect(
        () => VerifyEmailResponse.fromJson({'success': true}),
        throwsFormatException,
      );
    });
  });
}
