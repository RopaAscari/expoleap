import 'dart:io';
import 'dart:ui';
import 'package:expoleap/models/event_cubit_bundle.dart';
import 'package:expoleap/widgets/event_menu.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:expoleap/utils/utils.dart';
import 'package:expoleap/enums/enums.dart';
import 'package:expoleap/models/map.dart';
import 'package:expoleap/models/event.dart';
import 'package:expoleap/models/contact.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:expoleap/cubit/map_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttericon/elusive_icons.dart';
import 'package:expoleap/cubit/theme_cubit.dart';
import 'package:expoleap/cubit/event_cubit.dart';
import 'package:expoleap/ui/calendar_screen.dart';
import 'package:expoleap/constants/constants.dart';
import 'package:expoleap/state/map/map_state.dart';
import 'package:expoleap/widgets/flash_message.dart';
import 'package:expoleap/models/event_menu_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expoleap/cubit/navigation_cubit.dart';
import 'package:expoleap/ui/notification_screen.dart';
import 'package:expoleap/widgets/contact_details.dart';
import 'package:expoleap/ui/session_agenda_screen.dart';
import 'package:expoleap/cubit/pinned_event_cubit.dart';
import 'package:expoleap/cubit/notification_cubit.dart';
import 'package:expoleap/widgets/social_media_links.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:expoleap/ui/speaker/speaker_list_screen.dart';
import 'package:expoleap/ui/sponsor/sponsor_list_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expoleap/ui/exhibitor/exhibitor_list_screen.dart';
import 'package:expoleap/state/pinned_event/pinned_event_state.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:expoleap/resources/providers/db/pinned_event_sql_provider.dart';
import 'package:google_static_maps_controller/google_static_maps_controller.dart'
    as StaticMap;
import 'package:expoleap/widgets/conditional_render_delegate.dart';

class EventScreen extends StatefulWidget {
  final String tag;
  final EventModel event;
  final PinnedEventCubit cubit;
  final NotificationCubit notificationCubit;
  EventScreen(
      {Key? key,
      required this.tag,
      required this.cubit,
      required this.event,
      required this.notificationCubit})
      : super(key: key);
  EventScreenState createState() => EventScreenState();
}

class EventScreenState extends State<EventScreen> {
  int selected = 0;
  bool isEventPinned = false;
  EventModel get event => widget.event;
  final MapCubit mapCubit = new MapCubit();
  PinnedEventCubit get pinnedEventCubit => widget.cubit;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  initState() {
    validatePinnedEvent();
    mapCubit.fetchMapFromAddress(address: event.address);
    super.initState();
  }

  validatePinnedEvent() async {
    final List<Map<String, Object?>> pinnedEvents =
        await PinnedEventSQLProvider.instance.retrievePinnedEvents();

    final bool isPinned = pinnedEvents
            .where((element) => element['id'] as String == event.id)
            .toList()
            .length >
        0;

    this.setState(() {
      isEventPinned = isPinned;
    });
  }

  pinEvent() async {
    pinnedEventCubit.pinEvent(eventId: event.id);
    this.setState(() {
      isEventPinned = true;
    });
    FlashMessage.snackBuilder(
        context, 'Event was pinned to your homescreen', SnackBarType.Success);
  }

  unPinEvent() async {
    pinnedEventCubit.unPinEvent(eventId: event.id);
    this.setState(() {
      isEventPinned = false;
    });
    FlashMessage.snackBuilder(context, 'Event was removed from your homescreen',
        SnackBarType.Success);
  }

  determineRenderPinIcon(bool isDarkTheme) {
    if (isEventPinned && isDarkTheme) {
      return Constants.of(context).pinIconDark;
    } else if (!isEventPinned && isDarkTheme) {
      return Constants.of(context).pinIconLight;
    } else if (isEventPinned && !isDarkTheme) {
      return Constants.of(context).pinIconLight;
    } else {
      return Constants.of(context).pinIconDark;
    }
  }

