import 'app.dart';
import 'cubit/sponspor_cubit.dart';
import 'cubit/exhibitor_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:expoleap/cubit/map_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expoleap/cubit/event_cubit.dart';
import 'package:expoleap/cubit/theme_cubit.dart';
import 'package:expoleap/cubit/speaker_cubit.dart';
import 'package:expoleap/cubit/session_cubit.dart';
import 'package:expoleap/cubit/calender_cubit.dart';
import 'package:expoleap/cubit/notification_cubit.dart';
import 'package:expoleap/cubit/pinned_event_cubit.dart';

class Handler extends StatefulWidget {
  Handler({Key? key}) : super(key: key);
  HandlerState createState() => HandlerState();
}

class HandlerState extends State<Handler> {
  List<BlocProvider<Cubit>> combineProviders() {
    return [
      BlocProvider<MapCubit>(create: (context) => MapCubit()),
      BlocProvider<EventCubit>(create: (context) => EventCubit()),
      BlocProvider<ThemeCubit>(create: (context) => ThemeCubit()),
      BlocProvider<SpeakerCubit>(create: (context) => SpeakerCubit()),
      BlocProvider<SponsorCubit>(create: (context) => SponsorCubit()),
      BlocProvider<SessionCubit>(create: (context) => SessionCubit()),
      BlocProvider<CalendarCubit>(create: (context) => CalendarCubit()),
      BlocProvider<ExhibitorCubit>(create: (context) => ExhibitorCubit()),
      BlocProvider<PinnedEventCubit>(create: (context) => PinnedEventCubit()),
      BlocProvider<NotificationCubit>(create: (context) => NotificationCubit())
    ];
  }

  Widget build(BuildContext _) {
    return MultiBlocProvider(
        providers: combineProviders(),
        child: MaterialApp(debugShowCheckedModeBanner: false, home: App()));
  }
}
