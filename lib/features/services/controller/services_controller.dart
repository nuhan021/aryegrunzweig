import 'package:get/get.dart';

import '../../../core/utils/constants/api_constants.dart';
import '../../../core/utils/helpers/app_helper.dart';
import '../../auth/controller/auth_controller.dart';
import '../../auth/models/auth_models.dart';
import '../data/service_request_models.dart';
import '../data/service_request_repository.dart';

enum ServiceRequestStatus { quoteReady, underReview, scheduled, completed }

class ServiceRequest {
  ServiceRequest({
    required this.api,
    required this.id,
    required this.title,
    required this.submittedDate,
    required this.issueDescription,
    required this.status,
    required this.statusLabel,
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

  final CustomerServiceRequest api;
  final String id;
  final String title;
  final DateTime submittedDate;
  final String issueDescription;
  final ServiceRequestStatus status;
  final String statusLabel;
  final String requestedByName;
  final String address;
  final double quotedAmount;
  final double partsAndMaterials;
  final double tax;
  final double discount;
  final DateTime? quoteValidUntil;
  final String quoteNote;
  final DateTime? appointmentDate;
  final String appointmentTimeRange;
  final String technicianName;
  final String appointmentNote;
  final DateTime? completedDate;
  final double finalAmount;
  final String completionNote;
  final String partsUsed;
  final int photosCount;
  final String paymentMethodText;
}

class ServicesController extends GetxController {
  final ServiceRequestRepository _repository =
      Get.find<ServiceRequestRepository>();
  final AuthController _authController = Get.find<AuthController>();

  final selectedTabIndex = 0.obs;
  final requests = <ServiceRequest>[].obs;
  final isLoading = false.obs;
  final isActionLoading = false.obs;
  final openingRequestIds = <String>{}.obs;
  final errorMessage = ''.obs;
  final counterofferHistory = <QuoteCounteroffer>[].obs;
  final _categories = <String, ServiceCatalogCategory>{};

  @override
  void onInit() {
    super.onInit();
    loadRequests();
  }

  void selectTab(int index) => selectedTabIndex.value = index;

  Future<void> loadRequests() async {
    if (isLoading.value) return;
    isLoading.value = true;
    errorMessage.value = '';
    final catalog = await _repository.getCatalog();
    if (catalog.isSuccess && catalog.data != null) {
      _categories
        ..clear()
        ..addEntries(catalog.data!.map((item) => MapEntry(item.id, item)));
    }
    final result = await _repository.list();
    if (result.isSuccess && result.data != null) {
      requests.assignAll(result.data!.map(_toViewModel));
    } else {
      errorMessage.value = result.errorMessage;
    }
    isLoading.value = false;
  }

  Future<ServiceRequest?> refreshOne(ServiceRequest request) async {
    final result = await _repository.getOne(request.api.id);
    if (!result.isSuccess || result.data == null) {
      AppHelperFunctions.showErrorSnackBar(result.errorMessage);
      return null;
    }
    final updated = _toViewModel(result.data!);
    _replace(updated);
    return updated;
  }

  Future<ServiceRequest?> requestById(String id) async {
    final cached = requests.firstWhereOrNull(
      (item) => item.api.id == id || item.id == id,
    );
    if (cached != null) return refreshOne(cached);
    final result = await _repository.getOne(id);
    if (!result.isSuccess || result.data == null) {
      AppHelperFunctions.showErrorSnackBar(result.errorMessage);
      return null;
    }
    final request = _toViewModel(result.data!);
    requests.add(request);
    return request;
  }

  Future<bool> acceptQuote(ServiceRequest request) async {
    if (isActionLoading.value) return false;
    isActionLoading.value = true;
    try {
      final result = await _repository.acceptQuote(
        id: request.api.id,
        termsVersion: ApiConstants.termsVersion,
      );
      if (!result.isSuccess) {
        AppHelperFunctions.showErrorSnackBar(result.errorMessage);
        return false;
      }
      await refreshOne(request);
      return true;
    } finally {
      isActionLoading.value = false;
    }
  }

  Future<bool> rejectQuote(ServiceRequest request, {String? reason}) async {
    if (isActionLoading.value) return false;
    isActionLoading.value = true;
    try {
      final result = await _repository.rejectQuote(
        request.api.id,
        reason: reason,
      );
      if (!result.isSuccess) {
        AppHelperFunctions.showErrorSnackBar(result.errorMessage);
        return false;
      }
      await refreshOne(request);
      AppHelperFunctions.showSuccessSnackBar('Quotation rejected.');
      return true;
    } finally {
      isActionLoading.value = false;
    }
  }

  Future<bool> submitCounteroffer(
    ServiceRequest request, {
    required num requestedTotal,
    String? note,
  }) async {
    if (isActionLoading.value) return false;
    isActionLoading.value = true;
    try {
      final result = await _repository.counteroffer(
        id: request.api.id,
        requestedTotal: requestedTotal,
        note: note,
      );
      if (!result.isSuccess || result.data == null) {
        AppHelperFunctions.showErrorSnackBar(result.errorMessage);
        return false;
      }
      counterofferHistory.insert(0, result.data!);
      await refreshOne(request);
      AppHelperFunctions.showSuccessSnackBar('Negotiation request sent.');
      return true;
    } finally {
      isActionLoading.value = false;
    }
  }

  Future<void> loadCounteroffers(ServiceRequest request) async {
    final result = await _repository.counteroffers(request.api.id);
    if (result.isSuccess && result.data != null) {
      counterofferHistory.assignAll(result.data!);
    } else {
      AppHelperFunctions.showErrorSnackBar(result.errorMessage);
    }
  }

  Future<ServiceAuthorization?> authorizePayment(ServiceRequest request) async {
    if (isActionLoading.value) return null;
    isActionLoading.value = true;
    try {
      final result = await _repository.authorizePayment(request.api.id);
      if (!result.isSuccess || result.data == null) {
        AppHelperFunctions.showErrorSnackBar(result.errorMessage);
        return null;
      }
      return result.data;
    } finally {
      isActionLoading.value = false;
    }
  }

  Future<ServicePaymentStatus?> paymentStatus(String paymentId) async {
    final result = await _repository.paymentStatus(paymentId);
    if (!result.isSuccess || result.data == null) {
      AppHelperFunctions.showErrorSnackBar(result.errorMessage);
      return null;
    }
    return result.data;
  }

  Future<bool> confirmReport(ServiceRequest request) async {
    if (isActionLoading.value) return false;
    isActionLoading.value = true;
    try {
      final result = await _repository.confirmReport(request.api.id);
      if (!result.isSuccess) {
        AppHelperFunctions.showErrorSnackBar(result.errorMessage);
        return false;
      }
      await refreshOne(request);
      AppHelperFunctions.showSuccessSnackBar('Service report confirmed.');
      return true;
    } finally {
      isActionLoading.value = false;
    }
  }

  Future<bool> cancel(ServiceRequest request, String reason) async {
    if (isActionLoading.value) return false;
    isActionLoading.value = true;
    try {
      final result = await _repository.cancel(request.api.id, reason);
      if (!result.isSuccess || result.data == null) {
        AppHelperFunctions.showErrorSnackBar(result.errorMessage);
        return false;
      }
      _replace(_toViewModel(result.data!));
      AppHelperFunctions.showSuccessSnackBar('Service request cancelled.');
      return true;
    } finally {
      isActionLoading.value = false;
    }
  }

  List<ServiceRequest> get filteredRequests {
    switch (selectedTabIndex.value) {
      case 1:
        return requests
            .where((r) => r.api.status.group == CustomerRequestGroup.scheduled)
            .toList();
      case 2:
        return requests
            .where(
              (r) =>
                  r.api.status.group == CustomerRequestGroup.completed ||
                  r.api.status.group == CustomerRequestGroup.cancelled,
            )
            .toList();
      default:
        return requests
            .where((r) => r.api.status.group == CustomerRequestGroup.active)
            .toList();
    }
  }

  void _replace(ServiceRequest updated) {
    final index = requests.indexWhere((item) => item.api.id == updated.api.id);
    if (index >= 0) requests[index] = updated;
  }

  ServiceRequest _toViewModel(CustomerServiceRequest api) {
    final category = _categories[api.categoryId];
    ServiceCatalogIssue? issue;
    for (final item in category?.issues ?? const <ServiceCatalogIssue>[]) {
      if (item.id == api.issueId) issue = item;
    }
    final profile = _authController.currentProfile.value;
    AddressResponse? address;
    for (final item in profile?.addresses ?? const <AddressResponse>[]) {
      if (item.id == api.addressId) address = item;
    }
    final quote = api.quotation;
    final report = api.report;
    final scheduledStart = api.scheduledStart?.toLocal();
    final scheduledEnd = api.scheduledEnd?.toLocal();
    return ServiceRequest(
      api: api,
      id: api.requestNumber,
      title: category?.name ?? 'Service request',
      submittedDate: api.createdAt?.toLocal() ?? DateTime.now(),
      issueDescription: issue?.name ?? api.description,
      status: switch (api.status) {
        CustomerRequestStatus.quoteSent => ServiceRequestStatus.quoteReady,
        CustomerRequestStatus.scheduled => ServiceRequestStatus.scheduled,
        CustomerRequestStatus.completed => ServiceRequestStatus.completed,
        _ => ServiceRequestStatus.underReview,
      },
      statusLabel: api.status.label,
      requestedByName: profile == null
          ? 'Customer'
          : '${profile.firstName} ${profile.lastName}'.trim(),
      address: address == null
          ? 'Saved service address'
          : '${address.line1}, ${address.city}, ${address.state}',
      quotedAmount: quote?.effectiveTotal.toDouble() ?? 0,
      quoteValidUntil: quote?.validUntil.toLocal(),
      quoteNote: quote?.notes ?? '',
      appointmentDate: scheduledStart,
      appointmentTimeRange: scheduledStart == null
          ? ''
          : '${_time(scheduledStart)}${scheduledEnd == null ? '' : ' – ${_time(scheduledEnd)}'}',
      technicianName: api.technicianId == null
          ? 'Not assigned'
          : 'Assigned technician',
      appointmentNote: api.description,
      completedDate: api.status == CustomerRequestStatus.completed
          ? (report?.submittedAt.toLocal() ?? scheduledEnd)
          : null,
      finalAmount: quote?.effectiveTotal.toDouble() ?? 0,
      completionNote: report?.workPerformed ?? '',
      partsUsed: report?.partsUsed?.toString() ?? '—',
      photosCount: api.media
          .where((item) => item.mimeType?.startsWith('image/') ?? true)
          .length,
      paymentMethodText: quote?.payments.isEmpty ?? true
          ? '—'
          : quote!.payments.last.status,
    );
  }

  String _time(DateTime value) {
    final hour = value.hour % 12 == 0 ? 12 : value.hour % 12;
    final minute = value.minute.toString().padLeft(2, '0');
    return '$hour:$minute ${value.hour >= 12 ? 'PM' : 'AM'}';
  }
}
