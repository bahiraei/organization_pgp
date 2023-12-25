import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../../core/consts/app_environment.dart';
import '../../../../../core/consts/app_images.dart';
import '../../../../../core/utils/scroll_behavior.dart';
import '../../../../../core/widgets/app_bg.dart';
import '../../../../../core/widgets/image_loading_service.dart';
import '../../../../../core/widgets/title_bar.dart';
import '../../../../core/utils/routes.dart';
import '../../data/model/admin_message_model.dart';
import 'admin_edit_message_screen.dart';

class AdminMessageDetailScreenParams {
  final AdminMessageModel adminMessageModel;

  AdminMessageDetailScreenParams({
    required this.adminMessageModel,
  });
}

class AdminMessageDetailScreen extends StatefulWidget {
  final AdminMessageDetailScreenParams screenParams;

  const AdminMessageDetailScreen({
    super.key,
    required this.screenParams,
  });

  @override
  State<AdminMessageDetailScreen> createState() =>
      _AdminMessageDetailScreenState();
}

class _AdminMessageDetailScreenState extends State<AdminMessageDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final screenSize = Screen.fromContext(context).screenSize;

    double mainMargin = 0;

    if (screenSize == ScreenSize.xsmall) {
      mainMargin = 0;
    } else if (screenSize == ScreenSize.small) {
      mainMargin = 70;
    } else if (screenSize == ScreenSize.medium) {
      mainMargin = 200;
    } else if (screenSize == ScreenSize.large) {
      mainMargin = 400;
    } else if (screenSize == ScreenSize.xlarge) {
      mainMargin = 500;
    }
    return SafeArea(
      child: Scaffold(
        body: AppBackground(
          size: size,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleBar(
                size: size,
                title: 'جزئیات پیام ها',
                onTap: () => Navigator.pop(context),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(32),
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(32),
                      ),
                    ),
                    child: ScrollConfiguration(
                      behavior: MyScrollBehavior(),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: mainMargin,
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 16),
                              Container(
                                margin:
                                    const EdgeInsets.fromLTRB(15, 0, 15, 10),
                                width: size.width,
                                height: size.height / 3.2,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.horizontal(
                                    right: Radius.circular(0),
                                  ),
                                ),
                                child: ImageLoadingService(
                                  imageUrl: AppEnvironment.mediaBaseUrl +
                                      widget.screenParams.adminMessageModel.img
                                          .toString(),
                                  borderRadius: BorderRadius.circular(0),
                                  canZoom: false,
                                  errorWidget: (context, url, error) {
                                    return Padding(
                                      padding: const EdgeInsets.all(18),
                                      child: Image.asset(
                                        AppImages.projectImagePNG,
                                      ),
                                    );
                                  },
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              widget
                                                      .screenParams
                                                      .adminMessageModel
                                                      .title ??
                                                  '',
                                              textAlign: TextAlign.start,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ).animate().fadeIn(),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Text(
                                        widget.screenParams.adminMessageModel
                                                .fullText ??
                                            '',
                                        // textAlign: TextAlign.justify,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          height: 1.8,
                                        ),
                                      ).animate().fadeIn(
                                            delay: const Duration(
                                                milliseconds: 300),
                                          ),
                                    ),
                                    const SizedBox(height: 20),
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
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            await Navigator.of(context).pushNamed(
              Routes.adminEditMessageScreen,
              arguments: AdminEditMessageParam(
                adminMessageModel: widget.screenParams.adminMessageModel,
              ),
            );
          },
          label: const Icon(
            Icons.edit,
          ),
        ),
      ),
    );
  }
}
