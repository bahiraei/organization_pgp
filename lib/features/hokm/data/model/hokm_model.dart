class HokmModel {
  final String? data;
  final bool? isSuccess;
  final int? statusCode;
  final String? message;

  HokmModel({
    this.data,
    this.isSuccess,
    this.statusCode,
    this.message,
  });

  factory HokmModel.fromJson(Map json) {
    return HokmModel(
      data: json['data'].toString(),
      isSuccess: json['isSuccess'],
      statusCode: json['statusCode'],
      message: json['message'],
    );
  }
}
