import 'package:image_picker/image_picker.dart';

import '../../../../core/client/http_client.dart';
import '../model/comment_model.dart';
import '../model/info_for_create_message_model.dart';
import '../model/message_model.dart';
import '../response/admin_messages_response.dart';
import '../source/message_data_source.dart';

abstract class IMessageRepository {
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

class MessageRepository implements IMessageRepository {
  final IMessageDataSource dataSource;

  MessageRepository({
    required this.dataSource,
  });

  @override
  Future<MessageModel> getPosts() {
    return dataSource.getPosts();
  }

  @override
  Future<void> read({
    required String id,
  }) {
    return dataSource.read(id: id);
  }

  @override
  Future<CommentModel> getComments({
    required String id,
  }) {
    return dataSource.getComments(
      id: id,
    );
  }

  @override
  Future<void> addComment({
    required String id,
    required String comment,
  }) {
    return dataSource.addComment(
      id: id,
      comment: comment,
    );
  }

  @override
  Future<InfoForeCreateMessageModel> getInfoForCreateMessage() {
    return dataSource.getInfoForCreateMessage();
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
  }) {
    return dataSource.createMessage(
      title: title,
      fullText: fullText,
      canYouComment: canYouComment,
      isActive: isActive,
      startShowFa: startShowFa,
      endShowFa: endShowFa,
      personGroupId: personGroupId,
      eventId: eventId,
      categoryPersoneOfficelId: categoryPersoneOfficelId,
      image: image,
    );
  }

  @override
  Future<AdminMessageResponse> getAllAdminMessages({
    required int page,
    String? searchText,
  }) {
    return dataSource.getAllAdminMessages(
      page: page,
      searchText: searchText,
    );
  }

  @override
  Future<void> sendNotif({
    required String messageID,
  }) {
    return dataSource.sendNotif(
      messageID: messageID,
    );
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
  }) {
    return dataSource.editMessage(
      id: id,
      title: title,
      fullText: fullText,
      canYouComment: canYouComment,
      isActive: isActive,
      startShowFa: startShowFa,
      endShowFa: endShowFa,
      personGroupId: personGroupId,
      eventId: eventId,
      categoryPersoneOfficelId: categoryPersoneOfficelId,
      image: image,
    );
  }
}

final multimediaRepository = MessageRepository(
  dataSource: MessageDataSource(
    dio: httpClient,
  ),
);
