import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organization_pgp/features/home/data/model/home_data_model.dart';

import '../../../../../core/utils/routes.dart';
import '../../../../feedback/presentation/feedback_screen.dart';
import '../../../../profile/data/model/profile_model.dart';
import '../../bloc/home_bloc.dart';
import '../home_items.dart';

class HomePage extends StatelessWidget {
  final HomeData? homaData;
  final ProfileData? profile;

  const HomePage({
    super.key,
    required this.homaData,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
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
          /* HomeItems(
            color: Colors.green,
            text: "اخبار",
            routeName: Routes.news,
            child: Image.asset(
              AppImages.news,
              color: Colors.white,
            ),
          ),*/
          Builder(
            builder: (context) {
              return HomeItems(
                color: Colors.red,
                text: "پیام ها",
                badgeCount: homaData?.newMessageCount == null ||
                        homaData?.newMessageCount == 0
                    ? null
                    : homaData?.newMessageCount,
                routeName: Routes.message,
                onTap: () async {
                  await Navigator.pushNamed(
                    context,
                    Routes.message,
                  );

                  BlocProvider.of<HomeBloc>(context).add(const HomeStarted(
                    isRefreshing: true,
                  ));
                },
                child: const Icon(
                  Icons.perm_media,
                  color: Colors.white,
                ),
              );
            },
          ),
          /* HomeItems(
            color: Colors.blue,
            text: "نظر سنجی",
            routeName: Routes.survey,
            badgeCount:
                homaData?.newVoteCount == null || homaData?.newVoteCount == 0
                    ? null
                    : homaData?.newVoteCount,
            onTap: () async {
              await Navigator.pushNamed(
                context,
                Routes.survey,
              );

              BlocProvider.of<HomeBloc>(context).add(const HomeStarted(
                isRefreshing: true,
              ));
            },
            child: Image.asset(
              AppImages.survey,
              color: Colors.white,
            ),
          ),*/
          /*HomeItems(
            color: Colors.pink,
            text: "مسابقه",
            routeName: Routes.competition,
            child: Image.asset(
              AppImages.competition,
              color: Colors.white,
            ),
          ),*/
          HomeItems(
            color: Colors.blueGrey,
            text: "انتقادات و پیشنهادات",
            routeName: Routes.feedbacks,
            arguments: FeedbackScreenParams(
              profileData: profile,
            ),
            child: const Icon(
              Icons.feedback_outlined,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
