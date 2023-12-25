import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/service/file-manager-handler.dart';
import '../../../core/service/permission-handler.dart';
import '../../../core/utils/helper.dart';
import '../../../core/widgets/app_bg.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/show_image_full_screen.dart';
import '../../../core/widgets/title_bar.dart';
import '../data/repository/hokm_repository.dart';
import 'bloc/hokm_bloc.dart';

class HokmScreen extends StatefulWidget {
  const HokmScreen({super.key});

  @override
  State<HokmScreen> createState() => _HokmScreenState();
}

class _HokmScreenState extends State<HokmScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider<HokmBloc>(
      create: (context) {
        final bloc = HokmBloc(
          hokmRepository: hokmRepository,
          context: context,
        );

        bloc.add(HokmStarted());
        return bloc;
      },
      child: SafeArea(
        child: BlocBuilder<HokmBloc, HokmState>(
          builder: (context, state) {
            Helper.log(state.toString());

            if (state is HokmInitial || state is HokmLoading) {
              return Scaffold(
                body: AppBackground(
                  size: size,
                  child: Column(
                    children: [
                      TitleBar(
                        size: size,
                        title: 'آخرین حکم',
                        onTap: () => Navigator.of(context).pop(),
                      ),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(32),
                          ),
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(32),
                              ),
                              color: Colors.white,
                            ),
                            child: const Center(
                              child: SizedBox(
                                height: 32,
                                width: 32,
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is HokmError) {
              return Scaffold(
                body: AppBackground(
                  size: size,
                  child: Column(
                    children: [
                      TitleBar(
                        size: size,
                        title: 'آخرین حکم',
                        onTap: () => Navigator.of(context).pop(),
                      ),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(32),
                          ),
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(32),
                              ),
                              color: Colors.white,
                            ),
                            child: Center(
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
                                        BlocProvider.of<HokmBloc>(context).add(
                                          HokmStarted(),
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
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is HokmEmpty) {
              return Scaffold(
                body: AppBackground(
                  size: size,
                  child: Column(
                    children: [
                      TitleBar(
                        size: size,
                        title: 'آخرین حکم',
                        onTap: () => Navigator.of(context).pop(),
                      ),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(32),
                          ),
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(32),
                              ),
                              color: Colors.white,
                            ),
                            child: const Center(
                              child: Text(
                                'اطلاعاتی یافت نشد',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is HokmSuccess) {
              return Scaffold(
                body: AppBackground(
                  size: size,
                  child: Column(
                    children: [
                      TitleBar(
                        size: size,
                        title: 'آخرین حکم',
                        onTap: () => Navigator.of(context).pop(),
                      ),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(32),
                          ),
                          child: Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(32),
                              ),
                              color: Colors.white,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ShowImageFullScreen(
                                      base64Image: state.image,
                                      isBase64: true,
                                    ),
                                  ),
                                );
                              },
                              child: Image.memory(
                                state.image,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () async {
                    if (kIsWeb) {
                      FileManagerHandler.saveFileInWeb(
                        state.image,
                        'hokm.jpg',
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('تصویر با موفقیت ذخیره شد'),
                        ),
                      );
                    } else {
                      final status =
                          await PermissionHandler.getStoragePermission();

                      if (status != PermissionStatus.granted) {
                        return;
                      }
                      final file = await FileManagerHandler.saveFile(
                        name: 'hokm.jpg',
                        data: state.image,
                      );
                      if (mounted && file != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('تصویر با موفقیت ذخیره شد'),
                          ),
                        );
                      }
                    }
                  },
                  child: const Icon(
                    Icons.download,
                  ),
                ),
              );
            }

            throw Exception('state not found');
          },
        ),
      ),
    );
  }
}
