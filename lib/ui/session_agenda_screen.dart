import 'dart:math';
import 'package:expoleap/models/event_cubit_bundle.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:expoleap/utils/utils.dart';
import 'package:expoleap/enums/enums.dart';
import 'package:expoleap/models/event.dart';
import 'package:expoleap/widgets/error.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expoleap/cubit/theme_cubit.dart';
import 'package:expoleap/widgets/event_menu.dart';
import 'package:expoleap/constants/constants.dart';
import 'package:expoleap/cubit/session_cubit.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:expoleap/cubit/navigation_cubit.dart';
import 'package:expoleap/models/timetable_events.dart';
import 'package:expoleap/ui/session_detail_screen.dart';
import 'package:expoleap/state/session/session_state.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source) {
    appointments = source;
  }
}

class SessionAgendaScreen extends StatefulWidget {
  final EventModel event;
  final EventCubitBundle cubitBundle;
  SessionAgendaScreen({required this.event, required this.cubitBundle});
  @override
  SessionAgendaScreenState createState() => SessionAgendaScreenState();
}

class SessionAgendaScreenState extends State<SessionAgendaScreen> {
  final List<Color> _colorCollection = <Color>[];
  final List<String> _subjectCollection = <String>[];
  final SessionCubit sessionCubit = new SessionCubit();
  List<TimeRegion> _specialTimeRegion = <TimeRegion>[];
  final List<DateTime> _endTimeCollection = <DateTime>[];
  final List<DateTime> _startTimeCollection = <DateTime>[];
  final CalendarController controller = new CalendarController();
  final CalendarDataSource _dataSource = _DataSource(<Appointment>[]);
  final List<CalendarView> views = [
    CalendarView.day,
    CalendarView.week,
    CalendarView.month,
    CalendarView.schedule,
    CalendarView.workWeek,
    CalendarView.timelineDay,
    CalendarView.timelineWeek,
    CalendarView.timelineMonth,
    CalendarView.timelineWorkWeek,
  ];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    fetchSessions();
    super.initState();
  }

  fetchSessions() {
    sessionCubit.fetchSessions(eventId: widget.event.id);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void toggleMonthView() {
    controller.view = CalendarView.month;
  }

  void toggleDayView() {
    controller.view = CalendarView.workWeek;
  }

  @override
  Widget build(BuildContext context) {
    final bool isMonthView = controller.view == CalendarView.month;
    final bool isDarkTheme = BlocProvider.of<ThemeCubit>(context)
            .state
            .maybeWhen(
                data: (theme) => theme,
                orElse: () => Constants.of(context).darkTheme) ==
        Constants.of(context).darkTheme;

    return SafeArea(
        child: Scaffold(
            floatingActionButton: Padding(
                padding: const EdgeInsets.all(10),
                child: Opacity(
                    opacity: 1,
                    child: FloatingActionButton(
                      elevation: 0,
                      backgroundColor: Colors.blue[500],
                      child: Icon(
                        CupertinoIcons.calendar_badge_plus,
                        color: Colors.white,
                      ),
                      onPressed: () => toggleMonthView(),
                    ))),
            key: _scaffoldKey,
            drawer: new Drawer(
              child: EventMenu(
                  event: widget.event,
                  cubitBundle: widget.cubitBundle,
                  route: EventRoutes.Agenda),
            ),
            body: SafeArea(
                child: BlocConsumer<SessionCubit, SessionState>(
              builder: (BuildContext context, SessionState state) {
                return state.when(
                    idle: () => Center(),
                    loading: () => timetableLoadingWidget(isDarkTheme),
                    data: (timeTableEvents) => timeTableWidget(timeTableEvents),
                    error: (error) => errorWidget(error));
              },
              listener: (BuildContext context, SessionState state) {},
              bloc: sessionCubit,
            ))));
  }

  Widget timetableLoadingWidget(bool isDarkTheme) {
    return Center(child: CupertinoActivityIndicator());
  }

  Widget errorWidget(String error) {
    return Flex(direction: Axis.horizontal, children: [
      Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Flex(direction: Axis.vertical, children: [
            ErrorDisplay(
                error: error,
                enableRefresh: true,
                onRefresh: () => fetchSessions())
          ]))
    ]);
  }

  Widget timeTableWidget(List<TimetableEvent> timetablEvents) {
    final bool isDarkTheme = BlocProvider.of<ThemeCubit>(context)
            .state
            .maybeWhen(
                data: (theme) => theme,
                orElse: () => Constants.of(context).darkTheme) ==
        Constants.of(context).darkTheme;
    return Stack(children: <Widget>[
      SfCalendarTheme(
        data: SfCalendarThemeData(
          todayTextStyle: TextStyle(color: Colors.white),
          todayHighlightColor: Colors.blue[400],
          selectionBorderColor: Colors.blue[300],
          // cellBorderColor:
          brightness: isDarkTheme ? Brightness.dark : Brightness.light,
          backgroundColor: Theme.of(context).primaryColor,
        ),
        child: SfCalendar(
          allowedViews: [
            CalendarView.day,
            CalendarView.workWeek,
            CalendarView.timelineDay,
            CalendarView.timelineWeek,
          ],

          controller: controller,

          scheduleViewSettings: ScheduleViewSettings(
              monthHeaderSettings: MonthHeaderSettings(
            monthFormat: 'MMMM yyyy',
            height: 100,
            monthTextStyle: TextStyle(
                fontSize: 20,
                color: isDarkTheme ? HexColor('#EAEAEA') : Colors.grey[800]!),
            textAlign: TextAlign.left,
            backgroundColor:
                isDarkTheme ? HexColor('#141010') : HexColor('#EAEAEA'),
          )),
          //  cellBorderColor: Colros.red,
          dataSource: TimetableDataSource(timetablEvents),
          view: CalendarView.workWeek,
          onTap: (CalendarTapDetails details) {
            if (controller.view == CalendarView.month) {
              toggleDayView();
              return;
            }

            if (details.appointments == null) {
              return;
            }

            NavigationCubit.navigatorInstance.navigateTo(
                route: SessionDetailScreen(
                    session: details.appointments?[0].session),
                context: context);
          },

          onViewChanged: viewChanged,
          specialRegions: _specialTimeRegion,
        ),
      ),
      /*  Align(
          alignment: Alignment.topRight,
          child: FloatingActionButton(
            child: Icon(Icons.menu,
                color: isDarkTheme ? Colors.white : Colors.black),
            backgroundColor: Theme.of(context).primaryColor,
            heroTag: null,
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          )),*/
    ]);
  }

  void viewChanged(ViewChangedDetails viewChangedDetails) {
    List<DateTime> visibleDates = viewChangedDetails.visibleDates;
    List<TimeRegion> _timeRegion = <TimeRegion>[];
    List<Appointment> appointments = <Appointment>[];
    _dataSource.appointments!.clear();

    for (int i = 0; i < visibleDates.length; i++) {
      if (visibleDates[i].weekday == 6 || visibleDates[i].weekday == 7) {
        continue;
      }
      _timeRegion.add(TimeRegion(
          startTime: DateTime(visibleDates[i].year, visibleDates[i].month,
              visibleDates[i].day, 13, 0, 0),
          endTime: DateTime(visibleDates[i].year, visibleDates[i].month,
              visibleDates[i].day, 14, 0, 0),
          text: 'Break',
          enablePointerInteraction: false));
      SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
        setState(() {
          _specialTimeRegion = _timeRegion;
        });
      });
      for (int j = 0; j < _startTimeCollection.length; j++) {
        DateTime startTime = new DateTime(
            visibleDates[i].year,
            visibleDates[i].month,
            visibleDates[i].day,
            _startTimeCollection[j].hour,
            _startTimeCollection[j].minute,
            _startTimeCollection[j].second);
        DateTime endTime = new DateTime(
            visibleDates[i].year,
            visibleDates[i].month,
            visibleDates[i].day,
            _endTimeCollection[j].hour,
            _endTimeCollection[j].minute,
            _endTimeCollection[j].second);
        Random random = Random();
        appointments.add(Appointment(
            startTime: startTime,
            endTime: endTime,
            subject: _subjectCollection[random.nextInt(9)],
            color: _colorCollection[random.nextInt(9)]));
      }
    }
    for (int i = 0; i < appointments.length; i++) {
      _dataSource.appointments!.add(appointments[i]);
    }
    _dataSource.notifyListeners(
        CalendarDataSourceAction.reset, _dataSource.appointments!);
  }
}
