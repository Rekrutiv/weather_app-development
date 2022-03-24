import 'package:geocoding/geocoding.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:weather_app/constants/keys.dart';
import 'package:weather_app/constants/locations.dart';
import 'package:weather_app/models/location/location_model.dart';
import 'package:weather_app/service/location/location_service.dart';

class LocationRepository {
  LocationRepository({
    required LocationService locationService,
  }) {
    _locationService = locationService;
  }

  late final LocationService _locationService;

  Future<LocationModel> determineLocation() async {
    // get user location
    try {
      final geo = await _locationService.determinePosition();
      return LocationModel(
        latitude: geo.latitude,
        longitude: geo.longitude,
      );
    } catch (e) {
      throw Exception('insufficient permissions');
    }
  }

  LocationModel get defaultLocation => kyivLocation;

  Future<LocationModel> getStoredUserLocation(String userId) async {
    try {
      final box = await _getLocationBox();
      final json = box.get(userId);
      final LocationModel location = LocationModel.fromJson(json);
      return location;
    } catch (e) {
      // TODO: implement advanced error handling
      rethrow;
    }
  }

  Future<void> saveUserLocation({
    required String userId,
    required LocationModel location,
  }) async {
    final box = await _getLocationBox();
    await box.put(userId, location.toJson);
  }

  Future<Placemark> determineCityNameAtLocation(
    LocationModel location,
  ) async {
    List<Placemark> placeMarks = await placemarkFromCoordinates(
      location.latitude,
      location.longitude,
    );
    try {
      return placeMarks.first;
    } catch (e) {
      throw Exception('city not found');
    }
  }

  Future<Box> _getLocationBox() async {
    return await Hive.openBox(hiveLocationBoxKey);
  }
}
