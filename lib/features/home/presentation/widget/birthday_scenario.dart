import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:organization_pgp/features/auth/data/repository/auth_repository.dart';
import 'package:organization_pgp/features/home/data/repository/home_repository.dart';

import '../../../../core/core.dart';
import '../../../profile/data/repository/profile_repository.dart';
import '../bloc/home_bloc.dart';

class BirthdayScenarioScreen extends StatelessWidget {
  final ValueNotifier<int> tabIndexNotifier;
  final ValueNotifier<bool> showBirthdayNotifier;
  final ValueNotifier<bool> showBalloonsNotifier;
  final ValueNotifier<bool> showDialogNotifier;
  final AnimationController animationController;
  final Animation<Offset> animOffset;
  final String birthdayMessage;
  final loadingNotifier = ValueNotifier<bool>(false);

  BirthdayScenarioScreen({
    super.key,
    required this.tabIndexNotifier,
    required this.showBirthdayNotifier,
    required this.showBalloonsNotifier,
    required this.showDialogNotifier,
    required this.animationController,
    required this.animOffset,
    required this.birthdayMessage,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider<HomeBloc>(
      create: (context) => HomeBloc(
        homeRepository: homeRepository,
        authRepository: authRepository,
        profileRepository: profileRepository,
        context: context,
      ),
      child: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is HomeDialogError) {
            Helper.showSnackBar(state.exception.message.toString(), context);
          } else if (state is HomeHappyBirthdayReadSuccess) {
            Navigator.of(context).pop();
          }
        },
        child: Stack(
          children: [
            ValueListenableBuilder<bool>(
              valueListenable: showBirthdayNotifier,
              builder: (context, isShowBirthday, child) {
                return Stack(
                  children: [
                    //show lottie file
                    ValueListenableBuilder<bool>(
                      valueListenable: showBalloonsNotifier,
                      builder: (context, value, child) {
                        if (value) {
                          return Lottie.asset(
                            AppImages.balloons,
                            repeat: false,
                            fit: BoxFit.cover,
                            width: size.width,
                            height: size.height,
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                    //show dialog
                    Center(
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          HomeShowUp(
                            animationController: animationController,
                            animOffset: animOffset,
                            child: Container(
                              margin: const EdgeInsets.only(
                                left: 50,
                                right: 50,
                                top: 50,
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 20,
                                horizontal: 30,
                              ),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                /*color: Colors.tealAccent[100],*/
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 3,
                                    color: Colors.black26,
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 50),
                                  const SizedBox(height: 20),
                                  Text(
                                    birthdayMessage,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      /*color: Color(AppColor.purpleColor),*/
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  BlocBuilder<HomeBloc, HomeState>(
                                    builder: (context, state) {
                                      return AppButton(
                                        text: 'بستن',
                                        width: 100,
                                        isDisable: state is HomeDialogLoading,
                                        isLoading: state is HomeDialogLoading,
                                        color: const Color(
                                          AppColor.purpleColor,
                                        ),
                                        onClick: () async {
                                          BlocProvider.of<HomeBloc>(context)
                                              .add(
                                            HomeHappyBirthdayRead(),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          HomeShowUp(
                            animationController: animationController,
                            animOffset: animOffset,
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(AppImages.birthdayCake),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> sendReedBirthdayMessage(BuildContext context) async {
    loadingNotifier.value = true;
    /*final dio = Dio();
    final token = UtilPreferences.getString(Preferences.accessToken);
    dio.options = AppDioOption.postOption(token);
    try {
      final request = await dio
          .post("api/BornToday/ReadHappyBirthdayMessage")
          .then((value) {
        Navigator.pop(context);
      });
    } on DioException catch (error) {
      Helper.log(error.message.toString());
      Helper.log("${error.response?.data}");
      Helper.log("${error.response?.statusCode}");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('خطا در برقراری ارتباط با سرور'),
        ),
      );
    }*/
    Future.delayed(const Duration(seconds: 3));
    loadingNotifier.value = false;
    Navigator.pop(context);
  }
}

class HomeShowUp extends StatelessWidget {
  final Widget child;
  final int? delay;
  final AnimationController animationController;
  final Animation<Offset> animOffset;

  const HomeShowUp({
    super.key,
    required this.animationController,
    required this.animOffset,
    required this.child,
    this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animationController,
      child: SlideTransition(
        position: animOffset,
        child: child,
      ),
    );
  }
}
