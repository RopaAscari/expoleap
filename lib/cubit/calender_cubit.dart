import 'package:bloc/bloc.dart';
import 'package:expoleap/models/calendar.dart';
import 'package:expoleap/state/calendar/calendar_state.dart';
import 'package:expoleap/resources/repositories/calendar_repository.dart';

class CalendarCubit extends Cubit<CalendarState> {
  CalendarCubit() : super(Idle());

  final CalendarRepository calendarRepository = new CalendarRepository();

  void fetchCalendarEvents() async {
    try {
      emit(CalendarState.loading());
      final Map<DateTime, List<Calendar>> events =
          await calendarRepository.fetchCalendarEvents();

      emit(CalendarState.data(data: events));
    } catch (error) {
      emit(CalendarState.error(error: error.toString()));
    }
  }
}
