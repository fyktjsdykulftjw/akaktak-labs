class MoodEntry {
  int? id;
  final DateTime date;
  final int moodLevel; // 1-5 (😢 to 😄)
  final String? note;

  MoodEntry({
    this.id,
    required this.date,
    required this.moodLevel,
    this.note,
  });

  // Конвертация в Map для SQLite
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'date': date.toIso8601String(),
      'moodLevel': moodLevel,
      'note': note,
    };
  }

  // Создание из Map из SQLite
  factory MoodEntry.fromMap(Map<String, dynamic> map) {
    return MoodEntry(
      id: map['id'] as int?,
      date: DateTime.parse(map['date'] as String),
      moodLevel: map['moodLevel'] as int,
      note: map['note'] as String?,
    );
  }

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
    return '${date.day}.${date.month}.${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  // День недели
  String get dayOfWeek {
    const days = ['Вс', 'Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб'];
    return days[date.weekday % 7];
  }
}