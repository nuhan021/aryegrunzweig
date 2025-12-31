import 'package:aryegrunzweig/core/common/styles/global_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/common/widgets/custom_app_bar.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(
              title: 'Track Order',
              subtitle: 'Monitor the progress of your service request',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
                child: Column(
                  children: [
                    _buildStep(
                      title: 'Pending',
                      icon: Icons.access_time,
                      isFirst: true,
                      isActive: true,
                    ),
                    _buildStep(
                      title: 'Technician Assigned',
                      icon: Icons.check,
                      isActive: true,
                    ),
                    _buildStep(
                      title: 'Completed',
                      subtitle: 'Estimated arrival: 15 minutes',
                      icon: Icons.check,
                      isLast: true,
                      isActive: true,
                    ),

                    30.verticalSpace, // Spacing before the card
                    _buildTechnicianCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTechnicianCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF273232),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Elite Central Vacuum',
            style: getTextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          12.verticalSpace,
          Row(
            children: [
              // Avatar with 180deg Gradient
              Container(
                width: 60.w,
                height: 60.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF1A73E8), Color(0xFF28C76F)],
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  'JD',
                  style: getTextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              16.horizontalSpace,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'John Doe',
                    style: getTextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  4.verticalSpace,
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16.sp),
                      4.horizontalSpace,
                      Text(
                        '4.9 (127 jobs)',
                        style: getTextStyle(
                          fontSize: 14.sp,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          12.verticalSpace,
          Row(
            children: [
              // Call Button
              Expanded(
                child: _buildActionButton(
                  icon: Icons.phone_outlined,
                  label: 'Call',
                  color: const Color(0xFF1C4F50),
                  textColor: Colors.white,
                ),
              ),
              12.horizontalSpace,
              // Chat Button
              Expanded(
                child: _buildActionButton(
                  icon: Icons.chat_bubble_outline,
                  label: 'Chat',
                  color: Colors.white,
                  textColor: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required Color textColor,
  }) {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: textColor, size: 20.sp),
          8.horizontalSpace,
          Text(
            label,
            style: getTextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep({
    required String title,
    String? subtitle,
    required IconData icon,
    bool isFirst = false,
    bool isLast = false,
    required bool isActive,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 42.w,
                height: 42.w,
                decoration: BoxDecoration(
                  color: isActive ? const Color(0xFF1C4F50) : Colors.grey,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.white, size: 20.sp),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2.w,
                    color: const Color(0xFF1C4F50),
                  ),
                ),
            ],
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8.h),
                Text(
                  title,
                  style: getTextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: getTextStyle(
                      fontSize: 12.sp,
                      color: Colors.blueGrey,
                    ),
                  ),
                ],
                if (!isLast) SizedBox(height: 55.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}