import 'package:flutter/material.dart';
import 'screens/current_weather_screen.dart';
import 'screens/forecast_screen.dart';
import 'screens/city_search_screen.dart';
import 'services/weather_service.dart';
import 'models/weather_model.dart';
import 'models/forecast_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.white.withValues(alpha: 204), // 0.8 * 255
          indicatorColor: Colors.blue.withValues(alpha: 51), // 0.2 * 255
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ),
      ),
      home: const WeatherHomePage(),
    );
  }
}

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({Key? key}) : super(key: key);

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  final WeatherService _weatherService = WeatherService();
  WeatherModel? _currentWeather;
  List<ForecastModel>? _forecast;
  String _selectedCity = 'London';
  bool _isLoading = false;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadWeatherData();
  }

  Future<void> _loadWeatherData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final weather = await _weatherService.getCurrentWeather(_selectedCity);
      final forecast = await _weatherService.getForecast(_selectedCity);
      setState(() {
        _currentWeather = weather;
        _forecast = forecast;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load weather data')),
        );
      }
    }
  }

  void _onCitySelected(String city) {
    setState(() {
      _selectedCity = city;
    });
    _loadWeatherData();
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_currentWeather == null || _forecast == null) {
      return const Center(child: Text('No weather data available'));
    }

    switch (_selectedIndex) {
      case 0:
        return CurrentWeatherScreen(weather: _currentWeather!);
      case 1:
        return ForecastScreen(forecast: _forecast!);
      case 2:
        return CitySearchScreen(onCitySelected: _onCitySelected);
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedCity),
      ),
      body: SafeArea(
        child: _buildBody(),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.wb_sunny),
            label: 'Current',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today),
            label: 'Forecast',
          ),
          NavigationDestination(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
        ],
      ),
    );
  }
}
