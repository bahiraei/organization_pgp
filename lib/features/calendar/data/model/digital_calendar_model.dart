import '../../../meeting/data/model/meeting_model.dart';
import 'event_model.dart';

class DigitalCalendarModel {
  final String date;
  final String dayOfWeek;
  final int dayOfMonthNumber;
  final String monthName;
  final int count;
  final List<EventModel> events;
  final List<MeetingModel> meetings;

  DigitalCalendarModel({
    required this.date,
    required this.dayOfWeek,
    required this.dayOfMonthNumber,
    required this.monthName,
    required this.count,
    required this.events,
    required this.meetings,
  });

  factory DigitalCalendarModel.fromJson(dynamic json) {
    return DigitalCalendarModel(
      date: json['date'],
      dayOfWeek: json['dayOfWeek'],
      dayOfMonthNumber: json['dayOfMonthNumber'],
      monthName: json['monthName'],
      count: json['count'],
      events: json['events'] != null
          ? List.from(json['events'])
              .map(
                (e) => EventModel.fromJson(e),
              )
              .toList()
          : [],
      meetings: json['meeting'] != null
          ? List.from(json['meeting'])
              .map(
                (e) => MeetingModel.fromJson(e),
              )
              .toList()
          : [],
    );
  }
}
