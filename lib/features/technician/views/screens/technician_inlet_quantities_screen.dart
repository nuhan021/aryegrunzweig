import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../controller/technician_equipment_controller.dart';

class TechnicianInletQuantitiesScreen extends StatefulWidget {
  const TechnicianInletQuantitiesScreen({super.key, required this.controller});

  final TechnicianEquipmentController controller;

  @override
  State<TechnicianInletQuantitiesScreen> createState() =>
      _TechnicianInletQuantitiesScreenState();
}

class _TechnicianInletQuantitiesScreenState
    extends State<TechnicianInletQuantitiesScreen> {
  late final Map<String, Map<String, int>> _draft;

  @override
  void initState() {
    super.initState();
    _draft = widget.controller.inletQuantities.map(
      (floor, values) => MapEntry(floor, Map<String, int>.from(values)),
    );
  }

  void _adjust(String floor, String type, int delta) {
    setState(() {
      final current = _draft[floor]?[type] ?? 0;
      _draft[floor]?[type] = (current + delta).clamp(0, 99);
    });
  }

  Future<void> _save() async {
    final saved = await widget.controller.replaceInletQuantities(_draft);
    if (!saved || !mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Inlet quantities saved.')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const _QuantityHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 30.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tap + or – to adjust vacuum port counts per floor.',
                      style: getTextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF172231),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    22.verticalSpace,
                    ..._draft.entries.map(
                      (floor) => Padding(
                        padding: EdgeInsets.only(bottom: 14.h),
                        child: _FloorQuantityCard(
                          floor: floor.key,
                          quantities: floor.value,
                          onAdjust: (type, delta) =>
                              _adjust(floor.key, type, delta),
                        ),
                      ),
                    ),
                    28.verticalSpace,
                    _QuantityAction(
                      label: 'Save quantities',
                      primary: true,
                      onTap: _save,
                    ),
                    12.verticalSpace,
                    _QuantityAction(
                      label: 'Cancel',
                      onTap: () => Navigator.pop(context),
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

class _QuantityHeader extends StatelessWidget {
  const _QuantityHeader();

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
            'Update Inlet Quantities',
            style: getTextStyle(
              fontSize: 19.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          7.verticalSpace,
          Text(
            'Adjust the quantity for each inlet and save your changes.',
            style: getTextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white,
              lineHeight: 1.4,
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}

class _FloorQuantityCard extends StatelessWidget {
  const _FloorQuantityCard({
    required this.floor,
    required this.quantities,
    required this.onAdjust,
  });

  final String floor;
  final Map<String, int> quantities;
  final void Function(String type, int delta) onAdjust;

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
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
            ),
            child: Text(
              floor,
              style: getTextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF172231),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          ...TechnicianEquipmentController.inletTypes.map(
            (type) => Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      type == 'Chml-Elite' ? 'Chameleon-Elite' : type,
                      style: getTextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF667C9B),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  _CounterButton(
                    icon: Icons.remove,
                    enabled: (quantities[type] ?? 0) > 0,
                    onTap: () => onAdjust(type, -1),
                  ),
                  SizedBox(
                    width: 34.w,
                    child: Text(
                      '${quantities[type] ?? 0}',
                      textAlign: TextAlign.center,
                      style: getTextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF172231),
                      ),
                    ),
                  ),
                  _CounterButton(
                    icon: Icons.add,
                    enabled: true,
                    onTap: () => onAdjust(type, 1),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CounterButton extends StatelessWidget {
  const _CounterButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        height: 30.w,
        width: 30.w,
        decoration: BoxDecoration(
          color: icon == Icons.add ? AppColors.primary : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: enabled ? AppColors.primary : Colors.grey.shade300,
          ),
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 17.sp,
          color: icon == Icons.add
              ? Colors.white
              : enabled
              ? AppColors.primary
              : Colors.grey.shade300,
        ),
      ),
    );
  }
}

class _QuantityAction extends StatelessWidget {
  const _QuantityAction({
    required this.label,
    required this.onTap,
    this.primary = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 54.h,
        width: double.maxFinite,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: primary ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(11.r),
          border: Border.all(color: AppColors.primary),
        ),
        child: Text(
          label,
          style: getTextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: primary ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
