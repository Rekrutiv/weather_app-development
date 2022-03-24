import 'package:hive_flutter/hive_flutter.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/constants/keys.dart';
import 'package:weather_app/models/location/location_model.dart';
import 'package:weather_app/service/weather/open_weather_service.dart';

class WeatherRepository {
  WeatherRepository({
    required OpenWeatherService weatherService,
  }) {
    _weatherService = weatherService;
  }
  // TODO: refactor to use Factory method (for different locales)
  late final OpenWeatherService _weatherService;

  Future<List<Weather>> fetchWeatherForecastByLocation(
    LocationModel location,
    Language language,
  ) async {
    try {
      return await _weatherService.fetchWeatherForecastByLocation(
        location,
        language,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Weather>> fetchStoredWeatherForecastByLocationForUser({
    required String userId,
  }) async {
    final box = await _openWeatherBox();
    final List<Weather> forecast = [];
    final jsonList = box.get(userId) as List<Map<String, dynamic>>?;
    jsonList?.forEach((e) => forecast.add(Weather(e)));
    return forecast;
  }

  Future<void> storeForecastForUser({
    required List<Weather> forecast,
    required String userId,
  }) async {
    final box = await _openWeatherBox();
    final jsonList = forecast.map((e) => e.toJson()).toList();
    box.put(userId, jsonList);
  }

  Future<Box> _openWeatherBox() async {
    return await Hive.openBox(weatherBoxKey);
  }
}
