import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:weather_app/bloc/auth/auth_bloc.dart';
import 'package:weather_app/bloc/location/location_bloc.dart';
import 'package:weather_app/bloc/weather/weather_bloc.dart';
import 'package:weather_app/repository/auth_repository.dart';
import 'package:weather_app/repository/location_repository.dart';
import 'package:weather_app/repository/weather_repository.dart';
import 'package:weather_app/service/auth/auth_service.dart';
import 'package:weather_app/service/auth/google_sign_in_service.dart';
import 'package:weather_app/service/location/location_service.dart';
import 'package:weather_app/service/weather/open_weather_service.dart';
import 'package:weather_app/ui/global/theme.dart';
import 'package:weather_app/ui/home_screen/home_screen.dart';
import 'package:weather_app/ui/splash_screen/splash_screen.dart';

void main() async {
  await Hive.initFlutter();
  final AuthService googleSingInService = GoogleSignInService();
  final LocationService locationService = LocationService();
  final OpenWeatherService weatherService = OpenWeatherService();

  final AuthRepository authRepository = AuthRepository(
    googleSignInService: googleSingInService,
  );
  final LocationRepository locationRepository = LocationRepository(
    locationService: locationService,
  );
  final WeatherRepository weatherRepository = WeatherRepository(
    weatherService: weatherService,
  );

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (BuildContext context) => AuthBloc(
            authRepository: authRepository,
          ),
        ),
        BlocProvider<LocationBloc>(
          create: (BuildContext context) => LocationBloc(
            authRepository: authRepository,
            locationRepository: locationRepository,
          ),
        ),
        BlocProvider<WeatherBloc>(
          create: (BuildContext context) => WeatherBloc(
            authRepository: authRepository,
            locationRepository: locationRepository,
            weatherRepository: weatherRepository,
          ),
        ),
      ],
      child: EasyLocalization(
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('ru', 'RU'),
        ],
        startLocale: const Locale('ru', 'RU'),
        saveLocale: true,
        path: 'resources/locales',
        useOnlyLangCode: true,
        child: const MyApp(),
      ),
    ),
  );
  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
    ],
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'Weather App',
      theme: defaultTheme,
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => const SplashScreen(),
        HomeScreen.id: (context) => const HomeScreen(),
      },
    );
  }
}