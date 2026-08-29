class PageData<T> {
  const PageData({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  factory PageData.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic> json) itemFromJson,
  ) {
    final rawItems = json['items'];
    return PageData<T>(
      items: rawItems is List
          ? rawItems
                .whereType<Map>()
                .map((item) => itemFromJson(Map<String, dynamic>.from(item)))
                .toList(growable: false)
          : const [],
      total: _asInt(json['total']),
      page: _asInt(json['page'], fallback: 1),
      pageSize: _asInt(json['pageSize'], fallback: 25),
    );
  }

  final List<T> items;
  final int total;
  final int page;
  final int pageSize;

  bool get hasNextPage => page * pageSize < total;
  bool get isEmpty => items.isEmpty;

  static int _asInt(dynamic value, {int fallback = 0}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }
}
