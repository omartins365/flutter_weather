import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_weather/theme/theme.dart';
import 'package:flutter_weather/weather/weather.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:equatable/equatable.dart';

part 'theme_state.dart';

class ThemeCubit extends HydratedCubit<ThemeState> {
  static const defaultColor = Colors.blue;

  ThemeCubit() : super(const ThemeInitial());

  void updateTheme(Weather? weather) {
    if (weather != null) {
      emit(CurrentTheme(color: weather.toColor, isDarkMode: state.isDarkMode));
    }
  }

  void toggleDarkMode() {
    final isDarkMode = state.isDarkMode;
    emit(CurrentTheme(color: state.color, isDarkMode: !isDarkMode));
  }

  @override
  ThemeState fromJson(Map<String, dynamic> json) {
    return CurrentTheme(
        color: Color(int.parse(json['color'] as String)),
        isDarkMode: state.isDarkMode);
  }

  @override
  Map<String, dynamic> toJson(ThemeState state) {
    return <String, String>{'color': '${state.color}'};
  }

  ThemeData themeData(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isDarkMode = state.isDarkMode;
    final brightness = isDarkMode ? Brightness.dark : Brightness.light;
    final color = state.color;

    // const Map<int, Color> colorSwatch = {
    //   50: Color.fromRGBO(136, 14, 79, .1),
    //   100: Color.fromRGBO(136, 14, 79, .2),
    //   200: Color.fromRGBO(136, 14, 79, .3),
    //   300: Color.fromRGBO(136, 14, 79, .4),
    //   400: Color.fromRGBO(136, 14, 79, .5),
    //   500: Color.fromRGBO(136, 14, 79, .6),
    //   600: Color.fromRGBO(136, 14, 79, .7),
    //   700: Color.fromRGBO(136, 14, 79, .8),
    //   800: Color.fromRGBO(136, 14, 79, .9),
    //   900: Color.fromRGBO(136, 14, 79, 1),
    // };

    // final defaultLightColorScheme = ColorScheme.fromSwatch(
    //     primarySwatch: MaterialColor(color.value, colorSwatch));

    // final defaultDarkColorScheme = ColorScheme.fromSwatch(
    //     primarySwatch: MaterialColor(color.value, colorSwatch),
    //     brightness: Brightness.dark);

    final themeData = ThemeData(
      useMaterial3: true,
      colorSchemeSeed: color,
      brightness: brightness,
      // colorScheme:
      // isDarkMode ? defaultDarkColorScheme : defaultLightColorScheme,
      // primaryColor: state.color,
      textTheme: GoogleFonts.rajdhaniTextTheme(),
      appBarTheme: AppBarTheme(
        titleTextStyle: GoogleFonts.rajdhaniTextTheme(textTheme)
            .apply(bodyColor: isDarkMode ? Colors.white : null)
            .headline5,
        // foregroundColor: Colors.white,
        // backgroundColor: isDarkMode ? color.darken(80) : null,
      ),
    );
    return themeData;
  }
}

extension on Weather {
  Color get toColor {
    switch (condition) {
      case WeatherCondition.clear:
        return Colors.orangeAccent;
      case WeatherCondition.snowy:
        return Colors.lightBlueAccent;
      case WeatherCondition.cloudy:
        return Colors.blueGrey;
      case WeatherCondition.rainy:
        return Colors.indigoAccent;
      case WeatherCondition.unknown:
      default:
        return ThemeCubit.defaultColor;
    }
  }
}
