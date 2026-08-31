import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/helpers/app_helper.dart';
import '../../../auth/models/auth_models.dart';
import '../../data/profile_models.dart';
import '../../data/profile_repository.dart';
import '../views/screens/address_editor_screen.dart';

class SavedAddressesController extends GetxController {
  final ProfileRepository _repository = Get.find<ProfileRepository>();

  final addresses = <AddressResponse>[].obs;
  final isLoading = false.obs;
  final isSaving = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadAddresses();
  }

  Future<void> loadAddresses() async {
    if (isLoading.value) return;
    isLoading.value = true;
    errorMessage.value = '';
    final result = await _repository.getAddresses();
    if (result.isSuccess && result.data != null) {
      addresses.assignAll(result.data!);
    } else {
      errorMessage.value = result.errorMessage;
    }
    isLoading.value = false;
  }

  Future<bool> saveAddress({
    AddressResponse? existing,
    required AddressRequest request,
  }) async {
    if (isSaving.value) return false;
    isSaving.value = true;
    final result = existing == null
        ? await _repository.addAddress(request)
        : await _repository.updateAddress(existing.id, request);
    isSaving.value = false;
    if (!result.isSuccess) {
      AppHelperFunctions.showErrorSnackBar(result.errorMessage);
      return false;
    }
    await loadAddresses();
    return true;
  }

  Future<void> deleteAddress(AddressResponse address) async {
    final result = await _repository.deleteAddress(address.id);
    if (result.isSuccess && result.data?.success == true) {
      addresses.removeWhere((item) => item.id == address.id);
      AppHelperFunctions.showSuccessSnackBar('Address deleted successfully');
    } else {
      AppHelperFunctions.showErrorSnackBar(result.errorMessage);
    }
  }

  void openEditor(BuildContext context, [AddressResponse? address]) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            AddressEditorScreen(controller: this, existingAddress: address),
      ),
    );
  }

  void openAddressOptions(BuildContext context, AddressResponse address) {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit Address'),
                onTap: () {
                  Get.back();
                  openEditor(context, address);
                },
              ),
              ListTile(
                enabled: !address.isPrimary,
                leading: Icon(
                  Icons.delete,
                  color: address.isPrimary ? Colors.grey : Colors.red,
                ),
                title: Text(
                  address.isPrimary
                      ? 'Primary address cannot be deleted'
                      : 'Delete Address',
                ),
                onTap: address.isPrimary
                    ? null
                    : () {
                        Get.back();
                        deleteAddress(address);
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
