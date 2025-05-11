import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';
import '../models/forecast_model.dart';

class WeatherService {
  static const String _baseUrl = 'http://api.weatherapi.com/v1';
  static const String _apiKey = '85c6e28f3d3f42758c4185525250405';

  Future<WeatherModel> getCurrentWeather(String city) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/current.json?key=$_apiKey&q=$city&aqi=no'),
    );

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<List<ForecastModel>> getForecast(String city) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/forecast.json?key=$_apiKey&q=$city&days=7&aqi=no'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> forecastDays = data['forecast']['forecastday'];
      return forecastDays
          .map((day) => ForecastModel.fromJson(day))
          .toList();
    } else {
      throw Exception('Failed to load forecast data');
    }
  }

  Future<List<String>> searchCity(String query) async {
    if (query.isEmpty) return [];

    final response = await http.get(
      Uri.parse('$_baseUrl/search.json?key=$_apiKey&q=$query'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data as List)
          .map((city) => '${city['name']}, ${city['country']}')
          .toList();
    } else {
      throw Exception('Failed to search cities');
    }
  }
} 