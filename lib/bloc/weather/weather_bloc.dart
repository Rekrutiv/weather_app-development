import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/constants/keys.dart';
import 'package:weather_app/models/auth/authorized_user_model.dart';
import 'package:weather_app/models/location/location_model.dart';
import 'package:weather_app/repository/auth_repository.dart';
import 'package:weather_app/repository/location_repository.dart';
import 'package:weather_app/repository/weather_repository.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc({
    required AuthRepository authRepository,
    required LocationRepository locationRepository,
    required WeatherRepository weatherRepository,
  }) : super(WeatherInitial()) {
    _authRepository = authRepository;
    _locationRepository = locationRepository;
    _weatherRepository = weatherRepository;

    on<WeatherSetLocationEvent>(_weatherSetLocationEventHandler);
    on<WeatherSetUserEvent>(_weatherSetUserEventHandler);
    on<WeatherShowDaysForecastEvent>(_weatherShowDaysForecastEventHandler);
    on<WeatherShowHoursForecastEvent>(_weatherShowHoursForecastEventHandler);

    _addInitialWeatherFetchEvent();
  }
  late final AuthRepository _authRepository;
  late final LocationRepository _locationRepository;
  late final WeatherRepository _weatherRepository;

  WeatherState _intervalState = WeatherDaysForecastState([]);

  void _addInitialWeatherFetchEvent() {
    add(WeatherShowDaysForecastEvent(DateTime.now()));
  }

  Future _weatherSetLocationEventHandler(
    WeatherSetLocationEvent event,
    Emitter emit,
  ) async {
    final type = _intervalState.runtimeType;
    switch (type) {
      case WeatherDaysForecastState:
        await _weatherShowDaysForecastEventHandler(null, emit);
        break;
      case WeatherHoursForecastState:
        await _weatherShowHoursForecastEventHandler(null, emit);
        break;
      default:
        emit(WeatherFetchErrorState());
        break;
    }
  }

  Future _weatherSetUserEventHandler(
    WeatherSetUserEvent event,
    Emitter emit,
  ) async {
    final type = _intervalState.runtimeType;
    switch (type) {
      case WeatherDaysForecastState:
        await _weatherShowDaysForecastEventHandler(null, emit);
        break;
      case WeatherHoursForecastState:
        await _weatherShowHoursForecastEventHandler(null, emit);
        break;
      default:
        emit(WeatherFetchErrorState());
        break;
    }
  }

  Future _weatherShowDaysForecastEventHandler(
    WeatherShowDaysForecastEvent? event,
    Emitter emit,
  ) async {
    // TODO: implement filter based on provided [WeatherShowHoursForecastEvent.startingDate]
    final forecast = await _fetchWeatherForecast();
    final state = forecast.isEmpty
        ? WeatherFetchErrorState()
        : WeatherDaysForecastState(forecast);

    emit(state);
  }

  Future _weatherShowHoursForecastEventHandler(
    WeatherShowHoursForecastEvent? event,
    Emitter emit,
  ) async {
    // TODO: implement filter based on provided [WeatherShowHoursForecastEvent.dayDate]
    final forecast = await _fetchWeatherForecast();
    final state = forecast.isEmpty
        ? WeatherFetchErrorState()
        : WeatherHoursForecastState(forecast);

    emit(state);
  }

  Future<List<Weather>> _fetchWeatherForecast() async {
    final user = _authRepository.currentUser;
    late final LocationModel location;
    String userId = unauthorizedUserId;

    if (user is AuthorizedUserModel) {
      userId = user.id;
      location =
          await _locationRepository.getStoredUserLocation(userId).onError(
                (error, stackTrace) => _getCurrentLocation(),
              );
    } else {
      location = await _getCurrentLocation();
    }

    final List<Weather> forecast = [];
    try {
      final newForecast = await _weatherRepository
          .fetchWeatherForecastByLocation(location, Language.ENGLISH);
      forecast.addAll(newForecast);
      _weatherRepository.storeForecastForUser(
        forecast: forecast,
        userId: userId,
      );
    } catch (e) {
      //TODO: rework error handling
      log(e.toString());
      final storedForecast =
          await _weatherRepository.fetchStoredWeatherForecastByLocationForUser(
        userId: userId,
      );
      return storedForecast;
    }
    return forecast;
  }

  Future<LocationModel> _getCurrentLocation() async {
    return await _locationRepository.determineLocation().onError(
      (error, stackTrace) {
        return _locationRepository.defaultLocation;
      },
    );
  }

  @override
  void emit(WeatherState state) {
    _intervalState = state;
    // ignore: invalid_use_of_visible_for_testing_member
    super.emit(state);
  }
}
