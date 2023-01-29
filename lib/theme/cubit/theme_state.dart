part of 'theme_cubit.dart';

class ThemeState extends Equatable {
  final bool isDarkMode;
  final Color color;

  const ThemeState({required this.isDarkMode, required this.color});

  @override
  List<Object> get props => [isDarkMode, color];

  ThemeMode themeMode() {
    return isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }
}

class ThemeInitial extends ThemeState {
  const ThemeInitial()
      : super(isDarkMode: false, color: ThemeCubit.defaultColor);
}

class CurrentTheme extends ThemeState {
  const CurrentTheme({required super.isDarkMode, required super.color});
}
