class AsyncValue<T> {
  final T? value;
  final String? error;
  final bool isLoading;

  AsyncValue.loading() : value = null, error = null, isLoading = true;
  AsyncValue.data(this.value) : error = null, isLoading = false;
  AsyncValue.error(this.error) : value = null, isLoading = false;
}
