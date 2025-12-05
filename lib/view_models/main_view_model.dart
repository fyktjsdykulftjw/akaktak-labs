import 'package:flutter/material.dart';
import '../models/mood_entry.dart';
import '../models/quote.dart';
import '../data/repositories/mood_repository.dart';
import '../data/repositories/quote_repository.dart';

class MainViewModel with ChangeNotifier {
  final MoodRepository _moodRepository;
  final QuoteRepository _quoteRepository;
  
  List<MoodEntry> _moodEntries = [];
  Quote? _currentQuote;
  bool _isLoading = false;
  String? _city;
  Map<String, dynamic>? _weatherData;

  MainViewModel({
    required MoodRepository moodRepository,
    required QuoteRepository quoteRepository,
  })  : _moodRepository = moodRepository,
        _quoteRepository = quoteRepository;

  List<MoodEntry> get moodEntries => _moodEntries;
  Quote? get currentQuote => _currentQuote;
  bool get isLoading => _isLoading;
  String? get city => _city;
  Map<String, dynamic>? get weatherData => _weatherData;

  Future<void> initialize() async {
    await loadInitialData();
  }

  Future<void> loadInitialData() async {
    _isLoading = true;
    notifyListeners();

    await Future.wait([
      _loadMoodEntries(),
      _loadQuote(),
      _loadCity(),
    ]);

    if (_city != null && _city!.isNotEmpty) {
      await _loadWeather(_city!);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadMoodEntries() async {
    _moodEntries = await _moodRepository.getAllMoodEntries();
  }

  Future<void> _loadQuote() async {
    _currentQuote = await _quoteRepository.getDailyQuote();
  }

  Future<void> _loadCity() async {
    _city = await _moodRepository.getCity();
  }

  Future<void> _loadWeather(String city) async {
    _weatherData = await _quoteRepository.getWeatherForCity(city);
  }

  Future<void> addMoodEntry(int moodLevel, String? note) async {
    final entry = MoodEntry(
      date: DateTime.now(),
      moodLevel: moodLevel,
      note: note,
    );
    
    await _moodRepository.addMoodEntry(entry);
    _moodEntries.insert(0, entry);
    notifyListeners();
  }

  Future<void> updateQuote() async {
    _isLoading = true;
    notifyListeners();
    
    _currentQuote = await _quoteRepository.getDailyQuote();
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateCity(String newCity) async {
    if (newCity.trim().isEmpty) return;
    
    await _moodRepository.saveCity(newCity);
    _city = newCity;
    await _loadWeather(newCity);
    notifyListeners();
  }

  String? get weatherDescription {
    if (_weatherData == null) return null;
    final weather = _weatherData!['weather'] as List;
    if (weather.isNotEmpty) {
      return weather[0]['description'] as String;
    }
    return null;
  }

  double? get temperature {
    if (_weatherData == null) return null;
    final main = _weatherData!['main'] as Map<String, dynamic>;
    return main['temp'] as double?;
  }
}
