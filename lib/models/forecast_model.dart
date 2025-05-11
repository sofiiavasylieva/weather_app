class ForecastModel {
  final DateTime date;
  final double maxTemp;
  final double minTemp;
  final String condition;
  final String icon;

  ForecastModel({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.condition,
    required this.icon,
  });

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    return ForecastModel(
      date: DateTime.parse(json['date']),
      maxTemp: json['day']['maxtemp_c'].toDouble(),
      minTemp: json['day']['mintemp_c'].toDouble(),
      condition: json['day']['condition']['text'],
      icon: json['day']['condition']['icon'],
    );
  }
} 