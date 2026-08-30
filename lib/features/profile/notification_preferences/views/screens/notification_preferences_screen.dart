import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/common/widgets/custom_app_bar.dart';
import '../../../../../core/common/widgets/custom_button.dart';
import '../../controllers/notification_preferences_controller.dart';

class NotificationPreferencesScreen extends StatelessWidget {
  const NotificationPreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationPreferencesController());
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(
              title: 'Notification preferences',
              subtitle: 'Choose how you receive account updates.',
            ),
            Expanded(
              child: Obx(
                () => controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : ListView(
                        padding: EdgeInsets.all(20.w),
                        children: [
                          SwitchListTile(
                            title: const Text('Email notifications'),
                            subtitle: const Text(
                              'Receive service, order, and account updates by email.',
                            ),
                            value: controller.emailEnabled.value,
                            onChanged: (value) =>
                                controller.emailEnabled.value = value,
                          ),
                          const Divider(),
                          SwitchListTile(
                            title: const Text('Push notifications'),
                            subtitle: const Text(
                              'Receive updates directly on this device.',
                            ),
                            value: controller.pushEnabled.value,
                            onChanged: (value) =>
                                controller.pushEnabled.value = value,
                          ),
                          30.verticalSpace,
                          CustomButton(
                            text: controller.isSaving.value
                                ? 'Saving...'
                                : 'Save preferences',
                            onPressed: controller.save,
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
