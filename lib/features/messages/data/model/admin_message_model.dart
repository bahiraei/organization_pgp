import '../../../../core/consts/app_environment.dart';

class AdminMessageModel {
  final String title;
  final String? fullText;
  final String? img;
  final String? fullImagePath;
  final String startShowFa;
  final String endShowFa;
  final bool canYouComment;
  final bool isActive;
  final int? personGroupId;
  final String? eventId;
  final String? categoryPersonnelOfficeId;
  final String id;

  AdminMessageModel({
    required this.title,
    this.fullText,
    this.img,
    this.fullImagePath,
    required this.startShowFa,
    required this.endShowFa,
    required this.canYouComment,
    required this.isActive,
    this.personGroupId,
    this.eventId,
    this.categoryPersonnelOfficeId,
    required this.id,
  });

  factory AdminMessageModel.fromJson(dynamic json) {
    return AdminMessageModel(
      title: json['title'],
      img: json['img'],
      fullImagePath: json['fullImagePath'] != null
          ? AppEnvironment.baseUrl + json['fullImagePath']
          : json['fullImagePath'],
      startShowFa: json['startShowFa'],
      endShowFa: json['endShowFa'],
      canYouComment: json['canYouComment'],
      isActive: json['isActive'],
      id: json['id'],
      fullText: json['fullText'],
      categoryPersonnelOfficeId: json['categoryPersonelOfficeId'],
      eventId: json['eventId'],
      personGroupId: json['personGroupId'],
    );
  }
}
