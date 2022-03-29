
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:weather_app/repository/todo_repository.dart';
import 'package:weather_app/service/auth/auth_service.dart';
import 'package:weather_app/service/weather/open_weather_service.dart';

import '../models/db/weather_model_db.dart';
import '../repository/auth_repository.dart';
import '../repository/location_repository.dart';
import '../repository/weather_repository.dart';
import 'auth/google_sign_in_service.dart';
import 'location/location_service.dart';

class DependencyInjection {
  final sl = GetIt.instance;
  final AuthService googleSingInService = GoogleSignInService();
  final LocationService locationService = LocationService();
  final OpenWeatherService weatherService = OpenWeatherService();
  var box = Hive.box<WeatherModelDB>('transactions');

  void initGetIt() {
    sl.registerLazySingleton<AuthRepository>(() =>  AuthRepository(
      googleSignInService: googleSingInService,
    ));
    sl.registerLazySingleton<LocationRepository>(() =>  LocationRepository(
      locationService: locationService,
    ));
    sl.registerLazySingleton<WeatherRepository>(() =>  WeatherRepository(
      weatherService: weatherService,
    ));
    sl.registerLazySingleton<NoteRepository>(() =>  NoteRepository(box));
  }

}
