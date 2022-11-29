class BaseResponse {
  String? message;
  String? statusCode;
  bool? success;

  BaseResponse({
    this.message,
    this.statusCode,
    this.success,
  });

  factory BaseResponse.fromJson(Map<String, dynamic> json) {
    return BaseResponse(
      message: json['message'],
      statusCode: json['statusCode'],
      success: json['success'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['success'] = this.success;
    data['statusCode'] = this.statusCode;
    return data;
  }
}
