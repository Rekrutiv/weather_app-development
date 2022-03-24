import 'package:equatable/equatable.dart';

class LocationModel extends Equatable {
  const LocationModel({
    required this.latitude,
    required this.longitude,
    this.name,
  });
  final double latitude;
  final double longitude;
  final String? name;

  Map<String, dynamic> get toJson {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'name': name,
    };
  }

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      name: json['name'] as String?,
    );
  }
  LocationModel copyWith({
    double? latitude,
    double? longitude,
    String? name,
  }) {
    return LocationModel(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      name: name ?? this.name,
    );
  }

  @override
  List<Object?> get props => [latitude, longitude, name];
}
