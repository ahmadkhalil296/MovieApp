import 'weather_repository.dart';
import 'weather_forecast.dart';

class GetWeatherForecast {
  final WeatherRepository repository;
  GetWeatherForecast(this.repository);

  Future<List<WeatherForecast>> call(String city) {
    return repository.get3DayForecast(city);
  }
} 