import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

import '../../../../core/widgets/app_button.dart';

class PwaInstallDialog extends StatefulWidget {
  const PwaInstallDialog({super.key});

  @override
  State<PwaInstallDialog> createState() => _PwaInstallDialogState();
}

class _PwaInstallDialogState extends State<PwaInstallDialog> {
  @override
  Widget build(BuildContext context) {
    final screenSize = Screen.fromContext(context).screenSize;

    double mainMargin = 0.95;
    if (screenSize == ScreenSize.xsmall) {
      mainMargin = 0.95;
    } else if (screenSize == ScreenSize.small) {
      mainMargin = 0.8;
    } else if (screenSize == ScreenSize.medium) {
      mainMargin = 0.45;
    } else if (screenSize == ScreenSize.large) {
      mainMargin = 0.35;
    } else if (screenSize == ScreenSize.xlarge) {
      mainMargin = 0.35;
    }

    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Dialog(
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 0,
            vertical: 0,
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * mainMargin,
            height: MediaQuery.of(context).size.height * 0.9,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      const SizedBox(height: 48),
                      Image.asset(
                        'assets/images/logo.png',
                        width: 96,
                        height: 96,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "وب اپلیکیشن هدایت کشتی خلیج فارس را\r\nبه صفحه اصلی تلفن همراه خود اضافه کنید",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          height: 1.9,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 54),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 64),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xff39b8ec),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  padding: const EdgeInsets.all(12),
                                  child: const Center(
                                    child: Icon(
                                      CupertinoIcons.share,
                                      size: 26,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Share",
                                      ),
                                      Text(
                                        "انتخاب این گزینه از نوار پایین",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xff39b8ec),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  padding: const EdgeInsets.all(12),
                                  child: const Center(
                                    child: Icon(
                                      CupertinoIcons.add,
                                      size: 26,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Add to home screen",
                                      ),
                                      Text(
                                        "انتخاب این گزینه از منوی ظاهر شده",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xff39b8ec),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  padding: const EdgeInsets.all(12),
                                  child: const Center(
                                    child: Icon(
                                      Icons.done,
                                      size: 26,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Add",
                                      ),
                                      Text(
                                        "زدن این گزینه",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          text: 'متوجه شدم',
                          onClick: () async {
                            Navigator.pop(context);
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
    );
  }
}
