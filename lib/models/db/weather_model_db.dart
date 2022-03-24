import 'package:hive/hive.dart';

part 'weather_model_db.g.dart';

@HiveType(typeId: 0)
class WeatherModelDB extends HiveObject {
  @HiveField(0)
  late String weatherMain;

  @HiveField(1)
  late DateTime? weatherDate;

  @HiveField(2)
  late int celsius;

}