import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../home/views/widgets/service_request_buttons.dart';
import '../../controller/services_controller.dart';
import 'service_appointment_screen.dart';

class PaymentConfirmedScreen extends StatelessWidget {
  const PaymentConfirmedScreen({super.key, required this.request});

  final ServiceRequest request;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              const Spacer(flex: 3),
              Container(
                height: 72.w,
                width: 72.w,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(Icons.check, color: AppColors.primary, size: 36.sp),
              ),
              20.verticalSpace,
              Text(
                'Payment method confirmed',
                textAlign: TextAlign.center,
                style: getTextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              10.verticalSpace,
              Text(
                'Your appointment will be scheduled by our office.',
                textAlign: TextAlign.center,
                style: getTextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade600,
                ),
              ),
              const Spacer(flex: 4),
              SrPrimaryButton(
                text: 'View appointment',
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ServiceAppointmentScreen(request: request),
                  ),
                ),
              ),
              20.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
