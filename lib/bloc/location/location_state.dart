part of 'location_bloc.dart';

abstract class LocationState extends Equatable {
  const LocationState();
}

class LocationInitial extends LocationState {
  @override
  List<Object> get props => [];
}

class LocationLoadingState extends LocationState {
  const LocationLoadingState();
  @override
  List<Object?> get props => [];
}

class LocationDeterminedState extends LocationState {
  const LocationDeterminedState(this.location);
  final LocationModel location;
  @override
  List<Object?> get props => [location];
}
