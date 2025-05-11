import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/forecast_model.dart';

class ForecastScreen extends StatelessWidget {
  final List<ForecastModel> forecast;

  const ForecastScreen({Key? key, required this.forecast}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: _getBackgroundColors(forecast[0].condition),
        ),
      ),
      child: Column(
        children: [
          Card(
            color: Colors.white.withValues(alpha: 51),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: 220,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: true,
                      horizontalInterval: 5,
                      verticalInterval: 1,
                      getDrawingHorizontalLine: (value) {
                        return const FlLine(
                          color: Colors.black12,
                          strokeWidth: 1,
                        );
                      },
                      getDrawingVerticalLine: (value) {
                        return const FlLine(
                          color: Colors.black12,
                          strokeWidth: 1,
                        );
                      },
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            if (value.toInt() >= 0 && value.toInt() < forecast.length) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  '${forecast[value.toInt()].date.day}/${forecast[value.toInt()].date.month}',
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 12,
                                  ),
                                ),
                              );
                            }
                            return const Text('');
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 5,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              '${value.toInt()}°',
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 12,
                              ),
                            );
                          },
                          reservedSize: 42,
                        ),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: Colors.black12),
                    ),
                    minX: 0,
                    maxX: forecast.length - 1.0,
                    minY: forecast.map((e) => e.minTemp).reduce((a, b) => a < b ? a : b) - 5,
                    maxY: forecast.map((e) => e.maxTemp).reduce((a, b) => a > b ? a : b) + 5,
                    lineBarsData: [
                      LineChartBarData(
                        spots: forecast.asMap().entries.map((entry) {
                          return FlSpot(
                            entry.key.toDouble(),
                            entry.value.maxTemp,
                          );
                        }).toList(),
                        isCurved: true,
                        color: Colors.deepOrange,
                        barWidth: 4,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 6,
                              color: Colors.deepOrange,
                              strokeWidth: 2,
                              strokeColor: Colors.black26,
                            );
                          },
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [
                              Colors.deepOrange.withValues(alpha: 77), // 0.3 * 255
                              Colors.deepOrange.withValues(alpha: 13), // 0.05 * 255
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: forecast.length,
              itemBuilder: (context, index) {
                final day = forecast[index];
                return Card(
                  color: Colors.white.withValues(alpha: 51),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListTile(
                    leading: Image.network(
                      'https:${day.icon}',
                      width: 50,
                      height: 50,
                    ),
                    title: Text(
                      '${day.date.day}/${day.date.month}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      day.condition,
                      style: const TextStyle(color: Colors.black54),
                    ),
                    trailing: Text(
                      '${day.maxTemp.toStringAsFixed(1)}° / ${day.minTemp.toStringAsFixed(1)}°',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                );
              },
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
      return [
        const Color(0xFF1A237E), // Deep Blue
        const Color(0xFF0D47A1), // Blue
        const Color(0xFF01579B), // Light Blue
      ];
    } else if (condition.toLowerCase().contains('sunny') ||
        condition.toLowerCase().contains('clear')) {
      return [
        const Color(0xFFFFD700), // Gold
        const Color(0xFFFFA000), // Amber
        const Color(0xFFFF6F00), // Deep Orange
      ];
    } else if (condition.toLowerCase().contains('cloud')) {
      return [
        const Color(0xFF78909C), // Blue Grey
        const Color(0xFF607D8B), // Blue Grey
        const Color(0xFF455A64), // Blue Grey
      ];
    } else {
      return [
        const Color(0xFF2196F3), // Blue
        const Color(0xFF1976D2), // Blue
        const Color(0xFF0D47A1), // Blue
      ];
    }
  }
} 