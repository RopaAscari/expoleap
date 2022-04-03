import 'dart:async';
import 'package:flutter/services.dart';

import 'enums/enums.dart';
import 'cubit/theme_cubit.dart';
import 'package:flash/flash.dart';
import 'constants/constants.dart';
import 'cubit/notification_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:timetable/timetable.dart';
import 'package:expoleap/utils/utils.dart';
import 'package:expoleap/themes/themes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expoleap/ui/splash_screen.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:expoleap/resources/providers/notification/local_notiifcation_provider.dart';

class App extends StatefulWidget {
  App({Key? key}) : super(key: key);
  AppState createState() => AppState();
}

class AppState extends State<App> {
  Connectivity connectivity = Connectivity();
  late final StreamSubscription<ConnectivityResult> subscription;
  final NotificationCubit notificationCubit = new NotificationCubit();

  @override
  initState() {
    super.initState();
    connectivitySubscriber();
    handleForegroundNotificatons();
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }

  determineTheme(String theme) {
    if (theme == Constants.of(context).darkTheme) {
      return appThemeData[AppTheme.Dark];
    }
    return appThemeData[AppTheme.Light];
  }

  handleForegroundNotificatons() async {
    await FirebaseServices().getFcmToken();
    FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) async {
      LocalNotificationProvider.instance
          .showNotification(remoteMessage: remoteMessage);
    });
  }

  connectivitySubscriber() async {
    final ConnectivityResult connectivityResult =
        await (connectivity.checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(statusBarColor: Colors.red));
      _showBasicsFlash(duration: Duration(days: 365));
    }

    subscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      final bool notConnected = result == ConnectivityResult.none;

      if (notConnected) {
        SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(statusBarColor: Colors.red));
        _showBasicsFlash(duration: Duration(days: 365));
      } else {
        SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(statusBarColor: Colors.transparent));
      }
    });
    //});
  }

  void _showBasicsFlash({
    Duration? duration,
    flashStyle = FlashBehavior.floating,
  }) {
    final String theme = BlocProvider.of<ThemeCubit>(context, listen: false)
        .state
        .maybeWhen(data: (theme) => theme, orElse: () => 'Dark');
    final Color textColor = theme == Constants.of(context).darkTheme
        ? Colors.grey[800]!
        : Colors.white;
    final Color baseColor =
        theme == Constants.of(context).darkTheme ? Colors.white : Colors.black;

    final double offset = MediaQuery.of(context).size.width -
        MediaQuery.of(context).size.width * 0.60;

    showFlash(
      context: context,
      duration: duration,
      persistent: true,
      builder: (context, controller) {
        return Flash(
            behavior: flashStyle,
            controller: controller,
            backgroundColor: baseColor,
            position: FlashPosition.top,
            boxShadows: kElevationToShadow[10],
            borderRadius: BorderRadius.circular(50),
            margin: EdgeInsets.only(left: offset, right: offset, top: 10),
            horizontalDismissDirection: HorizontalDismissDirection.horizontal,
            child: FlashBar(
              showProgressIndicator: true,
              padding:
                  const EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 3),
              content: Row(
                children: [
                  Text('Offline ', style: TextStyle(color: textColor)),
                  Icon(Icons.offline_bolt, color: Colors.amber[600])
                ],
              ),
            ));
      },
    );
  }

  SnackBar notificationSnackBar() {
    return SnackBar(
        duration: Duration(seconds: 3),
        content: Container(
            height: 37,
            margin: const EdgeInsets.only(bottom: 20),
            child: Row(children: <Widget>[
              Icon(MaterialIcons.notifications),
              Text('New notifications coming in',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: ResponsiveFlutter.of(context).fontSize(1.3)))
            ])),
        backgroundColor: Colors.orange[800],
        behavior: SnackBarBehavior.fixed,
        action: new SnackBarAction(
          label: '',
          textColor: Colors.yellow,
          onPressed: () => null,
        ));
  }

  Widget build(BuildContext _) {
    final currentTheme = determineTheme(
        BlocProvider.of<ThemeCubit>(context, listen: true)
            .state
            .maybeWhen(data: (theme) => theme, orElse: () => 'Dark'));

    return MaterialApp(
      theme: currentTheme,
      home: SplashScreen(notificationCubit: notificationCubit),
      localizationsDelegates: [
        TimetableLocalizationsDelegate(),
      ],
      debugShowCheckedModeBanner: false,
      title: Constants.of(context).appName,
    );
  }
}
