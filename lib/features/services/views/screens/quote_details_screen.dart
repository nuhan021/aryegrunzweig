import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../home/views/widgets/service_request_buttons.dart';
import '../../controller/services_controller.dart';
import '../../data/service_request_models.dart';
import 'price_negotiation_screen.dart';
import 'service_payment_method_screen.dart';

class QuoteDetailsScreen extends StatefulWidget {
  const QuoteDetailsScreen({super.key, required this.request});

  final ServiceRequest request;

  @override
  State<QuoteDetailsScreen> createState() => _QuoteDetailsScreenState();
}

class _QuoteDetailsScreenState extends State<QuoteDetailsScreen> {
  bool agreed = true;
  final ServicesController controller = Get.find<ServicesController>();
  late ServiceRequest request;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    request = widget.request;
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadRequest());
  }

  Future<void> _loadRequest() async {
    final refreshed = await controller.refreshOne(request);
    if (!mounted) return;

    if (refreshed?.api.status == CustomerRequestStatus.accepted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ServicePaymentMethodScreen(request: refreshed!),
        ),
      );
      return;
    }

    setState(() {
      if (refreshed != null) request = refreshed;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _QuoteHeader(request: request),
            Expanded(
              child: Skeletonizer(
                enabled: isLoading,
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 20.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _InfoCard(
                        rows: [
                          ('Requested by', request.requestedByName),
                          ('Service', request.title),
                          ('Address', request.address),
                          (
                            'Valid until',
                            request.quoteValidUntil == null
                                ? '-'
                                : DateFormat(
                                    'MMMM d, yyyy · h:mm a',
                                  ).format(request.quoteValidUntil!),
                          ),
                        ],
                      ),
                      16.verticalSpace,

                      Container(
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14.r),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.maxFinite,
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 12.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(14.r),
                                  topRight: Radius.circular(14.r),
                                ),
                              ),
                              child: Text(
                                'Quote Breakdown',
                                style: getTextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 12.h,
                              ),
                              child: Column(
                                children: [
                                  _PriceRow(
                                    'Quoted service total',
                                    request.quotedAmount,
                                    isBold: true,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      16.verticalSpace,

                      if (request.quoteNote.trim().isNotEmpty)
                        Container(
                          width: double.maxFinite,
                          padding: EdgeInsets.all(14.w),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Text(
                            '"${request.quoteNote}"',
                            style: getTextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade700,
                              lineHeight: 1.5,
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                      if (request.quoteNote.trim().isNotEmpty) 16.verticalSpace,

                      Text(
                        'A hold for the quoted amount will be placed on your card when you accept this quote. You will only be charged after the service is completed and approved.',
                        style: getTextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade600,
                          lineHeight: 1.4,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      14.verticalSpace,

                      GestureDetector(
                        onTap: () => setState(() => agreed = !agreed),
                        child: Row(
                          children: [
                            Icon(
                              agreed
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                              size: 20.sp,
                              color: agreed ? AppColors.primary : Colors.grey,
                            ),
                            8.horizontalSpace,
                            Expanded(
                              child: Text(
                                'I agree to the service terms and quotation.',
                                style: getTextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black87,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      20.verticalSpace,

                      SrPrimaryButton(
                        text: 'Accept quote',
                        onPressed: agreed ? () => _acceptQuote(request) : () {},
                      ),
                      10.verticalSpace,
                      GestureDetector(
                        onTap: () => _rejectQuote(request),
                        child: Container(
                          height: 50.h,
                          width: double.maxFinite,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: Colors.red.shade200),
                          ),
                          child: Text(
                            'Reject quote',
                            style: getTextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.red.shade400,
                            ),
                          ),
                        ),
                      ),
                      10.verticalSpace,
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                PriceNegotiationScreen(request: request),
                          ),
                        ),
                        child: Container(
                          height: 50.h,
                          width: double.maxFinite,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            'Go for negotiation',
                            style: getTextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
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

  Future<void> _acceptQuote(ServiceRequest request) async {
    final accepted = await controller.acceptQuote(request);
    if (!accepted || !mounted) return;
    final updated = controller.requests.firstWhere(
      (item) => item.api.id == request.api.id,
      orElse: () => request,
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ServicePaymentMethodScreen(request: updated),
      ),
    );
  }

  Future<void> _rejectQuote(ServiceRequest request) async {
    final rejected = await controller.rejectQuote(request);
    if (rejected && mounted) Navigator.pop(context);
  }
}

class _QuoteHeader extends StatelessWidget {
  const _QuoteHeader({required this.request});

  final ServiceRequest request;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10.r),
          bottomRight: Radius.circular(10.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 20.w,
                  color: Colors.white,
                ),
              ),
              Text(
                'Back',
                style: getTextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          20.verticalSpace,
          Text(
            'Your service quotation',
            style: getTextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          10.verticalSpace,
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  'QUOTE READY',
                  style: getTextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
              8.horizontalSpace,
              Text(
                request.id,
                style: getTextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.rows});

  final List<(String, String)> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: rows.asMap().entries.map((entry) {
          final isLast = entry.key == rows.length - 1;
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 13.h),
            decoration: BoxDecoration(
              border: isLast
                  ? null
                  : Border(bottom: BorderSide(color: Colors.grey.shade100)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  entry.value.$1,
                  style: getTextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade500,
                  ),
                ),
                Flexible(
                  child: Text(
                    entry.value.$2,
                    textAlign: TextAlign.right,
                    style: getTextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow(this.label, this.value, {this.isBold = false});

  final String label;
  final double value;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: getTextStyle(
              fontSize: 13.sp,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
              color: isBold ? Colors.black : Colors.grey.shade600,
            ),
          ),
          Text(
            '\$${value.toStringAsFixed(2)}',
            style: getTextStyle(
              fontSize: 13.sp,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
