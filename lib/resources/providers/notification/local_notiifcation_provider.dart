import 'dart:math';
import 'dart:convert';
import 'package:expoleap/models/event.dart';
import 'package:expoleap/models/notification.dart';
import 'package:expoleap/widgets/late_handler.dart';
import 'package:expoleap/cubit/navigation_cubit.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:expoleap/resources/repositories/event_repository.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:expoleap/resources/providers/db/notification_sql_provider.dart';

const String appTitle = 'ExpoLeap';
const String androidChannelId = 'EU383H7MEI983BSG';
const String androidChannelName = 'ExpoLeap Notifications';
const String placeHolderId = '969a6ca3-5982-4c99-b5d5-3a613219b3fc';
const String androidChannelDescription =
    'Android channel to handle local app notifications';

class LocalNotificationProvider {
  LocalNotificationProvider._();
  static final LocalNotificationProvider instance =
      LocalNotificationProvider._();

  Late<FlutterLocalNotificationsPlugin> _flutterLocalNotificationsPlugin =
      new Late();

  Future<FlutterLocalNotificationsPlugin>
      get flutterLocalNotificationsPlugin async {
    if (_flutterLocalNotificationsPlugin.isInitialized)
      return _flutterLocalNotificationsPlugin.val;
    //// if _database is null we instantiate it
    _flutterLocalNotificationsPlugin.val = await initializeLocalNotifications();
    return _flutterLocalNotificationsPlugin.val;
  }

  Future<FlutterLocalNotificationsPlugin> initializeLocalNotifications() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    await _requestPermissions(flutterLocalNotificationsPlugin);

    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {}

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
            onDidReceiveLocalNotification: (
              int id,
              String? title,
              String? body,
              String? payload,
            ) async {});
    const MacOSInitializationSettings initializationSettingsMacOS =
        MacOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: initializationSettingsMacOS,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      final decoded = json.decode(payload as String);
      if (decoded != null) {
        final EventModel event =
            await EventRepository().getEvent(decoded['eventId']);
        // NavigationCubit.navigatorInstance
        //     .navigateTo(route: route, context: BuildContext());
        print('notification payload: $payload');
      }
    });
    return flutterLocalNotificationsPlugin;
  }

  _requestPermissions(
      FlutterLocalNotificationsPlugin flutterLocalNotifications) async {
    flutterLocalNotifications
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    flutterLocalNotifications
        .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void showNotification({required RemoteMessage remoteMessage}) async {
    var flutterLocalNotifications = await flutterLocalNotificationsPlugin;

    final String id = remoteMessage.messageId as String;
    final String eventId = remoteMessage.from as String;
    final int locationNotificationId = new Random().nextInt(10000000);
    ;
    final int timeStamp = new DateTime.now().millisecondsSinceEpoch;
    final String message = remoteMessage.notification?.body as String;
    final NotificationModel notification = new NotificationModel(
        id: id, message: message, eventId: placeHolderId, timeStamp: timeStamp);

    await NotificationSQLProvider.instance
        .updateNotifications(notification, placeHolderId);

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      androidChannelId,
      androidChannelName,
      importance: Importance.max,
      priority: Priority.high,
    );

    const IOSNotificationDetails iosPlatformChannelSpecifics =
        IOSNotificationDetails();

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iosPlatformChannelSpecifics);

    flutterLocalNotifications.show(locationNotificationId, appTitle,
        notification.message, platformChannelSpecifics,
        payload: notification.toJson());
  }
}
