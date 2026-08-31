import 'package:aryegrunzweig/core/common/styles/global_text_style.dart';
import 'package:aryegrunzweig/core/common/widgets/custom_app_bar.dart';
import 'package:aryegrunzweig/core/utils/helpers/app_helper.dart';
import 'package:aryegrunzweig/features/profile/payment_methods/controllers/payment_methods_controller.dart';
import 'package:aryegrunzweig/features/profile/payment_methods/views/widgets/add_card_button.dart';
import 'package:aryegrunzweig/features/profile/payment_methods/views/widgets/payment_card.dart';
import 'package:aryegrunzweig/features/profile/payment_methods/views/widgets/secure_payment_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PaymentMethodsController>(
      init: PaymentMethodsController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                // Header
                CustomAppBar(
                  title: 'Payment Methods',
                  subtitle: 'Manage your saved payment options',
                ),

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 16.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Add New Card Button
                          AddCardButton(
                            onPressed: () {
                              AppHelperFunctions.showSnackBar(
                                'Add card feature coming soon',
                                title: 'Add Card',
                              );
                            },
                          ),
                          SizedBox(height: 24.h),

                          // Payment Methods List
                          Obx(
                            () => ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.paymentMethods.length,
                              itemBuilder: (context, index) {
                                final method = controller.paymentMethods[index];
                                return PaymentCard(
                                  paymentMethod: method,
                                  onSetDefault: () {
                                    controller.setAsDefault(method.id);
                                    AppHelperFunctions.showSuccessSnackBar(
                                      'Card set as default',
                                    );
                                  },
                                  onEdit: () {
                                    AppHelperFunctions.showSnackBar(
                                      'Edit feature coming soon',
                                      title: 'Edit Card',
                                    );
                                  },
                                  onDelete: () {
                                    _showDeleteDialog(
                                      context,
                                      controller,
                                      method.id,
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 24.h),

                          // Secure Payment Info
                          const SecurePaymentInfo(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    PaymentMethodsController controller,
    String cardId,
  ) {
    Get.defaultDialog(
      title: 'Delete Card',
      content: Text(
        'Are you sure you want to delete this card?',
        style: getTextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF495565),
        ),
      ),
      textConfirm: 'Delete',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        controller.deletePaymentMethod(cardId);
        Get.back();
        AppHelperFunctions.showSuccessSnackBar('Card deleted');
      },
      onCancel: () {
        Get.back();
      },
    );
  }
}
