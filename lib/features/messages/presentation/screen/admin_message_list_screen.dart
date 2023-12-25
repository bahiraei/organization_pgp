import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../../../../core/widgets/bottom_loader.dart';
import '../../../../core/widgets/empty_bottom_loader.dart';
import '../../data/model/admin_message_model.dart';
import '../../data/repository/message_repository.dart';
import '../bloc/message_bloc.dart';
import 'admin_message_detail_screen.dart';

class AdminMessageListScreen extends StatelessWidget {
  const AdminMessageListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MessageBloc>(
      create: (context) {
        final bloc = MessageBloc(
          repository: multimediaRepository,
          context: context,
        );

        bloc.add(const MessageAdminStarted(
          isScrolling: false,
        ));
        return bloc;
      },
      child: const AdminMessageListSubScreen(),
    );
  }
}

class AdminMessageListSubScreen extends StatefulWidget {
  const AdminMessageListSubScreen({
    super.key,
  });

  @override
  State<AdminMessageListSubScreen> createState() =>
      _AdminMessageListSubScreenState();
}

class _AdminMessageListSubScreenState extends State<AdminMessageListSubScreen> {
  final _scrollController = ScrollController();

  final searchController = TextEditingController();

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
      context.read<MessageBloc>().add(
            const MessageAdminStarted(
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
      mainMargin = 0;
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
                title: 'لیست پیام ها',
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
                    child: BlocConsumer<MessageBloc, MessageState>(
                      listener: (context, state) {
                        if (state is MessageSendNotifSuccess) {
                          Helper.showToast(
                              title: 'موفق!',
                              description: 'عملیات با موفقیت انجام شد',
                              context: context);
                        } else if (state is MessageNotifError) {
                          Helper.showToast(
                            title: 'خطا!',
                            description:
                                state.exception.message ?? 'خطا در ارسال اعلان',
                            context: context,
                          );
                        }
                      },
                      buildWhen: (previous, current) =>
                          current is! MessageNotifError &&
                          current is! MessageSendNotifSuccess &&
                          current is! MessageSendNotifLoading,
                      builder: (BuildContext context, MessageState state) {
                        Helper.log(state.toString());

                        if (state is MessageLoading ||
                            state is MessageInitial) {
                          return Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 24,
                                  left: mainMargin,
                                  right: mainMargin,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          hintText: 'جستجو',
                                          hintStyle: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54,
                                          ),
                                          alignLabelWithHint: true,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 16,
                                          ),
                                          filled: true,
                                          fillColor: Colors.black12,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(24),
                                            borderSide: BorderSide.none,
                                          ),
                                          suffixIcon: IconButton(
                                            onPressed: () {},
                                            icon: const Icon(
                                              Icons.search,
                                            ),
                                          ),
                                        ),
                                        keyboardType: TextInputType.text,
                                        /*onTapOutside: (event) =>
                                            FocusScope.of(context).unfocus(),*/
                                        maxLines: 1,
                                        controller: searchController,
                                        onChanged: (value) {
                                          context.read<MessageBloc>().add(
                                                MessageAdminStarted(
                                                  isScrolling: false,
                                                  searchText:
                                                      searchController.text,
                                                ),
                                              );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Expanded(
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
                              ),
                            ],
                          );
                        } else if (state is MessageEmpty) {
                          return Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 24,
                                  left: mainMargin,
                                  right: mainMargin,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          hintText: 'جستجو',
                                          hintStyle: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54,
                                          ),
                                          alignLabelWithHint: true,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 16,
                                          ),
                                          filled: true,
                                          fillColor: Colors.black12,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(24),
                                            borderSide: BorderSide.none,
                                          ),
                                          suffixIcon: IconButton(
                                            onPressed: () {},
                                            icon: const Icon(
                                              Icons.search,
                                            ),
                                          ),
                                        ),
                                        keyboardType: TextInputType.text,
                                        /*onTapOutside: (event) =>
                                            FocusScope.of(context).unfocus(),*/
                                        maxLines: 1,
                                        controller: searchController,
                                        onChanged: (value) {
                                          context.read<MessageBloc>().add(
                                                MessageAdminStarted(
                                                  isScrolling: false,
                                                  searchText:
                                                      searchController.text,
                                                ),
                                              );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'اطلاعاتی یافت نشد',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        } else if (state is MessageError) {
                          return Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 24,
                                  left: mainMargin,
                                  right: mainMargin,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          hintText: 'جستجو',
                                          hintStyle: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54,
                                          ),
                                          alignLabelWithHint: true,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 16,
                                          ),
                                          filled: true,
                                          fillColor: Colors.black12,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(24),
                                            borderSide: BorderSide.none,
                                          ),
                                          suffixIcon: IconButton(
                                            onPressed: () {},
                                            icon: const Icon(
                                              Icons.search,
                                            ),
                                          ),
                                        ),
                                        keyboardType: TextInputType.text,
                                        /*onTapOutside: (event) =>
                                            FocusScope.of(context).unfocus(),*/
                                        maxLines: 1,
                                        controller: searchController,
                                        onChanged: (value) {
                                          context.read<MessageBloc>().add(
                                                MessageAdminStarted(
                                                  isScrolling: false,
                                                  searchText:
                                                      searchController.text,
                                                ),
                                              );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
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
                                          BlocProvider.of<MessageBloc>(context)
                                              .add(
                                            const MessageAdminStarted(
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
                              ),
                            ],
                          );
                        } else if (state is MessageAdminSuccess) {
                          return Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 24,
                                  left: mainMargin,
                                  right: mainMargin,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          hintText: 'جستجو',
                                          hintStyle: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54,
                                          ),
                                          alignLabelWithHint: true,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 16,
                                          ),
                                          filled: true,
                                          fillColor: Colors.black12,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(24),
                                            borderSide: BorderSide.none,
                                          ),
                                          suffixIcon: IconButton(
                                            onPressed: () {},
                                            icon: const Icon(
                                              Icons.search,
                                            ),
                                          ),
                                        ),
                                        keyboardType: TextInputType.text,
                                        /*onTapOutside: (event) =>
                                            FocusScope.of(context).unfocus(),*/
                                        maxLines: 1,
                                        controller: searchController,
                                        onChanged: (value) {
                                          context.read<MessageBloc>().add(
                                                MessageAdminStarted(
                                                  isScrolling: false,
                                                  searchText:
                                                      searchController.text,
                                                ),
                                              );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  controller: _scrollController,
                                  padding: EdgeInsets.fromLTRB(
                                    mainMargin,
                                    24,
                                    mainMargin,
                                    84,
                                  ),
                                  /*shrinkWrap: true,*/
                                  itemCount: !state.moreData
                                      ? state.messages.length
                                      : state.messages.length + 1,
                                  itemBuilder: (context, index) {
                                    if (index >= state.messages.length &&
                                        !state.moreData) {
                                      return const EmptyBottomLoader();
                                    } else if (index >= state.messages.length &&
                                        state.moreData) {
                                      return const BottomLoader();
                                    } else {
                                      return Column(
                                        children: [
                                          AdminMessageListItem(
                                            message: state.messages[index],
                                          ),
                                        ],
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
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
        floatingActionButton: Builder(builder: (context) {
          return FloatingActionButton(
            onPressed: () async {
              await Navigator.of(context).pushNamed(Routes.createMessage);

              if (mounted) {
                BlocProvider.of<MessageBloc>(context).add(
                  const MessageAdminStarted(
                    isScrolling: false,
                  ),
                );
              }
            },
            child: const Icon(Icons.add),
          );
        }),
      ),
    );
  }
}

