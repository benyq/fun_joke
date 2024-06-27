import 'package:equatable/equatable.dart';

class ViewState<T> extends Equatable{
  final T? data;
  final int? errorCode;
  final String? errorMessage;
  final ViewStateStatus status;

  const ViewState({this.data, this.errorCode, this.errorMessage, this.status = ViewStateStatus.loading});

  bool isLoading() => status == ViewStateStatus.loading;

  bool isError() => status == ViewStateStatus.error;

  bool isEmpty() => status == ViewStateStatus.empty;

  bool isSuccess() => status == ViewStateStatus.success;


  ViewState<T> successState(T? data) {
    return ViewState(
      data: data,
      status: ViewStateStatus.success,
    );
  }

  ViewState<T> errorState({int? errorCode, String? errorMessage}) {
    return ViewState(
      errorCode: errorCode,
      errorMessage: errorMessage,
      status: ViewStateStatus.error,
    );
  }

  ViewState<T> emptyState() {
    return const ViewState(
      status: ViewStateStatus.empty,
    );
  }

  ViewState<T> loadingState() {
    return const ViewState(
      status: ViewStateStatus.loading,
    );
  }

  copyWith({
    T? data,
    int? errorCode,
    String? errorMessage,
    ViewStateStatus? status,
  }) {
    return ViewState(
      data: data ?? this.data,
      errorCode: errorCode ?? this.errorCode ,
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [data, errorCode, errorMessage, status];
}

enum ViewStateStatus {
  loading,
  empty,
  error,
  success
}


