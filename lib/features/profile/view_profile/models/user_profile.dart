class UserProfile {
  final String userName;
  final String userEmail;
  final String? profileImageUrl;

  UserProfile({
    required this.userName,
    required this.userEmail,
    this.profileImageUrl,
  });
}
