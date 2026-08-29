import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../controller/technician_jobs_controller.dart';

class TechnicianServiceReportScreen extends StatefulWidget {
  const TechnicianServiceReportScreen({super.key, required this.controller});

  final TechnicianJobsController controller;

  @override
  State<TechnicianServiceReportScreen> createState() =>
      _TechnicianServiceReportScreenState();
}

class _TechnicianServiceReportScreenState
    extends State<TechnicianServiceReportScreen> {
  static const _statuses = [
    'Fixed',
    'Parts required / Return visit needed',
    'Unable to complete',
  ];

  late final TextEditingController _workController;
  late final TextEditingController _notesController;
  late final TextEditingController _arrivalController;
  late final TextEditingController _departureController;
  late final TextEditingController _followUpController;
  String _selectedStatus = _statuses.first;
  bool _followUpRequired = true;
  bool _customerConfirmed = true;
  final List<_PartItem> _parts = [
    _PartItem(name: 'Replacement inlet valve'),
    _PartItem(name: 'PVC coupling'),
  ];

  @override
  void initState() {
    super.initState();
    _workController = TextEditingController(
      text:
          'Inspected the central unit, hose connection, and main line. Removed a blockage from the basement branch line and tested suction at all accessible inlets. Suction has been restored.',
    );
    _notesController = TextEditingController(
      text: widget.controller.technicianNotes.value.isEmpty
          ? 'Customer advised to monitor suction over the next 48 hours. One older inlet valve on the first floor may need replacement during a future visit.'
          : widget.controller.technicianNotes.value,
    );
    _arrivalController = TextEditingController(text: '9:05 AM');
    _departureController = TextEditingController(text: '10:35 AM');
    _followUpController = TextEditingController();
  }

  @override
  void dispose() {
    _workController.dispose();
    _notesController.dispose();
    _arrivalController.dispose();
    _departureController.dispose();
    _followUpController.dispose();
    super.dispose();
  }

  Future<void> _addPart() async {
    final partController = TextEditingController();
    final part = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add part'),
        content: TextField(
          controller: partController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Part name and quantity',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, partController.text),
            child: const Text('Add'),
          ),
        ],
      ),
    );
    partController.dispose();
    if (part == null || part.trim().isEmpty || !mounted) return;
    setState(() => _parts.add(_PartItem(name: part.trim())));
  }

  void _submit() {
    if (_workController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Describe the work performed.')),
      );
      return;
    }
    if (_arrivalController.text.trim().isEmpty ||
        _departureController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter arrival and departure times.')),
      );
      return;
    }
    if (_followUpRequired && _followUpController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Describe the required follow-up.')),
      );
      return;
    }
    if (!_customerConfirmed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Customer confirmation is required.')),
      );
      return;
    }
    widget.controller.updateNotes(_notesController.text);
    widget.controller.markCompleted();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Service report submitted for review.')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const _ReportHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 26.h),
                child: Column(
                  children: [
                    _ReportCard(
                      title: 'Repair Status',
                      padding: EdgeInsets.all(12.w),
                      child: Column(
                        children: _statuses
                            .map(
                              (status) => Padding(
                                padding: EdgeInsets.only(bottom: 9.h),
                                child: _StatusOption(
                                  label: status,
                                  selected: _selectedStatus == status,
                                  onTap: () =>
                                      setState(() => _selectedStatus = status),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    16.verticalSpace,
                    _ReportCard(
                      title: 'Visit Time',
                      padding: EdgeInsets.all(12.w),
                      child: Row(
                        children: [
                          Expanded(
                            child: _TimeField(
                              label: 'Arrival time',
                              controller: _arrivalController,
                            ),
                          ),
                          12.horizontalSpace,
                          Expanded(
                            child: _TimeField(
                              label: 'Departure',
                              controller: _departureController,
                            ),
                          ),
                        ],
                      ),
                    ),
                    16.verticalSpace,
                    _LabeledTextArea(
                      eyebrow: 'Work Performed',
                      label: 'Describe diagnosis and repair',
                      controller: _workController,
                      minLines: 5,
                    ),
                    16.verticalSpace,
                    _ReportCard(
                      title: 'Parts Used',
                      trailing: GestureDetector(
                        onTap: _addPart,
                        child: Text(
                          '+ Add part',
                          style: getTextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ).copyWith(decoration: TextDecoration.underline),
                        ),
                      ),
                      padding: EdgeInsets.all(10.w),
                      child: Column(
                        children: _parts
                            .map(
                              (part) => Container(
                                width: double.maxFinite,
                                margin: EdgeInsets.only(bottom: 8.h),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 14.w,
                                  vertical: 12.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.r),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 10.w,
                                      width: 10.w,
                                      decoration: const BoxDecoration(
                                        color: AppColors.primary,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    12.horizontalSpace,
                                    Expanded(
                                      child: Text(
                                        part.name,
                                        style: getTextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xFF172231),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    ),
                                    _PartCounterButton(
                                      icon: Icons.remove,
                                      enabled: part.quantity > 1,
                                      onTap: () => setState(
                                        () => part.quantity =
                                            (part.quantity - 1).clamp(1, 99),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 30.w,
                                      child: Text(
                                        '${part.quantity}',
                                        textAlign: TextAlign.center,
                                        style: getTextStyle(
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF172231),
                                        ),
                                      ),
                                    ),
                                    _PartCounterButton(
                                      icon: Icons.add,
                                      enabled: true,
                                      onTap: () => setState(
                                        () => part.quantity =
                                            (part.quantity + 1).clamp(1, 99),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    16.verticalSpace,
                    Container(
                      width: double.maxFinite,
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Job Photos',
                            style: getTextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF172231),
                            ),
                          ),
                          14.verticalSpace,
                          Row(
                            children: const [
                              _ReportPhoto(label: 'Before'),
                              _ReportPhoto(label: 'After'),
                              _ReportPhoto(label: 'Equip.'),
                              _ReportPhoto(label: 'Inlet'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    16.verticalSpace,
                    _LabeledTextArea(
                      label: 'Technician Notes',
                      controller: _notesController,
                      minLines: 4,
                    ),
                    16.verticalSpace,
                    _ReportCard(
                      title: 'Follow-up Required?',
                      padding: EdgeInsets.all(12.w),
                      child: Column(
                        children: [
                          _ConfirmationTile(
                            label: 'Return visit or follow-up needed',
                            selected: _followUpRequired,
                            color: const Color(0xFFD98200),
                            backgroundColor: const Color(0xFFFFFAE9),
                            onTap: () => setState(
                              () => _followUpRequired = !_followUpRequired,
                            ),
                          ),
                          if (_followUpRequired) ...[
                            10.verticalSpace,
                            TextField(
                              controller: _followUpController,
                              minLines: 3,
                              maxLines: 5,
                              decoration: InputDecoration(
                                hintText:
                                    'Describe what needs to be done on the return visit...',
                                hintStyle: getTextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFFE7B95F),
                                  textAlign: TextAlign.left,
                                ),
                                filled: true,
                                fillColor: const Color(0xFFFFFAE9),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFFFC542),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFD98200),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    16.verticalSpace,
                    _ReportCard(
                      title: 'Customer Confirmation',
                      padding: EdgeInsets.all(12.w),
                      child: Column(
                        children: [
                          _ConfirmationTile(
                            label:
                                'Customer verbally confirmed that the service was completed to their satisfaction and understood the work performed.',
                            selected: _customerConfirmed,
                            color: const Color(0xFF149B72),
                            backgroundColor: Colors.white,
                            onTap: () => setState(
                              () => _customerConfirmed = !_customerConfirmed,
                            ),
                          ),
                          if (_customerConfirmed) ...[
                            10.verticalSpace,
                            Container(
                              width: double.maxFinite,
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 10.h,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEAFBF4),
                                borderRadius: BorderRadius.circular(9.r),
                                border: Border.all(
                                  color: const Color(0xFF32D296),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    size: 15.sp,
                                    color: const Color(0xFF149B72),
                                  ),
                                  7.horizontalSpace,
                                  Expanded(
                                    child: Text(
                                      'Customer confirmed Marc Anderson · Aug 1, 2026',
                                      style: getTextStyle(
                                        fontSize: 9.sp,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFF147A59),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    20.verticalSpace,
                    GestureDetector(
                      onTap: _submit,
                      child: Container(
                        height: 52.h,
                        width: double.maxFinite,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Text(
                          'Submit report for office review',
                          style: getTextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    10.verticalSpace,
                    Text(
                      'The office will review, confirm pricing, capture payment, and mark the job as completed.',
                      textAlign: TextAlign.center,
                      style: getTextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade500,
                        lineHeight: 1.4,
                      ),
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

class _ReportHeader extends StatelessWidget {
  const _ReportHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 22.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(12.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.chevron_left, size: 22.sp, color: Colors.white),
                Text(
                  'Back',
                  style: getTextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          20.verticalSpace,
          Text(
            'Service Report',
            style: getTextStyle(
              fontSize: 19.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          7.verticalSpace,
          Text(
            'View a complete summary of the work completed during your service.',
            style: getTextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  const _ReportCard({
    required this.title,
    required this.child,
    required this.padding,
    this.trailing,
  });

  final String title;
  final Widget child;
  final EdgeInsets padding;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: getTextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF172231),
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          ),
          Padding(padding: padding, child: child),
        ],
      ),
    );
  }
}

class _StatusOption extends StatelessWidget {
  const _StatusOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE8F2FE) : const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          children: [
            Container(
              height: 20.w,
              width: 20.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? AppColors.primary : const Color(0xFF99A7B9),
                  width: 2.w,
                ),
              ),
              alignment: Alignment.center,
              child: selected
                  ? Container(
                      height: 10.w,
                      width: 10.w,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    )
                  : null,
            ),
            10.horizontalSpace,
            Expanded(
              child: Text(
                label,
                style: getTextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: selected ? AppColors.primary : const Color(0xFF172231),
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

class _LabeledTextArea extends StatelessWidget {
  const _LabeledTextArea({
    required this.label,
    required this.controller,
    required this.minLines,
    this.eyebrow,
  });

  final String? eyebrow;
  final String label;
  final TextEditingController controller;
  final int minLines;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
            color: Colors.grey.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (eyebrow != null) ...[
                  Text(
                    eyebrow!,
                    style: getTextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  3.verticalSpace,
                ],
                Text(
                  label,
                  style: getTextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF172231),
                  ),
                ),
              ],
            ),
          ),
          TextField(
            controller: controller,
            minLines: minLines,
            maxLines: minLines + 3,
            style: getTextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF667C9B),
              lineHeight: 1.5,
              textAlign: TextAlign.left,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(12.w),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportPhoto extends StatelessWidget {
  const _ReportPhoto({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.w),
        child: Container(
          height: 72.h,
          decoration: BoxDecoration(
            color: const Color(0xFFFBFCFE),
            borderRadius: BorderRadius.circular(9.r),
            border: Border.all(color: const Color(0xFFDCE5EF)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image_outlined,
                size: 22.sp,
                color: const Color(0xFF92A7C5),
              ),
              6.verticalSpace,
              Text(
                label,
                style: getTextStyle(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF667C9B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimeField extends StatelessWidget {
  const _TimeField({required this.label, required this.controller});

  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: getTextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF172231),
          ),
        ),
        8.verticalSpace,
        TextField(
          controller: controller,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 13.h,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: const BorderSide(color: Color(0xFFDCE1E7)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }
}

class _PartCounterButton extends StatelessWidget {
  const _PartCounterButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isAdd = icon == Icons.add;
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        height: 24.w,
        width: 24.w,
        decoration: BoxDecoration(
          color: isAdd ? AppColors.primary : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: enabled ? AppColors.primary : Colors.grey.shade300,
          ),
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 14.sp,
          color: isAdd
              ? Colors.white
              : enabled
              ? AppColors.primary
              : Colors.grey.shade300,
        ),
      ),
    );
  }
}

class _ConfirmationTile extends StatelessWidget {
  const _ConfirmationTile({
    required this.label,
    required this.selected,
    required this.color,
    required this.backgroundColor,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color color;
  final Color backgroundColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.maxFinite,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(9.r),
          border: Border.all(color: color.withValues(alpha: 0.35)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 18.w,
              width: 18.w,
              decoration: BoxDecoration(
                color: selected ? color : Colors.white,
                borderRadius: BorderRadius.circular(4.r),
                border: Border.all(color: color),
              ),
              alignment: Alignment.center,
              child: selected
                  ? Icon(Icons.check, size: 13.sp, color: Colors.white)
                  : null,
            ),
            10.horizontalSpace,
            Expanded(
              child: Text(
                label,
                style: getTextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF667C9B),
                  lineHeight: 1.4,
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

class _PartItem {
  _PartItem({required this.name});

  final String name;
  int quantity = 1;
}
