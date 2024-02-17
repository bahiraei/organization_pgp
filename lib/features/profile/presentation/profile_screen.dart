import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:organization_pgp/core/widgets/error_view.dart';

import '../../../core/consts/app_environment.dart';
import '../../../core/utils/helper.dart';
import '../../../core/utils/routes.dart';
import '../../../core/widgets/image_loading_service.dart';
import '../../auth/data/repository/auth_repository.dart';
import '../data/repository/profile_repository.dart';
import 'bloc/profile_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker picker = ImagePicker();

  bool isSigningOut = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenSize = Screen.fromContext(context).screenSize;
    double mainMarginPercent = 0;
    if (screenSize == ScreenSize.xsmall) {
      mainMarginPercent = 0.0;
    } else if (screenSize == ScreenSize.small) {
      mainMarginPercent = 0.15;
    } else if (screenSize == ScreenSize.medium) {
      mainMarginPercent = 0.25;
    } else if (screenSize == ScreenSize.large) {
      mainMarginPercent = 0.32;
    } else if (screenSize == ScreenSize.xlarge) {
      mainMarginPercent = 0.2;
    }

    return BlocProvider<ProfileBloc>(
      create: (context) {
        final bloc = ProfileBloc(
          repository: authRepository,
          profileRepository: profileRepository,
          context: context,
        );

        bloc.add(const ProfileStarted());

        return bloc;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<ProfileBloc, ProfileState>(
          buildWhen: (previous, current) =>
              current is! ProfileChangeAvatarSuccess,
          listener: (context, state) {
            if (state is ProfileChangeAvatarSuccess) {
              BlocProvider.of<ProfileBloc>(context).add(
                const ProfileStarted(),
              );
            }
          },
          builder: (context, state) {
            Helper.log('state is $state');
            if (state is ProfileSuccess) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                      children: [
                        Gap(MediaQuery.of(context).viewPadding.top + 8),
                        Row(
                          children: [
                            const Gap(8),
                            IconButton(
                              padding: const EdgeInsets.all(0),
                              onPressed: () => Navigator.of(context).pop(),
                              icon: const Icon(
                                Icons.arrow_back_ios_rounded,
                              ),
                            ),
                            const Gap(32),
                            const Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'اطلاعات کاربری',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 100,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xffffecec),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: isSigningOut
                                    ? null
                                    : () async {
                                        final result = await showDialog(
                                          context: context,
                                          builder: (context) {
                                            return Dialog(
                                              insetPadding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 0,
                                                vertical: 0,
                                              ),
                                              shape: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius:
                                                    BorderRadius.circular(24),
                                              ),
                                              child: Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.41,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.85,
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        24, 24, 24, 24),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(24),
                                                  color: Theme.of(context)
                                                      .cardColor,
                                                ),
                                                child: Column(
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        children: [
                                                          const Gap(24),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(12),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .red.shade100,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          100),
                                                            ),
                                                            child: Icon(
                                                              Icons.exit_to_app,
                                                              color: Colors
                                                                  .red.shade400,
                                                              size: 36,
                                                            ),
                                                          ),
                                                          const Gap(12),
                                                          const Text(
                                                            'آیا از خروج از حساب اطمینان دارید؟',
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        SizedBox(
                                                          width: 120,
                                                          height: 44,
                                                          child: ElevatedButton(
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              backgroundColor:
                                                                  Colors.red,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12),
                                                                side: BorderSide
                                                                    .none,
                                                              ),
                                                            ),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(true);
                                                            },
                                                            child: const Text(
                                                              'خروج',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 120,
                                                          height: 44,
                                                          child: ElevatedButton(
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              backgroundColor:
                                                                  const Color(
                                                                      0xffececec),
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                side: BorderSide
                                                                    .none,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12),
                                                              ),
                                                            ),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(false);
                                                            },
                                                            child: const Text(
                                                              'انصراف',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black87,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );

                                        if (mounted) {
                                          if (result) {
                                            await authRepository.signOut().then(
                                                  (value) => Navigator
                                                      .pushReplacementNamed(
                                                    context,
                                                    Routes.splash,
                                                  ),
                                                );
                                          }
                                        }
                                      },
                                child: isSigningOut
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          color: Colors.grey,
                                        ),
                                      )
                                    : const Text(
                                        'خروج از حساب',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 10,
                                        ),
                                      ),
                              ),
                            ),
                            const Gap(8),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * mainMarginPercent,
                      ),
                      child: Column(
                        children: [
                          const Gap(48),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                borderRadius: BorderRadius.circular(100),
                                onTap: () async {
                                  // Pick an image.
                                  final XFile? image = await picker.pickImage(
                                    source: ImageSource.gallery,
                                    imageQuality: 50,
                                    maxWidth: 1920,
                                    maxHeight: 1080,
                                    requestFullMetadata: true,
                                  );

                                  if (image != null && mounted) {
                                    BlocProvider.of<ProfileBloc>(context).add(
                                      ProfileChangeAvatarStarted(
                                        filename: image.name,
                                        image: await image.readAsBytes(),
                                      ),
                                    );
                                  }
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: Colors.blueGrey,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: ImageLoadingService(
                                        onTap: () async {
                                          // Pick an image.
                                          final XFile? image =
                                              await picker.pickImage(
                                            source: ImageSource.gallery,
                                            imageQuality: 50,
                                            maxWidth: 1920,
                                            maxHeight: 1080,
                                            requestFullMetadata: true,
                                          );

                                          if (image != null && mounted) {
                                            BlocProvider.of<ProfileBloc>(
                                                    context)
                                                .add(
                                              ProfileChangeAvatarStarted(
                                                filename: image.name,
                                                image:
                                                    await image.readAsBytes(),
                                              ),
                                            );
                                          }
                                        },
                                        imageUrl: AppEnvironment.baseUrl +
                                            ("${state.profile.data?.fullPathProfileImage}?v=${DateTime.now().millisecondsSinceEpoch}"),
                                        fit: BoxFit.cover,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        canView: false,
                                        canZoom: false,
                                        errorWidget: (context, url, error) {
                                          return Image.asset(
                                            'assets/images/profile/default.png',
                                            fit: BoxFit.cover,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Gap(12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                state.profile.data?.fullName ?? '',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const Gap(6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                state.profile.data!.isAdmin ? 'مدیر' : 'کاربر',
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const Gap(32),
                          Container(
                            margin: const EdgeInsets.fromLTRB(48, 0, 48, 3),
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 24,
                            ),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(12),
                              ),
                              color: Color(0xffe8e8e8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'کد ملی',
                                  style: TextStyle(
                                    color: Color(0xff477fed),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  state.profile.data!.nationalCode,
                                  style: const TextStyle(
                                    color: Color(0xff3b3b3b),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.fromLTRB(48, 0, 48, 3),
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 24,
                            ),
                            decoration: const BoxDecoration(
                              color: Color(0xffe8e8e8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'تاریخ تولد',
                                  style: TextStyle(
                                    color: Color(0xff477fed),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  state.profile.data?.birthDayFa ?? '-',
                                  style: const TextStyle(
                                    color: Color(0xff3b3b3b),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textDirection: TextDirection.ltr,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.fromLTRB(48, 0, 48, 3),
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 24,
                            ),
                            decoration: const BoxDecoration(
                              color: Color(0xffe8e8e8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'جنسیت',
                                  style: TextStyle(
                                    color: Color(0xff477fed),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  state.profile.data!.gender == 1
                                      ? 'مرد'
                                      : 'زن',
                                  style: const TextStyle(
                                    color: Color(0xff3b3b3b),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.fromLTRB(48, 0, 48, 0),
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 24,
                            ),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(12),
                              ),
                              color: Color(0xffe8e8e8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'اداره',
                                  style: TextStyle(
                                    color: Color(0xff477fed),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  state.profile.data!.officeName ?? '-',
                                  style: const TextStyle(
                                    color: Color(0xff3b3b3b),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is ProfileInitial || state is ProfileLoading) {
              return Column(
                children: [
                  Column(
                    children: [
                      Gap(MediaQuery.of(context).viewPadding.top + 8),
                      Row(
                        children: [
                          const Gap(8),
                          IconButton(
                            padding: const EdgeInsets.all(0),
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(
                              Icons.arrow_back_ios_rounded,
                            ),
                          ),
                          const Gap(32),
                          const Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'اطلاعات کاربری',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Gap(100),
                        ],
                      ),
                    ],
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
            } else if (state is ProfileError) {
              return Column(
                children: [
                  Column(
                    children: [
                      Gap(MediaQuery.of(context).viewPadding.top + 8),
                      Row(
                        children: [
                          const Gap(8),
                          IconButton(
                            padding: const EdgeInsets.all(0),
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(
                              Icons.arrow_back_ios_rounded,
                            ),
                          ),
                          const Gap(32),
                          const Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'اطلاعات کاربری',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Gap(100),
                        ],
                      ),
                    ],
                  ),
                  ErrorView(
                    message: state.exception.message,
                    onRetry: () {
                      BlocProvider.of<ProfileBloc>(context).add(
                        const ProfileStarted(),
                      );
                    },
                  ),
                ],
              );
            }

            throw Exception('state $state notFound');
          },
        ),
      ),
    );
  }
}
