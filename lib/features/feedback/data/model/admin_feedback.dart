import '../enum/department_enum.dart';

class AdminFeedbackModel {
  /*
  * {
        "files": [
          {
            "fileName": "string",
            "extension": "string",
            "fileTitle": "string",
            "type": 1,
            "size": 0
          }
        ]
      }*/

  final String id;
  final String title;
  final String fullText;
  final int type;
  final String date;
  final String? answer;
  final String? answerDate;
  final DepartmentsEnum departmentsEnum;
  final String personalFullName;
  final String personId;
  final String officeName;
  final List files;

  AdminFeedbackModel({
    required this.id,
    required this.title,
    required this.fullText,
    required this.type,
    required this.date,
    this.answer,
    this.answerDate,
    required this.departmentsEnum,
    required this.personalFullName,
    required this.personId,
    required this.officeName,
    required this.files,
  });

  factory AdminFeedbackModel.fromJson(dynamic json) {
    DepartmentsEnum departmentsEnum = DepartmentsEnum.publicRelation;

    switch (json['type']) {
      case 0:
        departmentsEnum = DepartmentsEnum.publicRelation;
      case 1:
        departmentsEnum = DepartmentsEnum.admin;
    }

    return AdminFeedbackModel(
      id: json['id'],
      title: json['title'],
      fullText: json['fullText'],
      type: json['type'],
      date: json['date'],
      departmentsEnum: departmentsEnum,
      personalFullName: json['personalFullName'],
      personId: json['personId'],
      officeName: json['officeName'],
      answerDate: json['answerDate'],
      answer: json['answer'],
      files: json['files'] ?? [],
    );
  }
}
