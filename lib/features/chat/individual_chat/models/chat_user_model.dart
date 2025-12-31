class ChatUser {
  final String id;
  final String name;
  final String company;
  final String avatarInitials;
  final String? avatarUrl;

  ChatUser({
    required this.id,
    required this.name,
    required this.company,
    required this.avatarInitials,
    this.avatarUrl,
  });
}
