import '../domain/weather_repository.dart';
import '../domain/weather_forecast.dart';
import 'weather_api_service.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherApiService apiService;
  WeatherRepositoryImpl(this.apiService);

  @override
  Future<List<WeatherForecast>> get3DayForecast(String city) async {
    final apiResult = await apiService.fetch3DayForecast(city);
    return apiResult
        .map((e) => WeatherForecast(
              date: e.date,
              avgTempC: e.avgTempC,
              conditionText: e.conditionText,
              conditionIcon: e.conditionIcon,
              windKph: e.windKph,
              humidity: e.humidity,
              dailyChanceOfRain: e.dailyChanceOfRain,
            ))
        .toList();
  }
} 