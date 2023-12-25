import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organization_pgp/features/home/data/repository/home_repository.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sms_otp_auto_verify/sms_otp_auto_verify.dart';

import '../../../core/core.dart';
import '../../../core/exception/app_exception.dart';
import '../../auth/data/repository/auth_repository.dart';
import '../../home/presentation/home_screen.dart';
import '../../profile/data/repository/profile_repository.dart';
import 'bloc/splash_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  late Animation<Offset> animOffset;
  int? delay;

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();

    if (!kIsWeb) {
      AppInfo.appSignature =
          (await SmsVerification.getAppSignature())?.split(' ').last;
      Helper.log("appSignature => ${AppInfo.appSignature}");
    }

    AppInfo.packageInfo = info;
  }

  @override
  void dispose() {
    super.dispose();
    animationController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider<SplashBloc>(
      create: (context) {
        final bloc = SplashBloc(
          authRepository: authRepository,
          homeRepository: homeRepository,
          profileRepository: profileRepository,
          context: context,
        );

        bloc.add(SplashStarted());
        return bloc;
      },
      child: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) async {
          Helper.log(state.toString());
          if (state is SplashSuccess) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              Routes.home,
              arguments: HomeScreenParams(
                homeData: state.homeData,
                sliders: state.sliders,
                profileData: state.profileData,
              ),
              (route) => false,
            );
          } else if (state is SplashError) {
            if (state.exception is UnauthorizedException) {
              await authRepository.signOut().then(
                (value) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    Routes.login,
                    (route) => false,
                  );
                },
              );
            }
          }
        },
        child: SafeArea(
          child: Scaffold(
            body: AppBackground(
              size: size,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                      left: 32,
                    ),
                    child: Image.asset(
                      AppImages.petroshimi_logo,
                      height: 100,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    width: size.width,
                    height: 200,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.contain,
                        image: AssetImage(
                          AppImages.splashImage,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  BlocBuilder<SplashBloc, SplashState>(
                    builder: (context, state) {
                      if (state is SplashLoading || state is SplashInitial) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: CircularProgressIndicator(color: Colors.white),
                        );
                      } else if (state is SplashError &&
                          state.exception.message != null) {
                        return Column(
                          children: [
                            Text(
                              state.exception.message.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Builder(
                                  builder: (context) {
                                    return CustomButton(
                                      onPressed: () {
                                        BlocProvider.of<SplashBloc>(context)
                                            .add(
                                          SplashStarted(),
                                        );
                                      },
                                      borderRadius: 18,
                                      width: 86,
                                      height: 36,
                                      showShadow: false,
                                      backgroundColor: Colors.red,
                                      child: const Text(
                                        'تلاش مجدد',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.white,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 54),
                          ],
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ShowUp extends StatelessWidget {
  final Widget child;
  final int? delay;
  final AnimationController animationController;
  final Animation<Offset> animOffset;

  const ShowUp({
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
