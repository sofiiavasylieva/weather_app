class WeatherModel {
  final double temperature;
  final double feelsLike;
  final double humidity;
  final double windSpeed;
  final double pressure;
  final double visibility;
  final double precipitation;
  final String condition;
  final String icon;
  final DateTime date;

  WeatherModel({
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    required this.visibility,
    required this.precipitation,
    required this.condition,
    required this.icon,
    required this.date,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      temperature: json['current']['temp_c'].toDouble(),
      feelsLike: json['current']['feelslike_c'].toDouble(),
      humidity: json['current']['humidity'].toDouble(),
      windSpeed: json['current']['wind_kph'].toDouble(),
      pressure: json['current']['pressure_mb'].toDouble(),
      visibility: json['current']['vis_km'].toDouble(),
      precipitation: json['current']['precip_mm'].toDouble(),
      condition: json['current']['condition']['text'],
      icon: json['current']['condition']['icon'],
      date: DateTime.parse(json['current']['last_updated']),
    );
  }
} 