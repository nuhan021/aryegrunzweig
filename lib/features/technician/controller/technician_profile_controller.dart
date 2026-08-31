import 'package:get/get.dart';

import '../../../core/utils/helpers/app_helper.dart';
import '../../auth/controller/auth_controller.dart';
import '../../auth/models/auth_models.dart';
import '../../profile/data/profile_models.dart';
import '../../profile/data/profile_repository.dart';

class TechnicianProfileController extends GetxController {
  final ProfileRepository _repository = Get.find<ProfileRepository>();
  final profile = Rxn<UserProfileResponse>();
  final isLoading = false.obs;
  final isUpdatingAvailability = false.obs;

  String get fullName {
    final value = profile.value;
    return value == null ? '' : '${value.firstName} ${value.lastName}'.trim();
  }

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    final result = await _repository.getProfile();
    if (result.isSuccess && result.data != null) {
      profile.value = result.data;
      Get.find<AuthController>().currentProfile.value = result.data;
    } else {
      AppHelperFunctions.showErrorSnackBar(result.errorMessage);
    }
    isLoading.value = false;
  }

  Future<void> setAvailability(bool value) async {
    if (isUpdatingAvailability.value) return;
    isUpdatingAvailability.value = true;
    final result = await _repository.updateTechnician(
      TechnicianProfileUpdateRequest(isAvailable: value),
    );
    if (result.isSuccess) {
      await load();
      AppHelperFunctions.showSuccessSnackBar('Availability updated');
    } else {
      AppHelperFunctions.showErrorSnackBar(result.errorMessage);
    }
    isUpdatingAvailability.value = false;
  }
}
