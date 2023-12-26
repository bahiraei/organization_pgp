import '../enum/department_enum.dart';

class FeedbackModel {
  final String id;
  final String title;
  final String fullText;
  final int type;
  final String date;
  final String? answer;
  final String? answerDate;
  final DepartmentsEnum departmentsEnum;

  FeedbackModel({
    required this.id,
    required this.title,
    required this.fullText,
    required this.type,
    required this.date,
    this.answer,
    this.answerDate,
    required this.departmentsEnum,
  });

  factory FeedbackModel.fromJson(dynamic json) {
    DepartmentsEnum departmentsEnum = DepartmentsEnum.publicRelation;

    switch (json['type']) {
      case 0:
        departmentsEnum = DepartmentsEnum.publicRelation;
      case 1:
        departmentsEnum = DepartmentsEnum.admin;
    }

    return FeedbackModel(
      id: json['id'],
      title: json['title'],
      fullText: json['fullText'],
      type: json['type'],
      date: json['date'],
      answer: json['answer'],
      answerDate: json['answerDate'],
      departmentsEnum: departmentsEnum,
    );
  }
}
