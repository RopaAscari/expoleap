// @dart=2.9
import 'package:flutter/services.dart';

import 'handler.dart';
import 'constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:expoleap/resources/providers/notification/local_notiifcation_provider.dart';

Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage remoteMessage) async {
  LocalNotificationProvider.instance
      .showNotification(remoteMessage: remoteMessage);
}

Future<void> main() async {
  await dotenv.load();
  Paint.enableDithering = true;
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );

  await Firebase.initializeApp();
  // await FirebaseServices().getFcmToken();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(Constants(child: Handler()));
}
