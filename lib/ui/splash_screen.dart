import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:expoleap/ui/home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expoleap/cubit/event_cubit.dart';
import 'package:expoleap/cubit/theme_cubit.dart';
import 'package:expoleap/constants/constants.dart';
import 'package:expoleap/cubit/navigation_cubit.dart';
import 'package:expoleap/cubit/pinned_event_cubit.dart';
import 'package:expoleap/cubit/notification_cubit.dart';

class SplashScreen extends StatefulWidget {
  final NotificationCubit notificationCubit;
  SplashScreen({Key? key, required this.notificationCubit}) : super(key: key);

  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  final EventCubit eventCubit = new EventCubit();
  final PinnedEventCubit pinnedEventCubit = new PinnedEventCubit();

  @override
  initState() {
    super.initState();
    navigateToHomeScreen();
  }

  void navigateToHomeScreen() {
    Future.delayed(
      Duration(milliseconds: 3000),
      () => Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
              transitionDuration: Duration(milliseconds: 2000),
              pageBuilder: (_, __, ___) => HomeScreen(
                    eventCubit: eventCubit,
                    enableHeroAniamtion: true,
                    pinnedEventCubit: pinnedEventCubit,
                    notificationCubit: widget.notificationCubit,
                  )),
          (route) => false),
    );
  }

  Widget build(BuildContext context) {
    final bool isDarkTheme = BlocProvider.of<ThemeCubit>(context)
            .state
            .maybeWhen(
                data: (theme) => theme,
                orElse: () => Constants.of(context).darkTheme) ==
        Constants.of(context).darkTheme;

    final String logo = isDarkTheme
        ? Constants.of(context).appLogoDark
        : Constants.of(context).appLogoLight;

    return Scaffold(
        backgroundColor: Theme.of(context).canvasColor,
        body: Center(
            child: Hero(
                tag: Constants.of(context).appLogoHeroTag,
                child: Image.asset(logo,
                    width: MediaQuery.of(context).size.width * 0.50))));
  }
}
