import 'package:aryegrunzweig/features/services/data/service_request_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('catalog parses the documented category and issue response', () {
    final category = ServiceCatalogCategory.fromJson({
      'id': 'category-1',
      'name': 'Central vacuum repair',
      'description': null,
      'issues': [
        {'id': 'issue-1', 'name': 'Low suction'},
      ],
    });

    expect(category.id, 'category-1');
    expect(category.issues.single.name, 'Low suction');
  });

  test('service request parses quote, report, media, and history', () {
    final request = CustomerServiceRequest.fromJson(_requestResponse);

    expect(request.requestNumber, 'SR-AB12CD34');
    expect(request.status, CustomerRequestStatus.quoteSent);
    expect(request.quotation!.effectiveTotal, 175);
    expect(request.quotation!.counteroffers.single.status, 'APPROVED');
    expect(request.report!.followUpRequired, isFalse);
    expect(request.media.single.kind, 'ISSUE');
    expect(request.createdAt, DateTime.parse('2026-08-30T10:00:00.000Z'));
  });

  test('CreateRequestFormDto emits exact multipart text fields', () {
    final request = CreateServiceRequest(
      categoryId: 'category-1',
      issueId: 'issue-1',
      addressId: 'address-1',
      description: 'Low suction',
      preferredDate: DateTime.utc(2026, 9, 2, 9),
      preferredTime: '09:00-12:00',
    );

    expect(request.toFields(), {
      'categoryId': 'category-1',
      'issueId': 'issue-1',
      'addressId': 'address-1',
      'description': 'Low suction',
      'preferredDate': '2026-09-02T09:00:00.000Z',
      'preferredTime': '09:00-12:00',
    });
  });
}

const _requestResponse = <String, dynamic>{
  'id': 'request-1',
  'requestNumber': 'SR-AB12CD34',
  'customerId': 'customer-1',
  'technicianId': null,
  'categoryId': 'category-1',
  'issueId': 'issue-1',
  'addressId': 'address-1',
  'description': 'Low suction and rattling noise.',
  'status': 'QUOTE_SENT',
  'scheduledStart': null,
  'scheduledEnd': null,
  'cancellationReason': null,
  'media': [
    {
      'id': 'media-1',
      'kind': 'ISSUE',
      'url': 'https://example.com/photo.png',
      'mimeType': 'image/png',
    },
  ],
  'quotation': {
    'id': 'quote-1',
    'quoteNumber': 'QT-AB12CD34',
    'totalAmount': 192.1,
    'negotiatedTotal': 175,
    'status': 'SENT',
    'validUntil': '2026-09-02T09:00:00.000Z',
    'acceptedAt': null,
    'notes': 'Includes replacement filter.',
    'counteroffers': [
      {
        'id': 'offer-1',
        'quotationId': 'quote-1',
        'customerId': 'customer-1',
        'requestedTotal': 175,
        'note': 'Can you do this price?',
        'status': 'APPROVED',
        'decidedById': null,
        'decisionNote': null,
        'decidedAt': null,
        'supersededAt': null,
        'createdAt': '2026-08-30T11:00:00.000Z',
        'statusHistory': [],
      },
    ],
    'payments': [],
  },
  'report': {
    'id': 'report-1',
    'requestId': 'request-1',
    'repairStatus': 'Repaired',
    'workPerformed': 'Filter replaced and unit tested.',
    'technicianNotes': null,
    'partsUsed': {'filter': 1},
    'followUpRequired': false,
    'followUpNotes': null,
    'arrivalTime': null,
    'departureTime': null,
    'customerConfirmedAt': null,
    'submittedAt': '2026-08-30T12:00:00.000Z',
  },
  'equipment': [],
  'statusHistory': [
    {'status': 'NEW', 'note': null, 'createdAt': '2026-08-30T10:00:00.000Z'},
  ],
};
