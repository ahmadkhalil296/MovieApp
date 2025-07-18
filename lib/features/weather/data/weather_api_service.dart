import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherForecastDay {
  final String date;
  final double avgTempC;
  final String conditionText;
  final String conditionIcon;
  final double windKph;
  final int humidity;
  final int dailyChanceOfRain;

  WeatherForecastDay({
    required this.date,
    required this.avgTempC,
    required this.conditionText,
    required this.conditionIcon,
    required this.windKph,
    required this.humidity,
    required this.dailyChanceOfRain,
  });

  factory WeatherForecastDay.fromJson(Map<String, dynamic> json) {
    return WeatherForecastDay(
      date: json['date'],
      avgTempC: (json['day']['avgtemp_c'] as num).toDouble(),
      conditionText: json['day']['condition']['text'],
      conditionIcon: json['day']['condition']['icon'],
      windKph: (json['day']['maxwind_kph'] as num).toDouble(),
      humidity: (json['day']['avghumidity'] as num).toInt(),
      dailyChanceOfRain: int.tryParse(json['day']['daily_chance_of_rain'].toString()) ?? 0,
    );
  }
}

class WeatherApiService {
  static const String _apiKey = 'e46f99426371469f858174359251807';
  static const String _baseUrl = 'https://api.weatherapi.com/v1/forecast.json';

  Future<List<WeatherForecastDay>> fetch3DayForecast(String city) async {
    final url = Uri.parse('$_baseUrl?key=$_apiKey&q=$city&days=3&aqi=no&alerts=no');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List days = data['forecast']['forecastday'];
      return days.map((e) => WeatherForecastDay.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load weather data');
    }
  }
} 