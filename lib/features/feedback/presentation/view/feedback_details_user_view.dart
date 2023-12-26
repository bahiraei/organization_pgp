import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

import '../../../../core/widgets/app_bg.dart';
import '../../../../core/widgets/title_bar.dart';
import '../../data/model/feedback.dart';

class FeedbackDetailsUserView extends StatelessWidget {
  final FeedbackModel feedback;

  const FeedbackDetailsUserView({
    super.key,
    required this.feedback,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenSize = Screen.fromContext(context).screenSize;

    double mainMargin = 0;

    if (screenSize == ScreenSize.xsmall) {
      mainMargin = 16;
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
                    padding: EdgeInsets.fromLTRB(mainMargin, 0, mainMargin, 0),
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height,
                    decoration: const BoxDecoration(
                      color: Color(0xfffefefe),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(32),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 32),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 5,
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
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(26),
                                ),
                                child: Text(
                                  feedback.departmentsEnum.value,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  feedback.title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 24,
                            ),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: const Color(0xfff1f0ff),
                            ),
                            child: Text(
                              feedback.fullText ?? '',
                              style: const TextStyle(
                                fontSize: 14,
                                height: 2,
                              ),
                            ),
                          ),
                          if (feedback.answerDate?.isNotEmpty ?? false)
                            Column(
                              children: [
                                const SizedBox(height: 16),
                                const Divider(
                                  indent: 24,
                                  endIndent: 24,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 24,
                                  ),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: Colors.blue.shade100,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'پاسخ:',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        feedback.fullText ?? '',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          height: 2,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            feedback.answerDate ?? '',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              height: 2,
                                            ),
                                            textDirection: TextDirection.ltr,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 64),
                              ],
                            ),
                        ],
                      ),
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
