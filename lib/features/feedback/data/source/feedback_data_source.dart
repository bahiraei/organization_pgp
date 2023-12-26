import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/exception/http_response_validator.dart';
import '../response/admin_feedback_response.dart';
import '../response/feedback_response.dart';

abstract class IFeedbackDataSource {
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

class FeedbackDataSource
    with HttpResponseValidator
    implements IFeedbackDataSource {
  final Dio dio;

  FeedbackDataSource({
    required this.dio,
  });

  @override
  Future<FeedbackResponse> getAll() async {
    final response = await dio.post(
      '/api/Feedback/Get',
    );

    final validated = validateResponse(response);

    return FeedbackResponse.fromJson(validated.data);
  }

  @override
  Future<void> save({
    required String title,
    required String description,
    required int type,
    required List<PlatformFile> files,
  }) async {
    FormData formData = FormData.fromMap(
      {
        "Title": title,
        "FullText": description,
        "Type": type,
      },
    );

    for (PlatformFile file in files) {
      formData.files.add(
        MapEntry(
          'Files',
          kIsWeb
              ? MultipartFile.fromBytes(
                  file.bytes!,
                  filename: file.name,
                )
              : MultipartFile.fromFileSync(
                  file.path!,
                  filename: file.name,
                ),
        ),
      );
    }
    final response = await dio.post(
      '/api/Feedback/Save',
      data: formData,
    );

    final validated = validateResponse(response);
  }

  @override
  Future<AdminFeedbackResponse> getAllAdmin({
    required int page,
  }) async {
    final response = await dio.post(
      '/api/Feedback/GetAdmin',
      data: {
        "data": page,
      },
    );

    final validated = validateResponse(response);

    return AdminFeedbackResponse.fromJson(validated.data);
  }

  @override
  Future<void> answerAdmin({
    required String text,
    required String feedbackId,
  }) async {
    final response = await dio.post(
      '/api/Feedback/AnswerAdmin',
      data: {
        "text": text,
        "feedbackId": feedbackId,
      },
    );

    final validated = validateResponse(response);
  }
}
