import 'package:get/get.dart';

import '../../../auth/controller/auth_controller.dart';
import '../../data/profile_models.dart';
import '../../data/profile_repository.dart';

class NotificationPreferencesController extends GetxController {
  final ProfileRepository _repository = Get.find<ProfileRepository>();
  final emailEnabled = true.obs;
  final pushEnabled = true.obs;
  final isLoading = true.obs;
  final isSaving = false.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    final cached = Get.find<AuthController>().currentProfile.value;
    if (cached != null) {
      emailEnabled.value = cached.notificationEmail;
      pushEnabled.value = cached.notificationPush;
      isLoading.value = false;
      return;
    }
    final result = await _repository.getProfile();
    if (result.isSuccess && result.data != null) {
      Get.find<AuthController>().currentProfile.value = result.data;
      emailEnabled.value = result.data!.notificationEmail;
      pushEnabled.value = result.data!.notificationPush;
    } else {
      Get.snackbar('Error', result.errorMessage);
    }
    isLoading.value = false;
  }

  Future<void> save() async {
    if (isSaving.value) return;
    isSaving.value = true;
    final result = await _repository.updatePreferences(
      NotificationPreferencesRequest(
        email: emailEnabled.value,
        push: pushEnabled.value,
      ),
    );
    isSaving.value = false;
    if (!result.isSuccess) {
      Get.snackbar('Error', result.errorMessage);
      return;
    }
    await Get.find<AuthController>().refreshCurrentProfile();
    Get.snackbar('Success', 'Notification preferences updated');
  }
}
