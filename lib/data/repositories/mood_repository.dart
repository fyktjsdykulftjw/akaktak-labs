import '../../models/mood_entry.dart';
import '../services/database_service.dart';

class MoodRepository {
  final DatabaseService _databaseService;

  MoodRepository({required DatabaseService databaseService})
      : _databaseService = databaseService;

  Future<int> addMoodEntry(MoodEntry entry) async {
    return await _databaseService.saveMoodEntry(entry);
  }

  Future<List<MoodEntry>> getAllMoodEntries() async {
    return await _databaseService.getAllMoodEntries();
  }

  Future<void> saveCity(String city) async {
    await _databaseService.saveUserSettings('city', city);
  }

  Future<String?> getCity() async {
    return await _databaseService.getUserSettings('city');
  }
}
