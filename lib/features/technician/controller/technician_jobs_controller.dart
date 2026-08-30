import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/helpers/app_helper.dart';
import '../../services/data/service_request_models.dart';
import '../data/technician_models.dart';
import '../data/technician_repository.dart';

enum TechnicianJobStatus { assigned, inProgress, reportSubmitted, completed }

class TechnicianJob {
  const TechnicianJob({required this.api});
  final CustomerServiceRequest api;
  String get id => api.requestNumber;
  String get serviceName => 'Service request';
  String get customerName => 'Customer ${api.customerId}';
  String get phone => 'Available through customer contact';
  String get email => 'Available through customer contact';
  String get address => 'Saved address ${api.addressId}';
  String get requestedDate => api.scheduledStart == null
      ? 'Schedule pending'
      : DateFormat('EEEE, MMMM d').format(api.scheduledStart!.toLocal());
  String get appointmentTime => api.scheduledStart == null
      ? 'Pending'
      : DateFormat('h:mm a').format(api.scheduledStart!.toLocal());
  String get estimatedDuration {
    if (api.scheduledStart == null || api.scheduledEnd == null) {
      return 'Pending';
    }
    final minutes = api.scheduledEnd!.difference(api.scheduledStart!).inMinutes;
    return '${(minutes / 60).toStringAsFixed(minutes % 60 == 0 ? 0 : 1)} hours';
  }

  String get previousVisit => 'Not provided by API';
  String get issueTitle => api.description;
  String get issueDescription => api.description;
  TechnicianJobStatus get uiStatus => switch (api.status) {
    CustomerRequestStatus.inProgress => TechnicianJobStatus.inProgress,
    CustomerRequestStatus.reportSubmitted =>
      TechnicianJobStatus.reportSubmitted,
    CustomerRequestStatus.completed => TechnicianJobStatus.completed,
    _ => TechnicianJobStatus.assigned,
  };
}

class TechnicianJobsController extends GetxController {
  final TechnicianRepository _repository = Get.find<TechnicianRepository>();
  final jobs = <TechnicianJob>[].obs;
  final selectedJob = Rxn<TechnicianJob>();
  final homeStats = Rxn<TechnicianHomeStats>();
  final status = TechnicianJobStatus.assigned.obs;
  final technicianNotes = ''.obs;
  final currentNote = Rxn<TechnicianNote>();
  final currentReport = Rxn<TechnicianReport>();
  final isLoading = false.obs;
  final isActionLoading = false.obs;
  final errorMessage = ''.obs;

  TechnicianJob get job => selectedJob.value!;

  @override
  void onInit() {
    super.onInit();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    if (isLoading.value) return;
    isLoading.value = true;
    errorMessage.value = '';
    final statsFuture = _repository.homeStats();
    final jobsFuture = _repository.jobs();
    final statsResult = await statsFuture;
    final jobsResult = await jobsFuture;
    if (statsResult.isSuccess && statsResult.data != null) {
      homeStats.value = statsResult.data;
    } else {
      errorMessage.value = statsResult.errorMessage;
    }
    if (jobsResult.isSuccess && jobsResult.data != null) {
      jobs.assignAll(jobsResult.data!.map((item) => TechnicianJob(api: item)));
      if (selectedJob.value == null && jobs.isNotEmpty) selectJob(jobs.first);
    } else if (errorMessage.value.isEmpty) {
      errorMessage.value = jobsResult.errorMessage;
    }
    isLoading.value = false;
  }

  List<TechnicianJob> get todayJobs {
    final now = DateTime.now();
    return jobs
        .where((item) {
          final date = item.api.scheduledStart?.toLocal();
          return date != null &&
              date.year == now.year &&
              date.month == now.month &&
              date.day == now.day &&
              item.api.status != CustomerRequestStatus.cancelled;
        })
        .toList(growable: false);
  }

  List<TechnicianJob> get upcomingJobs {
    final endToday = DateTime.now().copyWith(hour: 23, minute: 59, second: 59);
    return jobs
        .where(
          (item) =>
              item.api.status == CustomerRequestStatus.scheduled &&
              (item.api.scheduledStart?.toLocal().isAfter(endToday) ?? false),
        )
        .toList(growable: false);
  }

