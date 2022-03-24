import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_app/constants/keys.dart';
import 'package:weather_app/models/auth/authorized_user_model.dart';
import 'package:weather_app/models/location/location_model.dart';
import 'package:weather_app/repository/auth_repository.dart';
import 'package:weather_app/repository/location_repository.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc({
    required LocationRepository locationRepository,
    required AuthRepository authRepository,
  }) : super(LocationInitial()) {
    _locationRepository = locationRepository;
    _authRepository = authRepository;
    on<DetermineLocationEvent>(_determineLocationEventHandler);
    add(const DetermineLocationEvent());
  }

  late final LocationRepository _locationRepository;
  late final AuthRepository _authRepository;

  Future<void> _determineLocationEventHandler(event, emit) async {
    emit(const LocationLoadingState());
    try {
      final location = await _locationRepository.determineLocation();
      final updatedLocation = await _updateLocationName(location);
      emit(LocationDeterminedState(updatedLocation));
      await _saveLocationForCurrentUser(updatedLocation);
    } catch (e) {
      final storedLocation = await _getStoredLocationForCurrentUser();
      emit(LocationDeterminedState(storedLocation));
    }
  }

  Future<LocationModel> _updateLocationName(
    LocationModel location,
  ) async {
    // TODO: implement localization
    LocationModel? locationWithName;
    try {
      final placeMark = await _locationRepository.determineCityNameAtLocation(
        location,
      );
      final locationName = placeMark.locality;
      locationWithName = location.copyWith(
        name: locationName,
      );
      return locationWithName;
    } catch (e) {
      return location;
    }
  }

  Future<LocationModel> _getStoredLocationForCurrentUser() async {
    try {
      return await _locationRepository.getStoredUserLocation(_userId);
    } catch (e) {
      return _locationRepository.defaultLocation;
    }
  }

  Future<void> _saveLocationForCurrentUser(LocationModel location) async {
    await _locationRepository.saveUserLocation(
      userId: _userId,
      location: location,
    );
  }

  String get _userId {
    final user = _authRepository.currentUser;
    final isAuthorized = user is AuthorizedUserModel;
    final userId = isAuthorized ? user.id : unauthorizedUserIdKey;
    return userId;
  }
}
