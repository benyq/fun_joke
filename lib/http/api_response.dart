import 'package:json_annotation/json_annotation.dart';

part 'api_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {
  final String msg;
  final int code;
  final T? data;

  ApiResponse({required this.msg, required this.code, this.data});

  bool get isSuccess => code == 200;

  factory ApiResponse.fromJson(
      Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$ApiResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$ApiResponseToJson(this, toJsonT);

  bool isEmpty() {
    if(data == null) {
      return true;
    } else {
      if(data is List) {
        return (data as List).isEmpty;
      }
      return false;
    }
  }

  bool noMoreData({int pageSize = 0}) {
    if(data == null) {
      return true;
    } else {
      if(data is List) {
        return (data as List).length < pageSize;
      }
      return false;
    }
  }
}