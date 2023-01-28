import 'package:flutter/material.dart';
import 'package:flutter_weather/weather/weather.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:equatable/equatable.dart';

part 'theme_state.dart';

class ThemeCubit extends HydratedCubit<ThemeState> {
  static const defaultColor = Color(0xFF2196F3);

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
