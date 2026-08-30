import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'edit_profile_form_field.dart';

class EditProfileForm extends StatelessWidget {
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController companyController;
  final TextEditingController addressController;
  final TextEditingController apartmentController;
  final TextEditingController cityController;
  final TextEditingController stateController;
  final TextEditingController zipController;
  final ValueChanged<String>? onFullNameChanged;
  final ValueChanged<String>? onEmailChanged;
  final ValueChanged<String>? onPhoneChanged;
  final ValueChanged<String>? onAddressChanged;
  final ValueChanged<String>? onApartmentChanged;
  final ValueChanged<String>? onCityChanged;
  final ValueChanged<String>? onStateChanged;
  final ValueChanged<String>? onZipChanged;

  const EditProfileForm({
    super.key,
    required this.fullNameController,
    required this.emailController,
    required this.phoneController,
    required this.companyController,
    required this.addressController,
    required this.apartmentController,
    required this.cityController,
    required this.stateController,
    required this.zipController,
    this.onFullNameChanged,
    this.onEmailChanged,
    this.onPhoneChanged,
    this.onAddressChanged,
    this.onApartmentChanged,
    this.onCityChanged,
    this.onStateChanged,
    this.onZipChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16.h,
      children: [
        EditProfileFormField(
          label: 'Full Name',
          hintText: 'John Smith',
          icon: Icons.person,
          controller: fullNameController,
          onChanged: onFullNameChanged,
        ),
        EditProfileFormField(
          label: 'Email Address',
          hintText: 'john.smith@email.com',
          icon: Icons.email,
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          onChanged: onEmailChanged,
          enabled: false,
        ),
        EditProfileFormField(
          label: 'Phone Number',
          hintText: '+1 (555) 123-4567',
          icon: Icons.phone,
          controller: phoneController,
          keyboardType: TextInputType.phone,
          onChanged: onPhoneChanged,
        ),
        EditProfileFormField(
          label: 'Company',
          hintText: 'Company name',
          icon: Icons.business,
          controller: companyController,
        ),
        EditProfileFormField(
          label: 'Address',
          hintText: 'Street Address',
          icon: Icons.location_on,
          controller: addressController,
          onChanged: onAddressChanged,
        ),
        EditProfileFormField(
          label: 'Apartment',
          hintText: 'Apartment Number',
          icon: Icons.apartment,
          controller: apartmentController,
          onChanged: onApartmentChanged,
        ),
        EditProfileFormField(
          label: 'City',
          hintText: 'City Name',
          icon: Icons.location_city,
          controller: cityController,
          onChanged: onCityChanged,
        ),
        EditProfileFormField(
          label: 'State',
          hintText: 'State',
          icon: Icons.map,
          controller: stateController,
          onChanged: onStateChanged,
        ),
        EditProfileFormField(
          label: 'Zip',
          hintText: 'Zip Code',
          icon: Icons.pin_drop,
          controller: zipController,
          keyboardType: TextInputType.number,
          onChanged: onZipChanged,
        ),
      ],
    );
  }
}
