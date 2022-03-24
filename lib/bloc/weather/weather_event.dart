part of 'weather_bloc.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();
}

class WeatherSetLocationEvent extends WeatherEvent {
  @override
  List<Object?> get props => [];
}

class WeatherSetUserEvent extends WeatherEvent {
  @override
  List<Object?> get props => [];
}

class WeatherShowDaysForecastEvent extends WeatherEvent {
  const WeatherShowDaysForecastEvent(
    this.startingDate,
  );
  // TODO: get rid of date field or make it optional (if making optional - make separate WeatherEvent class)
  final DateTime startingDate;
  @override
  List<Object?> get props => [
        startingDate.year,
        startingDate.month,
        startingDate.day,
      ];
}

class WeatherShowHoursForecastEvent extends WeatherEvent {
  const WeatherShowHoursForecastEvent(
    this.dayDate,
  );
  // TODO: get rid of date field or make it optional (if making optional - make separate WeatherEvent class)
  final DateTime dayDate;
  @override
  List<Object?> get props => [
        dayDate.year,
        dayDate.month,
        dayDate.day,
      ];
}
