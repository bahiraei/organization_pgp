import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:organization_pgp/features/profile/data/repository/profile_repository.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sms_otp_auto_verify/sms_otp_auto_verify.dart';

import '../../../core/core.dart';
import '../../../core/exception/app_exception.dart';
import '../../auth/data/repository/auth_repository.dart';
import '../../home/data/repository/home_repository.dart';
import '../../home/presentation/home_screen.dart';
import 'bloc/splash_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<Offset> animOffset;
  int? delay;

  @override
  void initState() {
    super.initState();
    _animate();
    _initPackageInfo();
  }

  void _animate() {
    delay = 3000;
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    final curve = CurvedAnimation(
      curve: Curves.decelerate,
      parent: animationController,
    );
    animOffset = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(curve);
    if (delay == null) {
      animationController.forward();
    } else {
      Timer(Duration(milliseconds: delay!), () {
        animationController.forward();
      });
    }
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
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider<SplashBloc>(
      create: (context) {
        final bloc = SplashBloc(
          authRepository: authRepository,
          homeRepository: homeRepository,
          context: context,
          profileRepository: profileRepository,
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
              await Future.delayed(const Duration(seconds: 5));
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
        child: Scaffold(
          body: Stack(
            clipBehavior: Clip.none,
            fit: StackFit.expand,
            children: [
              SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: Image.asset(
                  'assets/images/splash/background.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              // Blurred Overlay
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 5.0,
                    sigmaY: 5.0,
                  ), // Adjust the blur intensity
                  child: Container(
                    color: Colors.black.withOpacity(
                      0.4,
                    ), // Adjust the opacity as needed
                  ),
                ),
              ),

              Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/splash/splashLogo.png',
                          width: 140,
                          height: 140,
                        ),
                      ],
                    ).animate().scale(delay: 700.ms).fadeIn(),
                    const Gap(8),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'هدایت کشتی خلیج فارس',
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ).animate().slideY(delay: 1200.ms).fadeIn(),
                    const Gap(8),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'اپلیکیشن سازمانی',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ).animate().slideY(delay: 1700.ms).fadeIn(),
                    const Gap(8),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Future Per Network:AI',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ).animate().slideY(delay: 2200.ms).fadeIn(),
                    const Gap(32),
                    BlocBuilder<SplashBloc, SplashState>(
                      builder: (context, state) {
                        if (state is SplashLoading || state is SplashInitial) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child:
                                CircularProgressIndicator(color: Colors.white),
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
            ],
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
