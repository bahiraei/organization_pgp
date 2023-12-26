import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organization_pgp/features/meeting/presentation/view/meetings_page_screen.dart';

import '../data/repository/meeting_repository.dart';
import 'bloc/meeting_bloc.dart';

class MeetingsScreen extends StatelessWidget {
  const MeetingsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MeetingBloc>(
      create: (context) {
        final bloc = MeetingBloc(
          repository: meetingRepository,
          context: context,
        );

        bloc.add(const MeetingStarted(
          isScrolling: false,
        ));
        return bloc;
      },
      child: const MeetingsPageScreen(),
    );
  }
}
