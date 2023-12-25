import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/exception/http_response_validator.dart';
import '../model/comment_model.dart';
import '../model/info_for_create_message_model.dart';
import '../model/message_model.dart';
import '../response/admin_messages_response.dart';

abstract class IMessageDataSource {
  Future<MessageModel> getPosts();

  Future<void> read({
    required String id,
  });

  Future<CommentModel> getComments({
    required String id,
  });

  Future<void> addComment({
    required String id,
    required String comment,
  });

  Future<InfoForeCreateMessageModel> getInfoForCreateMessage();

  Future<void> createMessage({
    required String title,
    required String? fullText,
    required bool canYouComment,
    required bool isActive,
    required String startShowFa,
    required String endShowFa,
    required int? personGroupId,
    required String? eventId,
    required String? categoryPersoneOfficelId,
    required XFile? image,
  });

  Future<AdminMessageResponse> getAllAdminMessages({
    required int page,
    String? searchText,
  });

  Future<void> sendNotif({
    required String messageID,
  });

  Future<void> editMessage({
    required String id,
    required String title,
    required String? fullText,
    required bool canYouComment,
    required bool isActive,
    required String startShowFa,
    required String endShowFa,
    required int? personGroupId,
    required String? eventId,
    required String? categoryPersoneOfficelId,
    required XFile? image,
  });
}

class MessageDataSource
    with HttpResponseValidator
    implements IMessageDataSource {
  final Dio dio;

  MessageDataSource({
    required this.dio,
  });

  @override
  Future<MessageModel> getPosts() async {
    final response = await dio.post(
      '/api/Message/GetActive',
    );

    final validated = validateResponse(response);

    return MessageModel.fromJson(validated.data);
  }

  @override
  Future<void> read({
    required String id,
  }) async {
    final response = await dio.post(
      '/api/Message/Read',
      data: {
        'data': id,
      },
    );

    validateResponse(response);
  }

  @override
  Future<CommentModel> getComments({
    required String id,
  }) async {
    final response = await dio.post(
      '/api/Message/GetComments',
      data: {
        'data': id,
      },
    );

    final validated = validateResponse(response);

    return CommentModel.fromJson(validated.data);
  }

  @override
  Future<void> addComment({
    required String id,
    required String comment,
  }) async {
    final response = await dio.post(
      '/api/Message/RegisterComment',
      data: {
        "message": comment,
        "messageId": id,
      },
    );

    final validated = validateResponse(response);
  }

  @override
  Future<InfoForeCreateMessageModel> getInfoForCreateMessage() async {
    final response = await dio.post(
      '/api/Message/GetInfoForCreateMessage',
    );

    final validated = validateResponse(response);

    return InfoForeCreateMessageModel.fromJson(validated.data);
  }

  @override
  Future<void> createMessage({
    required String title,
    required String? fullText,
    required bool canYouComment,
    required bool isActive,
    required String startShowFa,
    required String endShowFa,
    required int? personGroupId,
    required String? eventId,
    required String? categoryPersoneOfficelId,
    required XFile? image,
  }) async {
    FormData formData = FormData.fromMap(
      {
        "title": title,
        "fullText": fullText,
        "canYouComment": canYouComment,
        "isActive": isActive,
        "startShowFa": startShowFa,
        "endShowFa": endShowFa,
        "personGroupId": personGroupId,
        "eventId": eventId,
        "categoryPersonelOfficeId": categoryPersoneOfficelId
      },
    );

    if (image != null) {
      formData.files.add(
        MapEntry(
          'FirstImageFile',
          kIsWeb
              ? MultipartFile.fromBytes(
                  await image.readAsBytes(),
                  filename: image.name,
                )
              : MultipartFile.fromFileSync(
                  image.path!,
                  filename: image.name,
                ),
        ),
      );
    }

    final response = await dio.post(
      '/api/Message/CreateOrEditMessage',
      data: formData,
    );

    final validated = validateResponse(response);
  }

  @override
  Future<AdminMessageResponse> getAllAdminMessages({
    required int page,
    String? searchText,
  }) async {
    final response = await dio.post(
      '/api/Message/GetMessageListForEdit',
      data: {
        "searchText": searchText,
        "page": page,
      },
    );

    final validated = validateResponse(response);

    return AdminMessageResponse.fromJson(validated.data);
  }

  @override
  Future<void> sendNotif({
    required String messageID,
  }) async {
    final response = await dio.post(
      '/api/Message/SendNotif',
      data: {
        "data": messageID,
      },
    );

    final validated = validateResponse(response);
  }

  @override
  Future<void> editMessage({
    required String id,
    required String title,
    required String? fullText,
    required bool canYouComment,
    required bool isActive,
    required String startShowFa,
    required String endShowFa,
    required int? personGroupId,
    required String? eventId,
    required String? categoryPersoneOfficelId,
    required XFile? image,
  }) async {
    FormData formData = FormData.fromMap(
      {
        "id": id,
        "title": title,
        "fullText": fullText,
        "canYouComment": canYouComment,
        "isActive": isActive,
        "startShowFa": startShowFa,
        "endShowFa": endShowFa,
        "personGroupId": personGroupId,
        "eventId": eventId,
        "categoryPersonelOfficeId": categoryPersoneOfficelId
      },
    );

    if (image != null) {
      formData.files.add(
        MapEntry(
          'FirstImageFile',
          kIsWeb
              ? MultipartFile.fromBytes(
                  await image.readAsBytes(),
                  filename: image.name,
                )
              : MultipartFile.fromFileSync(
                  image.path!,
                  filename: image.name,
                ),
        ),
      );
    }

    final response = await dio.post(
      '/api/Message/CreateOrEditMessage',
      data: formData,
    );

    final validated = validateResponse(response);
  }
}
