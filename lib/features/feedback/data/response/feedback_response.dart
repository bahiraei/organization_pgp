import '../model/feedback.dart';

class FeedbackResponse {
  final List<FeedbackModel> feedbacks;
  final bool? isSuccess;
  final int? statusCode;
  final String? message;

  FeedbackResponse({
    required this.feedbacks,
    this.isSuccess,
    this.statusCode,
    this.message,
  });

  factory FeedbackResponse.fromJson(dynamic json) {
    return FeedbackResponse(
      feedbacks: json['data'] != null
          ? List.from(json['data'])
              .map(
                (feedback) => FeedbackModel.fromJson(feedback),
              )
              .toList()
          : [],
      message: json['message'],
      statusCode: json['statusCode'],
      isSuccess: json['isSuccess'],
    );
  }
}
