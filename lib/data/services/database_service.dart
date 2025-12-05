import '../data_sources/local_data_source.dart';
import '../../models/mood_entry.dart';

class DatabaseService {
  final LocalDataSource _localDataSource;

  DatabaseService({required LocalDataSource localDataSource})
      : _localDataSource = localDataSource;

  Future<int> saveMoodEntry(MoodEntry entry) async {
    return await _localDataSource.insertMoodEntry(entry);
  }

  Future<List<MoodEntry>> getAllMoodEntries() async {
    return await _localDataSource.getAllMoodEntries();
  }

  Future<void> saveUserSettings(String key, String value) async {
    await _localDataSource.saveSetting(key, value);
  }

  Future<String?> getUserSettings(String key) async {
    return await _localDataSource.getSetting(key);
  }
}
