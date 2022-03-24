import 'package:weather/weather.dart';
import 'package:weather_app/constants/keys.dart';
import 'package:weather_app/models/location/location_model.dart';

class OpenWeatherService {
  WeatherFactory _getWeatherFactory(
    Language language,
  ) {
    return WeatherFactory(
      openWeatherMapApiKey,
      language: language,
    );
  }

  Future<List<Weather>> fetchWeatherForecastByLocation(
    LocationModel location,
    Language language,
  ) async {
    try {
      final List<Weather> weatherForecast =
          await _getWeatherFactory(language).fiveDayForecastByLocation(
        location.latitude,
        location.longitude,
      );

      return weatherForecast;
    } catch (e) {
      rethrow;
    }
  }
}
