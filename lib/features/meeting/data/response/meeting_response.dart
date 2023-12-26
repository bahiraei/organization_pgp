import '../model/meeting_model.dart';

class MeetingResponse {
  final List<MeetingModel> meetings;
  final bool moreData;
  final bool? isSuccess;
  final int? statusCode;
  final String? message;

  MeetingResponse({
    required this.meetings,
    required this.moreData,
    this.isSuccess,
    this.statusCode,
    this.message,
  });

  factory MeetingResponse.fromJson(dynamic json) {
    return MeetingResponse(
      meetings: json['data']['meetings'] != null
          ? List.from(json['data']['meetings'])
              .map(
                (meeting) => MeetingModel.fromJson(meeting),
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
