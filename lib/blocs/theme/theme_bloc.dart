import 'package:flutterprojectsetup/blocs/theme/theme_event.dart';
import 'package:flutterprojectsetup/blocs/theme/theme_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc(super.initialState) {
    on<DarkThemeEvent>((event, emit) => emit(ChangeTheme(true)));
    on<LightThemeEvent>((event, emit) => emit(ChangeTheme(false)));
  }
}
