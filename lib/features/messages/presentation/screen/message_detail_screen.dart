import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../core/core.dart';
import '../../../audio_player/audio_player_screen.dart';
import '../../../audio_player/domain/params/audio_player_params.dart';
import '../../data/model/comment_model.dart';
import '../../data/model/message_model.dart';
import '../../data/repository/message_repository.dart';
import '../bloc/message_bloc.dart';
import 'bottom_sheet/register_comment_bottom_sheet.dart';
import 'video_play_screen.dart';

class MessageDetailScreenParams {
  final MessageEntity multimediaEntity;

  MessageDetailScreenParams({
    required this.multimediaEntity,
  });
}

class MessageDetailScreen extends StatefulWidget {
  final MessageDetailScreenParams screenParams;

  const MessageDetailScreen({
    super.key,
    required this.screenParams,
  });

  @override
  State<MessageDetailScreen> createState() => _MessageDetailScreenState();
}

class _MessageDetailScreenState extends State<MessageDetailScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    if (!widget.screenParams.multimediaEntity.isReaded) {
      multimediaRepository.read(id: widget.screenParams.multimediaEntity.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final screenSize = Screen.fromContext(context).screenSize;

    double mainMargin = 0;

    if (screenSize == ScreenSize.xsmall) {
      mainMargin = 0;
    } else if (screenSize == ScreenSize.small) {
      mainMargin = 70;
    } else if (screenSize == ScreenSize.medium) {
      mainMargin = 200;
    } else if (screenSize == ScreenSize.large) {
      mainMargin = 400;
    } else if (screenSize == ScreenSize.xlarge) {
      mainMargin = 500;
    }
    return BlocProvider<MessageBloc>(
      create: (context) {
        final bloc = MessageBloc(
          repository: multimediaRepository,
          context: context,
        );

        if (widget.screenParams.multimediaEntity.canYouComment) {
          bloc.add(
            MessageCommentsStarted(
              id: widget.screenParams.multimediaEntity.id!,
            ),
          );
        }

        return bloc;
      },
      child: SafeArea(
        child: Scaffold(
          body: AppBackground(
            size: size,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleBar(
                  size: size,
                  title: 'جزئیات پیام ها',
                  onTap: () => Navigator.pop(context),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(32),
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(32),
                        ),
                      ),
                      child: ScrollConfiguration(
                        behavior: MyScrollBehavior(),
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: mainMargin,
                            ),
                            child: Column(
                              children: [
                                const SizedBox(height: 16),
                                Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(15, 0, 15, 10),
                                  width: size.width,
                                  height: size.height / 3.2,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.horizontal(
                                      right: Radius.circular(0),
                                    ),
                                  ),
                                  child: ImageLoadingService(
                                    imageUrl: AppEnvironment.mediaBaseUrl +
                                        widget.screenParams.multimediaEntity.img
                                            .toString(),
                                    borderRadius: BorderRadius.circular(0),
                                    canZoom: false,
                                    errorWidget: (context, url, error) {
                                      return Padding(
                                        padding: const EdgeInsets.all(18),
                                        child: Image.asset(
                                          AppImages.projectImagePNG,
                                        ),
                                      );
                                    },
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                widget
                                                        .screenParams
                                                        .multimediaEntity
                                                        .title ??
                                                    '',
                                                textAlign: TextAlign.start,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ).animate().fadeIn(),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                widget
                                                        .screenParams
                                                        .multimediaEntity
                                                        .fullText ??
                                                    '',
                                                // textAlign: TextAlign.justify,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  height: 1.8,
                                                ),
                                              ).animate().fadeIn(
                                                    delay: const Duration(
                                                        milliseconds: 300),
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      DefaultTabController(
                                        length: 3,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TabBar(
                                              labelColor: Colors.black,
                                              indicatorColor: Colors.blue,
                                              tabs: [
                                                Tab(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Text(
                                                        "تصویر   ",
                                                        style: TextStyle(
                                                          color: Colors.blue,
                                                        ),
                                                      ),
                                                      Text(
                                                        "${widget.screenParams.multimediaEntity.images?.length ?? 0}",
                                                        style: const TextStyle(
                                                          color: Colors.blue,
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                          fontStyle:
                                                              FontStyle.italic,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Tab(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Text(
                                                        "ویدئو   ",
                                                        style: TextStyle(
                                                          color: Colors.blue,
                                                        ),
                                                      ),
                                                      Text(
                                                        "${widget.screenParams.multimediaEntity.videos?.length ?? 0}",
                                                        style: const TextStyle(
                                                          color: Colors.blue,
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                          fontStyle:
                                                              FontStyle.italic,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Tab(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Text(
                                                        "صدا   ",
                                                        style: TextStyle(
                                                          color: Colors.blue,
                                                        ),
                                                      ),
                                                      Text(
                                                        "${widget.screenParams.multimediaEntity.voices?.length ?? 0}",
                                                        style: const TextStyle(
                                                          color: Colors.blue,
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                          fontStyle:
                                                              FontStyle.italic,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: size.height / 3,
                                              child: TabBarView(
                                                children: [
                                                  if (widget
                                                          .screenParams
                                                          .multimediaEntity
                                                          .images
                                                          ?.isEmpty ??
                                                      true)
                                                    const Center(
                                                      child: Text(
                                                        "موردی برای نمایش وجود ندارد",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    )
                                                  else
                                                    SizedBox(
                                                      height: size.height / 3,
                                                      child: ListView.builder(
                                                        itemCount: widget
                                                                .screenParams
                                                                .multimediaEntity
                                                                .images
                                                                ?.length ??
                                                            0,
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 10),
                                                        itemBuilder:
                                                            (context, index) {
                                                          return GestureDetector(
                                                            onTap: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          ShowImageFullScreen(
                                                                    imageUrl: AppEnvironment
                                                                            .mediaBaseUrl +
                                                                        widget
                                                                            .screenParams
                                                                            .multimediaEntity
                                                                            .images![index]
                                                                            .fileName!,
                                                                    images: widget
                                                                        .screenParams
                                                                        .multimediaEntity
                                                                        .images,
                                                                    selectedImageFromList:
                                                                        index,
                                                                    baseUrl:
                                                                        AppEnvironment
                                                                            .mediaBaseUrl,
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                            child: Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                horizontal: 10,
                                                              ),
                                                              width:
                                                                  size.width /
                                                                      1.2,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15),
                                                                image:
                                                                    DecorationImage(
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  image:
                                                                      NetworkImage(
                                                                    AppEnvironment
                                                                            .mediaBaseUrl +
                                                                        widget
                                                                            .screenParams
                                                                            .multimediaEntity
                                                                            .images![index]
                                                                            .fileName!,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  if (widget
                                                          .screenParams
                                                          .multimediaEntity
                                                          .videos
                                                          ?.isEmpty ??
                                                      true)
                                                    const Center(
                                                      child: Text(
                                                        "موردی برای نمایش وجود ندارد",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    )
                                                  else
                                                    GridView.builder(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        vertical: 24,
                                                      ),
                                                      gridDelegate:
                                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 3,
                                                        crossAxisSpacing: 8,
                                                        mainAxisSpacing: 16,
                                                      ),
                                                      itemCount: widget
                                                              .screenParams
                                                              .multimediaEntity
                                                              .videos
                                                              ?.length ??
                                                          0,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return videoItems(
                                                          size: size,
                                                          videoUrl: AppEnvironment
                                                                  .mediaBaseUrl +
                                                              widget
                                                                  .screenParams
                                                                  .multimediaEntity
                                                                  .videos![
                                                                      index]
                                                                  .fileName!,
                                                        );
                                                      },
                                                    ),
                                                  if (widget
                                                          .screenParams
                                                          .multimediaEntity
                                                          .voices
                                                          ?.isEmpty ??
                                                      true)
                                                    const Center(
                                                      child: Text(
                                                        "موردی برای نمایش وجود ندارد",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    )
                                                  else
                                                    ListView.builder(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        top: 24,
                                                        bottom: 24,
                                                      ),
                                                      itemCount: widget
                                                              .screenParams
                                                              .multimediaEntity
                                                              .voices
                                                              ?.length ??
                                                          0,
                                                      physics:
                                                          const BouncingScrollPhysics(),
                                                      itemBuilder:
                                                          (context, index) {
                                                        final voice = widget
                                                            .screenParams
                                                            .multimediaEntity
                                                            .voices![index];
                                                        Helper.log(AppEnvironment
                                                                .mediaBaseUrl +
                                                            voice.fileName!);
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                            left: 24,
                                                            right: 24,
                                                          ),
                                                          child: InkWell(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                            onTap: () async {
                                                              final Uri uri =
                                                                  Uri.parse(
                                                                AppEnvironment
                                                                        .mediaBaseUrl +
                                                                    voice
                                                                        .fileName!,
                                                              );
                                                              showBottomSheet(
                                                                context:
                                                                    context,
                                                                backgroundColor:
                                                                    Colors
                                                                        .transparent,
                                                                enableDrag:
                                                                    true,
                                                                builder:
                                                                    (context) {
                                                                  return AudioPlayerBottomSheet(
                                                                    audioPlayerParams:
                                                                        AudioPlayerParams(
                                                                      uri: uri,
                                                                      title:
                                                                          'پادکست ${index + 1}',
                                                                    ),
                                                                  );
                                                                },
                                                              );
                                                            },
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Container(
                                                                  height: 60,
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .fromLTRB(
                                                                          48,
                                                                          8,
                                                                          16,
                                                                          8),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
                                                                    color: Colors
                                                                        .white,
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        color: Colors
                                                                            .black
                                                                            .withOpacity(0.20),
                                                                        offset: const Offset(
                                                                            0,
                                                                            3),
                                                                        blurRadius:
                                                                            6,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Container(
                                                                        width:
                                                                            40,
                                                                        height:
                                                                            40,
                                                                        decoration:
                                                                            const BoxDecoration(
                                                                          shape:
                                                                              BoxShape.circle,
                                                                          color:
                                                                              Color(0xff0090FF),
                                                                        ),
                                                                        child:
                                                                            const Icon(
                                                                          Icons
                                                                              .play_arrow_rounded,
                                                                          color:
                                                                              Colors.white,
                                                                          size:
                                                                              20,
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                          width:
                                                                              8),
                                                                      Text(
                                                                        'پادکست ${index + 1}',
                                                                        style:
                                                                            const TextStyle(
                                                                          color:
                                                                              Color(0xff0090FF),
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
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 5),
                                if (widget.screenParams.multimediaEntity
                                    .canYouComment)
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        24, 24, 24, 24),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'دیدگاه کاربران',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Builder(builder: (context) {
                                              return ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color(0xfffe5722),
                                                  shape: RoundedRectangleBorder(
                                                    side: BorderSide.none,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: screenSize !=
                                                                ScreenSize
                                                                    .xsmall &&
                                                            screenSize !=
                                                                ScreenSize.small
                                                        ? 24
                                                        : 12,
                                                    vertical: screenSize !=
                                                                ScreenSize
                                                                    .xsmall &&
                                                            screenSize !=
                                                                ScreenSize.small
                                                        ? 16
                                                        : 8,
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  final result =
                                                      await showModalBottomSheet(
                                                    isScrollControlled: true,
                                                    shape:
                                                        const RoundedRectangleBorder(
                                                      side: BorderSide.none,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(32),
                                                        topLeft:
                                                            Radius.circular(32),
                                                      ),
                                                    ),
                                                    constraints: BoxConstraints(
                                                      maxWidth: screenSize ==
                                                              ScreenSize.xsmall
                                                          ? size.width
                                                          : 600,
                                                    ),
                                                    context: context,
                                                    builder: (context) =>
                                                        RegisterCommentBottomSheet(
                                                      id: widget.screenParams
                                                          .multimediaEntity.id!,
                                                    ),
                                                  );

                                                  if (result && mounted) {
                                                    BlocProvider.of<
                                                                MessageBloc>(
                                                            context)
                                                        .add(
                                                      MessageCommentsStarted(
                                                        id: widget
                                                            .screenParams
                                                            .multimediaEntity
                                                            .id!,
                                                      ),
                                                    );
                                                  }
                                                },
                                                child: const Row(
                                                  children: [
                                                    Icon(
                                                      Icons.comment,
                                                      color: Colors.white,
                                                      size: 14,
                                                    ),
                                                    Gap(8),
                                                    Text(
                                                      'ثبت دیدگاه',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }),
                                          ],
                                        ),
                                        Divider(
                                          color: Colors.grey.shade500,
                                          height: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                if (widget.screenParams.multimediaEntity
                                    .canYouComment)
                                  BlocBuilder<MessageBloc, MessageState>(
                                    builder: (context, state) {
                                      Helper.log('state is $state');

                                      if (state is MessageCommentsSuccess) {
                                        if (state.data.data?.isEmpty ?? true) {
                                          return ConstrainedBox(
                                            constraints: const BoxConstraints(
                                              minHeight: 300,
                                            ),
                                            child: const Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.list,
                                                  color: Colors.black45,
                                                  size: 48,
                                                ),
                                                Gap(24),
                                                Text(
                                                  'دیدگاهی یافت نشد!',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black45,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                        return ListView.builder(
                                          padding: const EdgeInsets.fromLTRB(
                                            24,
                                            0,
                                            24,
                                            32,
                                          ),
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: state.data.data?.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return CommentListItem(
                                              comment: state.data.data![index],
                                            );
                                          },
                                        );
                                      } else if (state
                                              is MessageCommentsLoading ||
                                          state is MessageInitial) {
                                        return Center(
                                          child: ConstrainedBox(
                                            constraints: const BoxConstraints(
                                              minHeight: 300,
                                            ),
                                            child: const Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  height: 32,
                                                  width: 32,
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      } else if (state
                                          is MessageCommentsError) {
                                        return ConstrainedBox(
                                          constraints: const BoxConstraints(
                                            minHeight: 300,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                state.exception.message ??
                                                    'خطایی رخ داده است',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(height: 24),
                                              SizedBox(
                                                width: null,
                                                child: CustomButton(
                                                  width: 84,
                                                  height: 40,
                                                  backgroundColor: Colors.red,
                                                  showShadow: false,
                                                  borderRadius: 20,
                                                  onPressed: () {
                                                    BlocProvider.of<
                                                                MessageBloc>(
                                                            context)
                                                        .add(
                                                      MessageCommentsStarted(
                                                        id: widget
                                                            .screenParams
                                                            .multimediaEntity
                                                            .id!,
                                                      ),
                                                    );
                                                  },
                                                  child: const Text(
                                                    'تلاش مجدد',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 64),
                                            ],
                                          ),
                                        );
                                      }

                                      throw Exception(
                                          'state $state not found!');
                                    },
                                  ),
                              ],
                            ),
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

  Widget videoItems({required Size size, required String videoUrl}) {
    return SizedBox(
      width: 64,
      height: size.height / 6,
      child: Material(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VideoPlayerScreen(videoUrl: videoUrl),
              ),
            );
          },
          child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(5),
            width: size.width / 3.5,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              Icons.play_circle_outlined,
              size: 48,
              color: Colors.white.withOpacity(0.54),
            ),
          ),
        ),
      ),
    );
  }
}

class CommentListItem extends StatelessWidget {
  final CommentEntity comment;

  const CommentListItem({
    super.key,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 200,
      ),
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: AppColor.shadow1,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.blue,
                  ),
                  padding: const EdgeInsets.all(2),
                  child: ImageLoadingService(
                    imageUrl: comment.profileImage ?? '',
                    borderRadius: BorderRadius.circular(100),
                    onTap: null,
                    fit: BoxFit.cover,
                    canView: false,
                    canZoom: false,
                    errorWidget: (context, url, error) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.asset(
                          'assets/images/profile/default.png',
                          width: 50,
                          height: 50,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const Gap(8),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            comment.personalFullName,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            comment.categoryPersonTitle,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                      ],
                    ),
                    const Gap(4),
                    Row(
                      children: [
                        /*Text(
                          comment.categoryPersonTitle,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 6,
                          ),
                          height: 10,
                          width: 1,
                          color: Colors.grey.shade400,
                        ),*/
                        Icon(
                          Icons.watch_later_outlined,
                          color: Colors.grey.shade400,
                          size: 12,
                        ),
                        const Gap(2),
                        Flexible(
                          child: Text(
                            comment.createDateFa,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(
            color: Colors.grey.shade400,
            height: 21,
            indent: 8,
            endIndent: 8,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    comment.message ?? '',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
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