  List<TechnicianJob> get completedJobs => jobs
      .where((item) => item.api.status == CustomerRequestStatus.completed)
      .toList(growable: false);

  void selectJob(TechnicianJob value) {
    selectedJob.value = value;
    status.value = value.uiStatus;
    technicianNotes.value = '';
    currentNote.value = null;
    currentReport.value = null;
    loadNote();
    loadReport();
  }

  Future<TechnicianJob?> refreshSelected() async {
    final selected = selectedJob.value;
    if (selected == null) return null;
    final result = await _repository.job(selected.api.id);
    if (!result.isSuccess || result.data == null) {
      AppHelperFunctions.showErrorSnackBar(result.errorMessage);
      return null;
    }
    final updated = TechnicianJob(api: result.data!);
    final index = jobs.indexWhere((item) => item.api.id == updated.api.id);
    if (index >= 0) jobs[index] = updated;
    selectJob(updated);
    return updated;
  }

  Future<void> markInProgress() async {
    final selected = selectedJob.value;
    if (selected == null ||
        selected.api.status != CustomerRequestStatus.scheduled ||
        isActionLoading.value) {
      return;
    }
    isActionLoading.value = true;
    final result = await _repository.startJob(
      selected.api.id,
      note: 'Technician started the assigned visit.',
    );
    isActionLoading.value = false;
    if (!result.isSuccess || result.data == null) {
      AppHelperFunctions.showErrorSnackBar(result.errorMessage);
      return;
    }
    final updated = TechnicianJob(api: result.data!);
    final index = jobs.indexWhere((item) => item.api.id == updated.api.id);
    if (index >= 0) jobs[index] = updated;
    selectJob(updated);
    AppHelperFunctions.showSuccessSnackBar('Job marked in progress.');
  }

  Future<void> loadNote() async {
    final selected = selectedJob.value;
    if (selected == null) return;
    final result = await _repository.note(selected.api.id);
    if (result.isSuccess) {
      currentNote.value = result.data;
      technicianNotes.value = result.data?.text ?? '';
    }
  }

  Future<void> loadReport() async {
    final selected = selectedJob.value;
    if (selected == null) return;
    final result = await _repository.report(selected.api.id);
    if (result.isSuccess) currentReport.value = result.data;
  }

  Future<bool> updateNotes(String notes) async {
    final selected = selectedJob.value;
    final text = notes.trim();
    if (selected == null || text.isEmpty) return false;
    final result = currentNote.value == null
        ? await _repository.createNote(selected.api.id, text)
        : await _repository.updateNote(selected.api.id, text);
    if (!result.isSuccess || result.data == null) {
      AppHelperFunctions.showErrorSnackBar(result.errorMessage);
      return false;
    }
    currentNote.value = result.data;
    technicianNotes.value = result.data!.text;
    return true;
  }

  Future<bool> uploadMedia(String kind, String path) async {
    final selected = selectedJob.value;
    if (selected == null) return false;
    final result = await _repository.uploadMedia(
      id: selected.api.id,
      kind: kind,
      filePath: path,
    );
    if (!result.isSuccess) {
      AppHelperFunctions.showErrorSnackBar(result.errorMessage);
      return false;
    }
    return true;
  }

  Future<bool> submitReport(TechnicianReportPayload payload) async {
    final selected = selectedJob.value;
    if (selected == null || isActionLoading.value) return false;
    isActionLoading.value = true;
    final result = currentReport.value == null
        ? await _repository.createReport(selected.api.id, payload)
        : await _repository.updateReport(selected.api.id, payload);
    isActionLoading.value = false;
    if (!result.isSuccess || result.data == null) {
      AppHelperFunctions.showErrorSnackBar(result.errorMessage);
      return false;
    }
    currentReport.value = result.data;
    await refreshSelected();
    await loadDashboard();
    AppHelperFunctions.showSuccessSnackBar(
      'Report submitted for office review.',
    );
    return true;
  }

  // Completion is performed by office approval; technician report submission
  // advances the backend request to REPORT_SUBMITTED.
  void markCompleted() {}
}
