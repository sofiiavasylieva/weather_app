import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/weather_service.dart';

class CitySearchScreen extends StatefulWidget {
  final Function(String) onCitySelected;

  const CitySearchScreen({Key? key, required this.onCitySelected}) : super(key: key);

  @override
  State<CitySearchScreen> createState() => _CitySearchScreenState();
}

class _CitySearchScreenState extends State<CitySearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final WeatherService _weatherService = WeatherService();
  List<String> _searchResults = [];
  List<String> _savedCities = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCities();
  }

  Future<void> _loadSavedCities() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedCities = prefs.getStringList('saved_cities') ?? [];
    });
  }

  Future<void> _saveCity(String city) async {
    if (!_savedCities.contains(city)) {
      final prefs = await SharedPreferences.getInstance();
      _savedCities.add(city);
      await prefs.setStringList('saved_cities', _savedCities);
      setState(() {});
    }
  }

  Future<void> _removeCity(String city) async {
    final prefs = await SharedPreferences.getInstance();
    _savedCities.remove(city);
    await prefs.setStringList('saved_cities', _savedCities);
    setState(() {});
  }

  Future<void> _searchCity(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final results = await _weatherService.searchCity(query);
      if (!mounted) return;
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to search cities')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search city...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onChanged: (value) {
              _searchCity(value);
            },
          ),
          const SizedBox(height: 16),
          if (_isLoading)
            const CircularProgressIndicator()
          else
            Expanded(
              child: ListView(
                children: [
                  if (_searchResults.isNotEmpty) ...[
                    const Text(
                      'Search Results',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ..._searchResults.map((city) => ListTile(
                          title: Text(city),
                          trailing: IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () => _saveCity(city),
                          ),
                          onTap: () {
                            widget.onCitySelected(city);
                          },
                        )),
                    const Divider(),
                  ],
                  const Text(
                    'Saved Cities',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ..._savedCities.map((city) => ListTile(
                        title: Text(city),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _removeCity(city),
                        ),
                        onTap: () {
                          widget.onCitySelected(city);
                        },
                      )),
                ],
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
} 