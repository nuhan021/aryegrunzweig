class EditProfileData {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String address;
  final String apartment;
  final String city;
  final String state;
  final String zipCode;
  final String? profileImageUrl;

  EditProfileData({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.apartment,
    required this.city,
    required this.state,
    required this.zipCode,
    this.profileImageUrl,
  });
}
