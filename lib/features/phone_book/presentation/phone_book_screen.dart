import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/utils/helper.dart';
import '../../../core/utils/routes.dart';
import '../../../core/widgets/app_bg.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/title_bar.dart';
import '../data/repository/phone_repository.dart';
import 'bloc/phone_bloc.dart';

class PhoneBookScreen extends StatefulWidget {
  const PhoneBookScreen({super.key});

  @override
  State<PhoneBookScreen> createState() => _PhoneBookScreenState();
}

class _PhoneBookScreenState extends State<PhoneBookScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<PhoneBloc>(
      create: (context) {
        final bloc = PhoneBloc(
          phoneRepository: phoneRepository,
          context: context,
        );

        /*bloc.add(
          const PhoneStarted(
            isRefreshing: false,
            searchTag: null,
          ),
        );*/
        return bloc;
      },
      child: const PhoneBookSubScreen(),
    );
  }
}

class PhoneBookSubScreen extends StatefulWidget {
  const PhoneBookSubScreen({super.key});

  @override
  State<PhoneBookSubScreen> createState() => _PhoneBookSubScreenState();
}

class _PhoneBookSubScreenState extends State<PhoneBookSubScreen> {
  TextEditingController searchController = TextEditingController();

  Timer? _timer;

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
      mainMargin = 500;
    } else if (screenSize == ScreenSize.xlarge) {
      mainMargin = 600;
    }
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: AppBackground(
          size: size,
          child: Column(
            children: [
              TitleBar(
                size: size,
                title: 'دفتر تلفن',
                onTap: () => Navigator.pop(context),
                child: Builder(builder: (context) {
                  return InkWell(
                    onTap: () {
                      BlocProvider.of<PhoneBloc>(context).add(
                        const PhoneStarted(
                          isRefreshing: true,
                          searchTag: null,
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.refresh_outlined,
                      color: Colors.white,
                      size: 30,
                    ),
                  );
                }),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.fromLTRB(mainMargin, 0, mainMargin, 0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(32),
                    ),
                  ),
                  child: Column(
                    children: [
                      Builder(builder: (context) {
                        return Padding(
                          padding: const EdgeInsets.only(
                            right: 16,
                            left: 16,
                            bottom: 16,
                            top: 24,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'L',
                                    style: TextStyle(
                                      color: Color(0xff4786ea),
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'E',
                                    style: TextStyle(
                                      color: Color(0xffda3337),
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'T',
                                    style: TextStyle(
                                      color: Color(0xff3bbb55),
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    ' ',
                                    style: TextStyle(
                                      color: Colors.orange,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'C',
                                    style: TextStyle(
                                      color: Color(0xff4786ea),
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'P',
                                    style: TextStyle(
                                      color: Color(0xfff3c30b),
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'I',
                                    style: TextStyle(
                                      color: Color(0xffda3337),
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'B',
                                    style: TextStyle(
                                      color: Color(0xff4786ea),
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const Gap(16),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      onTapOutside: (event) {
                                        FocusScope.of(context).unfocus();
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        hintStyle: const TextStyle(
                                          fontSize: 14,
                                        ),
                                        suffixIcon: const Icon(
                                          Icons.search,
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 12,
                                        ),
                                        hintText: 'جستجو در لیست',
                                      ),
                                      controller: searchController,
                                      onChanged: (value) {
                                        _startTimer();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                      BlocBuilder<PhoneBloc, PhoneState>(
                        builder: (context, state) {
                          Helper.log(state.toString());

                          if (state is PhoneLoading) {
                            return const Center(
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
                          } else if (state is PhoneInitial) {
                            return const SizedBox();
                          } else if (state is PhoneEmpty) {
                            return const Center(
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
                            );
                          } else if (state is PhoneError) {
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
                                        BlocProvider.of<PhoneBloc>(context).add(
                                          const PhoneStarted(
                                            isRefreshing: false,
                                            searchTag: null,
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
                          } else if (state is PhoneSuccess) {
                            return Expanded(
                              child: ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 24,
                                ),
                                itemBuilder: (context, index) {
                                  final realIndex = index;

                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                          Routes.phoneBookDetails,
                                          arguments: state.phones[realIndex],
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 16,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 3,
                                              offset: Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Colors.black12,
                                                    blurRadius: 3,
                                                  ),
                                                ],
                                              ),
                                              child: const Icon(
                                                Icons.person,
                                                size: 32,
                                                color: Colors.black,
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    state.phones[realIndex]
                                                        .unitTitle!,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Color(0xff014993),
                                                    ),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(height: 6),
                                                  Text(
                                                    state.phones[realIndex]
                                                            .phone ??
                                                        '',
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Color(0xff014993),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            Material(
                                              color: const Color(0xff014993),
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              child: InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                onTap: () async {
                                                  await Share.share(
                                                    "${state.phones[realIndex].unitTitle}\n ${state.phones[realIndex].phone}\n ${state.phones[realIndex].description ?? ''}",
                                                  );
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(12),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                  ),
                                                  child: const Icon(
                                                    Icons.share,
                                                    size: 20,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                itemCount: state.phones.length,
                              ),
                            );
                          }

                          throw Exception('state not found');
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    _timer?.cancel(); // Cancel the timer if it's active
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel(); // Cancel the previous timer (if any)
    _timer = Timer(const Duration(milliseconds: 500), _handleTimeout);
  }

  void _handleTimeout() {
    Helper.log("User finished typing: ${searchController.text}");
    BlocProvider.of<PhoneBloc>(context).add(
      PhoneStarted(
        isRefreshing: false,
        searchTag: searchController.text,
      ),
    );
  }
}
