import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/theme/theme.dart'
    show BrighterColor, DarkerColor;
import 'package:flutter_weather/weather/weather.dart';

import '../../theme/cubit/theme_cubit.dart';

class WeatherPopulated extends StatelessWidget {
  const WeatherPopulated({
    super.key,
    required this.weather,
    required this.units,
    required this.onRefresh,
  });

  final Weather weather;
  final TemperatureUnits units;
  final ValueGetter<Future<void>> onRefresh;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = context.read<ThemeCubit>().state.isDarkMode;
    final textColor =
        isDarkMode ? theme.colorScheme.secondary : theme.colorScheme.onPrimary;
    return Stack(
      children: [
        _WeatherBackground(),
        RefreshIndicator(
          onRefresh: onRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            clipBehavior: Clip.none,
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 48),
                  _WeatherIcon(condition: weather.condition),
                  Text(
                    weather.location,
                    style: theme.textTheme.headline2?.copyWith(
                      fontWeight: FontWeight.w200,
                      color: textColor,
                    ),
                  ),
                  Text(
                    weather.formattedTemperature(units),
                    style: theme.textTheme.headline3?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  Text(
                    '''Last Updated at ${TimeOfDay.fromDateTime(weather.lastUpdated).format(context)}''',
                    style: theme.textTheme.bodyText1?.copyWith(
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _WeatherIcon extends StatelessWidget {
  const _WeatherIcon({required this.condition});

  static const _iconSize = 75.0;

  final WeatherCondition condition;

  @override
  Widget build(BuildContext context) {
    return Text(
      condition.toEmoji,
      style: const TextStyle(fontSize: _iconSize),
    );
  }
}

extension on WeatherCondition {
  String get toEmoji {
    switch (this) {
      case WeatherCondition.clear:
        return '☀️';
      case WeatherCondition.rainy:
        return '🌧️';
      case WeatherCondition.cloudy:
        return '☁️';
      case WeatherCondition.snowy:
        return '🌨️';
      case WeatherCondition.unknown:
        return '❓';
    }
  }
}

class _WeatherBackground extends StatefulWidget {
  @override
  State<_WeatherBackground> createState() => _WeatherBackgroundState();
}

class _WeatherBackgroundState extends State<_WeatherBackground> {
  @override
  Widget build(BuildContext context) {
    final color = context.read<ThemeCubit>().state.color;
    final lightColors = [
      color,
      color.brighten(),
      color.brighten(33),
      color.brighten(50),
    ];
    final darkColors = [
      color,
      color.darken(),
      color.darken(33),
      color.darken(50),
    ];
    return BlocBuilder<ThemeCubit, ThemeState>(
      buildWhen: (previous, current) =>
          previous.isDarkMode != current.isDarkMode,
      builder: (context, state) {
        return SizedBox.expand(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.25, 0.75, 0.90, 1.0],
                colors: state.isDarkMode ? darkColors : lightColors,
              ),
            ),
          ),
        );
      },
    );
  }
}

extension on Weather {
  String formattedTemperature(TemperatureUnits units) {
    return '''${temperature.value.toStringAsPrecision(2)}°${units.isCelsius ? 'C' : 'F'}''';
  }
}
