import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../controller/orders_controller.dart';
import 'return_request_submitted_screen.dart';

class ReturnOrderScreen extends StatefulWidget {
  const ReturnOrderScreen({super.key, required this.order});

  final ShopOrder order;

  @override
  State<ReturnOrderScreen> createState() => _ReturnOrderScreenState();
}

class _ReturnOrderScreenState extends State<ReturnOrderScreen> {
  static const List<String> _reasons = [
    'Item arrived damaged',
    'Wrong item received',
    'Item not as described',
    'Changed my mind',
    'Compatibility issue',
    'Other reason',
  ];

  final TextEditingController _commentsController = TextEditingController();
  final OrdersController _controller = Get.find<OrdersController>();
  String? _selectedReason = _reasons.first;

  @override
  void dispose() {
    _commentsController.dispose();
    super.dispose();
  }

  Future<void> _submitReturn() async {
    if (_selectedReason == null) {
      return;
    }
    final submitted = await _controller.requestReturn(
      order: widget.order,
      reason: _selectedReason!,
      comments: _commentsController.text,
    );
    if (!submitted || !mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const ReturnRequestSubmittedScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ReturnHeader(onBack: () => Navigator.of(context).pop()),
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _OrderSummaryCard(order: widget.order),
                    30.verticalSpace,
                    Text(
                      'Reason for return',
                      style: getTextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF172231),
                      ),
                    ),
                    14.verticalSpace,
                    ..._reasons.map(
                      (reason) => _ReasonTile(
                        label: reason,
                        isSelected: _selectedReason == reason,
                        onTap: () => setState(() => _selectedReason = reason),
                      ),
                    ),
                    8.verticalSpace,
                    Text.rich(
                      TextSpan(
                        text: 'Additional comments ',
                        style: getTextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF172231),
                        ),
                        children: [
                          TextSpan(
                            text: '(optional)',
                            style: getTextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    10.verticalSpace,
                    TextField(
                      controller: _commentsController,
                      minLines: 4,
                      maxLines: 6,
                      style: getTextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF172231),
                      ),
                      decoration: InputDecoration(
                        hintText: 'Describe the issue in more detail...',
                        hintStyle: getTextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF92A7C5),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFD),
                        contentPadding: EdgeInsets.all(16.w),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: const BorderSide(
                            color: Color(0xFFDCE5EF),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    16.verticalSpace,
                    Container(
                      width: double.maxFinite,
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F6FD),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: const Color(0xFFD5E0EB)),
                      ),
                      child: Text(
                        '⚠️ Do not ship the item back until Central Care has approved your return request and provided a return label.',
                        style: getTextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.primary,
                          lineHeight: 1.5,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    16.verticalSpace,
                    Obx(
                      () => GestureDetector(
                        onTap: _controller.isActionLoading.value
                            ? null
                            : _submitReturn,
                        child: Container(
                          height: 54.h,
                          width: double.maxFinite,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: _controller.isActionLoading.value
                              ? SizedBox(
                                  height: 22.w,
                                  width: 22.w,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2.3,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'Submit return request',
                                  style: getTextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReturnHeader extends StatelessWidget {
  const _ReturnHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 22.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(14.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onBack,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.chevron_left, color: Colors.white, size: 22.sp),
                  3.horizontalSpace,
                  Text(
                    'Back',
                    style: getTextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          16.verticalSpace,
          Text(
            'Request a return',
            style: getTextStyle(
              fontSize: 19.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          4.verticalSpace,
          Text(
            'Returns are subject to approval by Central\nCare. Please select your reason below.',
            style: getTextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white,
              lineHeight: 1.35,
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderSummaryCard extends StatelessWidget {
  const _OrderSummaryCard({required this.order});

  final ShopOrder order;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 110.w,
            width: 110.w,
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey.shade200),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.inventory_2_outlined,
              color: Colors.grey.shade400,
              size: 38.sp,
            ),
          ),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.itemName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: getTextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                    textAlign: TextAlign.left,
                  ),
                ),
                8.verticalSpace,
                Text(
                  'Order Code: #${order.orderCode}',
                  style: getTextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade700,
                  ),
                ),
                6.verticalSpace,
                Text(
                  'Ordered: ${DateFormat('MMMM d, yyyy').format(order.orderDate)}',
                  style: getTextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF92A7C5),
                  ),
                ),
                14.verticalSpace,
                Text(
                  '\$${order.price.toStringAsFixed(2)}',
                  style: getTextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReasonTile extends StatelessWidget {
  const _ReasonTile({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 48.h,
        width: double.maxFinite,
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8F2FE) : const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(11.r),
          border: isSelected
              ? Border.all(color: AppColors.primary.withValues(alpha: 0.08))
              : null,
        ),
        child: Row(
          children: [
            Container(
              height: 22.w,
              width: 22.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : const Color(0xFF99A7B9),
                  width: 2.w,
                ),
              ),
              alignment: Alignment.center,
              child: isSelected
                  ? Container(
                      height: 11.w,
                      width: 11.w,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    )
                  : null,
            ),
            12.horizontalSpace,
            Expanded(
              child: Text(
                label,
                style: getTextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: isSelected
                      ? AppColors.primary
                      : const Color(0xFF172231),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
