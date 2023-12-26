import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/consts/app_environment.dart';
import '../../../../core/utils/helper.dart';
import '../../../../core/widgets/app_bg.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/custom_text_form_field.dart';
import '../../../../core/widgets/show_image_full_screen.dart';
import '../../../../core/widgets/title_bar.dart';
import '../../data/model/admin_feedback.dart';
import '../../data/repository/feedback_repository.dart';
import '../bloc/feedback_bloc.dart';

class FeedbackDetailsAdminView extends StatefulWidget {
  final AdminFeedbackModel feedback;

  const FeedbackDetailsAdminView({
    super.key,
    required this.feedback,
  });

  @override
  State<FeedbackDetailsAdminView> createState() =>
      _FeedbackDetailsAdminViewState();
}

class _FeedbackDetailsAdminViewState extends State<FeedbackDetailsAdminView> {
  final formKey = GlobalKey<FormState>();
  final descriptionController = TextEditingController();

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

    return BlocProvider<FeedbackBloc>(
      create: (context) => FeedbackBloc(
        repository: feedbackRepository,
        context: context,
      ),
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
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height,
                      decoration: const BoxDecoration(
                        color: Color(0xfffefefe),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(32),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: mainMargin,
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 32),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(24, 0, 24, 0),
                                child: Row(
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
                                        widget.feedback.date,
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
                                        widget.feedback.departmentsEnum.value,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 32),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(24, 0, 24, 0),
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        widget.feedback.title,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 24,
                                ),
                                margin: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: const Color(0xfff1f0ff),
                                ),
                                child: Text(
                                  widget.feedback.fullText ?? '',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    height: 2,
                                  ),
                                ),
                              ),
                              if (widget.feedback.files.isNotEmpty)
                                const SizedBox(height: 16),
                              if (widget.feedback.files.isNotEmpty)
                                SizedBox(
                                  height: 80,
                                  child: ListView.builder(
                                    padding:
                                        const EdgeInsets.fromLTRB(24, 0, 24, 0),
                                    itemCount: widget.feedback.files.length,
                                    scrollDirection: Axis.horizontal,
                                    physics: const BouncingScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      final file = widget.feedback.files[index];

                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(left: 16),
                                        child: InkWell(
                                          onTap: () async {
                                            try {
                                              if (file['fileName']
                                                      .toString()
                                                      .endsWith('.png') ||
                                                  file['fileName']
                                                      .toString()
                                                      .endsWith('.jpg')) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ShowImageFullScreen(
                                                      imageUrl:
                                                          '${AppEnvironment.projectStatusBaseUrl}${file['fileName']}',
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                launchUrl(
                                                  Uri.parse(
                                                      '${AppEnvironment.projectStatusBaseUrl}${file['fileName']}'),
                                                );
                                              }
                                            } catch (e) {
                                              launchUrl(
                                                Uri.parse(
                                                    '${AppEnvironment.projectStatusBaseUrl}${file['fileName']}'),
                                              );
                                            }
                                          },
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: 60,
                                                width: 190,
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                  16,
                                                  8,
                                                  16,
                                                  8,
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.20),
                                                      offset:
                                                          const Offset(0, 3),
                                                      blurRadius: 6,
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: 40,
                                                      height: 40,
                                                      decoration:
                                                          const BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color:
                                                            Color(0xff0090FF),
                                                      ),
                                                      child: const Icon(
                                                        Icons
                                                            .file_present_rounded,
                                                        color: Colors.white,
                                                        size: 20,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Expanded(
                                                      child: Text(
                                                        file['fileTitle'],
                                                        style: const TextStyle(
                                                          overflow:
                                                              TextOverflow.fade,
                                                          color:
                                                              Color(0xff0090FF),
                                                          fontSize: 13,
                                                        ),
                                                        maxLines: 1,
                                                        textDirection:
                                                            TextDirection.ltr,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              if (widget.feedback.files.isNotEmpty)
                                const SizedBox(height: 16),
                              if (widget.feedback.answerDate?.isNotEmpty ??
                                  false)
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(24, 0, 24, 0),
                                  child: Column(
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
                                          borderRadius:
                                              BorderRadius.circular(16),
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
                                              widget.feedback.fullText ?? '',
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
                                                  widget.feedback.answerDate ??
                                                      '',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    height: 2,
                                                  ),
                                                  textDirection:
                                                      TextDirection.ltr,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 64),
                                    ],
                                  ),
                                ),
                              if (widget.feedback.answerDate?.isEmpty ?? true)
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(24, 0, 24, 0),
                                  child:
                                      BlocConsumer<FeedbackBloc, FeedbackState>(
                                    listener: (context, state) {
                                      if (state is FeedbackApplyAdminSuccess) {
                                        Navigator.of(context).pop(true);
                                      } else if (state is FeedbackError) {
                                        Helper.showToast(
                                          title: 'پیام!',
                                          description:
                                              state.exception.message ??
                                                  "خطا در ثبت پاسخ",
                                          context: context,
                                        );
                                      }
                                    },
                                    builder: (context, state) {
                                      return Form(
                                        key: formKey,
                                        child: Column(
                                          children: [
                                            const SizedBox(height: 16),
                                            const Divider(
                                              indent: 24,
                                              endIndent: 24,
                                              color: Colors.grey,
                                            ),
                                            const SizedBox(height: 16),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 0),
                                              child: CustomTextFormField(
                                                label: const Text(
                                                  'پاسخ',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                hintText: 'پاسخ را وارد کنید',
                                                maxLines: 4,
                                                controller:
                                                    descriptionController,
                                                showClearButton: true,
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                  vertical: 16,
                                                ),
                                                hintStyle: const TextStyle(
                                                  fontSize: 15,
                                                ),
                                                validator: (value) {
                                                  if (value?.isEmpty ?? true) {
                                                    return 'پاسخ را وارد کنید';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                            const SizedBox(height: 24),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 0),
                                              child: AppButton(
                                                text: 'ثبت پاسخ',
                                                isLoading:
                                                    state is FeedbackLoading,
                                                onClick: () {
                                                  if (formKey.currentState!
                                                      .validate()) {
                                                    BlocProvider.of<
                                                                FeedbackBloc>(
                                                            context)
                                                        .add(
                                                      FeedbackApplyAdminStarted(
                                                        text:
                                                            descriptionController
                                                                .text,
                                                        feedbackId:
                                                            widget.feedback.id,
                                                      ),
                                                    );
                                                  }
                                                },
                                                height: 54,
                                              ),
                                            )
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
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
