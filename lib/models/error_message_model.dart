class ErrorMessageModel {
  int? statusCode;
  String? message;
  String? error;

  ErrorMessageModel({this.statusCode, this.message, this.error});

  factory ErrorMessageModel.fromJson(Map<String, dynamic> json) =>
      ErrorMessageModel(
        statusCode: json['statusCode'],
        message: json['message'],
        error: json['error'],
      );

  Map<String, dynamic> toJson() => {
    'statusCode': statusCode,
    'message': message,
    'error': error,
  };
}