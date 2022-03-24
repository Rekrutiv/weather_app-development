part of 'weather_bloc.dart';

abstract class WeatherState {
  const WeatherState();
}

// removed equatable due to time limitations (no time to implement props getter correctly)
class WeatherInitial extends WeatherState {}

class WeatherLoadingState extends WeatherState {}

class WeatherDaysForecastState extends WeatherState {
  const WeatherDaysForecastState(this.forecast);
  final List<Weather> forecast;
}

class WeatherHoursForecastState extends WeatherState {
  const WeatherHoursForecastState(this.forecast);
  final List<Weather> forecast;
}

class WeatherFetchErrorState extends WeatherState {}
