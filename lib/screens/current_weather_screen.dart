import 'package:flutter/material.dart';
import '../models/weather_model.dart';

class CurrentWeatherScreen extends StatelessWidget {
  final WeatherModel weather;

  const CurrentWeatherScreen({Key? key, required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: _getBackgroundColors(weather.condition),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${weather.temperature.toStringAsFixed(1)}°C',
                        style: const TextStyle(
                          fontSize: 44,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        weather.condition,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 51),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Image.network(
                      'https:${weather.icon}',
                      width: 64,
                      height: 64,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Card(
                  color: Colors.white.withValues(alpha: 51),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildWeatherInfo('Feels Like', '${weather.feelsLike.toStringAsFixed(1)}°C'),
                        _buildWeatherInfo('Humidity', '${weather.humidity.toStringAsFixed(0)}%'),
                        _buildWeatherInfo('Wind', '${weather.windSpeed.toStringAsFixed(1)} km/h'),
                        _buildWeatherInfo('Pressure', '${weather.pressure.toStringAsFixed(0)} mb'),
                        _buildWeatherInfo('Visibility', '${weather.visibility.toStringAsFixed(0)} km'),
                        _buildWeatherInfo('Precip.', '${weather.precipitation.toStringAsFixed(1)} mm'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  List<Color> _getBackgroundColors(String condition) {
    if (condition.toLowerCase().contains('rain') ||
        condition.toLowerCase().contains('drizzle') ||
        condition.toLowerCase().contains('shower')) {
      return const [
        Color(0xFF1A237E), // Deep Blue
        Color(0xFF0D47A1), // Blue
        Color(0xFF01579B), // Light Blue
      ];
    } else if (condition.toLowerCase().contains('sunny') ||
        condition.toLowerCase().contains('clear')) {
      return const [
        Color(0xFFFFD700), // Gold
        Color(0xFFFFA000), // Amber
        Color(0xFFFF6F00), // Deep Orange
      ];
    } else if (condition.toLowerCase().contains('cloud')) {
      return const [
        Color(0xFF78909C), // Blue Grey
        Color(0xFF607D8B), // Blue Grey
        Color(0xFF455A64), // Blue Grey
      ];
    } else {
      return const [
        Color(0xFF2196F3), // Blue
        Color(0xFF1976D2), // Blue
        Color(0xFF0D47A1), // Blue
      ];
    }
  }
} 