  Widget build(BuildContext _) {
    final bool isDarkTheme = BlocProvider.of<ThemeCubit>(context)
            .state
            .maybeWhen(
                data: (theme) => theme,
                orElse: () => Constants.of(context).darkTheme) ==
        Constants.of(context).darkTheme;

    final EventCubitBundle bundle = EventCubitBundle(
        pinnedEventCubit: widget.cubit,
        notificationCubit: widget.notificationCubit);

    return BlocConsumer<PinnedEventCubit, PinnedEventState>(
        bloc: pinnedEventCubit,
        listener: (context, state) {
          final error =
              state.maybeWhen(error: (error) => error, orElse: () => null);

          if (error != null) {
            this.setState(() {
              isEventPinned = false;
            });
            FlashMessage.snackBuilder(context,
                'Error occured while pinning event', SnackBarType.Error);
          }
        },
        builder: (BuildContext context, PinnedEventState state) {
          return SafeArea(
              child: Scaffold(
                  key: _scaffoldKey,
                  drawer: new Drawer(
                    child: EventMenu(
                        event: widget.event,
                        cubitBundle: bundle,
                        route: EventRoutes.Event),
                  ),
                  backgroundColor: Theme.of(context).canvasColor,
                  body: CustomScrollView(
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    slivers: <Widget>[
                      SliverAppBar(
                        floating: true,
                        leading: menuIconWidget(),
                        actions: <Widget>[notificationIconWidget()],
                        title: null,
                        backgroundColor: Colors.transparent,
                        expandedHeight: 400.0,
                        flexibleSpace: FlexibleSpaceBar(
                          collapseMode: CollapseMode.pin,
                          background: eventLogo(event.logo),
                        ),
                      ),
                      SliverPadding(
                          padding: const EdgeInsets.all(15),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate(
                              [
                                eventHeader(event.name, event.description,
                                    isDarkTheme, isEventPinned),
                                countdownWidget(
                                    event.dates[0].end, isDarkTheme),
                                mapWidget(isDarkTheme),
                                contactDetailWidget(event),
                                socialMediaLinksWidget(),
                              ],
                            ),
                          )),
                    ],
                  )));
        });
  }

  Widget menuIconWidget() {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: InkWell(
          child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: HexColor('#232323').withOpacity(0.7)),
              child: Icon(
                Icons.menu,
                //  color: baseColor,
              )),
          onTap: () => _scaffoldKey.currentState?.openDrawer(),
        ));
  }

  Widget notificationIconWidget() {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: InkWell(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: HexColor('#232323').withOpacity(0.7)),
              child: Stack(children: [
                SvgPicture.asset(
                  Constants.of(context).bellIcon,
                  height: 19,
                  width: 19,
                ),
                Positioned(
                    top: 0,
                    right: 0,
                    child: Icon(Icons.circle, color: Colors.red, size: 9))
              ]),
            ),
            onTap: () => NavigationCubit.navigatorInstance.navigateTo(
                route: NotificationScreen(
                    event: event, notificationCubit: widget.notificationCubit),
                context: context)));
  }

  Widget mapWidget(bool isDarkTheme) {
    return BlocBuilder<MapCubit, MapState>(
        bloc: mapCubit,
        builder: (BuildContext context, MapState state) {
          return state.when(
              idle: () => Center(),
              error: (error) => mapErrorWidget(error),
              loading: () => mapShimmerWidget(isDarkTheme),
              data: (data) => locationDisplayWidget(data));
        });
  }

  Widget mapErrorWidget(String error) {
    final String location =
        '${event.address.address1}, ${event.address.address2}, ${event.address.region}';
    return Column(children: [
      locationHeader(location),
      Container(
          width: 475,
          height: 300,
          margin: const EdgeInsets.only(top: 12),
          child: Center(
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('$error  ',
                style: TextStyle(
                  fontSize: ResponsiveFlutter.of(context).fontSize(1.4),
                )),
            Icon(Icons.error, color: Colors.red[400])
          ])),
          decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20)))
    ]);
  }

  Widget socialMediaShimmerWidget(isDarkTheme) {
    return Shimmer.fromColors(
        period: Duration(milliseconds: 1000),
        baseColor: HexColor(isDarkTheme ? '#4E4D4D' : '#EEECEC'),
        highlightColor: isDarkTheme ? Colors.grey[700]! : Colors.grey[200]!,
        enabled: true,
        child: Container(
            margin: const EdgeInsets.only(top: 50),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                height: 30,
                width: 30,
                margin: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100)),
              ),
              Container(
                height: 30,
                width: 30,
                margin: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100)),
              ),
              Container(
                height: 30,
                width: 30,
                margin: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100)),
              ),
              Container(
                height: 30,
                width: 30,
                margin: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100)),
              )
            ])));
  }

  Widget contactShimmerWidget(bool isDarkTheme) {
    return Shimmer.fromColors(
        period: Duration(milliseconds: 1000),
        baseColor: HexColor(isDarkTheme ? '#4E4D4D' : '#EEECEC'),
        highlightColor: isDarkTheme ? Colors.grey[700]! : Colors.grey[200]!,
        enabled: true,
        child: Column(children: [
          Align(
              alignment: Alignment.centerLeft,
              child: Container(
                height: 30,
                margin: const EdgeInsets.only(top: 15),
                width: 100,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(7)),
              )),
          Align(
              alignment: Alignment.centerLeft,
              child: Container(
                height: 30,
                margin: const EdgeInsets.only(top: 20),
                width: 200,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(7)),
              )),
          Align(
              alignment: Alignment.centerLeft,
              child: Container(
                height: 30,
                margin: const EdgeInsets.only(top: 10),
                width: 200,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(7)),
              ))
        ]));
  }

  Widget mapShimmerWidget(bool isDarkTheme) {
    return Shimmer.fromColors(
        period: Duration(milliseconds: 1000),
        baseColor: HexColor(isDarkTheme ? '#4E4D4D' : '#EEECEC'),
        highlightColor: isDarkTheme ? Colors.grey[700]! : Colors.grey[200]!,
        enabled: true,
        child: Column(children: [
          Align(
              alignment: Alignment.centerLeft,
              child: Container(
                alignment: Alignment.centerLeft,
                width: 100,
                height: 25,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(7)),
                margin: const EdgeInsets.only(top: 25),
              )),
          Container(
            width: MediaQuery.of(context).size.width - 30,
            height: 300,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.only(top: 15),
          )
        ]));
  }

  Widget logoShimmerWidget(bool isDarkTheme) {
    return Shimmer.fromColors(
        period: Duration(milliseconds: 1000),
        baseColor: HexColor(isDarkTheme ? '#4E4D4D' : '#EEECEC'),
        highlightColor: isDarkTheme ? Colors.grey[700]! : Colors.grey[200]!,
        enabled: true,
        child: Container(
          height: 400,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
        ));
  }

  Widget countDownShimmerWidget(bool isDarkTheme) {
    return Shimmer.fromColors(
        period: Duration(milliseconds: 1000),
        baseColor: HexColor(isDarkTheme ? '#4E4D4D' : '#EEECEC'),
        highlightColor: isDarkTheme ? Colors.grey[700]! : Colors.grey[200]!,
        enabled: true,
        child: Container(
          height: 120,
          margin: const EdgeInsets.only(top: 20),
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
        ));
  }

  Widget eventHeaderShimmerWidget(bool isDarkTheme) {
    return Shimmer.fromColors(
        period: Duration(milliseconds: 1000),
        baseColor: HexColor(isDarkTheme ? '#4E4D4D' : '#EEECEC'),
        highlightColor: isDarkTheme ? Colors.grey[700]! : Colors.grey[200]!,
        enabled: true,
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
              height: 25,
              width: 100,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
            ),
            Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
            )
          ]),
          Container(
            height: 50,
            margin: const EdgeInsets.only(top: 15),
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5)),
          ),
        ]));
  }

  Widget eventStackActions() {
    return Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: HexColor('#232323')),
                  child: SvgPicture.asset(
                    Constants.of(context).menuIcon,
                    height: 22,
                    width: 22,
                  )),
              onTap: () => _scaffoldKey.currentState?.openDrawer(),
            ),
            InkWell(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: HexColor('#232323')),
                  child: Stack(children: [
                    SvgPicture.asset(
                      Constants.of(context).bellIcon,
                      height: 19,
                      width: 19,
                    ),
                    Positioned(
                        top: 0,
                        right: 0,
                        child: Icon(Icons.circle, color: Colors.red, size: 9))
                  ]),
                ),
                onTap: () => NavigationCubit.navigatorInstance.navigateTo(
                    route: NotificationScreen(
                        event: event,
                        notificationCubit: widget.notificationCubit),
                    context: context)),
          ],
        ));
  }

  Widget eventLogo(String? logo) {
    return Hero(
      tag: widget.tag,
      child: ConditionalRenderDelegate(
          condition: logo != null,
          renderWidget: Container(
              height: 400,
              width: MediaQuery.of(context).size.width,
              decoration: new BoxDecoration(
                  // shape: BoxShape.circle,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(25),
                      bottomLeft: Radius.circular(25)),
                  image: new DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(logo as String)))),
          fallbackWidget: ClipRRect(
              child: Image.asset(
                Constants.of(context).defaultEvent,
                width: MediaQuery.of(context).size.width,
                height: 400,
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(25),
                  bottomLeft: Radius.circular(25)))),
    );
  }

  Widget eventHeader(
      String name, String? description, bool isDarkTheme, bool isEventPinned) {
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          '$name',
          style:
              TextStyle(fontSize: ResponsiveFlutter.of(context).fontSize(1.9)),
        ),
        InkWell(
            child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: isEventPinned
                        ? Colors.orange
                        : isDarkTheme
                            ? Colors.black
                            : HexColor('#F7F7F7'),
                    borderRadius: BorderRadius.circular(10)),
                child: SvgPicture.asset(
                  determineRenderPinIcon(isDarkTheme),
                  height: 20,
                  width: 20,
                )),
            onTap: () => isEventPinned ? unPinEvent() : pinEvent())
      ]),
      Text(
        '\n$description',
        style: TextStyle(fontSize: ResponsiveFlutter.of(context).fontSize(1.4)),
      )
    ]);
  }

  Widget socialMediaLinksWidget() {
    return SocialMediaLinks(socials: event.social);
  }

  Widget contactDetailWidget(EventModel event) {
    final Contact contact = new Contact(
        email: event.email, phone: event.phone, website: event.website);
    return ContactDetails(
      contact: contact,
    );
  }

  Widget drawerMenuItems(List<EventMenuItem> menuItems) {
    return Column(children: [
      Padding(
          padding: const EdgeInsets.all(10),
          child: Row(children: [
            IconButton(
                padding: const EdgeInsets.all(0),
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 15,
                  color: Colors.grey[500],
                ),
                onPressed: () =>
                    NavigationCubit.navigatorInstance.pop(context: context)),
            Text(
              ' Back to Home',
              style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: ResponsiveFlutter.of(context).fontSize(1.15)),
            )
          ])),
      Padding(
          padding: const EdgeInsets.all(10),
          child: Row(children: [
            ConditionalRenderDelegate(
              condition: event.logo != null,
              renderWidget: Container(
                  width: 35.0,
                  height: 35.0,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          fit: BoxFit.cover,
                          image:
                              CachedNetworkImageProvider(event.logo ?? '')))),
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
                  event.name,
                  style: TextStyle(
                      fontSize: ResponsiveFlutter.of(context).fontSize(1.3)),
                ))
          ])),
      Padding(
        padding: const EdgeInsets.only(top: 30, bottom: 30),
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: menuItems.length,
            itemBuilder: (_, i) {
              return ListTile(
                  tileColor: selected == i ? Colors.blue[200] : null,
                  leading: Icon(
                    menuItems[i].icon,
                    color: selected == i ? Colors.white : Colors.grey[800],
                  ),
                  title: Text(menuItems[i].title,
                      style: TextStyle(
                          color:
                              selected == i ? Colors.white : Colors.grey[800],
                          fontSize:
                              ResponsiveFlutter.of(context).fontSize(1.4))),
                  onTap: () => {
                        this.setState(() => selected = i),
                        NavigationCubit.navigatorInstance.navigateTo(
                            route: menuItems[i].route, context: context)
                      });
            }),
      )
    ]);
  }

  Widget locationHeader(String location) {
    return Row(
      children: [
        SvgPicture.asset(
          Constants.of(context).markerIcon,
          height: 25,
          width: 25,
        ),
        Text(
          '  $location',
          style:
              TextStyle(fontSize: ResponsiveFlutter.of(context).fontSize(1.3)),
        )
      ],
    );
  }

  Widget locationDisplayWidget(MapResponse mapData) {
    return Container(
        margin: const EdgeInsets.only(
          top: 15,
        ),
        child: Column(
          children: [
            locationHeader(mapData.location),
            InkWell(
                onTap: () =>
                    MapUtils.openMap(mapData.latitude, mapData.longitude),
                child: Container(
                    margin: const EdgeInsets.only(
                      top: 15,
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Image(image: mapData.image))))
          ],
        ));
  }

  Widget countdownWidget(String date, bool isDarkTheme) {
    final DateTime dateTime = DateTime.parse(date);
    Timestamp myTimeStamp = Timestamp.fromDate(dateTime);
    return Container(
      height: 120,
      margin: const EdgeInsets.only(top: 15, bottom: 10),
      width: double.infinity,
      decoration: BoxDecoration(
          color: HexColor(isDarkTheme ? '#0B0000' : '#F1F1F1'),
          borderRadius: BorderRadius.circular(15)),
      child: Center(
        child: CountdownTimer(
          endTime: myTimeStamp.millisecondsSinceEpoch,
          widgetBuilder: (_, CurrentRemainingTime? time) {
            if (time == null) {
              final String date = DateFormat('MMM d, y').format(dateTime);
              return Center(child: Text('The event ended on $date'));
            }
            final days = (time.days ?? '00').toString();
            final hours = (time.hours ?? '00').toString();
            final min = (time.min ?? '00').toString();
            final sec = (time.sec ?? '00').toString();
            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Event starts in'),
                  Text(
                    ' $days: $hours: $min: $sec',
                    style: TextStyle(
                        fontSize: ResponsiveFlutter.of(context).fontSize(4)),
                  )
                ]);
          },
        ),
      ),
    );
  }
}
