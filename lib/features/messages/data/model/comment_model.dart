import '../../../../core/consts/app_environment.dart';

class CommentModel {
  final List<CommentEntity>? data;
  final bool? isSuccess;
  final int? statusCode;
  final String? message;

  CommentModel({
    this.data,
    this.isSuccess,
    this.statusCode,
    this.message,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    var data = <CommentEntity>[];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        data.add(
          CommentEntity.fromJson(v),
        );
      });
    }
    return CommentModel(
      isSuccess: json['isSuccess'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: data,
    );
  }
}

class CommentEntity {
/*  {
  "message": "string",
  "personalFullName": "string",
  "categoryPersoneTitle": "string",
  "profileImage": "string",
  "id": 0,
  "createDateFa": "string"
  }*/
  final String? message;
  final String personalFullName;
  final String categoryPersonTitle;
  final String? profileImage;
  final int id;
  final String createDateFa;

  CommentEntity({
    this.message,
    required this.id,
    this.profileImage,
    required this.categoryPersonTitle,
    required this.createDateFa,
    required this.personalFullName,
  });

  factory CommentEntity.fromJson(Map<String, dynamic> json) {
    return CommentEntity(
      id: json['id'],
      categoryPersonTitle: json['categoryPersoneTitle'],
      createDateFa: json['createDateFa'],
      personalFullName: json['personalFullName'],
      message: json['message'],
      profileImage: json['profileImage'] != null
          ? '${AppEnvironment.baseUrl}${json['profileImage']}'
          : null,
    );
  }
}
