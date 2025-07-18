import 'weather_forecast.dart';

abstract class WeatherRepository {
  Future<List<WeatherForecast>> get3DayForecast(String city);
} 