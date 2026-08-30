import 'package:aryegrunzweig/features/profile/data/profile_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('AddressDto serializes required and supplied optional fields only', () {
    const request = AddressRequest(
      line1: '123 Main Street',
      city: 'Toronto',
      state: 'ON',
      zipCode: 'M5V 2T6',
      isPrimary: true,
    );

    expect(request.toJson(), {
      'line1': '123 Main Street',
      'city': 'Toronto',
      'state': 'ON',
      'zipCode': 'M5V 2T6',
      'isPrimary': true,
    });
  });

  test('PaymentResponseDto parses exact enums and nullable relations', () {
    final payment = PaymentResponse.fromJson({
      'id': 'payment-1',
      'userId': 'user-1',
      'quotationId': null,
      'orderId': 'order-1',
      'purpose': 'ORDER',
      'provider': 'stripe',
      'providerReference': null,
      'currency': 'cad',
      'stripeCheckoutSessionId': 'cs_test',
      'stripePaymentIntentId': null,
      'amount': 349.0,
      'status': 'SUCCEEDED',
      'createdAt': '2026-08-29T10:00:00.000Z',
      'updatedAt': '2026-08-29T10:01:00.000Z',
      'quotation': null,
      'order': {'id': 'order-1', 'orderNumber': 'CC-3084'},
    });

    expect(payment.purpose, PaymentPurpose.order);
    expect(payment.status, PaymentStatus.succeeded);
    expect(payment.reference, 'CC-3084');
    expect(payment.quotation, isNull);
  });

  test('InvoiceResponseDto parses parties, service, and line items', () {
    final invoice = InvoiceResponse.fromJson({
      'paymentId': 'payment-1',
      'invoiceNumber': 'INV-2026-089',
      'date': 'August 29, 2026',
      'statusLabel': 'PAID',
      'paymentStatus': 'SUCCEEDED',
      'purpose': 'QUOTATION',
      'currency': 'cad',
      'vendor': {
        'name': 'Central Care',
        'addressLines': ['123 Main Street'],
        'email': null,
        'logoUrl': null,
      },
      'billTo': {
        'name': 'Sarah Thompson',
        'addressLines': ['1842 Maplewood Drive'],
        'email': 'sarah@example.com',
        'logoUrl': null,
      },
      'service': {
        'serviceType': 'Central Vacuum Repair',
        'technician': 'Marc Anderson',
        'serviceDate': 'August 29, 2026',
        'duration': '1h 30m',
      },
      'lineItems': [
        {
          'name': 'Repair service',
          'description': null,
          'quantity': '1',
          'price': 245,
        },
      ],
      'notes': null,
      'subtotal': 220,
      'serviceCharges': 0,
      'tax': 25,
      'taxPercent': 11.36,
      'total': 245,
    });

    expect(invoice.service!.technician, 'Marc Anderson');
    expect(invoice.lineItems.single.quantity, '1');
    expect(invoice.total, 245);
  });

  test('PublicSiteSettingsResponseDto allows every field to be null', () {
    final settings = PublicSettingsResponse.fromJson({
      'businessName': null,
      'officePhone': null,
      'supportEmail': null,
      'businessAddress': null,
      'serviceArea': null,
      'logoUrl': null,
      'landingHeroImageUrl': null,
    });

    expect(settings.businessName, isNull);
    expect(settings.supportEmail, isNull);
  });
}
