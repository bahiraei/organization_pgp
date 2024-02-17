import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organization_pgp/core/widgets/empty_view.dart';
import 'package:organization_pgp/core/widgets/error_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../core/core.dart';
import '../../data/repository/message_repository.dart';
import '../bloc/message_bloc.dart';
import 'message_detail_screen.dart';

class MessageScreen extends StatefulWidget {
  final String? id;

  const MessageScreen({
    super.key,
    this.id,
  });

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final _refreshController = RefreshController();

  @override
  void initState() {
    Helper.log('Redirect Id => ${widget.id}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenSize = Screen.fromContext(context).screenSize;

    double mainMargin = 16;
    double imageWidthSize = 150;
    if (screenSize == ScreenSize.xsmall) {
      mainMargin = 16;
      imageWidthSize = size.width / 3;
    } else if (screenSize == ScreenSize.small) {
      mainMargin = 70;
      imageWidthSize = 150;
    } else if (screenSize == ScreenSize.medium) {
      mainMargin = 150;
      imageWidthSize = 150;
    } else if (screenSize == ScreenSize.large) {
      mainMargin = 400;
      imageWidthSize = 150;
    } else if (screenSize == ScreenSize.xlarge) {
      mainMargin = 400;
      imageWidthSize = 150;
    }

    return BlocProvider<MessageBloc>(
      create: (context) {
        final bloc = MessageBloc(
          repository: multimediaRepository,
          context: context,
        );

        bloc.add(
          MessageStarted(
            isRefreshing: false,
            id: widget.id,
          ),
        );
        return bloc;
      },
      child: SafeArea(
        child: Scaffold(
          body: Builder(
            builder: (context) {
              return SmartRefresher(
                header: const MaterialClassicHeader(
                  backgroundColor: Colors.blue,
                  color: Colors.white,
                ),
                controller: _refreshController,
                onRefresh: () {
                  BlocProvider.of<MessageBloc>(context).add(
                    const MessageStarted(
                      isRefreshing: true,
                    ),
                  );
                },
                child: AppBackground(
                  size: size,
                  child: Column(
                    children: [
                      TitleBar(
                        size: size,
                        title: "پیام ها",
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(32),
                          ),
                          child: Container(
                            padding: EdgeInsets.fromLTRB(
                                mainMargin, 0, mainMargin, 0),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(32),
                              ),
                            ),
                            child: BlocConsumer<MessageBloc, MessageState>(
                              listener: (context, state) async {
                                if (_refreshController.isRefresh) {
                                  if (state is MessageSuccess ||
                                      state is MessageEmpty) {
                                    _refreshController.refreshCompleted();
                                  } else if (state is MessageError) {
                                    _refreshController.refreshFailed();
                                  }
                                }

                                if (state is MessageSuccess) {
                                  if (state.redirectEntity != null) {
                                    await Navigator.of(context).pushNamed(
                                      Routes.messageDetails,
                                      arguments: MessageDetailScreenParams(
                                        multimediaEntity: state.redirectEntity!,
                                      ),
                                    );
                                  }
                                }
                              },
                              buildWhen: (previous, current) =>
                                  current is! MessageRefreshing,
                              builder: (context, state) {
                                Helper.log(state.toString());

                                if (state is MessageLoading ||
                                    state is MessageInitial) {
                                  return const Center(
                                    child: SizedBox(
                                      height: 32,
                                      width: 32,
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                } else if (state is MessageEmpty) {
                                  return const Expanded(
                                    child: EmptyView(),
                                  );
                                } else if (state is MessageError) {
                                  return ErrorView(
                                    message: state.exception.message,
                                    onRetry: () {
                                      BlocProvider.of<MessageBloc>(context).add(
                                        const MessageStarted(
                                          isRefreshing: false,
                                        ),
                                      );
                                    },
                                  );
                                } else if (state is MessageSuccess) {
                                  return ScrollConfiguration(
                                    behavior: MyScrollBehavior(),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: state.data.data?.length,
                                      padding: const EdgeInsets.only(
                                        top: 24,
                                        bottom: 24,
                                      ),
                                      itemBuilder: (context, index) {
                                        final post = state.data.data![index];
                                        return Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              5, 5, 5, 8),
                                          child: GestureDetector(
                                            onTap: () async {
                                              await Navigator.of(context)
                                                  .pushNamed(
                                                Routes.messageDetails,
                                                arguments:
                                                    MessageDetailScreenParams(
                                                  multimediaEntity: post,
                                                ),
                                              );

                                              if (mounted) {
                                                BlocProvider.of<MessageBloc>(
                                                        context)
                                                    .add(
                                                  const MessageStarted(
                                                      isRefreshing: true),
                                                );
                                              }
                                            },
                                            child: Container(
                                              width: double.infinity,
                                              height: 150,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: Colors.white,
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Colors.black45,
                                                    offset: Offset(0, 1),
                                                    blurRadius: 1.8,
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: imageWidthSize,
                                                    /*height: 120,*/
                                                    height: double.infinity,
                                                    decoration:
                                                        const BoxDecoration(
                                                      borderRadius: BorderRadius
                                                          .horizontal(
                                                        right:
                                                            Radius.circular(10),
                                                      ),
                                                    ),
                                                    child: ImageLoadingService(
                                                      imageUrl: AppEnvironment
                                                              .mediaBaseUrl +
                                                          post.img.toString(),
                                                      borderRadius:
                                                          const BorderRadius
                                                              .horizontal(
                                                        right:
                                                            Radius.circular(10),
                                                      ),
                                                      canZoom: false,
                                                      errorWidget: (context,
                                                          url, error) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(18),
                                                          child: Image.asset(
                                                            AppImages
                                                                .projectImagePNG,
                                                          ),
                                                        );
                                                      },
                                                      fit: BoxFit.cover,
                                                      onTap: () async {
                                                        await Navigator.of(
                                                                context)
                                                            .pushNamed(
                                                          Routes.messageDetails,
                                                          arguments:
                                                              MessageDetailScreenParams(
                                                            multimediaEntity:
                                                                post,
                                                          ),
                                                        );

                                                        if (mounted) {
                                                          BlocProvider.of<
                                                                      MessageBloc>(
                                                                  context)
                                                              .add(
                                                            const MessageStarted(
                                                                isRefreshing:
                                                                    true),
                                                          );
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const SizedBox(
                                                            height: 12),
                                                        Text(
                                                          "${post.title}",
                                                          textAlign:
                                                              TextAlign.start,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 13,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 20),
                                                        Row(
                                                          children: [
                                                            const Icon(
                                                              Icons
                                                                  .date_range_outlined,
                                                              size: 20,
                                                              color: Colors
                                                                  .black87,
                                                            ),
                                                            const SizedBox(
                                                                width: 5),
                                                            Text(
                                                              "${post.date}",
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black87,
                                                              ),
                                                              textDirection:
                                                                  TextDirection
                                                                      .ltr,
                                                            ),
                                                          ],
                                                        ),
                                                        const Spacer(),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                const Icon(
                                                                  Icons
                                                                      .camera_alt,
                                                                  color: Colors
                                                                      .black87,
                                                                  size: 20,
                                                                ),
                                                                const SizedBox(
                                                                    width: 3),
                                                                Text(
                                                                  "${post.images?.length ?? 0}",
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .black87,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    width: 10),
                                                                const Icon(
                                                                  Icons
                                                                      .keyboard_voice_outlined,
                                                                  color: Colors
                                                                      .black87,
                                                                  size: 20,
                                                                ),
                                                                const SizedBox(
                                                                    width: 3),
                                                                Text(
                                                                  "${post.voices?.length ?? 0}",
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .black87,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    width: 10),
                                                                const Icon(
                                                                  Icons
                                                                      .video_call_rounded,
                                                                  color: Colors
                                                                      .black87,
                                                                  size: 20,
                                                                ),
                                                                const SizedBox(
                                                                    width: 3),
                                                                Text(
                                                                  "${post.videos?.length ?? 0}",
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .black87,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            if (!post.isReaded)
                                                              const Icon(
                                                                Icons
                                                                    .circle_notifications_rounded,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                            height: 10),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(width: 12),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
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
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }
}
