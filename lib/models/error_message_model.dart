class ErrorMessageModel {
  int? status;
  String? message;
  String? error;

  ErrorMessageModel({this.status, this.message, this.error});

  factory ErrorMessageModel.fromJson(Map<String, dynamic> json) =>
      ErrorMessageModel(
        status: json['status'],
        message: json['message'],
        error: json['error'],
      );

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'error': error,
  };
}