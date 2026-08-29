import 'package:get/get.dart';

enum TechnicianJobStatus { assigned, inProgress, completed }

class TechnicianJob {
  const TechnicianJob({
    required this.id,
    required this.serviceName,
    required this.customerName,
    required this.phone,
    required this.email,
    required this.address,
    required this.requestedDate,
    required this.appointmentTime,
    required this.estimatedDuration,
    required this.previousVisit,
    required this.issueTitle,
    required this.issueDescription,
  });

  final String id;
  final String serviceName;
  final String customerName;
  final String phone;
  final String email;
  final String address;
  final String requestedDate;
  final String appointmentTime;
  final String estimatedDuration;
  final String previousVisit;
  final String issueTitle;
  final String issueDescription;
}

class TechnicianJobsController extends GetxController {
  final status = TechnicianJobStatus.assigned.obs;
  final technicianNotes = ''.obs;

  final job = const TechnicianJob(
    id: 'SR-1048',
    serviceName: 'Central Vacuum Repair',
    customerName: 'Sarah Thompson',
    phone: '(514) 555-0188',
    email: 'sarah.thompson@email.com',
    address: '1842 Maplewood Drive, Westmount',
    requestedDate: 'Friday, August 1',
    appointmentTime: '9:00 AM',
    estimatedDuration: '1.5 hours',
    previousVisit: 'May 12, 2025',
    issueTitle: 'Low suction throughout the home',
    issueDescription:
        'The vacuum unit turns on normally, but suction is weak on both the basement and first floor. The issue started approximately two days ago.',
  );

  void markInProgress() => status.value = TechnicianJobStatus.inProgress;

  void updateNotes(String notes) => technicianNotes.value = notes.trim();

  void markCompleted() => status.value = TechnicianJobStatus.completed;
}
