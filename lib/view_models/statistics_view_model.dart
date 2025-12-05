import 'package:flutter/material.dart';
import '../models/mood_entry.dart';
import '../data/repositories/mood_repository.dart';

class StatisticsViewModel with ChangeNotifier {
  final MoodRepository _moodRepository;
  
  List<MoodEntry> _moodEntries = [];
  bool _isLoading = false;

  StatisticsViewModel({required MoodRepository moodRepository})
      : _moodRepository = moodRepository;

  List<MoodEntry> get moodEntries => _moodEntries;
  bool get isLoading => _isLoading;

  Future<void> loadStatistics() async {
    _isLoading = true;
    notifyListeners();

    _moodEntries = await _moodRepository.getAllMoodEntries();

    _isLoading = false;
    notifyListeners();
  }

  double getAverageMood() {
    if (_moodEntries.isEmpty) return 0;
    final sum = _moodEntries.map((e) => e.moodLevel).reduce((a, b) => a + b);
    return sum / _moodEntries.length;
  }

  int getTotalEntriesCount() {
    return _moodEntries.length;
  }

  String getMostCommonMood() {
    if (_moodEntries.isEmpty) return 'Нет данных';
    
    final distribution = <int, int>{};
    for (var i = 1; i <= 5; i++) {
      distribution[i] = 0;
    }
    
    for (final entry in _moodEntries) {
      distribution[entry.moodLevel] = distribution[entry.moodLevel]! + 1;
    }
    
    final maxEntry = distribution.entries.reduce(
      (a, b) => a.value > b.value ? a : b,
    );
    
    switch (maxEntry.key) {
      case 1: return '😢';
      case 2: return '😕';
      case 3: return '😐';
      case 4: return '🙂';
      case 5: return '😄';
      default: return '😐';
    }
  }
}
