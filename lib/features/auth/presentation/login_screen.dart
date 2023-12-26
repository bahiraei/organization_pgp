import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:organization_pgp/core/core.dart';
import 'package:organization_pgp/features/auth/presentation/dialog/policy_dialog.dart';
import 'package:organization_pgp/features/auth/presentation/verify_screen.dart';
import 'package:organization_pgp/features/home/data/repository/home_repository.dart';
import 'package:persian_utils/persian_utils.dart';
import 'package:universal_html/html.dart' as html;

import '../../profile/data/repository/profile_repository.dart';
import '../data/repository/auth_repository.dart';
import 'bloc/auth_bloc.dart';
import 'dialog/pwe_install_dialog.dart';

class LoginScreen extends StatefulWidget {
  final LoginScreenParams? screenParams;

  const LoginScreen({
    super.key,
    this.screenParams,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final nationalCodeController = TextEditingController();
  final natCodeNotifier = ValueNotifier<bool>(true);
  final showClearButton = ValueNotifier<bool>(false);

  final formKey = GlobalKey<FormState>();

  bool isPwaInstallShowed = false;

  @override
  void initState() {
    nationalCodeController.text = widget.screenParams?.nationalCode ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!isPwaInstallShowed &&
        kIsWeb &&
        !html.window.matchMedia('(display-mode: standalone)').matches) {
      isPwaInstallShowed = true;
      Future.delayed(
        const Duration(seconds: 1),
        () {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => const PwaInstallDialog(),
          );
        },
      );
    }

    final size = MediaQuery.of(context).size;
    final keyboardSize = MediaQuery.of(context).viewInsets.bottom;

    final screenSize = Screen.fromContext(context).screenSize;

    double mainMargin = 0.15;
    if (screenSize == ScreenSize.xsmall) {
      mainMargin = 0.15;
    } else if (screenSize == ScreenSize.small) {
      mainMargin = 0.2;
    } else if (screenSize == ScreenSize.medium) {
      mainMargin = 0.45;
    } else if (screenSize == ScreenSize.large) {
      mainMargin = 0.65;
    } else if (screenSize == ScreenSize.xlarge) {
      mainMargin = 0.65;
    }
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
          } else if (state is AuthSuccess) {
            Navigator.of(context).pushNamed(
              Routes.verify,
              arguments: VerifyScreenParams(
                nationalCode: nationalCodeController.text,
              ),
            );
          }
        },
        child: WillPopScope(
          onWillPop: () => SystemNavigator.pop().then((value) => value as bool),
          child: SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: size.height + keyboardSize + 400,
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
                            height: size.height * 0.8 + keyboardSize + 400,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(48),
                                topRight: Radius.circular(48),
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: size.width * (mainMargin / 2),
                            ),
                            child: BlocBuilder<AuthBloc, AuthState>(
                              builder: (context, state) {
                                return Form(
                                  key: formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Gap(48),
                                      const Align(
                                        alignment: Alignment.topRight,
                                        child: Text(
                                          "خوش آمدید!",
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Color(0xff383838),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      const Text(
                                        "برای استفاده از سرویس های مختلف، لطفاً کد ملی خود را وارد کنید:",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xff383838),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 30),
                                      AppTextFormField(
                                        fillColor: const Color(0xff8FD5FF)
                                            .withOpacity(0.47),
                                        onTapOutside: (event) {},
                                        textColor: Colors.blue,
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        controller: nationalCodeController,
                                        maxLength: 10,
                                        validator: (value) {
                                          if (value.isEmpty ||
                                              value.length > 10) {
                                            return "کد ملی را وارد کنید";
                                          }

                                          return null;
                                        },
                                        keyboardType: TextInputType.phone,
                                        hint: 'کد ملی',
                                        hintText: "کد ملی را وارد کنید",
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                        ],
                                        suffixIcon:
                                            ValueListenableBuilder<bool>(
                                          valueListenable: showClearButton,
                                          builder: (context, value, _) {
                                            return GestureDetector(
                                              onTap: () {
                                                nationalCodeController.clear();
                                                showClearButton.value = false;
                                                natCodeNotifier.value = true;
                                              },
                                              child: value
                                                  ? Container(
                                                      margin:
                                                          const EdgeInsets.all(
                                                              12),
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.grey[800],
                                                      ),
                                                      child: const Icon(
                                                        Icons.clear,
                                                        color: Colors.white,
                                                        size: 15,
                                                      ),
                                                    )
                                                  : const SizedBox(),
                                            );
                                          },
                                        ),
                                        onChanged: (value) {
                                          final bool isNationalCode = value
                                              .isValidIranianNationalCode();
                                          if (isNationalCode &&
                                              value.isNotEmpty &&
                                              value.length == 10) {
                                            showClearButton.value = true;
                                            natCodeNotifier.value = false;
                                          } else {
                                            showClearButton.value = false;
                                            natCodeNotifier.value = true;
                                          }
                                        },
                                        autofocus: false,
                                        /*onFieldSubmitted: (value) {
                                            final bool isNationalCode =
                                                nationalCodeController.text
                                                    .isValidIranianNationalCode();

                                            if (!isNationalCode) {
                                              Helper.showSnackBar(
                                                'کدملی وارد شده صحیح نمیباشد',
                                                context,
                                              );
                                              return;
                                            }
                                            if (formKey.currentState!
                                                .validate()) {
                                              BlocProvider.of<AuthBloc>(context)
                                                  .add(
                                                AuthLoginStarted(
                                                  nationalCode:
                                                      nationalCodeController
                                                          .text,
                                                  smsAutoFillCode:
                                                      AppInfo.appSignature,
                                                ),
                                              );
                                            }
                                          },*/
                                      ),
                                      const SizedBox(height: 30),
                                      Row(
                                        children: [
                                          const Text(
                                            'با ثبت نام در برنامه، ',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xff383838),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    const PolicyDialog(),
                                              );
                                            },
                                            child: const Text(
                                              'شرایط و قوانین ',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.blueAccent,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const Text(
                                            'را قبول می کنم.',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xff383838),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 30),
                                      ValueListenableBuilder<bool>(
                                        valueListenable: natCodeNotifier,
                                        builder: (context, value, _) {
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: SizedBox(
                                                  height: 52,
                                                  child: ElevatedButton(
                                                    onPressed:
                                                        state is AuthLoading ||
                                                                value
                                                            ? () {}
                                                            : () {
                                                                final bool
                                                                    isNationalCode =
                                                                    nationalCodeController
                                                                        .text
                                                                        .isValidIranianNationalCode();

                                                                if (!isNationalCode) {
                                                                  Helper
                                                                      .showSnackBar(
                                                                    'کدملی وارد شده صحیح نمیباشد',
                                                                    context,
                                                                  );
                                                                  return;
                                                                }
                                                                if (formKey
                                                                    .currentState!
                                                                    .validate()) {
                                                                  BlocProvider.of<
                                                                              AuthBloc>(
                                                                          context)
                                                                      .add(
                                                                    AuthLoginStarted(
                                                                      nationalCode:
                                                                          nationalCodeController
                                                                              .text,
                                                                      smsAutoFillCode:
                                                                          AppInfo
                                                                              .appSignature,
                                                                    ),
                                                                  );
                                                                }
                                                              },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      elevation: 0,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(16),
                                                        side: BorderSide.none,
                                                      ),
                                                      backgroundColor: value
                                                          ? Theme.of(context)
                                                              .disabledColor
                                                          : Colors.blue,
                                                    ),
                                                    child: state is AuthLoading
                                                        ? const CupertinoActivityIndicator(
                                                            color: Colors.white,
                                                          )
                                                        : const Text(
                                                            'ورود',
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                      const SizedBox(height: 120),
                                    ],
                                  ),
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
      ),
    );
  }
}

class LoginScreenParams {
  final String? nationalCode;

  LoginScreenParams({
    this.nationalCode,
  });
}
