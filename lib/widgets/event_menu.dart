import 'package:expoleap/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:expoleap/enums/enums.dart';
import 'package:expoleap/models/event.dart';
import 'package:expoleap/ui/home_screen.dart';
import 'package:expoleap/ui/event_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttericon/elusive_icons.dart';
import 'package:expoleap/cubit/event_cubit.dart';
import 'package:expoleap/ui/calendar_screen.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:expoleap/constants/constants.dart';
import 'package:expoleap/cubit/navigation_cubit.dart';
import 'package:expoleap/models/event_menu_item.dart';
import 'package:expoleap/ui/session_agenda_screen.dart';
import 'package:expoleap/models/event_cubit_bundle.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:expoleap/ui/speaker/speaker_list_screen.dart';
import 'package:expoleap/ui/sponsor/sponsor_list_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expoleap/ui/exhibitor/exhibitor_list_screen.dart';
import 'package:expoleap/widgets/conditional_render_delegate.dart';

class EventMenu extends StatefulWidget {
  final EventModel event;
  final EventRoutes route;
  final EventCubitBundle cubitBundle;

  EventMenu({
    required this.event,
    required this.route,
    required this.cubitBundle,
  });
  EventMenuState createState() => EventMenuState();
}

class EventMenuState extends State<EventMenu> {
  Widget build(BuildContext context) {
    final bool isDarkTheme = BlocProvider.of<ThemeCubit>(context)
            .state
            .maybeWhen(data: (theme) => theme, orElse: () => 'Dark') ==
        Constants.of(context).darkTheme;
    final List<EventMenuItem> menuItems = [
      EventMenuItem(
          title: 'Calendar',
          icon: Elusive.calendar,
          eventRoute: EventRoutes.Calendar,
          route: CalendarScreen(
              event: widget.event, cubitBundle: widget.cubitBundle)),
      EventMenuItem(
          title: 'Agenda',
          icon: Entypo.back_in_time,
          eventRoute: EventRoutes.Agenda,
          route: SessionAgendaScreen(
              event: widget.event, cubitBundle: widget.cubitBundle)),
      EventMenuItem(
          title: 'Speakers',
          icon: Entypo.sound,
          eventRoute: EventRoutes.Speaker,
          route: SpeakerListScreen(
              event: widget.event, cubitBundle: widget.cubitBundle)),
      EventMenuItem(
          title: 'Exhibitors',
          icon: Entypo.users,
          eventRoute: EventRoutes.Exhibitor,
          route: ExhibitorListScreen(
              event: widget.event, cubitBundle: widget.cubitBundle)),
      EventMenuItem(
          title: 'Sponsors',
          icon: Entypo.thumbs_up,
          eventRoute: EventRoutes.Sponsor,
          route: SponsorListScreen(
              event: widget.event, cubitBundle: widget.cubitBundle)),
    ];

    return Column(children: [
      Container(
          decoration: BoxDecoration(
              color: isDarkTheme ? Colors.black : Colors.grey[100],
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(0))),
          child: Column(children: [
            Padding(
                padding: const EdgeInsets.all(10),
                child: InkWell(
                    onTap: () => NavigationCubit.navigatorInstance.navigateTo(
                        route: HomeScreen(
                            eventCubit: new EventCubit(),
                            enableHeroAniamtion: false,
                            pinnedEventCubit:
                                widget.cubitBundle.pinnedEventCubit,
                            notificationCubit:
                                widget.cubitBundle.notificationCubit),
                        shouldPreserveRouteHistory: false,
                        context: context),
                    child: Row(children: [
                      Icon(
                        Icons.arrow_back_ios,
                        size: 15,
                        color: Colors.grey[500],
                      ),
                      Text(
                        ' Back to Home',
                        style: TextStyle(
                            color: Colors.grey[500],
                            fontSize:
                                ResponsiveFlutter.of(context).fontSize(1.15)),
                      )
                    ]))),
            Padding(
                padding: const EdgeInsets.all(10),
                child: InkWell(
                    onTap: () {
                      if (widget.route == EventRoutes.Event) {
                        return null;
                      }
                      NavigationCubit.navigatorInstance.navigateTo(
                          route: EventScreen(
                              notificationCubit:
                                  widget.cubitBundle.notificationCubit,
                              cubit: widget.cubitBundle.pinnedEventCubit,
                              tag: '',
                              event: widget.event),
                          context: context);
                    },
                    child: Row(children: [
                      ConditionalRenderDelegate(
                        condition: widget.event.logo != null,
                        renderWidget: Container(
                            width: 35.0,
                            height: 35.0,
                            decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                image: new DecorationImage(
                                    fit: BoxFit.cover,
                                    image: CachedNetworkImageProvider(
                                        widget.event.logo ?? '')))),
                        fallbackWidget: ClipRRect(
                          child: Image.asset(
                            Constants.of(context).defaultEvent,
                            width: 35,
                            height: 35,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(500.0),
                        ),
                      ),
                      Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: Text(
                            widget.event.name,
                            style: TextStyle(
                                fontSize: ResponsiveFlutter.of(context)
                                    .fontSize(1.3)),
                          )),
                      ConditionalRenderDelegate(
                          condition: widget.route == EventRoutes.Event,
                          renderWidget: Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Icon(Icons.circle,
                                  size: 10, color: Colors.blue)),
                          fallbackWidget: Center())
                    ])))
          ])),
      Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 30),
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: menuItems.length,
            itemBuilder: (_, i) {
              final bool isSelected = menuItems[i].eventRoute == widget.route;
              return ListTile(
                  tileColor: isSelected ? Colors.blue[400] : null,
                  leading: Icon(
                    menuItems[i].icon,
                    color: isSelected ? Colors.white : Colors.grey[500],
                  ),
                  title: Text(menuItems[i].title,
                      style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey[500],
                          fontSize:
                              ResponsiveFlutter.of(context).fontSize(1.3))),
                  onTap: () => isSelected
                      ? null
                      : NavigationCubit.navigatorInstance.navigateTo(
                          route: menuItems[i].route, context: context));
            }),
      )
    ]);
  }
}
