import 'dart:convert';

import 'package:aryegrunzweig/core/services/api_client.dart';
import 'package:aryegrunzweig/core/services/session_store.dart';
import 'package:aryegrunzweig/features/technician/data/technician_models.dart';
import 'package:aryegrunzweig/features/technician/data/technician_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test(
    'home stats sends timezone and parses the documented response',
    () async {
      final repository = _repository((request) async {
        expect(request.method, 'GET');
        expect(request.url.path, '/api/technician/home-stats');
        expect(request.url.queryParameters['timezone'], 'America/Toronto');
        return http.Response(jsonEncode(_homeStats), 200);
      });

      final result = await repository.homeStats();
      expect(result.isSuccess, isTrue);
      expect(result.data!.jobsToday, 3);
      expect(result.data!.firstName, 'Marc');
    },
  );

  test('jobs and in-progress update use technician endpoints', () async {
    var call = 0;
    final repository = _repository((request) async {
      call++;
      if (call == 1) {
        expect(request.url.path, '/api/technician/service-requests');
        return http.Response(jsonEncode([_request]), 200);
      }
      expect(request.method, 'PATCH');
      expect(
        request.url.path,
        '/api/technician/service-requests/request-1/status',
      );
      expect(jsonDecode(request.body), {
        'status': 'IN_PROGRESS',
        'note': 'Arrived on site',
      });
      return http.Response(
        jsonEncode({..._request, 'status': 'IN_PROGRESS'}),
        200,
      );
    });

    final job = (await repository.jobs()).data!.single;
    expect(job.requestNumber, 'SR-1');
    expect(job.customer!.phone, '+15145550188');
    expect(job.address!.line1, '1842 Maplewood Drive');
    final started = await repository.startJob(
      'request-1',
      note: 'Arrived on site',
    );
    expect(started.isSuccess, isTrue);
  });

  test('report submission sends every documented workflow field', () async {
    final repository = _repository((request) async {
      expect(request.method, 'POST');
      expect(
        request.url.path,
        '/api/technician/service-requests/request-1/report',
      );
      expect(jsonDecode(request.body), {
        'repairStatus': 'Fixed',
        'workPerformed': 'Replaced inlet valve',
        'technicianNotes': 'Tested suction',
        'partsUsed': [
          {'name': 'Inlet valve', 'quantity': 1},
        ],
        'followUpRequired': true,
        'followUpNotes': 'Check again next week',
        'arrivalTime': '2026-08-01T09:00:00.000Z',
        'departureTime': '2026-08-01T10:30:00.000Z',
      });
      return http.Response(jsonEncode(_report), 201);
    });

    final result = await repository.createReport(
      'request-1',
      TechnicianReportPayload(
        repairStatus: 'Fixed',
        workPerformed: 'Replaced inlet valve',
        technicianNotes: 'Tested suction',
        partsUsed: const [TechnicianPartUsed(name: 'Inlet valve', quantity: 1)],
        followUpRequired: true,
        followUpNotes: 'Check again next week',
        arrivalTime: DateTime.utc(2026, 8, 1, 9),
        departureTime: DateTime.utc(2026, 8, 1, 10, 30),
      ),
    );
    expect(result.isSuccess, isTrue);
    expect(result.data!.repairStatus, 'Fixed');
  });

  test('equipment create sends inlet inventory in the Swagger shape', () async {
    final repository = _repository((request) async {
      expect(
        request.url.path,
        '/api/technician/service-requests/request-1/equipment',
      );
      expect(jsonDecode(request.body), {
        'unitNumber': 'Unit #1',
        'manufacturer': 'Beam',
        'additionalFeatures': <String>[],
        'inlets': [
          {'floor': 'Basement', 'type': 'HDH', 'quantity': 2},
        ],
      });
      return http.Response(jsonEncode(_equipment), 201);
    });

    final result = await repository.createEquipment(
      'request-1',
      const TechnicianEquipmentPayload(
        unitNumber: 'Unit #1',
        manufacturer: 'Beam',
        inlets: [
          TechnicianInletPayload(floor: 'Basement', type: 'HDH', quantity: 2),
        ],
      ),
    );
    expect(result.isSuccess, isTrue);
    expect(result.data!.inlets.single.quantity, 2);
  });
}

TechnicianRepository _repository(
  Future<http.Response> Function(http.Request) handler,
) => TechnicianRepository(
  ApiClient(
    baseUrl: 'https://example.test',
    sessionStore: _FakeSessionStore(),
    httpClient: MockClient(handler),
  ),
);

class _FakeSessionStore implements SessionStore {
  @override
  String? accessToken = 'access-token';
  @override
  String? refreshToken;
  @override
  String? userId = 'technician-1';
  @override
  String? userRole = 'TECHNICIAN';
  @override
  Future<void> clear() async {}
  @override
  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    String? userId,
    String? userRole,
  }) async {}
  @override
  Future<void> updateIdentity({String? userId, String? userRole}) async {}
}

const _homeStats = {
  'firstName': 'Marc',
  'jobsToday': 3,
  'inProgress': 1,
  'completedThisMonth': 12,
  'weeklyTasks': 8,
  'completedThisWeek': 5,
  'totalCompleted': 84,
  'upcoming': 4,
  'averageRating': 4.8,
  'date': '2026-08-30',
  'timezone': 'America/Toronto',
};

const _request = {
  'id': 'request-1',
  'requestNumber': 'SR-1',
  'customerId': 'customer-1',
  'technicianId': 'technician-1',
  'categoryId': 'category-1',
  'issueId': null,
  'addressId': 'address-1',
  'description': 'Low suction',
  'status': 'SCHEDULED',
  'scheduledStart': '2026-08-30T09:00:00.000Z',
  'scheduledEnd': '2026-08-30T10:30:00.000Z',
  'cancellationReason': null,
  'customer': {
    'id': 'customer-1',
    'firstName': 'Sarah',
    'lastName': 'Thompson',
    'email': 'sarah@example.com',
    'phone': '+15145550188',
  },
  'address': {
    'id': 'address-1',
    'line1': '1842 Maplewood Drive',
    'apartment': 'Apt 4',
    'city': 'Westmount',
    'state': 'QC',
    'zipCode': 'H3Z 2A4',
    'country': 'Canada',
    'isPrimary': false,
  },
  'media': [],
  'quotation': null,
  'report': null,
  'equipment': [],
  'statusHistory': [],
};

const _report = {
  'id': 'report-1',
  'requestId': 'request-1',
  'repairStatus': 'Fixed',
  'workPerformed': 'Replaced inlet valve',
  'technicianNotes': 'Tested suction',
  'partsUsed': {'items': []},
  'followUpRequired': true,
  'followUpNotes': 'Check again next week',
  'arrivalTime': '2026-08-01T09:00:00.000Z',
  'departureTime': '2026-08-01T10:30:00.000Z',
  'customerConfirmedAt': null,
  'submittedAt': '2026-08-01T10:35:00.000Z',
};

const _equipment = {
  'id': 'equipment-1',
  'customerId': 'customer-1',
  'requestId': 'request-1',
  'unitNumber': 'Unit #1',
  'manufacturer': 'Beam',
  'model': null,
  'serialNumber': null,
  'location': null,
  'condition': null,
  'additionalFeatures': [],
  'inlets': [
    {'id': 'inlet-1', 'floor': 'Basement', 'type': 'HDH', 'quantity': 2},
  ],
  'media': [],
};
