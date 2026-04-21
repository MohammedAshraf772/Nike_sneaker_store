import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<bool> {
  // true = dark mode, false = light mode
  ThemeCubit() : super(true);

  void toggleTheme() => emit(!state);
}
