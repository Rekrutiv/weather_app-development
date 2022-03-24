import 'package:hive/hive.dart';
import 'models/db/weather_model_db.dart';

class Boxes {
  static Box<WeatherModelDB> getTransactions() =>
      Hive.box<WeatherModelDB>('transactions');
}