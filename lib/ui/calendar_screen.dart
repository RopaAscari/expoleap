import 'package:intl/intl.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:expoleap/utils/utils.dart';
import 'package:expoleap/enums/enums.dart';
import 'package:expoleap/models/event.dart';
import 'package:expoleap/widgets/error.dart';
import 'package:expoleap/models/calendar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expoleap/widgets/event_menu.dart';
import 'package:expoleap/cubit/theme_cubit.dart';
import 'package:expoleap/constants/constants.dart';
import 'package:expoleap/cubit/calender_cubit.dart';
import 'package:ripple_animation/ripple_animation.dart';
import 'package:expoleap/models/event_cubit_bundle.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:expoleap/state/calendar/calendar_state.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:expoleap/widgets/conditional_render_delegate.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel, WeekdayFormat;

class CalendarScreen extends StatefulWidget {
  final EventModel event;
  final EventCubitBundle cubitBundle;
  CalendarScreen({Key? key, required this.event, required this.cubitBundle})
      : super(key: key);
  @override
  CalendarScreenState createState() => CalendarScreenState();
}

class CalendarScreenState extends State<CalendarScreen> {
  DateTime currDate = DateTime.now();
  List<Calendar> currentEvents = [];
  CalendarCubit calenderCubit = new CalendarCubit();
  Map<DateTime, List<Calendar>> calendarEvents = {};
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    calenderCubit.fetchCalendarEvents();
    super.initState();
  }

  String ordinaDate(int day) {
    if (day == 11 || day == 12 || day == 13) {
      return '${day}th';
    }
    if (day % 10 == 1) {
      return '${day}st';
    }
    if (day % 10 == 2) {
      return '${day}nd';
    }
    if (day % 10 == 3) {
      return '${day}rd';
    }
    return '${day}th';
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkTheme = BlocProvider.of<ThemeCubit>(context)
            .state
            .maybeWhen(
                data: (theme) => theme,
                orElse: () => Constants.of(context).darkTheme) ==
        Constants.of(context).darkTheme;
    final Color timelineColor = isDarkTheme ? Colors.white : Colors.black;

    return SafeArea(
        child: Scaffold(
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.blue[500],
              child: Icon(Icons.menu, color: Colors.white),
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            ),
            key: _scaffoldKey,
            drawer: new Drawer(
              child: EventMenu(
                  event: widget.event,
                  cubitBundle: widget.cubitBundle,
                  route: EventRoutes.Calendar),
            ),
            body: Stack(children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
                child: CalendarCarousel<Calendar>(
                  onCalendarChanged: (date) {
                    //    print('DATE $date');
                  },
                  onDayPressed: (DateTime date, List<Calendar> events) {
                    this.setState(() {
                      currDate = date;
                      currentEvents = events;
                    });
                  },
                  dayPadding: 6.5,
                  headerTextStyle: TextStyle(
                      color: timelineColor,
                      fontSize: ResponsiveFlutter.of(context).fontSize(1.7)),
                  thisMonthDayBorderColor: Colors.transparent,
                  selectedDayButtonColor: Colors.blue[500]!,
                  selectedDayBorderColor: Colors.transparent,
                  // markedDateIconOffset: 2.0,
                  selectedDayTextStyle: TextStyle(
                      color: timelineColor,
                      fontSize: ResponsiveFlutter.of(context).fontSize(1.35)),
                  weekendTextStyle: TextStyle(
                      color: timelineColor,
                      fontSize: ResponsiveFlutter.of(context).fontSize(1.35)),
                  daysTextStyle: TextStyle(
                      color: timelineColor,
                      fontSize: ResponsiveFlutter.of(context).fontSize(1.35)),
                  nextDaysTextStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: ResponsiveFlutter.of(context).fontSize(1.35)),
                  prevDaysTextStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: ResponsiveFlutter.of(context).fontSize(1.35)),
                  weekdayTextStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: ResponsiveFlutter.of(context).fontSize(1.35)),
                  weekDayFormat: WeekdayFormat.short,
                  firstDayOfWeek: 0,
                  showHeader: true,
                  isScrollable: true,
                  weekFormat: false,
                  height: MediaQuery.of(context).size.height,
                  selectedDateTime: currDate,
                  daysHaveCircularBorder: true,
                  customGridViewPhysics: NeverScrollableScrollPhysics(),
                  markedDatesMap: EventList<Calendar>(events: calendarEvents),
                  markedDateWidget: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Container(
                        height: 0,
                        width: 0,
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(top: 10),
                        decoration: new BoxDecoration(
                          color: Color(0xFF30A9B2),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                      )),
                ),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Material(
                      elevation: 50,
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * .49,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey[800]!,
                                offset: Offset(0.5, 0.5), //(x,y)
                                blurRadius: 3.0,
                              ),
                            ],
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20)),
                          ),
                          child: CustomScrollView(
                              physics: const BouncingScrollPhysics(
                                  parent: AlwaysScrollableScrollPhysics()),
                              slivers: <Widget>[
                                SliverAppBar(
                                  elevation: 0,
                                  floating: true,
                                  title: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Events on the ${ordinaDate(currDate.day)}',
                                        style: TextStyle(
                                            color: isDarkTheme
                                                ? Colors.white
                                                : Colors.grey[800],
                                            fontSize:
                                                ResponsiveFlutter.of(context)
                                                    .fontSize(1.55)),
                                      )),
                                  automaticallyImplyLeading: false,
                                  //  title: null,
                                  backgroundColor: Colors.transparent,
                                ),
                                refreshWidget(),
                                SliverList(
                                    delegate: SliverChildListDelegate([
                                  Padding(
                                      padding: const EdgeInsets.all(25),
                                      child: BlocConsumer<CalendarCubit,
                                          CalendarState>(
                                        builder: (BuildContext context,
                                            CalendarState state) {
                                          return state.when(
                                              idle: () => Center(),
                                              loading: () => loadingWidget(),
                                              data: (calendar) => Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.45,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: eventListContainer()),
                                              error: (error) => Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.80,
                                                  child: Flex(
                                                      direction: Axis.vertical,
                                                      children: [
                                                        ErrorDisplay(
                                                            error: error,
                                                            enableRefresh: true,
                                                            onRefresh: () =>
                                                                null)
                                                      ])));
                                        },
                                        listener: (BuildContext context,
                                            CalendarState state) {
                                          final Map<DateTime, List<Calendar>>?
                                              data = state.maybeWhen(
                                                  data: (data) => data,
                                                  orElse: () => null);

                                          if (data != null) {
                                            this.setState(
                                                () => calendarEvents = data);
                                          }
                                        },
                                        bloc: calenderCubit,
                                      )),
                                ]))
                              ]))))
            ])));
  }

  Widget refreshWidget() {
    return CupertinoSliverRefreshControl(
      refreshTriggerPullDistance: 100.0,
      refreshIndicatorExtent: 60.0,
      onRefresh: () async {
        await Future.delayed(Duration(milliseconds: 600));
        // widget.notificationCubit.fetchNotifications(eventId: widget.event.id);
      },
    );
  }

  Widget loadingWidget() {
    return Center(child: CircularProgressIndicator());
  }

  Widget eventListContainer() {
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      ConditionalRenderDelegate(
          condition: currentEvents.length == 0,
          renderWidget: Expanded(
              child: Center(
                  child: Padding(
                      padding: const EdgeInsets.only(bottom: 100),
                      child: Text('No events available ',
                          style: TextStyle(
                              fontSize: ResponsiveFlutter.of(context)
                                  .fontSize(1.4)))))),
          fallbackWidget: Expanded(
              child: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: ListView.builder(
                    itemCount: currentEvents.length,
                    itemBuilder: (BuildContext context, int index) {
                      return eventList(currentEvents[index]);
                    },
                  ))))
    ]);
  }

  Widget eventList(Calendar calendar) {
    DateFormat format = DateFormat("hh:mm a");
    final dateString = format.format(DateTime.parse(calendar.originalStart));

    return Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.transparent,
              offset: Offset(1, 3), //(x,y)
              blurRadius: 5.0,
            ),
          ],
        ),
        child: ListTile(
            isThreeLine: true,
            minLeadingWidth: 25.0,
            leading: Container(
                width: 10,
                height: 15,
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 15),
                child: RippleAnimation(
                    repeat: true,
                    color: HexColor(calendar.color),
                    minRadius: 15,
                    ripplesCount: 6,
                    child: Container())),
            title: Text(calendar.title ?? '',
                style: TextStyle(
                    fontSize: ResponsiveFlutter.of(context).fontSize(1.55))),
            subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(calendar.description,
                      style: TextStyle(
                          fontSize:
                              ResponsiveFlutter.of(context).fontSize(1.4))),
                  Text(calendar.location,
                      style: TextStyle(
                          fontSize:
                              ResponsiveFlutter.of(context).fontSize(1.0)))
                ]),
            trailing: Text(dateString.toString(),
                style: TextStyle(
                    fontSize: ResponsiveFlutter.of(context).fontSize(1.3)))));
  }
}
