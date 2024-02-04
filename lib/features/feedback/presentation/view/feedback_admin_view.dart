import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

import '../../../../core/utils/helper.dart';
import '../../../../core/utils/routes.dart';
import '../../../../core/widgets/app_bg.dart';
import '../../../../core/widgets/bottom_loader.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/empty_bottom_loader.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../core/widgets/title_bar.dart';
import '../../../profile/data/model/profile_model.dart';
import '../../data/model/admin_feedback.dart';
import '../bloc/feedback_bloc.dart';
import '../feedback_details_screen.dart';

class FeedbackAdminView extends StatefulWidget {
  final ProfileData? profileData;

  const FeedbackAdminView({
    super.key,
    this.profileData,
  });

  @override
  State<FeedbackAdminView> createState() => _FeedbackAdminViewState();
}

class _FeedbackAdminViewState extends State<FeedbackAdminView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(
      _onScroll,
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(
        _onScroll,
      )
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<FeedbackBloc>().add(
            const FeedbackAdminStarted(
              isScrolling: true,
            ),
          );
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll /** 0.9*/);
  }

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
    return SafeArea(
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
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
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
                          return const Expanded(
                            child: EmptyView(),
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
                                        const FeedbackAdminStarted(
                                          isScrolling: false,
                                        ),
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
                        } else if (state is FeedbackAdminSuccess) {
                          return ListView.builder(
                            controller: _scrollController,
                            padding: EdgeInsets.fromLTRB(
                                mainMargin, 24, mainMargin, 84),
                            shrinkWrap: true,
                            itemCount: !state.moreData
                                ? state.feedbacks.length
                                : state.feedbacks.length + 1,
                            itemBuilder: (context, index) {
                              if (index >= state.feedbacks.length &&
                                  !state.moreData) {
                                return const EmptyBottomLoader();
                              } else if (index >= state.feedbacks.length &&
                                  state.moreData) {
                                return const BottomLoader();
                              } else {
                                return FeedBackAdminListItem(
                                  feedback: state.feedbacks[index],
                                  profileData: widget.profileData!,
                                );
                              }
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
      ),
    );
  }
}

class FeedBackAdminListItem extends StatefulWidget {
  final ProfileData profileData;
  final AdminFeedbackModel feedback;

  const FeedBackAdminListItem({
    super.key,
    required this.profileData,
    required this.feedback,
  });

  @override
  State<FeedBackAdminListItem> createState() => _FeedBackAdminListItemState();
}

class _FeedBackAdminListItemState extends State<FeedBackAdminListItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final result = await Navigator.of(context).pushNamed(
          Routes.feedbackDetails,
          arguments: FeedbackDetailsScreenParams(
            profileData: widget.profileData,
            adminFeedback: widget.feedback,
          ),
        );

        if (result == true && mounted) {
          BlocProvider.of<FeedbackBloc>(context).add(
            const FeedbackAdminStarted(
              isScrolling: false,
            ),
          );
        }
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
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (widget.feedback.answerDate?.isEmpty ?? true)
                    ? Colors.orange.withOpacity(0.2)
                    : Colors.blue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.feedback.answerDate?.isEmpty ?? true)
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: SvgPicture.asset(
                        width: 24,
                        height: 24,
                        'assets/images/feedback/message-exclamation.svg',
                        colorFilter: const ColorFilter.mode(
                          Colors.orange,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  if (widget.feedback.answerDate?.isNotEmpty ?? false)
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: SvgPicture.asset(
                        width: 24,
                        height: 24,
                        'assets/images/feedback/message-check.svg',
                        colorFilter: const ColorFilter.mode(
                          Colors.blue,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          widget.feedback.title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                      /* if (feedback.answerDate?.isNotEmpty ?? false)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(26),
                          ),
                          child: const Text(
                            'پاسخ داده شده',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),*/
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        widget.feedback.departmentsEnum.value,
                        style: const TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
