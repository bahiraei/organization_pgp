import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:pinput/pinput.dart';
import 'package:sms_otp_auto_verify/sms_otp_auto_verify.dart';
import "package:universal_html/html.dart" as html;

import '../../../core/consts/app_images.dart';
import '../../../core/utils/helper.dart';
import '../../../core/utils/routes.dart';
import '../../../core/widgets/app_button.dart';
import '../../home/data/repository/home_repository.dart';
import '../../home/presentation/home_screen.dart';
import '../../home/presentation/widget/dialog/pwa_update_alarm_sheet.dart';
import '../../profile/data/repository/profile_repository.dart';
import '../data/repository/auth_repository.dart';
import 'bloc/auth_bloc.dart';
import 'login_screen.dart';

class VerifyScreen extends StatelessWidget {
  final VerifyScreenParams screenParams;

  const VerifyScreen({
    super.key,
    required this.screenParams,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (context) {
        final bloc = AuthBloc(
          authRepository: authRepository,
          profileRepository: profileRepository,
          homeRepository: homeRepository,
          context: context,
        );

        return bloc;
      },
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            Helper.showSnackBar(state.exception.message.toString(), context);
          } else if (state is AuthVerifyNeedUpdate) {
            Helper.log('need Update state!');
            if (kIsWeb) {
              html.window.location.reload();
            } else {
              Navigator.of(context).pushNamed(
                Routes.update,
                arguments: state.appVersion,
              );
            }
          } else if (state is AuthVerifySuccess) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              Routes.home,
              arguments: HomeScreenParams(
                homeData: state.homeData,
                sliders: state.sliders,
                profileData: state.profileData,
              ),
              (route) => false,
            );
          }
        },
        child: VerifySubScreen(
          screenParams: screenParams,
        ),
      ),
    );
  }
}

class VerifyScreenParams {
  final String nationalCode;

  VerifyScreenParams({
    required this.nationalCode,
  });
}

class VerifySubScreen extends StatefulWidget {
  final VerifyScreenParams screenParams;

  const VerifySubScreen({
    super.key,
    required this.screenParams,
  });

  @override
  State<VerifySubScreen> createState() => _VerifySubScreenState();
}

class _VerifySubScreenState extends State<VerifySubScreen> {
  final verifyCodeController = TextEditingController();
  final disableButton = ValueNotifier<bool>(true);
  final timerNotifier = ValueNotifier<int>(0);
  late Timer timer;

  final defaultPinTheme = PinTheme(
    width: 65,
    height: 56,
    margin: const EdgeInsets.symmetric(horizontal: 5),
    textStyle: const TextStyle(
      fontSize: 20,
      color: Colors.black,
      fontWeight: FontWeight.bold,
    ),
    decoration: BoxDecoration(
      color: Colors.grey[200],
      border: Border.all(
        color: Colors.black38,
        width: 1,
      ),
      borderRadius: BorderRadius.circular(5),
    ),
  );

  void startTimer() {
    timerNotifier.value = 180;
    const duration = Duration(seconds: 1);
    timer = Timer.periodic(duration, (timer) {
      if (timerNotifier.value == 0) {
        timer.cancel();
      } else {
        timerNotifier.value--;
      }
    });
  }

  @override
  void initState() {
    startTimer();
    super.initState();
    if (!kIsWeb) {
      _startListeningSms();
    }
  }

