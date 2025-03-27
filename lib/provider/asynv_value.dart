class AsyncValue<T> {
  final T? data;
  final bool isLoading;
  final String? error;

  AsyncValue._({this.data, this.isLoading = false, this.error});

  factory AsyncValue.loading() => AsyncValue._(isLoading: true);

  factory AsyncValue.data(T data) => AsyncValue._(data: data);

  factory AsyncValue.error(String error) => AsyncValue._(error: error);
}