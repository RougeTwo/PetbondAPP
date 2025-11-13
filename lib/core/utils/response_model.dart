class ResponseModel {
  final int statusCode;
  final String? message;
  final dynamic body;

  ResponseModel({required this.statusCode, this.message, this.body});

  factory ResponseModel.fromJson(int statusCode, dynamic json) {
    return ResponseModel(
      statusCode: statusCode,
      message: json['message'],
      body: json['data'],
    );
  }
}