  /// listen sms
  _startListeningSms() {
    SmsVerification.startListeningSms().then((message) {
      setState(() {
        verifyCodeController.text = SmsVerification.getCode(
          message,
          RegExp(
            r'\d+',
            multiLine: true,
          ),
        );
        disableButton.value = true;
        BlocProvider.of<AuthBloc>(context).add(
          AuthVerifyStarted(
            nationalCode: widget.screenParams.nationalCode,
            confirmCode: verifyCodeController.text,
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = Screen.fromContext(context).screenSize;

    return BlocProvider<AuthBloc>(
      create: (context) {
        final bloc = AuthBloc(
          authRepository: authRepository,
          profileRepository: profileRepository,
          homeRepository: homeRepository,
          context: context,
        );

        return bloc;
      },
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            disableButton.value = false;
            Helper.showSnackBar(state.exception.message.toString(), context);
          } else if (state is AuthVerifyNeedUpdate) {
            Helper.log('need Update state!');
            if (kIsWeb) {
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
                builder: (context) => UpdateAlarmBottomSheet(
                  appVersion: state.appVersion,
                ),
              );
            } else {
              Navigator.of(context).pushNamed(
                Routes.update,
                arguments: state.appVersion,
              );
            }
          } else if (state is AuthVerifySuccess) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              Routes.home,
              arguments: HomeScreenParams(
                homeData: state.homeData,
                sliders: state.sliders,
                profileData: state.profileData,
              ),
              (route) => false,
            );
          } else if (state is AuthSuccess) {
            startTimer();
            Helper.showSnackBar('کد ورود مجدد برای شما ارسال شد', context);
          }
        },
        child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    /*height: size.height * 0.8 + keyboardSize,*/
                    decoration: const BoxDecoration(
                      color: Color(0xff00c4ff),
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          left: 0,
                          top: 0,
                          right: 0,
                          child: SizedBox(
                            width: double.infinity,
                            height: 250,
                            child: Opacity(
                              opacity: 0.9,
                              child: Image.asset(
                                AppImages.loginBG,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 16,
                          top: 0,
                          right: 0,
                          child: SizedBox(
                            width: double.infinity,
                            height: 220,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  AppImages.logo,
                                  fit: BoxFit.cover,
                                  height: 140,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 220),
                          /* height: size.height * 0.8 + keyboardSize - 26,*/
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(48),
                              topRight: Radius.circular(48),
                            ),
                          ),
                          padding: const EdgeInsets.fromLTRB(36, 0, 36, 0),
                          child: BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Gap(48),
                                  const Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'کد تایید را وارد کنید',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Color(0xff333333),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  const Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'کد تایید به شماره موبایل شما ارسال شد',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Directionality(
                                      textDirection: TextDirection.ltr,
                                      child: Pinput(
                                        autofocus: true,
                                        controller: verifyCodeController,
                                        keyboardType: TextInputType.number,
                                        /* pinputAutovalidateMode:
                                            PinputAutovalidateMode.onSubmit,*/
                                        focusedPinTheme:
                                            defaultPinTheme.copyWith(
                                          decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).disabledColor,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                        ),
                                        defaultPinTheme: defaultPinTheme,
                                        onChanged: (value) {
                                          if (value.length == 4) {
                                            disableButton.value = false;
                                          } else {
                                            disableButton.value = true;
                                          }
                                        },
                                        onCompleted: (value) {},
                                        onSubmitted: (value) {
                                          if (state is AuthLoading ||
                                              value.length != 4) {
                                            return;
                                          }

                                          disableButton.value = true;
                                          BlocProvider.of<AuthBloc>(context)
                                              .add(
                                            AuthVerifyStarted(
                                              nationalCode: widget
                                                  .screenParams.nationalCode,
                                              confirmCode:
                                                  verifyCodeController.text,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 48),
                                  ValueListenableBuilder<bool>(
                                    valueListenable: disableButton,
                                    builder: (context, isDisabled, _) {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          AppButton(
                                            width: 200,
                                            onClick: state is! AuthLoading
                                                ? () {
                                                    BlocProvider.of<AuthBloc>(
                                                            context)
                                                        .add(
                                                      AuthVerifyStarted(
                                                        nationalCode: widget
                                                            .screenParams
                                                            .nationalCode,
                                                        confirmCode:
                                                            verifyCodeController
                                                                .text,
                                                      ),
                                                    );
                                                  }
                                                : () {},
                                            isLoading: state is AuthLoading,
                                            isDisable: isDisabled,
                                            color: Colors.blue,
                                            height: 54,
                                            text: 'ورود',
                                          )
                                        ],
                                      );
                                    },
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ValueListenableBuilder<int>(
                                        valueListenable: timerNotifier,
                                        builder: (context, value, _) {
                                          if (value == 0) {
                                            return const SizedBox();
                                          }
                                          return Padding(
                                            padding:
                                                const EdgeInsets.only(top: 24),
                                            child: Text(
                                              "${timerNotifier.value} ثانیه تا ارسال مجدد",
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      ValueListenableBuilder<int>(
                                        valueListenable: timerNotifier,
                                        builder: (context, value, _) {
                                          if (value != 0) {
                                            return const SizedBox();
                                          }
                                          return Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8),
                                            child: TextButton(
                                              onPressed: value != 0
                                                  ? () {}
                                                  : () {
                                                      BlocProvider.of<AuthBloc>(
                                                              context)
                                                          .add(
                                                        AuthLoginStarted(
                                                          nationalCode: widget
                                                              .screenParams
                                                              .nationalCode,
                                                        ),
                                                      );
                                                    },
                                              child: const Text(
                                                "ارسال مجدد کد",
                                                style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pushReplacementNamed(
                                            context,
                                            Routes.login,
                                            arguments: LoginScreenParams(
                                              nationalCode: widget
                                                  .screenParams.nationalCode,
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          'ویرایش کد ملی',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.blue,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 62),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (!kIsWeb) {
      SmsVerification.stopListening();
    }

    super.dispose();
  }
}
