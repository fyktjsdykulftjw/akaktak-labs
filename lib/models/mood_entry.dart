class MoodEntry {
  final DateTime date;
  final int moodLevel; // 1-5 (😢 to 😄)
  final String? note;

  MoodEntry({
    required this.date,
    required this.moodLevel,
    this.note,
  });

  // Геттер для эмодзи настроения
  String get emoji {
    switch (moodLevel) {
      case 1: return '😢';
      case 2: return '😕';
      case 3: return '😐';
      case 4: return '🙂';
      case 5: return '😄';
      default: return '😐';
    }
  }

  // Геттер для названия настроения
  String get moodName {
    switch (moodLevel) {
      case 1: return 'Грустно';
      case 2: return 'Так себе';
      case 3: return 'Нормально';
      case 4: return 'Хорошо';
      case 5: return 'Отлично';
      default: return 'Нормально';
    }
  }

  // Форматированная дата
  String get formattedDate {
    return '${date.day}.${date.month}.${date.year}';
  }
}