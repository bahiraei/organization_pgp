import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organization_pgp/core/core.dart';
import 'package:organization_pgp/core/service/firebase_messaging.dart';
import 'package:organization_pgp/features/auth/data/repository/auth_repository.dart';
import 'package:organization_pgp/features/home/data/repository/home_repository.dart';
import 'package:organization_pgp/features/home/presentation/bloc/home_bloc.dart';
import 'package:organization_pgp/features/home/presentation/widget/app_bar.dart';
import 'package:organization_pgp/features/home/presentation/widget/birthday_scenario.dart';
import 'package:organization_pgp/features/home/presentation/widget/bottom_bar.dart';
import 'package:organization_pgp/features/home/presentation/widget/dialog/pwa_update_alarm_sheet.dart';
import 'package:organization_pgp/features/home/presentation/widget/drawer_bar.dart';
import 'package:organization_pgp/features/home/presentation/widget/home_slider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../core/service/local_notification_service.dart';
import '../../profile/data/model/profile_model.dart';
import '../../profile/data/repository/profile_repository.dart';
import '../data/model/home_data_model.dart';
import '../data/model/slider_model.dart';
import 'widget/pages/pages.dart';

class HomeScreen extends StatefulWidget {
  final HomeScreenParams screenParams;

  const HomeScreen({
    super.key,
    required this.screenParams,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final tabIndexNotifier = ValueNotifier<int>(0);
  final showBirthdayNotifier = ValueNotifier<bool>(false);
  final showBalloonsNotifier = ValueNotifier<bool>(false);
  final showDialogNotifier = ValueNotifier<bool>(false);

  final _refreshController = RefreshController();

  bool isUpdateShowed = false;
  @override
  Widget build(BuildContext context) {
    final screenSize = Screen.fromContext(context).screenSize;

    Helper.log(
        "${AppInfo.appVersionForCheckUpdate} < ${AppInfo.appServerBuildNumber} => ${AppInfo.appVersionForCheckUpdate < AppInfo.appServerBuildNumber}");

    if (!isUpdateShowed &&
        (AppInfo.appServerBuildNumber > AppInfo.appVersionForCheckUpdate) &&
        kIsWeb) {
      isUpdateShowed = true;
      Future.delayed(
        const Duration(seconds: 1),
        () {
          showModalBottomSheet(
            isDismissible: false,
            useRootNavigator: false,
            isScrollControlled: true,
            enableDrag: false,
            context: context,
            constraints: BoxConstraints(
              maxWidth: screenSize != ScreenSize.xsmall ||
                      screenSize != ScreenSize.small
                  ? 700
                  : double.infinity,
            ),
            shape: const RoundedRectangleBorder(
              side: BorderSide.none,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(32),
                topLeft: Radius.circular(32),
              ),
            ),
            builder: (context) => const UpdateAlarmBottomSheet(),
          );
        },
      );
    }

    return BlocProvider<HomeBloc>(
      create: (context) {
        final bloc = HomeBloc(
          homeRepository: homeRepository,
          authRepository: authRepository,
          profileRepository: profileRepository,
          context: context,
        );

        bloc.add(
          HomeStarted(
            homData: widget.screenParams.homeData,
            sliders: widget.screenParams.sliders,
            profileData: widget.screenParams.profileData,
            isRefreshing: true,
          ),
        );

        return bloc;
      },
      child: SafeArea(
        child: BlocConsumer<HomeBloc, HomeState>(
          listenWhen: (previous, current) => current is HomeSuccess,
          listener: (context, state) {
            if (_refreshController.isRefresh) {
              if (state is HomeSuccess) {
                _refreshController.refreshCompleted();
              } else if (state is HomeError) {
                _refreshController.refreshFailed();
              }
            }
          },
          buildWhen: (previous, current) =>
              previous != current && current is! HomeInitial,
          builder: (context, state) {
            Helper.log("state is {$state}");
            if (state is HomeLoading) {
              return const Scaffold(
                body: Center(
                  child: SizedBox(
                    height: 32,
                    width: 32,
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            } else if (state is HomeError) {
              return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        state.exception.message ?? 'خطایی رخ داده است',
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
                            BlocProvider.of<HomeBloc>(context).add(
                              HomeStarted(
                                homData: widget.screenParams.homeData,
                                sliders: widget.screenParams.sliders,
                                profileData: widget.screenParams.profileData,
                                isRefreshing: true,
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
              );
            } else if (state is HomeSuccess) {
              return SmartRefresher(
                header: const MaterialClassicHeader(
                  backgroundColor: Colors.blue,
                  color: Colors.white,
                ),
                controller: _refreshController,
                onRefresh: () {
                  BlocProvider.of<HomeBloc>(context).add(
                    const HomeStarted(
                      isRefreshing: true,
                      homData: null,
                      profileData: null,
                    ),
                  );
                },
                child: Scaffold(
                  key: scaffoldKey,
                  appBar: PreferredSize(
                    preferredSize: const Size.fromHeight(120),
                    child: CustomAppBar(
                      drawerTap: () => scaffoldKey.currentState?.openDrawer(),
                      tabIndexNotifier: tabIndexNotifier,
                      homeData: state.homeData.data,
                    ),
                  ),
                  drawer: CustomDrawer(
                    profile: state.profileData,
                    scaffoldKey: scaffoldKey,
                  ),
                  body: Builder(
                    builder: (context) {
                      if (state.homeData.data?.happyBirthdayMessage != null) {
                        final userSeenBirthdayCount = state.homeData.data
                            ?.happyBirthdayMessage!.userInfo!.countReaded!;
                        final showBirthdayCount = state.homeData.data
                            ?.happyBirthdayMessage!.message!.countForShow!;
                        if (userSeenBirthdayCount! <= showBirthdayCount!) {
                          showBirthdayNotifier.value = true;
                        }

                        final animationController = AnimationController(
                          vsync: this,
                          duration: const Duration(milliseconds: 1000),
                        );
                        final curve = CurvedAnimation(
                          curve: Curves.decelerate,
                          parent: animationController,
                        );
                        final animOffset = Tween<Offset>(
                          begin: const Offset(0, 1),
                          end: Offset.zero,
                        ).animate(curve);
                        Timer(const Duration(milliseconds: 2000), () {
                          animationController.forward();
                        });
                        animationController.addListener(
                          () {
                            if (animationController.isCompleted) {
                              showBalloonsNotifier.value = true;
                              Timer(const Duration(seconds: 8), () {
                                showDialogNotifier.value = true;
                                // animOffset = Tween<Offset>(
                                //   begin: const Offset(0, 1),
                                //   end: Offset.zero,
                                // ).animate(curve);
                                animationController.forward();
                              });
                            }
                          },
                        );

                        Future.delayed(
                          Duration.zero,
                          () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return BirthdayScenarioScreen(
                                  tabIndexNotifier: tabIndexNotifier,
                                  showBirthdayNotifier: showBirthdayNotifier,
                                  showBalloonsNotifier: showBalloonsNotifier,
                                  showDialogNotifier: showDialogNotifier,
                                  animationController: animationController,
                                  animOffset: animOffset,
                                  birthdayMessage: state.homeData.data!
                                      .happyBirthdayMessage!.message!.message!,
                                );
                              },
                            );
                          },
                        );
                      }
                      return ValueListenableBuilder<int>(
                        valueListenable: tabIndexNotifier,
                        builder: (context, index, _) {
                          switch (tabIndexNotifier.value) {
                            case 0:
                              return SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    HomePage(
                                      homaData: state.homeData.data,
                                      profile: state.profileData,
                                    ),
                                    const SizedBox(height: 64),
                                    HomeSlider(
                                      sliders: state.sliders,
                                    ),
                                    const SizedBox(height: 64),
                                    const SizedBox(
                                      width: double.infinity,
                                    ),
                                  ],
                                ),
                              );
                            case 1:
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  PersonalPage(
                                    profile: state.profileData,
                                  ),
                                  const SizedBox(
                                    width: double.infinity,
                                  ),
                                ],
                              );
                            case 2:
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  MonitoringPage(
                                    profile: state.profileData,
                                  ),
                                  const SizedBox(
                                    width: double.infinity,
                                  ),
                                ],
                              );
                            default:
                              return const SizedBox();
                          }
                        },
                      );
                    },
                  ),
                  bottomNavigationBar: CustomNavigationBar(
                    tabIndexNotifier: tabIndexNotifier,
                  ),
                ),
              );
            } else if (state is HomeInitial) {
              return Scaffold(
                key: scaffoldKey,
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(135),
                  child: CustomAppBar(
                    homeData: widget.screenParams.homeData?.data,
                    drawerTap: () => scaffoldKey.currentState?.openDrawer(),
                    tabIndexNotifier: tabIndexNotifier,
                  ),
                ),
                body: Builder(
                  builder: (context) {
                    return ValueListenableBuilder<int>(
                      valueListenable: tabIndexNotifier,
                      builder: (context, index, _) {
                        switch (tabIndexNotifier.value) {
                          case 0:
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                HomePage(
                                  homaData: widget.screenParams.homeData?.data,
                                  profile:
                                      widget.screenParams.profileData?.data,
                                ),
                                const SizedBox(height: 64),
                                HomeSlider(
                                  sliders: widget.screenParams.sliders,
                                ),
                              ],
                            );
                          case 1:
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                PersonalPage(
                                  profile:
                                      widget.screenParams.profileData?.data,
                                ),
                                const SizedBox(height: 20),
                                Container(
                                  width: double.infinity,
                                  color: Colors.white,
                                ),
                              ],
                            );
                          case 2:
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MonitoringPage(
                                  profile:
                                      widget.screenParams.profileData?.data,
                                ),
                              ],
                            );
                          default:
                            return const SizedBox();
                        }
                      },
                    );
                  },
                ),
                bottomNavigationBar: CustomNavigationBar(
                  tabIndexNotifier: tabIndexNotifier,
                ),
              );
            }

            throw Exception("state not found {$state}");
          },
        ),
      ),
    );
  }

  int? notificationCount;

  @override
  void initState() {
    super.initState();
    try {
      if (!kIsWeb && mounted) {
        LocalNotificationService.initialize(context: context);
      }
    } catch (e) {
      Helper.log('local notification error');
    }
    handleFirebaseMessaging();
  }

  @override
  void didChangeDependencies() {
    Helper.log('didChangeDependencies');
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    Helper.log('didUpdateWidget');
    super.didUpdateWidget(oldWidget);
  }

  Future<void> handleFirebaseMessaging() async {
    try {
      await FirebaseMessagingService.getToken();
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      FirebaseMessaging.instance.getInitialMessage().then(
        (message) {
          if (message != null && !kIsWeb) {
            LocalNotificationService.showNotification(
              title: '${message.notification!.title}',
              body: message.notification!.body,
              payload: jsonEncode(message.data),
              imageUrl: message.notification?.android?.imageUrl,
              appNotificationChannelType:
                  LocalNotificationService.getChannelFromString(
                channelId: message.notification?.android?.channelId,
              ),
            );
          }
        },
      );

      ///When the app is in the foreground, the app will receive a notification
      FirebaseMessaging.onMessage.listen(
        (message) {
          Helper.log(message.data.toString());
          Helper.log(message.data['image'].toString());
          Helper.log(message.notification.toString());
          Helper.log(message.notification?.android?.imageUrl.toString() ?? '');

          if (message.notification != null && !kIsWeb) {
            LocalNotificationService.showNotification(
              title: '${message.notification!.title}',
              body: message.notification!.body,
              payload: jsonEncode(message.data),
              imageUrl: message.notification?.android?.imageUrl,
              appNotificationChannelType:
                  LocalNotificationService.getChannelFromString(
                channelId: message.notification?.android?.channelId,
              ),
            );
          }
        },
      );

      ///When the app is in the background but opened, and user taps on the notification.
      FirebaseMessaging.onMessageOpenedApp.listen(
        (message) {
          final routeFromMessage = message.data['route'];
          if (routeFromMessage != null) {
            Navigator.of(context).pushNamed(
              '/$routeFromMessage',
              arguments: {
                'id': message.data['id'],
              },
            );
          }
        },
      );
    } catch (e) {
      Helper.log(e.toString());
    }
  }
}

class HomeScreenParams {
  final ProfileModel? profileData;
  final HomeDataModel? homeData;
  final SliderModel? sliders;

  const HomeScreenParams({
    this.profileData,
    this.homeData,
    this.sliders,
  });
}
