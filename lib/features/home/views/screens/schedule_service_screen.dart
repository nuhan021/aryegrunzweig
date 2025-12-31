import 'package:aryegrunzweig/core/common/widgets/custom_app_bar.dart';
import 'package:aryegrunzweig/core/common/widgets/custom_button.dart';
import 'package:aryegrunzweig/core/utils/helpers/app_helper.dart';
import 'package:aryegrunzweig/features/home/views/screens/request_booking_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../../controller/home_controller.dart';

class ScheduleServiceScreen extends StatelessWidget {
  ScheduleServiceScreen({super.key});

  final HomeController controller = Get.find<HomeController>();

  final List<String> timeSlots = [
    "8:30 AM - 10:00 AM",
    "10:00 AM - 11:30 PM",
    "11:30 PM - 1:00 PM",
    "1:00 PM - 2:30 PM",
    "2:30 PM - 4:00 PM",
    "4:00 PM - 5:30 PM",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(
              title: 'Schedule Service',
              subtitle: 'Set a convenient time for the service',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    20.verticalSpace,

                    // ক্যালেন্ডার সেকশন
                    Text('Select Date', style: _headerStyle()),
                    15.verticalSpace,
                    _buildCalendarCard(),

                    25.verticalSpace,

                    // সার্ভিস আওয়ার নোট
                    _buildNoteCard(),

                    25.verticalSpace,


                    Text('Select Time', style: _headerStyle()),
                    15.verticalSpace,


                    _buildTimeSlotGrid(),

                    40.verticalSpace,
                    CustomButton(
                      text: 'Next',
                      onPressed: () {
                        AppHelperFunctions.navigateToScreen(context, RequestBookingScreen());
                      },
                    ),
                    20.verticalSpace,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarCard() {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Obx(
        () => TableCalendar(
          firstDay: DateTime.now(),
          lastDay: DateTime.now().add(const Duration(days: 365)),
          focusedDay: controller.focusedDay.value,
          currentDay: DateTime.now(),
          selectedDayPredicate: (day) =>
              isSameDay(controller.selectedDate.value, day),
          onDaySelected: (selectedDay, focusedDay) {
            controller.updateSelectedDate(selectedDay, focusedDay);
          },
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
            leftChevronIcon: const Icon(
              Icons.chevron_left,
              color: Color(0xFF1C4F50),
            ),
            rightChevronIcon: const Icon(
              Icons.chevron_right,
              color: Color(0xFF1C4F50),
            ),
          ),
          calendarStyle: CalendarStyle(
            selectedDecoration: const BoxDecoration(
              color: Color(0xFF1C4F50),
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              color: const Color(0xFF1C4F50).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            todayTextStyle: const TextStyle(
              color: Color(0xFF1C4F50),
              fontWeight: FontWeight.bold,
            ),
            defaultTextStyle: TextStyle(fontSize: 14.sp),
            weekendTextStyle: TextStyle(
              fontSize: 14.sp,
              color: Colors.red.withOpacity(0.6),
            ),
          ),
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
            weekendStyle: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeSlotGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.h,
        mainAxisExtent: 50.h,
      ),
      itemCount: timeSlots.length,
      itemBuilder: (context, index) {
        return Obx(() {
          bool isSelected =
              controller.selectedTimeSlot.value == timeSlots[index];
          return GestureDetector(
            onTap: () => controller.updateTimeSlot(timeSlots[index]),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF1C4F50)
                    : const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isSelected
                      ? Colors.transparent
                      : Colors.grey.withOpacity(0.1),
                ),
              ),
              child: Text(
                timeSlots[index],
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
            ),
          );
        });
      },
    );
  }

  Widget _buildNoteCard() {
    return Obx(() {
      String currentNote = controller.availabilityNote;
      int weekday = controller.selectedDate.value.weekday;
      bool isClosed =
          weekday == DateTime.saturday || weekday == DateTime.sunday;

      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isClosed
              ? Colors.red.withOpacity(0.05)
              : const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isClosed
                ? Colors.red
                : const Color(0xFF1C4F50).withOpacity(0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isClosed ? Icons.highlight_off : Icons.info_outline,
                  size: 18.sp,
                  color: isClosed ? Colors.red : const Color(0xFF1C4F50),
                ),
                8.horizontalSpace,
                Text(
                  'Status :',
                  style: TextStyle(
                    color: isClosed ? Colors.red : const Color(0xFF1C4F50),
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
            8.verticalSpace,
            Text(
              currentNote,
              style: TextStyle(
                fontSize: 13.sp,
                color: isClosed ? Colors.red : Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (!isClosed) ...[
              5.verticalSpace,
              _noteText('Please select a slot within the available hours.'),
            ],
          ],
        ),
      );
    });
  }

  Widget _noteText(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Text(
        text,
        style: TextStyle(fontSize: 12.sp, color: Colors.black54),
      ),
    );
  }

  TextStyle _headerStyle() {
    return TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    );
  }
}
