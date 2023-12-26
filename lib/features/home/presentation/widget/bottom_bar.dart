import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

class CustomNavigationBar extends StatefulWidget {
  final ValueNotifier<int> tabIndexNotifier;

  const CustomNavigationBar({
    super.key,
    required this.tabIndexNotifier,
  });

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenSize = Screen.fromContext(context).screenSize;

    double mainMargin = 0.1;
    if (screenSize == ScreenSize.xsmall) {
      mainMargin = 0.1;
    } else if (screenSize == ScreenSize.small) {
      mainMargin = 0.2;
    } else if (screenSize == ScreenSize.medium) {
      mainMargin = 0.3;
    } else if (screenSize == ScreenSize.large) {
      mainMargin = 0.3;
    } else if (screenSize == ScreenSize.xlarge) {
      mainMargin = 0.4;
    }
    return ValueListenableBuilder(
      valueListenable: widget.tabIndexNotifier,
      builder: (context, value, child) {
        return Container(
          height: 96,
          padding: const EdgeInsets.only(top: 14, bottom: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 2,
              ),
            ],
          ),
          margin: EdgeInsets.fromLTRB(
            size.width * mainMargin,
            0,
            size.width * mainMargin,
            20,
          ),
          child: Builder(
            builder: (context) {
              return BottomBarWidget(
                onTap: (value) {
                  widget.tabIndexNotifier.value = value;
                },
                currentIndex: widget.tabIndexNotifier.value,
              );
            },
          ),
        );
      },
    );
  }
}

class BottomBarWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int value) onTap;

  const BottomBarWidget({
    super.key,
    required this.onTap,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              onTap(0);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: currentIndex == 0 ? Colors.blue : Colors.blueGrey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const SizedBox(
                    width: 25,
                    height: 25,
                    child: Icon(
                      Icons.home,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'خانه',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: 0.8,
          height: 48,
          color: Colors.black12,
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              onTap(1);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: currentIndex == 1 ? Colors.blue : Colors.blueGrey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const SizedBox(
                    width: 25,
                    height: 25,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'پرسنلی',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: 0.8,
          height: 48,
          color: Colors.black12,
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              onTap(2);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: currentIndex == 2 ? Colors.blue : Colors.blueGrey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const SizedBox(
                    width: 25,
                    height: 25,
                    child: Icon(
                      Icons.star,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'مانیتورینگ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
