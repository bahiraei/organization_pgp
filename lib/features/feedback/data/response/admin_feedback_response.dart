import '../model/admin_feedback.dart';

class AdminFeedbackResponse {
  final List<AdminFeedbackModel> feedbacks;
  final bool? isSuccess;
  final int? statusCode;
  final String? message;
  final bool moreData;

  AdminFeedbackResponse({
    required this.feedbacks,
    this.isSuccess,
    this.statusCode,
    this.message,
    required this.moreData,
  });

  factory AdminFeedbackResponse.fromJson(dynamic json) {
    return AdminFeedbackResponse(
      feedbacks: json['data']['feedbacks'] != null
          ? List.from(json['data']['feedbacks'])
              .map(
                (feedback) => AdminFeedbackModel.fromJson(feedback),
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
