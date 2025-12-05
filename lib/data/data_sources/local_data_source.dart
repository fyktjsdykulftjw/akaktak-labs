import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../models/mood_entry.dart';

class LocalDataSource {
  static final LocalDataSource _instance = LocalDataSource._internal();
  factory LocalDataSource() => _instance;
  LocalDataSource._internal();

  static Database? _database;

  Future<Database> get database async {
    // Заглушка для LR6 - в реальном приложении здесь будет инициализация БД
    throw UnimplementedError('LocalDataSource.database not implemented for LR6');
  }

  Future<int> insertMoodEntry(MoodEntry entry) async {
    // Заглушка для LR6
    print('Inserting mood entry: ${entry.toMap()}');
    return 1;
  }

  Future<List<MoodEntry>> getAllMoodEntries() async {
    // Заглушка для LR6 - возвращаем тестовые данные
    return [
      MoodEntry(
        date: DateTime.now().subtract(const Duration(days: 1)),
        moodLevel: 4,
        note: 'Хороший день',
      ),
      MoodEntry(
        date: DateTime.now().subtract(const Duration(days: 2)),
        moodLevel: 3,
        note: 'Нормальный день',
      ),
    ];
  }

  Future<void> saveSetting(String key, String value) async {
    print('Saving setting: $key = $value');
  }

  Future<String?> getSetting(String key) async {
    // Заглушка для LR6
    return null;
  }
}
