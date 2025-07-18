import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import '../domain/weather_forecast.dart';
import '../domain/get_weather_forecast.dart';
import '../data/weather_api_service.dart';
import '../data/weather_repository_impl.dart';

class HomeState {
  final bool isLoading;
  final String? error;
  final String? userName;
  final List<WeatherForecast>? forecast;

  HomeState({
    this.isLoading = false,
    this.error,
    this.userName,
    this.forecast,
  });

  HomeState copyWith({
    bool? isLoading,
    String? error,
    String? userName,
    List<WeatherForecast>? forecast,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      userName: userName ?? this.userName,
      forecast: forecast ?? this.forecast,
    );
  }
}

class HomeNotifier extends StateNotifier<HomeState> {
  final GetWeatherForecast getWeatherForecast;
  HomeNotifier(this.getWeatherForecast) : super(HomeState()) {
    fetchUserName();
    fetchWeatherForCurrentLocation();
  }

  Future<void> fetchUserName() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        final name = doc.data()?['fullName'] as String?;
        state = state.copyWith(userName: name, isLoading: false);
      } else {
        state = state.copyWith(error: 'User not found', isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(error: 'Failed to load user name', isLoading: false);
    }
  }

  Future<void> fetchWeatherForCurrentLocation() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        state = state.copyWith(error: 'Location services are disabled.', isLoading: false);
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          state = state.copyWith(error: 'Location permissions are denied', isLoading: false);
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        state = state.copyWith(error: 'Location permissions are permanently denied', isLoading: false);
        return;
      }
      final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      final query = '${position.latitude},${position.longitude}';
      final forecast = await getWeatherForecast(query);
      state = state.copyWith(forecast: forecast, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: 'Failed to load weather for your location', isLoading: false);
    }
  }
}

final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  final apiService = WeatherApiService();
  final repo = WeatherRepositoryImpl(apiService);
  final usecase = GetWeatherForecast(repo);
  return HomeNotifier(usecase);
}); 