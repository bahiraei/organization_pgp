import 'member_model.dart';
import 'negotiable_model.dart';

class MeetingModel {
  final String id;
  final String title;
  final String? description;
  final String? type;
  final bool isHeld;
  final String? headOf;
  final String? secretary;
  final String? location;
  final String? heldDateFa;
  final String startTime;
  final String endTime;
  final String? meetingCode;
  final List<MemberModel> members;
  final List<NegotiableModel> negotiables;
  final String? fullFileName;
  final bool hasFile;

  MeetingModel({
    required this.id,
    required this.title,
    this.description,
    this.type,
    required this.isHeld,
    this.headOf,
    this.secretary,
    this.location,
    this.heldDateFa,
    required this.startTime,
    required this.endTime,
    this.meetingCode,
    required this.members,
    required this.negotiables,
    this.fullFileName,
    required this.hasFile,
  });

  factory MeetingModel.fromJson(Map<String, dynamic> json) {
    var data = <MeetingModel>[];

    return MeetingModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: json['type'],
      isHeld: json['isHeld'],
      headOf: json['headOf'],
      secretary: json['secretary'],
      location: json['location'],
      heldDateFa: json['heldDateFa'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      meetingCode: json['meetingCode'],
      fullFileName: json['fullFileName'],
      hasFile: json['hasFile'],
      members: json['members'] != null
          ? List.from(json['members'])
              .map(
                (e) => MemberModel.fromJson(e),
              )
              .toList()
          : [],
      negotiables: json['negotiableItems'] != null
          ? List.from(json['negotiableItems'])
              .map(
                (e) => NegotiableModel.fromJson(e),
              )
              .toList()
          : [],
    );
  }
}
