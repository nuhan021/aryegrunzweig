enum AsyncViewStatus { idle, loading, success, empty, failure }

class AsyncViewState<T> {
  const AsyncViewState._({required this.status, this.data, this.message});

  const AsyncViewState.idle() : this._(status: AsyncViewStatus.idle);

  const AsyncViewState.loading() : this._(status: AsyncViewStatus.loading);

  const AsyncViewState.success(T data)
    : this._(status: AsyncViewStatus.success, data: data);

  const AsyncViewState.empty() : this._(status: AsyncViewStatus.empty);

  const AsyncViewState.failure(String message)
    : this._(status: AsyncViewStatus.failure, message: message);

  final AsyncViewStatus status;
  final T? data;
  final String? message;

  bool get isLoading => status == AsyncViewStatus.loading;
  bool get hasData => status == AsyncViewStatus.success && data != null;
  bool get isEmpty => status == AsyncViewStatus.empty;
  bool get hasError => status == AsyncViewStatus.failure;
}
