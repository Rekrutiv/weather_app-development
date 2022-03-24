part of 'location_bloc.dart';

abstract class LocationEvent extends Equatable {
  const LocationEvent();
}

class DetermineLocationEvent extends LocationEvent {
  const DetermineLocationEvent();
  @override
  List<Object?> get props => [];
}
