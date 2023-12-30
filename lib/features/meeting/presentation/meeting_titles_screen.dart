import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';
import 'package:gap/gap.dart';

import '../../../core/consts/app_colors.dart';
import '../data/model/meeting_model.dart';

class MeetingTitleScreen extends StatelessWidget {
  final MeetingModel meeting;

  const MeetingTitleScreen({
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
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          meeting.title,
                          style: const TextStyle(
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
            child: Column(
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
                  margin: EdgeInsets.symmetric(
                    vertical: 24,
                    horizontal: mainMargin,
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
                      const Gap(16),
                      const Divider(
                        height: 0,
                        color: Colors.black12,
                      ),
                      const Gap(16),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: meeting.negotiables.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              boxShadow: AppColor.shadow,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                const Gap(8),
                                Text(
                                  meeting.negotiables[index].subject,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
