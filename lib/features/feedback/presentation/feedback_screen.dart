import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/helper.dart';
import '../../profile/data/model/profile_model.dart';
import '../data/repository/feedback_repository.dart';
import 'bloc/feedback_bloc.dart';
import 'view/feedback_admin_view.dart';
import 'view/feedback_user_view.dart';

class FeedbackScreen extends StatelessWidget {
  final FeedbackScreenParams screenParams;

  const FeedbackScreen({
    super.key,
    required this.screenParams,
  });

  @override
  Widget build(BuildContext context) {
    Helper.log("isAdmin => ${screenParams.profileData?.isAdmin}");
    if (screenParams.profileData?.isAdmin ?? false) {
      return BlocProvider<FeedbackBloc>(
        create: (context) {
          final bloc = FeedbackBloc(
            repository: feedbackRepository,
            context: context,
          );

          bloc.add(const FeedbackAdminStarted(
            isScrolling: false,
          ));
          return bloc;
        },
        child: FeedbackAdminView(
          profileData: screenParams.profileData,
        ),
      );
    } else {
      return FeedbackUserView(
        profileData: screenParams.profileData,
      );
    }
  }
}

class FeedbackScreenParams {
  final ProfileData? profileData;

  FeedbackScreenParams({
    this.profileData,
  });
}
