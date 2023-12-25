import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/core.dart';
import '../../../profile/data/model/profile_model.dart';
import 'drawer_items.dart';

class CustomDrawer extends StatelessWidget {
  final ProfileData profile;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const CustomDrawer({
    super.key,
    required this.profile,
    required this.scaffoldKey,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(
                Routes.profile,
              );
              scaffoldKey.currentState?.closeDrawer();
            },
            child: Container(
              padding: const EdgeInsets.fromLTRB(15, 20, 15, 10),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
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
                              Navigator.of(context).pushNamed(
                                Routes.profile,
                              );
                              scaffoldKey.currentState?.closeDrawer();
                            },
                            imageUrl: AppEnvironment.baseUrl +
                                ("${profile.fullPathProfileImage}?v=${DateTime.now().millisecondsSinceEpoch}"),
                            fit: BoxFit.cover,
                            borderRadius: BorderRadius.circular(100),
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
                  const Gap(12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        profile.fullName ?? '',
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
                        profile.isAdmin ? 'مدیر' : 'کاربر',
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          DrawerMenuItem(
            title: 'حساب کاربری',
            child: const Icon(Icons.person),
            onTap: () {
              Navigator.of(context).pushNamed(
                Routes.profile,
              );
              scaffoldKey.currentState?.closeDrawer();
            },
          ),
          const Spacer(),
          Container(
            alignment: Alignment.center,
            height: 40,
            width: double.infinity,
            color: Colors.blue,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${AppInfo.packageInfo?.version} ',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                  textDirection: TextDirection.ltr,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
