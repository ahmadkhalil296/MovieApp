import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'home_provider.dart';
import 'dart:math' as math;

class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeProvider);
    final size = MediaQuery.of(context).size;

    // Debug print for forecast dates and device time
    if (state.forecast != null && state.forecast!.isNotEmpty) {
      for (final day in state.forecast!) {
        print('Forecast date from API: ${day.date}');
        final dateObj = DateTime.tryParse(day.date);
        print('Parsed as DateTime: $dateObj, Device local: ${DateTime.now()}');
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFF010C2A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Greeting and user name
                Text(
                  'Hello',
                  style: TextStyle(
                    color: Color(0xFF1560EF),
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                if (state.isLoading)
                  Row(
                    children: [
                      SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Loading...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  )
                else
                  Text(
                    state.userName ?? 'User',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                SizedBox(height: 24),
                // 3-day forecast selector
                if (state.forecast != null && state.forecast!.isNotEmpty)
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(state.forecast!.length, (i) {
                        final day = state.forecast![i];
                        final dateObj = DateTime.tryParse(day.date);
                        final weekday = dateObj != null ? _weekdayFromDate(dateObj) : '';
                        final dayNum = dateObj != null ? dateObj.day.toString() : '';
                        return _dateItem(
                          weekday,
                          dayNum,
                          isSelected: i == 0,
                        );
                      }),
                    ),
                  )
                else
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _dateItem('Mon', '22'),
                        _dateItem('Tue', '23'),
                        _dateItem('Wed', '24', isSelected: true),
                      ],
                    ),
                  ),
                SizedBox(height: 32),
                // Main weather info
                if (state.forecast != null && state.forecast!.isNotEmpty)
                  Center(
                    child: Column(
                      children: [
                        Image.network(
                          'https:${state.forecast![0].conditionIcon}',
                          width: 64,
                          height: 64,
                        ),
                        SizedBox(height: 8),
                        Text(
                          '${state.forecast![0].avgTempC.toStringAsFixed(1)}°C',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          state.forecast![0].conditionText,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Center(
                    child: Column(
                      children: [
                        Icon(Icons.wb_sunny, color: Colors.yellow[700], size: 64),
                        SizedBox(height: 8),
                        Text(
                          '28°C',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Sunny',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                SizedBox(height: 32),
                // Animated weather details
                if (state.forecast != null && state.forecast!.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AnimatedCircleIndicator(
                        label: 'Wind',
                        value: state.forecast![0].windKph,
                        maxValue: 100,
                        unit: 'km/h',
                        color: Colors.blueAccent,
                      ),
                      AnimatedCircleIndicator(
                        label: 'Humidity',
                        value: state.forecast![0].humidity.toDouble(),
                        maxValue: 100,
                        unit: '%',
                        color: Colors.greenAccent,
                      ),
                      AnimatedCircleIndicator(
                        label: 'Rain',
                        value: state.forecast![0].dailyChanceOfRain.toDouble(),
                        maxValue: 100,
                        unit: '%',
                        color: Colors.cyanAccent,
                      ),
                    ],
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _weatherDetail('Wind', '12 km/h'),
                      _weatherDetail('Humidity', '60%'),
                      _weatherDetail('Rain', '0%'),
                    ],
                  ),
                SizedBox(height: 32),
                // Weather trend chart placeholder
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Center(
                    child: Text(
                      'Weather Trend Chart',
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),
                ),
                SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _BottomNavBar(),
    );
  }

  // Helper: Get weekday string from DateTime
  String _weekdayFromDate(DateTime dt) {
    switch (dt.weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }

  Widget _dateItem(String day, String date, {bool isSelected = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: isSelected
          ? BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            )
          : null,
      child: Column(
        children: [
          Text(
            day,
            style: TextStyle(
              color: isSelected ? Color(0xFF1560EF) : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 4),
          Text(
            date,
            style: TextStyle(
              color: isSelected ? Color(0xFF1560EF) : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _weatherDetail(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

// AnimatedCircleIndicator widget
class AnimatedCircleIndicator extends StatelessWidget {
  final String label;
  final double value;
  final double maxValue;
  final String unit;
  final Color color;

  const AnimatedCircleIndicator({
    super.key,
    required this.label,
    required this.value,
    required this.maxValue,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: value / maxValue),
      duration: Duration(seconds: 1),
      builder: (context, percent, child) {
        return Column(
          children: [
            SizedBox(
              width: 64,
              height: 64,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: percent,
                    strokeWidth: 6,
                    backgroundColor: Colors.white12,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                  Center(
                    child: Text(
                      value.toStringAsFixed(0),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 4),
            Text(
              unit,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
            SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(Icons.star, 'Fav'),
          _navItem(Icons.person, 'Profile'),
          _navItem(Icons.home, 'Home', isActive: true),
          _navItem(Icons.check, 'Check'),
          _navItem(Icons.star, 'Fav'),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, {bool isActive = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isActive ? Colors.white : Colors.white54,
          size: 28,
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.white54,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
} 