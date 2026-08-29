import 'package:get/get.dart';

enum ServiceRequestStatus { quoteReady, underReview, scheduled, completed }

class ServiceRequest {
  ServiceRequest({
    required this.id,
    required this.title,
    required this.submittedDate,
    required this.issueDescription,
    required this.status,
    required this.requestedByName,
    required this.address,
    this.quotedAmount = 0,
    this.partsAndMaterials = 0,
    this.tax = 0,
    this.discount = 0,
    this.quoteValidUntil,
    this.quoteNote = '',
    this.appointmentDate,
    this.appointmentTimeRange = '',
    this.technicianName = '',
    this.appointmentNote = '',
    this.completedDate,
    this.finalAmount = 0,
    this.completionNote = '',
    this.partsUsed = '',
    this.photosCount = 0,
    this.paymentMethodText = '',
  });

  final String id;
  final String title;
  final DateTime submittedDate;
  final String issueDescription;
  ServiceRequestStatus status;
  final String requestedByName;
  final String address;

  // Quote
  final double quotedAmount;
  final double partsAndMaterials;
  final double tax;
  final double discount;
  final DateTime? quoteValidUntil;
  final String quoteNote;

  // Appointment
  final DateTime? appointmentDate;
  final String appointmentTimeRange;
  final String technicianName;
  final String appointmentNote;

  // Completed
  final DateTime? completedDate;
  final double finalAmount;
  final String completionNote;
  final String partsUsed;
  final int photosCount;
  final String paymentMethodText;
}

class ServicesController extends GetxController {
  var selectedTabIndex = 0.obs;

  final RxList<ServiceRequest> requests = <ServiceRequest>[
    ServiceRequest(
      id: 'SR-1048',
      title: 'Central Vacuum Repair',
      submittedDate: DateTime(2026, 7, 31),
      issueDescription: 'Low suction throughout the home',
      status: ServiceRequestStatus.quoteReady,
      requestedByName: 'Sarah Thompson',
      address: '1842 Maplewood Drive, Westmount',
      partsAndMaterials: 195.00,
      tax: 24.38,
      discount: 0,
      quotedAmount: 245.00,
      quoteValidUntil: DateTime(2026, 8, 1, 16, 30),
      quoteNote:
          'Based on the information and photos received, our technician will inspect the main line and repair the blockage or inlet issue. If additional parts are required, our office will contact you before making changes.',
      appointmentDate: DateTime(2026, 8, 1),
      appointmentTimeRange: '9:00 AM – 10:30 AM',
      technicianName: 'Marc Anderson',
      appointmentNote:
          'Our technician will inspect your central vacuum system and address the reported low suction issue.',
    ),
    ServiceRequest(
      id: 'SR-1049',
      title: 'Broken inlet valve',
      submittedDate: DateTime(2026, 8, 1),
      issueDescription: 'Our team is reviewing your request.',
      status: ServiceRequestStatus.underReview,
      requestedByName: 'Sarah Thompson',
      address: '1842 Maplewood Drive, Westmount',
    ),
    ServiceRequest(
      id: 'SR-1050',
      title: 'Central Vacuum Repair',
      submittedDate: DateTime(2026, 7, 20),
      issueDescription: 'Low suction throughout the home',
      status: ServiceRequestStatus.scheduled,
      requestedByName: 'Sarah Thompson',
      address: '1842 Maplewood Drive, Westmount',
      appointmentDate: DateTime(2026, 8, 1),
      appointmentTimeRange: '9:00 AM – 10:30 AM',
      technicianName: 'Marc Anderson',
      appointmentNote:
          'Our technician will inspect your central vacuum system and address the reported low suction issue.',
    ),
    ServiceRequest(
      id: 'SR-1032',
      title: 'Central Vacuum Repair',
      submittedDate: DateTime(2026, 7, 15),
      issueDescription: 'Low suction throughout the home',
      status: ServiceRequestStatus.completed,
      requestedByName: 'Sarah Thompson',
      address: '1842 Maplewood Drive, Westmount',
      technicianName: 'Marc Anderson',
      completedDate: DateTime(2026, 8, 1),
      finalAmount: 245.00,
      completionNote:
          'Our technician removed a blockage from the basement branch line, tested suction at all accessible vacuum ports, and restored normal system performance.',
      partsUsed: 'PVC coupling, replacement inlet valve',
      photosCount: 4,
      paymentMethodText: 'Paid by card',
    ),
  ].obs;

  void selectTab(int index) => selectedTabIndex.value = index;

  void authorizeAndSchedule(ServiceRequest request) {
    request.status = ServiceRequestStatus.scheduled;
    requests.refresh();
  }

  List<ServiceRequest> get filteredRequests {
    switch (selectedTabIndex.value) {
      case 1:
        return requests
            .where((r) => r.status == ServiceRequestStatus.scheduled)
            .toList();
      case 2:
        return requests
            .where((r) => r.status == ServiceRequestStatus.completed)
            .toList();
      default:
        return requests
            .where(
              (r) =>
                  r.status == ServiceRequestStatus.quoteReady ||
                  r.status == ServiceRequestStatus.underReview,
            )
            .toList();
    }
  }
}
