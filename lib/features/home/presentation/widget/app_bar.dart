import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organization_pgp/features/home/data/model/home_data_model.dart';
import 'package:organization_pgp/features/home/presentation/widget/tab_bar.dart';

import '../../../../core/core.dart';
import '../bloc/home_bloc.dart';

class CustomAppBar extends StatefulWidget {
  final VoidCallback drawerTap;
  final ValueNotifier<int> tabIndexNotifier;
  final HomeData? homeData;

  const CustomAppBar({
    super.key,
    required this.drawerTap,
    required this.tabIndexNotifier,
    required this.homeData,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: widget.drawerTap,
              icon: const Icon(
                Icons.menu,
                color: Colors.blue,
              ),
            ),
            const CustomLogo(),
            if ((widget.homeData?.newMessageCount ?? 0) > 0)
              Builder(
                builder: (context) {
                  return Badge(
                    label: Text(
                      '${widget.homeData?.newMessageCount}',
                    ),
                    isLabelVisible: widget.homeData?.newMessageCount != null &&
                        (widget.homeData?.newMessageCount ?? 0) > 0,
                    alignment: Alignment.topRight,
                    offset: const Offset(-7, 8),
                    child: IconButton(
                      onPressed: () async {
                        await Navigator.of(context).pushNamed(Routes.message);

                        BlocProvider.of<HomeBloc>(context)
                            .add(const HomeStarted(
                          isRefreshing: true,
                          homData: null,
                        ));
                      },
                      icon: const Icon(
                        Icons.notifications,
                        color: Colors.blue,
                      ),
                    ),
                  );
                },
              ),
            if ((widget.homeData?.newMessageCount ?? 0) <= 0)
              const SizedBox(width: 48),
          ],
        ),
        const Spacer(),
        ValueListenableBuilder<int>(
          valueListenable: widget.tabIndexNotifier,
          builder: (context, index, _) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(1, 2),
                    blurRadius: 1,
                  ),
                ],
              ),
              child: Row(
                children: [
                  CustomTabBar(
                    title: 'خانه',
                    isShowLine: widget.tabIndexNotifier.value == 0,
                    onTap: () => widget.tabIndexNotifier.value = 0,
                    child: Icon(
                      Icons.home,
                      color: widget.tabIndexNotifier.value == 0
                          ? Colors.black87
                          : Colors.black54,
                    ),
                  ),
                  CustomTabBar(
                    icon: Icons.person,
                    title: 'پرسنلی',
                    isShowLine: widget.tabIndexNotifier.value == 1,
                    onTap: () => widget.tabIndexNotifier.value = 1,
                  ),
                  CustomTabBar(
                    title: 'مانیتورینگ 360',
                    isShowLine: widget.tabIndexNotifier.value == 2,
                    onTap: () => widget.tabIndexNotifier.value = 2,
                    icon: Icons.star,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
