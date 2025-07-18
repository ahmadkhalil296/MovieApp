class WeatherForecast {
  final String date;
  final double avgTempC;
  final String conditionText;
  final String conditionIcon;
  final double windKph;
  final int humidity;
  final int dailyChanceOfRain;

  WeatherForecast({
    required this.date,
    required this.avgTempC,
    required this.conditionText,
    required this.conditionIcon,
    required this.windKph,
    required this.humidity,
    required this.dailyChanceOfRain,
  });
} 