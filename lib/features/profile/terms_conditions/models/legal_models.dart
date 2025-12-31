class TermsSection {
  final int number;
  final String title;
  final String content;
  final List<String>? bulletPoints;

  TermsSection({
    required this.number,
    required this.title,
    required this.content,
    this.bulletPoints,
  });
}

class PrivacySection {
  final int number;
  final String title;
  final String content;
  final List<String>? bulletPoints;

  PrivacySection({
    required this.number,
    required this.title,
    required this.content,
    this.bulletPoints,
  });
}
