import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../controller/technician_equipment_controller.dart';
import 'technician_edit_equipment_screen.dart';
import 'technician_inlet_quantities_screen.dart';

class TechnicianEquipmentScreen extends StatelessWidget {
  const TechnicianEquipmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<TechnicianEquipmentController>()
        ? Get.find<TechnicianEquipmentController>()
        : Get.put(TechnicianEquipmentController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const _EquipmentHeader(),
            Expanded(
              child: Obx(() {
                final floors = controller.inletQuantities.entries.toList();
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                return SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 28.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.maxFinite,
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 13.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF8EE),
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(color: const Color(0xFFFFC878)),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 20.sp,
                              color: const Color(0xFFD97706),
                            ),
                            10.horizontalSpace,
                            Expanded(
                              child: Text(
                                'Visible to technicians and admin only.',
                                style: getTextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF9A4E0A),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      24.verticalSpace,
                      _InfoTable(
                        title: 'Main Vacuum Unit',
                        rows: [
                          ('Unit number', controller.unitNumber.value),
                          ('Manufacturer', controller.manufacturer.value),
                          ('Model', controller.model.value),
                          ('Serial number', controller.serialNumber.value),
                          ('Location', controller.location.value),
                          (
                            'Previous condition',
                            controller.previousCondition.value,
                          ),
                        ],
                      ),
                      24.verticalSpace,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              'Floor-wise Vacuum Port Inventory',
                              maxLines: 2,
                              style: getTextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF172231),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          12.horizontalSpace,
                          GestureDetector(
                            onTap: () => _addFloor(context, controller),
                            child: Text(
                              '+ Add Floor',
                              style: getTextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primary,
                              ).copyWith(decoration: TextDecoration.underline),
                            ),
                          ),
                        ],
                      ),
                      12.verticalSpace,
                      _InventoryTable(floors: floors),
                      22.verticalSpace,
                      Text(
                        'Additional Features',
                        style: getTextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF172231),
                        ),
                      ),
                      12.verticalSpace,
                      _InfoTable(
                        title: 'Features',
                        rows: controller.additionalFeatures.isEmpty
                            ? const [('None recorded', '')]
                            : controller.additionalFeatures
                                  .map((feature) => (feature, ''))
                                  .toList(growable: false),
                      ),
                      40.verticalSpace,
                      _OutlineButton(
                        label: 'Edit equipment details',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TechnicianEditEquipmentScreen(
                              controller: controller,
                            ),
                          ),
                        ),
                      ),
                      12.verticalSpace,
                      _OutlineButton(
                        label: 'Update inlet quantities',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TechnicianInletQuantitiesScreen(
                              controller: controller,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addFloor(
    BuildContext context,
    TechnicianEquipmentController controller,
  ) async {
    final floorController = TextEditingController();
    final floor = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add floor'),
        content: TextField(
          controller: floorController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Floor name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, floorController.text),
            child: const Text('Add'),
          ),
        ],
      ),
    );
    floorController.dispose();
    if (floor != null) controller.addFloor(floor);
  }
}

class _EquipmentHeader extends StatelessWidget {
  const _EquipmentHeader();

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
            'Equipment & Vacuum Ports',
            style: getTextStyle(
              fontSize: 19.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          7.verticalSpace,
          Text(
            'Record the equipment details and the condition of all vacuum ports.',
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

class _InfoTable extends StatelessWidget {
  const _InfoTable({required this.title, required this.rows});

  final String title;
  final List<(String, String)> rows;

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
              title,
              style: getTextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF172231),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          ...rows.asMap().entries.map(
            (entry) => _TableRow(
              label: entry.value.$1,
              value: entry.value.$2,
              isLast: entry.key == rows.length - 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _TableRow extends StatelessWidget {
  const _TableRow({
    required this.label,
    required this.value,
    required this.isLast,
  });

  final String label;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: getTextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF667C9B),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: getTextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF172231),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InventoryTable extends StatelessWidget {
  const _InventoryTable({required this.floors});

  final List<MapEntry<String, Map<String, int>>> floors;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          _inventoryRow([
            'Floor',
            'HDH',
            'Chameleon',
            'Chml-Elite',
            'Standard',
          ], header: true),
          ...floors.map(
            (floor) => _inventoryRow([
              floor.key,
              for (final type in TechnicianEquipmentController.inletTypes)
                (floor.value[type] ?? 0).toString().padLeft(2, '0'),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _inventoryRow(List<String> values, {bool header = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
      color: header ? Colors.grey.shade50 : Colors.white,
      child: Row(
        children: values.asMap().entries.map((entry) {
          return Expanded(
            flex: entry.key == 0 ? 2 : 1,
            child: Text(
              entry.value,
              textAlign: entry.key == 0 ? TextAlign.left : TextAlign.center,
              style: getTextStyle(
                fontSize: entry.key == 0 ? 10.sp : 9.sp,
                fontWeight: header ? FontWeight.w500 : FontWeight.w400,
                color: header
                    ? const Color(0xFF172231)
                    : const Color(0xFF667C9B),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  const _OutlineButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 54.h,
        width: double.maxFinite,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(11.r),
          border: Border.all(color: AppColors.primary),
        ),
        child: Text(
          label,
          style: getTextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
