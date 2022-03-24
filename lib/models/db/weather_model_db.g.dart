// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_model_db.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WeatherModelDBAdapter extends TypeAdapter<WeatherModelDB> {
  @override
  final int typeId = 0;

  @override
  WeatherModelDB read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WeatherModelDB()
      ..weatherMain = fields[0] as String
      ..weatherDate = fields[1] as DateTime?
      ..celsius = fields[2] as int;
  }

  @override
  void write(BinaryWriter writer, WeatherModelDB obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.weatherMain)
      ..writeByte(1)
      ..write(obj.weatherDate)
      ..writeByte(2)
      ..write(obj.celsius);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeatherModelDBAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
