import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';
import 'package:gap/gap.dart';

import '../../../core/consts/app_colors.dart';
import '../../../core/consts/app_environment.dart';
import '../../../core/utils/helper.dart';
import '../../../core/widgets/image_loading_service.dart';
import '../data/model/meeting_model.dart';

class MeetingSubscribersScreen extends StatelessWidget {
  final MeetingModel meeting;

  const MeetingSubscribersScreen({
    super.key,
    required this.meeting,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = Screen.fromContext(context).screenSize;

    double mainMargin = 0;

    if (screenSize == ScreenSize.xsmall) {
      mainMargin = 16;
    } else if (screenSize == ScreenSize.small) {
      mainMargin = 70;
    } else if (screenSize == ScreenSize.medium) {
      mainMargin = 200;
    } else if (screenSize == ScreenSize.large) {
      mainMargin = 500;
    } else if (screenSize == ScreenSize.xlarge) {
      mainMargin = 600;
    }

    Helper.log(meeting.members.toString());
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
                          'اعضای گفتگو',
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
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: mainMargin),
              child: Column(
                children: [
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: AppColor.shadow1,
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 24,
                          horizontal: 16,
                        ),
                        margin: const EdgeInsets.fromLTRB(16, 24, 16, 0),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                          ],
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: meeting.members.length,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 32,
                      ),
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    const Color(0xff9a80df).withOpacity(0.24),
                                spreadRadius: 3,
                                blurRadius: 3,
                              ),
                            ],
                            border: Border.all(
                              color: const Color(0xff9a80df),
                            ),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: SizedBox(
                                    width: 64,
                                    height: 64,
                                    child: ImageLoadingService(
                                      imageUrl:
                                          "${AppEnvironment.baseUrl}${meeting.fullFileName}",
                                      borderRadius: BorderRadius.circular(100),
                                      fit: BoxFit.cover,
                                      errorWidget: (context, url, error) {
                                        return Image.asset(
                                          'assets/images/profile/default.png',
                                          width: 64,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              const Gap(8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            meeting.members[index].fullName,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Gap(4),
                                    Row(
                                      children: [
                                        Text(
                                          meeting.members[index]
                                                  .categoryTitle ??
                                              '',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Color(0xff9a80df),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
