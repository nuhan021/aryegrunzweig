import 'package:aryegrunzweig/core/common/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:aryegrunzweig/core/common/styles/global_text_style.dart';
import '../../controllers/help_support_controller.dart';
import '../../widgets/contact_option_card.dart';
import '../../widgets/faq_card.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HelpSupportController());

    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       Text(
      //         'Help & Support',
      //         style: getTextStyle(
      //           color: Colors.white,
      //           fontSize: 16.sp,
      //           fontWeight: FontWeight.w600,
      //         ),
      //       ),
      //       Text(
      //         'Get assistance for any issue or question',
      //         style: getTextStyle(
      //           color: Colors.white,
      //           fontSize: 12.sp,
      //           fontWeight: FontWeight.w400,
      //         ),
      //       ),
      //     ],
      //   ),
      //   backgroundColor: AppColors.primary,
      //   elevation: 0,
      //   automaticallyImplyLeading: true,
      // ),
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: 'Help & Support',
              subtitle: 'Get assistance for any issue or question',
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Contact Us Section
                      Text(
                        'Contact Us',
                        style: getTextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF101727),
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Contact Options
                      Obx(
                        () => Column(
                          children: List.generate(
                            controller.contactOptions.length,
                            (index) {
                              final contact = controller.contactOptions[index];
                              return Padding(
                                padding: EdgeInsets.only(bottom: 12.h),
                                child: ContactOptionCard(contact: contact),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 32.h),

                      Text(
                        'Send us a message',
                        style: getTextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 14.h),
                      TextField(
                        controller: controller.fullNameController,
                        decoration: const InputDecoration(
                          labelText: 'Full name *',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      TextField(
                        controller: controller.emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email *',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      TextField(
                        controller: controller.phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'Phone',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      TextField(
                        controller: controller.serviceController,
                        decoration: const InputDecoration(
                          labelText: 'Service',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      TextField(
                        controller: controller.messageController,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          labelText: 'Message *',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 14.h),
                      Obx(
                        () => SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: controller.isSubmitting.value
                                ? null
                                : controller.submitContact,
                            child: Text(
                              controller.isSubmitting.value
                                  ? 'Sending...'
                                  : 'Send message',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 32.h),

                      // Frequently Asked Questions Section
                      Text(
                        'Frequently Asked Questions',
                        style: getTextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF101727),
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // FAQ Cards
                      Obx(
                        () => Column(
                          children: List.generate(controller.faqs.length, (
                            index,
                          ) {
                            final faq = controller.faqs[index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: FAQCard(faq: faq),
                            );
                          }),
                        ),
                      ),
                      SizedBox(height: 32.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
