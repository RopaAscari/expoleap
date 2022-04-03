import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:expoleap/utils/utils.dart';
import 'package:expoleap/models/event.dart';
import 'package:expoleap/ui/event_screen.dart';
import 'package:expoleap/constants/constants.dart';
import 'package:expoleap/cubit/navigation_cubit.dart';
import 'package:expoleap/cubit/pinned_event_cubit.dart';
import 'package:expoleap/cubit/notification_cubit.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:expoleap/widgets/conditional_render_delegate.dart';

class EventTile extends StatefulWidget {
  final dynamic event;
  final PinnedEventCubit cubit;
  final NotificationCubit notificationCubit;
  EventTile(
      {required this.cubit,
      required this.event,
      required this.notificationCubit});
  EventTileState createState() => EventTileState();
}

class EventTileState extends State<EventTile> {
  EventModel get event => widget.event;

  Widget build(BuildContext _) {
    return ListTile(
      onTap: () async {
        FocusScope.of(context).unfocus();

        await Future.delayed(Duration(milliseconds: 200));

        NavigationCubit.navigatorInstance.navigateTo(
            route: EventScreen(
              event: event,
              tag: event.id,
              cubit: widget.cubit,
              notificationCubit: widget.notificationCubit,
            ),
            context: context);
      },
      leading: ConditionalRenderDelegate(
        condition: event.icon != null,
        renderWidget: CachedNetworkImage(
          width: 60.0,
          height: 60.0,
          imageUrl: event.icon ?? '',
          imageBuilder: (context, imageProvider) => Container(
              decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                      fit: BoxFit.cover, image: imageProvider))),
          placeholder: (context, url) => Shimmer.fromColors(
              period: Duration(milliseconds: 1500),
              baseColor: HexColor('#EEECEC'),
              highlightColor: Colors.grey[200]!,
              enabled: true,
              child: Container(
                width: 60.0,
                height: 60.0,
              )),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        fallbackWidget: ClipRRect(
          child: Image.asset(
            Constants.of(context).defaultEvent,
            width: 45,
            height: 45,
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(500.0),
        ),
      ),
      title: Text(event.name,
          style:
              TextStyle(fontSize: ResponsiveFlutter.of(context).fontSize(1.4))),
      subtitle: Text(event.address.region,
          style:
              TextStyle(fontSize: ResponsiveFlutter.of(context).fontSize(1.2))),
    );
  }
}
