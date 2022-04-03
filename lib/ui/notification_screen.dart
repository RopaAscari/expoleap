import 'package:expoleap/cubit/navigation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:expoleap/enums/enums.dart';
import 'package:expoleap/models/event.dart';
import 'package:expoleap/widgets/error.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_elapsed/time_elapsed.dart';
import 'package:expoleap/cubit/theme_cubit.dart';
import 'package:expoleap/constants/constants.dart';
import 'package:expoleap/models/notification.dart';
import 'package:expoleap/widgets/placeholder.dart';
import 'package:expoleap/widgets/flash_message.dart';
import 'package:expoleap/cubit/notification_cubit.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:expoleap/state/notification/notification_state.dart';

class NotificationScreen extends StatefulWidget {
  final EventModel event;
  final NotificationCubit notificationCubit;
  NotificationScreen(
      {Key? key, required this.event, required this.notificationCubit})
      : super(key: key);
  NotificationScreenState createState() => NotificationScreenState();
}

class NotificationScreenState extends State<NotificationScreen> {
  // final NotificationCubit notificationCubit = new NotificationCubit();

  @override
  initState() {
    super.initState();
    widget.notificationCubit.fetchNotifications(eventId: widget.event.id);
  }

  Future<void> showDeleteDialog(
      BuildContext highLevelContext, String notificationId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).canvasColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text('Delete Notification',
              style: TextStyle(
                  fontSize: ResponsiveFlutter.of(context).fontSize(1.55))),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'You are about to delete this notification, this action is irreversable',
                    style: TextStyle(
                        fontSize: ResponsiveFlutter.of(context).fontSize(1.5))),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                NavigationCubit.navigatorInstance.pop(context: context);
              },
            ),
            TextButton(
                child: const Text('Delete'),
                onPressed: () {
                  widget.notificationCubit.deleteNotification(
                      eventId: widget.event.id, notificationId: notificationId);
                  NavigationCubit.navigatorInstance.pop(context: context);
                  FlashMessage.snackBuilder(highLevelContext,
                      'Notification deleted', SnackBarType.Error);
                }),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext _) {
    final bool isDarkTheme = BlocProvider.of<ThemeCubit>(context)
            .state
            .maybeWhen(data: (theme) => theme, orElse: () => 'Dark') ==
        Constants.of(context).darkTheme;
    final Color baseColor = isDarkTheme ? Colors.white : Colors.black;
    return SafeArea(
        child: Scaffold(
            body: CustomScrollView(
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: <Widget>[
        appBar(baseColor),
        notificationSiliverList(isDarkTheme),
      ],
    )));
  }

  Widget refreshWidget() {
    return CupertinoSliverRefreshControl(
      refreshTriggerPullDistance: 100.0,
      refreshIndicatorExtent: 60.0,
      onRefresh: () async {
        await Future.delayed(Duration(milliseconds: 600));
        widget.notificationCubit.fetchNotifications(eventId: widget.event.id);
      },
    );
  }

  SliverList notificationSiliverList(bool isDarkTheme) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Padding(
              padding: const EdgeInsets.only(left: 15, top: 15),
              child: BlocConsumer<NotificationCubit, NotificationState>(
                builder: (BuildContext context, NotificationState state) {
                  return state.when(
                      idle: () => Center(child: Text('idle')),
                      loading: () => PlaceHolder(count: 10),
                      data: (notifications) =>
                          notificationList(notifications, isDarkTheme),
                      error: (error) => Flex(
                              direction: Axis.horizontal,
                              children: [
                                ErrorDisplay(
                                    error: error,
                                    enableRefresh: true,
                                    onRefresh: () => null)
                              ]));
                },
                listener: (BuildContext context, NotificationState state) {
                  final error = state.maybeWhen(
                      error: (error) => error, orElse: () => null);
                  if (error != null) {
                    return FlashMessage.snackBuilder(
                        context, error, SnackBarType.Error);
                  }
                },
                bloc: widget.notificationCubit,
              ))
        ],
      ),
    );
  }

  Widget notificationList(
      List<NotificationModel> notifications, bool isDarkTheme) {
    if (notifications.length == 0) {
      return emptyNotifications();
    }

    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: notifications.length,
            itemBuilder: (BuildContext context, int index) {
              return Slidable(
                actionPane: SlidableDrawerActionPane(),
                actionExtentRatio: 0.25,
                child: Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: ListTile(
                        // minLeadingWidth: 10,
                        leading: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: isDarkTheme
                                    ? Colors.grey[900]
                                    : Colors.grey[100]),
                            child: Opacity(
                                opacity: 0.7,
                                child: Image.asset(
                                    Constants.of(context).notificationBell,
                                    width: 50,
                                    height: 50))),
                        title: Text(
                          notifications[index].message,
                          style: TextStyle(
                              fontSize:
                                  ResponsiveFlutter.of(context).fontSize(1.3),
                              color: isDarkTheme
                                  ? Colors.grey[300]
                                  : Colors.black.withOpacity(0.7)),
                        ),
                        trailing: Text(
                            TimeElapsed().elapsedTimeDynamic(
                                new DateTime.fromMillisecondsSinceEpoch(notifications[index].timeStamp)
                                    .toString()),
                            style: TextStyle(
                                fontSize:
                                    ResponsiveFlutter.of(context).fontSize(1.2),
                                color: isDarkTheme
                                    ? Colors.grey[300]
                                    : Colors.black.withOpacity(0.7))))),
                secondaryActions: <Widget>[
                  IconSlideAction(
                    onTap: () =>
                        showDeleteDialog(context, notifications[index].id),
                    caption: 'Delete',
                    color: Colors.red,
                    icon: Icons.delete,
                  ),
                ],
              );
            }));
  }

  SliverAppBar appBar(Color baseColor) {
    return SliverAppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).canvasColor,
      floating: true,
      title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios,
              color: baseColor,
              size: 15,
            )),
        Text('Notifications',
            style: TextStyle(
                color: baseColor,
                fontSize: ResponsiveFlutter.of(context).fontSize(1.6)))
      ]),
    );
  }

  Widget emptyNotifications() {
    return Container(
        height: MediaQuery.of(context).size.height - 150,
        child: Flex(direction: Axis.horizontal, children: [
          Expanded(
              child: Center(
            child: Text(
              'No notifications available',
              style: TextStyle(
                  fontSize: ResponsiveFlutter.of(context).fontSize(1.35)),
            ),
          ))
        ]));
  }
}
