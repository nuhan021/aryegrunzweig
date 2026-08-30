import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../auth/models/auth_models.dart';
import '../../../data/profile_models.dart';
import '../../controllers/saved_addresses_controller.dart';

class AddressEditorScreen extends StatefulWidget {
  const AddressEditorScreen({
    super.key,
    required this.controller,
    this.existingAddress,
  });

  final SavedAddressesController controller;
  final AddressResponse? existingAddress;

  @override
  State<AddressEditorScreen> createState() => _AddressEditorScreenState();
}

class _AddressEditorScreenState extends State<AddressEditorScreen> {
  late final TextEditingController line1;
  late final TextEditingController apartment;
  late final TextEditingController city;
  late final TextEditingController state;
  late final TextEditingController zipCode;
  late final TextEditingController country;
  late bool isPrimary;

  @override
  void initState() {
    super.initState();
    final value = widget.existingAddress;
    line1 = TextEditingController(text: value?.line1 ?? '');
    apartment = TextEditingController(text: value?.apartment ?? '');
    city = TextEditingController(text: value?.city ?? '');
    state = TextEditingController(text: value?.state ?? '');
    zipCode = TextEditingController(text: value?.zipCode ?? '');
    country = TextEditingController(text: value?.country ?? 'Canada');
    isPrimary = value?.isPrimary ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.existingAddress == null ? 'Add Address' : 'Edit Address',
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(20.w),
        children: [
          _field('Street address *', line1),
          _field('Apartment', apartment),
          _field('City *', city),
          _field('State/Province *', state),
          _field('Postal/Zip code *', zipCode),
          _field('Country', country),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Set as primary address'),
            value: isPrimary,
            onChanged: (value) => setState(() => isPrimary = value),
          ),
          24.verticalSpace,
          Obx(
            () => FilledButton(
              onPressed: widget.controller.isSaving.value ? null : _save,
              child: Text(
                widget.controller.isSaving.value ? 'Saving...' : 'Save Address',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(String label, TextEditingController controller) => Padding(
    padding: EdgeInsets.only(bottom: 14.h),
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    ),
  );

  Future<void> _save() async {
    if ([
      line1.text,
      city.text,
      state.text,
      zipCode.text,
    ].any((value) => value.trim().isEmpty)) {
      Get.snackbar('Error', 'Complete all required address fields.');
      return;
    }
    final success = await widget.controller.saveAddress(
      existing: widget.existingAddress,
      request: AddressRequest(
        line1: line1.text.trim(),
        apartment: apartment.text.trim().isEmpty ? null : apartment.text.trim(),
        city: city.text.trim(),
        state: state.text.trim(),
        zipCode: zipCode.text.trim(),
        country: country.text.trim().isEmpty ? 'Canada' : country.text.trim(),
        latitude: widget.existingAddress?.latitude,
        longitude: widget.existingAddress?.longitude,
        isPrimary: isPrimary,
      ),
    );
    if (success && mounted) Navigator.of(context).pop();
  }

  @override
  void dispose() {
    line1.dispose();
    apartment.dispose();
    city.dispose();
    state.dispose();
    zipCode.dispose();
    country.dispose();
    super.dispose();
  }
}
