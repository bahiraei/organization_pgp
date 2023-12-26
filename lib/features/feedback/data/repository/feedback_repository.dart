import 'package:file_picker/file_picker.dart';

import '../../../../core/client/http_client.dart';
import '../response/admin_feedback_response.dart';
import '../response/feedback_response.dart';
import '../source/feedback_data_source.dart';

abstract class IFeedbackRepository {
  Future<FeedbackResponse> getAll();

  Future<void> save({
    required String title,
    required String description,
    required int type,
    required List<PlatformFile> files,
  });

  Future<AdminFeedbackResponse> getAllAdmin({
    required int page,
  });

  Future<void> answerAdmin({
    required String text,
    required String feedbackId,
  });
}

class FeedbackRepository implements IFeedbackRepository {
  final IFeedbackDataSource dataSource;

  FeedbackRepository({
    required this.dataSource,
  });

  @override
  Future<FeedbackResponse> getAll() {
    return dataSource.getAll();
  }

  @override
  Future<void> save({
    required String title,
    required String description,
    required int type,
    required List<PlatformFile> files,
  }) {
    return dataSource.save(
      title: title,
      description: description,
      type: type,
      files: files,
    );
  }

  @override
  Future<AdminFeedbackResponse> getAllAdmin({
    required int page,
  }) {
    return dataSource.getAllAdmin(
      page: page,
    );
  }

  @override
  Future<void> answerAdmin({
    required String text,
    required String feedbackId,
  }) {
    return dataSource.answerAdmin(
      feedbackId: feedbackId,
      text: text,
    );
  }
}

final feedbackRepository = FeedbackRepository(
  dataSource: FeedbackDataSource(
    dio: httpClient,
  ),
);
