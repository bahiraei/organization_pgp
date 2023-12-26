import 'package:flutter/material.dart';

import '../../../../../core/utils/routes.dart';
import '../../../../profile/data/model/profile_model.dart';
import '../home_items.dart';

class PersonalPage extends StatelessWidget {
  final ProfileData? profile;

  const PersonalPage({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(
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
          HomeItems(
            color: Colors.purple,
            text: "فیش",
            routeName: Routes.fish,
            child: Icon(
              Icons.receipt_long,
              color: Colors.white,
            ),
          ),
          HomeItems(
            color: Colors.green,
            text: "دفترچه تلفن",
            routeName: Routes.phoneBook,
            child: Icon(
              Icons.phone_rounded,
              color: Colors.white,
            ),
          ),
          /*    HomeItems(
            color: Colors.blue,
            text: "افراد تحت تکفل",
            routeName: Routes.dependants,
            arguments: profile?.dependencies,
            child: const Icon(
              Icons.family_restroom_rounded,
              color: Colors.white,
            ),
          ),*/
          /*  const HomeItems(
            color: Colors.red,
            text: "لیست امول",
            routeName: Routes.property,
            child: Icon(
              Icons.home_work,
              color: Colors.white,
            ),
          ),*/
          /* const HomeItems(
            color: Colors.blueAccent,
            text: "مناسبت ها",
            routeName: Routes.event,
            child: Icon(
              Icons.event_seat,
              color: Colors.white,
            ),
          ),*/
          HomeItems(
            color: Colors.blueGrey,
            text: "جلسات",
            routeName: Routes.meetings,
            child: Icon(
              Icons.group,
              color: Colors.white,
            ),
          ),
          HomeItems(
            color: Colors.indigo,
            text: "تقویم دیجیتال",
            routeName: Routes.calendar,
            child: Icon(
              Icons.calendar_month_rounded,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
