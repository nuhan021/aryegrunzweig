import 'package:aryegrunzweig/core/common/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:aryegrunzweig/core/common/styles/global_text_style.dart';
import '../../controllers/saved_addresses_controller.dart';
import '../../widgets/address_card.dart';

class SavedAddressesScreen extends StatelessWidget {
  const SavedAddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SavedAddressesController());

    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       Text(
      //         'Saved Addresses',
      //         style: getTextStyle(
      //           color: Colors.white,
      //           fontSize: 16.sp,
      //           fontWeight: FontWeight.w600,
      //         ),
      //       ),
      //       Text(
      //         'Manage your stored service locations',
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
              title: 'Saved Addresses',
              subtitle: 'Manage your stored service locations',
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Add New Address Button
                      GestureDetector(
                        onTap: () {
                          // Navigate to add address screen
                          Get.snackbar(
                            'Info',
                            'Navigate to add address screen',
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          height: 52.h,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFFD0D5DB),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                size: 20.w,
                                color: const Color(0xFF495565),
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Add New Address',
                                style: getTextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF495565),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // Address List
                      Obx(
                        () => controller.addresses.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 32.h),
                                  child: Text(
                                    'No addresses added yet',
                                    style: getTextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xFF697282),
                                    ),
                                  ),
                                ),
                              )
                            : Column(
                                children: List.generate(
                                  controller.addresses.length,
                                  (index) {
                                    final address = controller.addresses[index];
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: 16.h),
                                      child: AddressCard(
                                        address: address,
                                        onMenuPressed: () => controller
                                            .openAddressOptions(address.id),
                                      ),
                                    );
                                  },
                                ),
                              ),
                      ),
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
