import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../../../profile/data/model/profile_model.dart';
import '../../data/model/feedback.dart';
import '../../data/repository/feedback_repository.dart';
import '../bloc/feedback_bloc.dart';
import '../feedback_details_screen.dart';

class FeedbackUserView extends StatefulWidget {
  final ProfileData? profileData;

  const FeedbackUserView({
    super.key,
    this.profileData,
  });

  @override
  State<FeedbackUserView> createState() => _FeedbackUserViewState();
}

class _FeedbackUserViewState extends State<FeedbackUserView> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenSize = Screen.fromContext(context).screenSize;

    double mainMargin = 0;

    if (screenSize == ScreenSize.xsmall) {
      mainMargin = 8;
    } else if (screenSize == ScreenSize.small) {
      mainMargin = 70;
    } else if (screenSize == ScreenSize.medium) {
      mainMargin = 200;
    } else if (screenSize == ScreenSize.large) {
      mainMargin = 450;
    } else if (screenSize == ScreenSize.xlarge) {
      mainMargin = 550;
    }
    return BlocProvider<FeedbackBloc>(
      create: (context) {
        final bloc = FeedbackBloc(
          repository: feedbackRepository,
          context: context,
        );

        bloc.add(FeedbackUserStarted());
        return bloc;
      },
      child: SafeArea(
        child: Scaffold(
          body: AppBackground(
            size: size,
            child: Column(
              children: [
                TitleBar(
                  size: size,
                  title: 'انتقادات و پیشنهادات',
                  onTap: () => Navigator.pop(context),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(32),
                    ),
                    child: Container(
                      padding:
                          EdgeInsets.fromLTRB(mainMargin, 0, mainMargin, 0),
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height,
                      decoration: const BoxDecoration(
                        color: Color(0xfffefefe),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(32),
                        ),
                      ),
                      child: BlocBuilder<FeedbackBloc, FeedbackState>(
                        builder: (BuildContext context, FeedbackState state) {
                          Helper.log(state.toString());

                          if (state is FeedbackLoading ||
                              state is FeedbackInitial) {
                            return const Center(
                              child: SizedBox(
                                height: 32,
                                width: 32,
                                child: CircularProgressIndicator(),
                              ),
                            );
                          } else if (state is FeedbackEmpty) {
                            return const Center(
                              child: Text(
                                'اطلاعاتی یافت نشد',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            );
                          } else if (state is FeedbackError) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    state.exception.message ??
                                        'خطایی رخ داده است',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 44),
                                  SizedBox(
                                    width: null,
                                    child: CustomButton(
                                      width: 120,
                                      height: 44,
                                      backgroundColor: Colors.red,
                                      showShadow: false,
                                      borderRadius: 20,
                                      onPressed: () {
                                        BlocProvider.of<FeedbackBloc>(context)
                                            .add(
                                          FeedbackUserStarted(),
                                        );
                                      },
                                      child: const Text(
                                        'تلاش مجدد',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else if (state is FeedbackUserSuccess) {
                            return ListView.builder(
                              padding: const EdgeInsets.fromLTRB(8, 24, 8, 84),
                              shrinkWrap: true,
                              itemCount: state.feedbacks.length,
                              itemBuilder: (context, index) {
                                return FeedBackUserListItem(
                                  feedback: state.feedbacks[index],
                                  profileData: widget.profileData!,
                                );
                              },
                            );
                          }

                          throw Exception('state not found');
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: BlocBuilder<FeedbackBloc, FeedbackState>(
            builder: (context, state) {
              Helper.log('float state  is => $state');
              if (state is FeedbackEmpty || state is FeedbackUserSuccess) {
                return FloatingActionButton(
                  onPressed: () async {
                    final result = await Navigator.of(context).pushNamed(
                      Routes.applyFeedback,
                    );

                    if (result == true ?? false) {
                      if (mounted) {
                        BlocProvider.of<FeedbackBloc>(context)
                            .add(FeedbackUserStarted());
                      }
                    }
                  },
                  child: const Icon(
                    Icons.add,
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ),
      ),
    );
  }
}

class FeedBackUserListItem extends StatelessWidget {
  final ProfileData profileData;
  final FeedbackModel feedback;

  const FeedBackUserListItem({
    super.key,
    required this.profileData,
    required this.feedback,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          Routes.feedbackDetails,
          arguments: FeedbackDetailsScreenParams(
            profileData: profileData,
            userFeedback: feedback,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              blurRadius: 3,
              color: Colors.black12,
            ),
          ],
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      /* if (feedback.answerDate?.isNotEmpty ?? false)
                        const Badge(
                          backgroundColor: Colors.red,
                        ),
                      if (feedback.answerDate?.isNotEmpty ?? false)
                        const SizedBox(width: 4),*/
                      Flexible(
                        child: Text(
                          feedback.title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Text(
                    feedback.date,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    textDirection: TextDirection.ltr,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  feedback.departmentsEnum.value,
                  style: const TextStyle(
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
