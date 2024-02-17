import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:organization_pgp/core/widgets/empty_view.dart';
import 'package:organization_pgp/core/widgets/error_view.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/consts/app_colors.dart';
import '../../../../core/consts/app_environment.dart';
import '../../../../core/utils/helper.dart';
import '../../../../core/utils/routes.dart';
import '../../../../core/widgets/bottom_loader.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/empty_bottom_loader.dart';
import '../../data/model/meeting_model.dart';
import '../bloc/meeting_bloc.dart';

class MeetingsPageScreen extends StatefulWidget {
  const MeetingsPageScreen({
    super.key,
  });

  @override
  State<MeetingsPageScreen> createState() => _MeetingsPageScreenState();
}

class _MeetingsPageScreenState extends State<MeetingsPageScreen> {
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
      context.read<MeetingBloc>().add(
            const MeetingStarted(
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
    final screenSize = Screen.fromContext(context).screenSize;

    double mainMargin = 0;

    if (screenSize == ScreenSize.xsmall) {
      mainMargin = 16;
    } else if (screenSize == ScreenSize.small) {
      mainMargin = 70;
    } else if (screenSize == ScreenSize.medium) {
      mainMargin = 250;
    } else if (screenSize == ScreenSize.large) {
      mainMargin = 450;
    } else if (screenSize == ScreenSize.xlarge) {
      mainMargin = 600;
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            children: [
              Gap(MediaQuery.of(context).viewPadding.top + 8),
              Row(
                children: [
                  const Gap(8),
                  IconButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back_ios_rounded,
                    ),
                  ),
                  const Gap(32),
                  const Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'جلسات',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(64),
                ],
              ),
            ],
          ),
          BlocBuilder<MeetingBloc, MeetingState>(
            builder: (context, state) {
              Helper.log(state.toString());

              if (state is MeetingLoading || state is MeetingInitial) {
                return const Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 32,
                        width: 32,
                        child: CircularProgressIndicator(),
                      ),
                    ],
                  ),
                );
              } else if (state is MeetingEmpty) {
                return const Expanded(
                  child: EmptyView(),
                );
              } else if (state is MeetingError) {
                return ErrorView(
                  message: state.exception.message,
                  onRetry: () {
                    BlocProvider.of<MeetingBloc>(context).add(
                      const MeetingStarted(
                        isScrolling: false,
                      ),
                    );
                  },
                );
              } else if (state is MeetingSuccess) {
                return Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.symmetric(
                      horizontal: mainMargin,
                      vertical: 32,
                    ),
                    itemCount: !state.moreData
                        ? state.meetings.length
                        : state.meetings.length + 1,
                    itemBuilder: (context, index) {
                      if (index >= state.meetings.length && !state.moreData) {
                        return const EmptyBottomLoader();
                      } else if (index >= state.meetings.length &&
                          state.moreData) {
                        return const BottomLoader();
                      } else {
                        return MeetingListItem(
                          meeting: state.meetings[index],
                        );
                      }
                    },
                  ),
                );
              }

              throw Exception('state not found');
            },
          ),
        ],
      ),
    );
  }
}

class MeetingListItem extends StatelessWidget {
  final MeetingModel meeting;

  const MeetingListItem({
    super.key,
    required this.meeting,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 24,
      ),
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: AppColor.shadow1,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Flexible(
                child: Text(
                  meeting.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const Gap(8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'رئیس جلسه',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const Gap(4),
                  Text(
                    meeting.headOf ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'دبیر جلسه',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    const Gap(4),
                    Text(
                      meeting.secretary ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Gap(24),
          Row(
            children: [
              Flexible(
                child: Text(
                  meeting.description ?? '',
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const Gap(24),
          Column(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xff9a80df).withOpacity(0.24),
                        spreadRadius: 3,
                        blurRadius: 3,
                      ),
                    ],
                    border: Border.all(
                      color: const Color(0xff9a80df),
                    ),
                  ),
                  height: 52,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/meeting/meetingUser.png',
                            width: 30,
                          ),
                          const Gap(10),
                          const Text(
                            'اعضای جلسه',
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xff4a4063),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Color(0xff4a4063),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    Routes.meetingSubscribers,
                    arguments: meeting,
                  );
                },
              ),
              const Gap(12),
              InkWell(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xff9a80df).withOpacity(0.24),
                        spreadRadius: 3,
                        blurRadius: 3,
                      ),
                    ],
                    border: Border.all(
                      color: const Color(0xff9a80df),
                    ),
                  ),
                  height: 52,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/meeting/chatbubbles.png',
                            width: 30,
                          ),
                          const Gap(10),
                          const Text(
                            'موضوعات قابل گفتگو',
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xff4a4063),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Color(0xff4a4063),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    Routes.meetingTitles,
                    arguments: meeting,
                  );
                },
              ),
            ],
          ),
          const Gap(24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (!meeting.isHeld)
                const Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: Color(0xff9a80df),
                      size: 18,
                    ),
                    Gap(4),
                    Text(
                      'برگزار نشده',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff9a80df),
                      ),
                      textDirection: TextDirection.ltr,
                    ),
                  ],
                ),
              if (meeting.isHeld)
                const Row(
                  children: [
                    Icon(
                      Icons.check,
                      color: Colors.green,
                      size: 18,
                    ),
                    Gap(4),
                    Text(
                      'برگزار شده',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.green,
                      ),
                      textDirection: TextDirection.ltr,
                    ),
                  ],
                ),
              Text(
                '# ${meeting.meetingCode ?? '-----'}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xff9a80df),
                ),
                textDirection: TextDirection.ltr,
              ),
            ],
          ),
          const Gap(8),
          const Divider(),
          const Gap(8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            '${meeting.heldDateFa} ${meeting.startTime} زمان برگزاری',
                            style: const TextStyle(
                              fontSize: 13,
                            ),
                            textDirection: TextDirection.ltr,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            meeting.location ?? '',
                            style: const TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (meeting.hasFile && meeting.fullFileName != null)
                ElevatedButton(
                  onPressed: () async {
                    if (meeting.fullFileName != null) {
                      await launchUrl(
                        Uri.parse(
                          AppEnvironment.baseUrl + meeting.fullFileName!,
                        ),
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff9a80df),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'دانلود پیوست',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
