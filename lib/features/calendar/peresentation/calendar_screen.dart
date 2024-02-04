import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:organization_pgp/core/widgets/empty_view.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import '../../../core/consts/app_colors.dart';
import '../../../core/utils/helper.dart';
import '../../../core/utils/routes.dart';
import '../../../core/widgets/custom_button.dart';
import '../../meeting/data/model/meeting_model.dart';
import '../data/model/digital_calendar_model.dart';
import '../data/model/event_model.dart';
import '../data/repository/digital_calendar_repository.dart';
import 'bloc/digital_calendar_bloc.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  Jalali selectedDate = DateTime.now().toJalali();

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screenSize = Screen.fromContext(context).screenSize;

    double mainMargin = 0;
    if (screenSize == ScreenSize.xsmall) {
      mainMargin = 32;
    } else if (screenSize == ScreenSize.small) {
      mainMargin = 70;
    } else if (screenSize == ScreenSize.medium) {
      mainMargin = 250;
    } else if (screenSize == ScreenSize.large) {
      mainMargin = 400;
    } else if (screenSize == ScreenSize.xlarge) {
      mainMargin = 400;
    }
    return BlocProvider<DigitalCalendarBloc>(
      create: (context) {
        final bloc = DigitalCalendarBloc(
          repository: digitalCalendarRepository,
          context: context,
        );

        bloc.add(DigitalCalendarStarted());

        return bloc;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              children: [
                Gap(MediaQuery.of(context).viewPadding.top + 8),
                Row(
                  children: [
                    const Gap(8),
                    IconButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.arrow_back_ios_rounded,
                      ),
                    ),
                    const Gap(32),
                    const Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'تقویم دیجیتال',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(64),
                  ],
                ),
              ],
            ),
            BlocBuilder<DigitalCalendarBloc, DigitalCalendarState>(
              builder: (context, state) {
                Helper.log('state is $state');

                if (state is DigitalCalendarInitial ||
                    state is DigitalCalendarLoading) {
                  return const Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 32,
                          width: 32,
                          child: CircularProgressIndicator(),
                        ),
                      ],
                    ),
                  );
                } else if (state is DigitalCalendarError) {
                  return Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          state.exception.message ?? 'خطایی رخ داده است',
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
                              BlocProvider.of<DigitalCalendarBloc>(context).add(
                                DigitalCalendarStarted(),
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
                  );
                } else if (state is DigitalCalendarSuccess) {
                  final List<dynamic> listItems = [
                    ...state.digitalCalendars[selectedIndex].meetings,
                    ...state.digitalCalendars[selectedIndex].events
                  ];

                  Helper.log('listItems => ${listItems.length}');
                  return Expanded(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 180,
                          child: ListView.builder(
                            itemCount: state.digitalCalendars.length,
                            padding: EdgeInsets.symmetric(
                              horizontal: mainMargin,
                              vertical: 16,
                            ),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return DigitalCalendarDayItem(
                                digitalCalendar: state.digitalCalendars[index],
                                onTap: () {
                                  setState(() {
                                    selectedIndex = index;
                                  });
                                },
                                isSelected: selectedIndex == index,
                              );
                            },
                          ),
                        ),
                        const Gap(24),
                        Expanded(
                          child: ListView.builder(
                            itemCount: listItems.length,
                            padding: EdgeInsets.fromLTRB(
                              mainMargin - 12,
                              8,
                              mainMargin - 12,
                              24,
                            ),
                            itemBuilder: (context, index) {
                              if (listItems[index] is EventModel) {
                                return EventListItem(
                                  event: listItems[index],
                                );
                              } else if (listItems[index] is MeetingModel) {
                                return MeetingListItem(
                                  meeting: listItems[index],
                                );
                              }
                              return null;
                            },
                          ),
                        )
                      ],
                    ),
                  );
                } else if (state is DigitalCalendarEmpty) {
                  return const Expanded(
                    child: EmptyView(),
                  );
                }

                throw Exception('state not found');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DigitalCalendarDayItem extends StatelessWidget {
  final DigitalCalendarModel digitalCalendar;
  final bool isSelected;
  final Function() onTap;

  const DigitalCalendarDayItem({
    super.key,
    required this.digitalCalendar,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 16),
      child: InkWell(
        borderRadius:
            isSelected ? BorderRadius.circular(32) : BorderRadius.circular(16),
        onTap: () {
          onTap();
        },
        child: AnimatedContainer(
          width: isSelected ? null : 120,
          padding: EdgeInsets.fromLTRB(
            isSelected ? 8 : 32,
            0,
            isSelected ? 16 : 32,
            0,
          ),
          decoration: BoxDecoration(
            color: const Color(0xffe6edfd),
            borderRadius: isSelected
                ? BorderRadius.circular(32)
                : BorderRadius.circular(16),
            gradient: isSelected
                ? const LinearGradient(
                    colors: [
                      Color(0xff244993),
                      Color(0xff376fe0),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )
                : null,
            boxShadow: AppColor.shadow,
          ),
          duration: const Duration(milliseconds: 400),
          child: Row(
            mainAxisAlignment:
                isSelected ? MainAxisAlignment.start : MainAxisAlignment.center,
            children: [
              if (!isSelected)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      digitalCalendar.dayOfWeek,
                      style: TextStyle(
                        fontSize: 14,
                        color: isSelected ? Colors.white : null,
                      ),
                    ),
                    const Gap(4),
                    Text(
                      digitalCalendar.dayOfMonthNumber.toString(),
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w500,
                        color: isSelected ? Colors.white : null,
                      ),
                    ),
                    const Gap(4),
                    Text(
                      digitalCalendar.monthName,
                      style: TextStyle(
                        fontSize: 14,
                        color: isSelected ? Colors.white : null,
                      ),
                    ),
                    const Gap(8),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.orange,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 1,
                      ),
                      child: Text(
                        digitalCalendar.count.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              if (isSelected)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${digitalCalendar.dayOfMonthNumber} ${digitalCalendar.monthName}',
                      style: TextStyle(
                        fontSize: 14,
                        color: isSelected ? Colors.white : null,
                      ),
                    ),
                    const Gap(4),
                    Text(
                      digitalCalendar.dayOfWeek,
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w500,
                        color: isSelected ? Colors.white : null,
                      ),
                    ),
                    const Gap(4),
                    Text(
                      '${digitalCalendar.count} مورد',
                      style: TextStyle(
                        fontSize: 14,
                        color: isSelected ? Colors.white : null,
                      ),
                    ),
                  ],
                ),
              if (isSelected) const Gap(32),
              if (isSelected)
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_month_sharp,
                      color: Colors.white30,
                      size: 64,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class EventListItem extends StatelessWidget {
  final EventModel event;

  const EventListItem({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(9),
        onTap: () {
          /* Navigator.of(context).pushNamed(Routes.event);*/
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(9),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 3,
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xffFFD8A4),
                  borderRadius: BorderRadius.circular(9),
                ),
                padding: const EdgeInsets.all(16),
                width: 64,
                height: 64,
                child: Image.asset('assets/images/calendar/calendar.png'),
              ),
              const Gap(8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            event.title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'مکان : ${event.location}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Row(
                          children: [
                            const Flexible(
                              child: Text(
                                'ساعت : ',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                '${event.holdingHours}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                                textDirection: TextDirection.ltr,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MeetingListItem extends StatelessWidget {
  final MeetingModel meeting;

  const MeetingListItem({
    super.key,
    required this.meeting,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(9),
        onTap: () {
          Navigator.of(context).pushNamed(Routes.meetings);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(9),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 3,
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xffBFC3FF),
                  borderRadius: BorderRadius.circular(9),
                ),
                padding: const EdgeInsets.all(16),
                width: 64,
                height: 64,
                child: Image.asset('assets/images/calendar/admin.png'),
              ),
              const Gap(8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            meeting.title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            'مکان : ${meeting.location}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Flexible(
                                child: Text(
                                  'ساعت : ',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  meeting.startTime,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  textDirection: TextDirection.ltr,
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
      ),
    );
  }
}
