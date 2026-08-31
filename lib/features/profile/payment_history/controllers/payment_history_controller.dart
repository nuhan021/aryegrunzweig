import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/helpers/app_helper.dart';
import '../../data/profile_models.dart';
import '../../data/profile_repository.dart';

class PaymentHistoryController extends GetxController {
  final ProfileRepository _repository = Get.find<ProfileRepository>();

  final payments = <PaymentResponse>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final loadingInvoiceIds = <String>{}.obs;

  num get totalPaid => payments
      .where(
        (payment) =>
            payment.status == PaymentStatus.succeeded ||
            payment.status == PaymentStatus.captured,
      )
      .fold<num>(0, (sum, payment) => sum + payment.amount);

  @override
  void onInit() {
    super.onInit();
    loadPayments();
  }

  Future<void> loadPayments() async {
    if (isLoading.value) return;
    isLoading.value = true;
    errorMessage.value = '';
    final result = await _repository.getPayments();
    if (result.isSuccess && result.data != null) {
      payments.assignAll(result.data!);
    } else {
      errorMessage.value = result.errorMessage;
    }
    isLoading.value = false;
  }

  Future<void> showInvoice(PaymentResponse payment) async {
    if (loadingInvoiceIds.contains(payment.id)) return;
    loadingInvoiceIds.add(payment.id);
    try {
      final result = await _repository.getInvoice(payment.id);
      if (!result.isSuccess || result.data == null) {
        AppHelperFunctions.showErrorSnackBar(result.errorMessage);
        return;
      }
      final invoice = result.data!;
      Get.dialog(
        AlertDialog(
          title: Text(invoice.invoiceNumber),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Date: ${invoice.date}'),
              Text('Status: ${invoice.statusLabel}'),
              Text('Billed to: ${invoice.billTo.name}'),
              const SizedBox(height: 12),
              Text(
                'Total: ${invoice.currency.toUpperCase()} ${invoice.total.toStringAsFixed(2)}',
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: Get.back, child: const Text('Close')),
          ],
        ),
      );
    } finally {
      loadingInvoiceIds.remove(payment.id);
    }
  }
}
