import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/widgets/app_bg.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/title_bar.dart';
import '../data/model/phone_book_model.dart';

class PhoneBookDetailsScreen extends StatefulWidget {
  final Phone phone;

  const PhoneBookDetailsScreen({
    super.key,
    required this.phone,
  });

  @override
  State<PhoneBookDetailsScreen> createState() => _PhoneBookDetailsScreenState();
}

class _PhoneBookDetailsScreenState extends State<PhoneBookDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final screenSize = Screen.fromContext(context).screenSize;

    double mainMargin = 0;

    if (screenSize == ScreenSize.xsmall) {
      mainMargin = 8;
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
        body: AppBackground(
          size: size,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TitleBar(
                size: size,
                title: 'جزییات دفتر تلفن',
                onTap: () => Navigator.pop(context),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(32),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: mainMargin),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(32),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Icon(
                            Icons.person_pin,
                            size: 120,
                            color: Colors.grey[700],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 48,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'نام مخاطب:',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    widget.phone.personName ?? '-',
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'شماره تلفن:',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    widget.phone.phone ?? '-',
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'اداره:',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    widget.phone.bohkt ?? '-',
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'واحد:',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    widget.phone.unitTitle ?? '-',
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'جزییات:',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    widget.phone.description ?? '-',
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 64),
                              CustomButton(
                                elevation: 3,
                                height: 52,
                                onPressed: () async {
                                  await Share.share(
                                    "${widget.phone.unitTitle}\n ${widget.phone.phone}\n ${widget.phone.description ?? ''}",
                                  );
                                },
                                showShadow: false,
                                backgroundColor: const Color(0xff014993),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.share,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'اشتراک گذاری',
                                      style: TextStyle(
                                        color: Colors.white,
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
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
