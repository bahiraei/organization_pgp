import '../model/digital_calendar_model.dart';

class DigitalCalendarResponse {
  final List<DigitalCalendarModel> digitalCalendars;
  final bool? isSuccess;
  final int? statusCode;
  final String? message;

  DigitalCalendarResponse({
    required this.digitalCalendars,
    this.isSuccess,
    this.statusCode,
    this.message,
  });

  factory DigitalCalendarResponse.fromJson(dynamic json) {
    return DigitalCalendarResponse(
      digitalCalendars: json['data'] != null
          ? List.from(json['data'])
              .map(
                (digitalCalendar) => DigitalCalendarModel.fromJson(
                  digitalCalendar,
                ),
              )
              .toList()
          : [],
      message: json['message'],
      statusCode: json['statusCode'],
      isSuccess: json['isSuccess'],
    );
  }
}
