class ResponseData {
  const ResponseData({
    required this.isSuccess,
    required this.statusCode,
    required this.errorMessage,
    required this.responseData,
  });

  final bool isSuccess;
  final int statusCode;
  final String errorMessage;
  final dynamic responseData;

  bool get isUnauthorized => statusCode == 401;

  bool get isNetworkError => statusCode == 0 || statusCode == 408;

  T? dataAs<T>() => responseData is T ? responseData as T : null;
}
