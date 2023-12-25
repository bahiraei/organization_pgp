import 'package:flutter/material.dart';

import '../../../../../core/utils/routes.dart';
import '../../../../profile/data/model/profile_model.dart';
import '../home_items.dart';

class MonitoringPage extends StatelessWidget {
  final ProfileData? profile;

  const MonitoringPage({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    if (profile?.isAdmin ?? false) {
      return Padding(
        padding: const EdgeInsets.only(
          top: 20,
          right: 0,
        ),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          runAlignment: WrapAlignment.start,
          alignment: WrapAlignment.start,
          runSpacing: 20,
          spacing: 0,
          children: [
            /*const HomeItems(
              color: Colors.green,
              text: "پروژه ها",
              routeName: Routes.projectStatusCategory,
              child: Icon(
                Icons.pie_chart,
                color: Colors.white,
              ),
            ),*/
            /*HomeItems(
              color: Colors.purple,
              text: "BI",
              onTap: () {
                launchUrl(
                  Uri.parse('https://powerbi.bipc.ir/reports'),
                  mode: LaunchMode.externalApplication,
                );
              },
              child: const Icon(
                Icons.bar_chart,
                color: Colors.white,
              ),
            ),*/
            /*const HomeItems(
              color: Colors.blue,
              text: "هواشناسی",
              routeName: Routes.weather,
              child: Icon(
                Icons.cloud,
                color: Colors.white,
              ),
            ),*/
            if (profile?.canAddMessage ?? false)
              const HomeItems(
                color: Colors.orange,
                text: "مدیریت پیام",
                routeName: Routes.createMessageList,
                child: Icon(
                  Icons.message,
                  color: Colors.white,
                ),
              ),
          ],
        ),
      );
    } else {
      return const Expanded(
        child: Center(
          child: Text('موردی برای نمایش وجود ندارد'),
        ),
      );
    }
  }
}
