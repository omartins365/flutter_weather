import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/theme/theme.dart';
import 'package:flutter_weather/weather/weather.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_repository/weather_repository.dart';

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key, required WeatherRepository weatherRepository})
      : _weatherRepository = weatherRepository;

  final WeatherRepository _weatherRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _weatherRepository,
      child: BlocProvider(
        create: (_) => ThemeCubit(),
        child: const WeatherAppView(),
      ),
    );
  }
}

class WeatherAppView extends StatelessWidget {
  const WeatherAppView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return MaterialApp(
          theme: ThemeData(
            primaryColor: state.color,
            textTheme: GoogleFonts.rajdhaniTextTheme().apply(
              bodyColor: Colors.black,
              displayColor: Colors.black,
            ),
            appBarTheme: AppBarTheme(
              titleTextStyle: GoogleFonts.rajdhaniTextTheme(textTheme)
                  .apply(bodyColor: Colors.white)
                  .headline5,
              foregroundColor: Colors.white,
              backgroundColor: state.color.darken(30),
            ),
          ),
          darkTheme: ThemeData(
            primaryColor: state.color,
            textTheme: GoogleFonts.rajdhaniTextTheme().apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ),
            brightness: Brightness.dark,
            appBarTheme: AppBarTheme(
              titleTextStyle: GoogleFonts.rajdhaniTextTheme(textTheme)
                  .apply(bodyColor: Colors.white)
                  .headline5,
              foregroundColor: Colors.white,
              backgroundColor: state.color.darken(30),
            ),

            /* dark theme settings */
          ),
          themeMode: state.themeMode(),
          home: const WeatherPage(),
        );
      },
    );
  }
}
