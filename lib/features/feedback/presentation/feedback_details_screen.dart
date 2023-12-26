import 'package:flutter/material.dart';

import '../../profile/data/model/profile_model.dart';
import '../data/model/admin_feedback.dart';
import '../data/model/feedback.dart';
import 'view/feedback_details_admin_view.dart';
import 'view/feedback_details_user_view.dart';

class FeedbackDetailsScreen extends StatelessWidget {
  final FeedbackDetailsScreenParams screenParams;

  const FeedbackDetailsScreen({
    super.key,
    required this.screenParams,
  });

  @override
  Widget build(BuildContext context) {
    if (screenParams.profileData?.isAdmin ?? false) {
      return FeedbackDetailsAdminView(
        feedback: screenParams.adminFeedback!,
      );
    } else {
      return FeedbackDetailsUserView(
        feedback: screenParams.userFeedback!,
      );
    }
  }
}

class FeedbackDetailsScreenParams {
  final ProfileData? profileData;
  final FeedbackModel? userFeedback;
  final AdminFeedbackModel? adminFeedback;

  FeedbackDetailsScreenParams({
    this.profileData,
    this.userFeedback,
    this.adminFeedback,
  });
}
