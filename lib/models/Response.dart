import 'package:flutter/widgets.dart';

class ResponseModel {
  const ResponseModel({
    @required this.status,
    @required this.code,
    this.message,
    this.data,
  });

  final int status;
  final String code;
  final String message;
  final Map<String, dynamic> data;

  ResponseModel withData(Map<String, dynamic> newData) =>
      ResponseModel(status: status, code: code, message: message, data: newData);

  bool isSuccessful() => (status >= 200 && status < 300);

  factory ResponseModel.fromMap(Map<String, dynamic> json) => ResponseModel(
        status: int.tryParse(json['status']) ?? 500,
        code: json['code'] ?? "",
        message: json['message'] ?? "",
        data: json['data'] ?? {},
      );
}
