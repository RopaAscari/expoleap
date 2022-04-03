import 'package:expoleap/models/theme.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:expoleap/state/theme/theme_state.dart';

const String darkTheme = 'Dark';
const String lightTheme = 'Light';

class ThemeCubit extends HydratedCubit<ThemeState> {
  ThemeCubit() : super(Idle());

  void changeTheme({required String theme}) {
    try {
      emit(ThemeState.data(theme: theme));
    } catch (err) {
      ThemeState.error(error: err.toString());
    }
  }

  @override
  ThemeState fromJson(Map<String, dynamic> json) {
    try {
      final theme = ApplicationTheme.fromMap(json);
      return ThemeState.data(theme: theme.theme);
    } catch (_) {
      return ThemeState.data(theme: darkTheme);
    }
  }

  @override
  Map<String, dynamic> toJson(ThemeState state) {
    try {
      return {
        'theme': state.maybeWhen(data: (data) => data, orElse: () => darkTheme)
      };
    } catch (_) {
      return null as Map<String, dynamic>;
    }
  }
}
