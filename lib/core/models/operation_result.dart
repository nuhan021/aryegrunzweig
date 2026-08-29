class OperationResult<T> {
  const OperationResult._({
    required this.isSuccess,
    required this.statusCode,
    this.data,
    this.errorMessage = '',
  });

  const OperationResult.success(T data, {required int statusCode})
    : this._(isSuccess: true, statusCode: statusCode, data: data);

  const OperationResult.failure({
    required int statusCode,
    required String errorMessage,
  }) : this._(
         isSuccess: false,
         statusCode: statusCode,
         errorMessage: errorMessage,
       );

  final bool isSuccess;
  final int statusCode;
  final T? data;
  final String errorMessage;
}
