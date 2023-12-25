import '../model/admin_message_model.dart';

class AdminMessageResponse {
  final List<AdminMessageModel> messages;
  final bool? isSuccess;
  final int? statusCode;
  final String? message;
  final bool moreData;

  AdminMessageResponse({
    required this.messages,
    this.isSuccess,
    this.statusCode,
    this.message,
    required this.moreData,
  });

  factory AdminMessageResponse.fromJson(dynamic json) {
    return AdminMessageResponse(
      messages: json['data']['messages'] != null
          ? List.from(json['data']['messages'])
              .map(
                (message) => AdminMessageModel.fromJson(message),
              )
              .toList()
          : [],
      moreData: json['data']['moreData'],
      message: json['message'],
      statusCode: json['statusCode'],
      isSuccess: json['isSuccess'],
    );
  }
}