class AdminMessageListItem extends StatefulWidget {
  final AdminMessageModel message;

  const AdminMessageListItem({
    super.key,
    required this.message,
  });

  @override
  State<AdminMessageListItem> createState() => _AdminMessageListItemState();
}

class _AdminMessageListItemState extends State<AdminMessageListItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 5, 5, 8),
      child: Builder(builder: (context) {
        return GestureDetector(
          onTap: () async {
            await Navigator.of(context).pushNamed(
              Routes.createMessageDetailsList,
              arguments: AdminMessageDetailScreenParams(
                  adminMessageModel: widget.message),
            );

            if (mounted) {
              context.read<MessageBloc>().add(
                    const MessageAdminStarted(
                      isScrolling: false,
                    ),
                  );
              /*BlocProvider.of<MessageBloc>(context).add(
                const MessageAdminStarted(
                  isScrolling: false,
                ),
              );*/
            }
          },
          child: Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
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
                  width: 120,
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.horizontal(
                      right: Radius.circular(10),
                    ),
                  ),
                  child: ImageLoadingService(
                    imageUrl: widget.message.fullImagePath.toString(),
                    borderRadius: const BorderRadius.horizontal(
                      right: Radius.circular(10),
                    ),
                    canZoom: false,
                    errorWidget: (context, url, error) {
                      return Padding(
                        padding: const EdgeInsets.all(18),
                        child: Image.asset(
                          AppImages.projectImagePNG,
                        ),
                      );
                    },
                    fit: BoxFit.cover,
                    onTap: () async {
                      Navigator.of(context).pushNamed(
                        Routes.createMessageDetailsList,
                        arguments: AdminMessageDetailScreenParams(
                            adminMessageModel: widget.message),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(height: 12),
                      Text(
                        widget.message.title,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.date_range_outlined,
                                size: 20,
                                color: Colors.black87,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                widget.message.startShowFa,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                                textDirection: TextDirection.ltr,
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () async {
                              final bool result = await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Dialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Container(
                                          width: 300,
                                          padding: const EdgeInsets.fromLTRB(
                                            16,
                                            24,
                                            16,
                                            24,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                Icons
                                                    .notification_important_rounded,
                                                size: 38,
                                                color: Colors.black54,
                                              ),
                                              const SizedBox(height: 25),
                                              const Text(
                                                'آیا از ارسال اعلان اطمینان دارید؟',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  color: Color(AppColor
                                                      .gradiantDarkColor),
                                                ),
                                              ),
                                              const SizedBox(height: 32),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 14),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: CustomButton(
                                                        onPressed: () async {
                                                          Navigator.of(context)
                                                              .pop(true);
                                                        },
                                                        showShadow: false,
                                                        backgroundColor:
                                                            Colors.blue,
                                                        height: 38,
                                                        elevation: 2,
                                                        child: const Text(
                                                          'بله',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 18),
                                                    Expanded(
                                                      child: CustomButton(
                                                        onPressed: () =>
                                                            Navigator.of(
                                                                    context)
                                                                .pop(false),
                                                        showShadow: false,
                                                        backgroundColor:
                                                            Colors.red,
                                                        height: 38,
                                                        elevation: 2,
                                                        child: const Text(
                                                          'خیر',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12,
                                                          ),
                                                        ),
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
                                  ) ??
                                  false;

                              if (mounted) {
                                if (result) {
                                  Helper.log(widget.message.id);
                                  BlocProvider.of<MessageBloc>(context).add(
                                    MessageSendNotifStarted(
                                      messageId: widget.message.id,
                                    ),
                                  );
                                }
                              }
                            },
                            icon: const Icon(
                              Icons.notifications,
                              color: Colors.blue,
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
      }),
    );
  }
}
