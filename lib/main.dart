import 'package:flutter/material.dart';
import 'screens/main_screen.dart';
import 'screens/statistics_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mood Tracker',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      // Используем StatefulWidget для управления состоянием
      home: const MoodTrackerApp(),
    );
  }
}

class MoodTrackerApp extends StatefulWidget {
  const MoodTrackerApp({super.key});

  @override
  State<MoodTrackerApp> createState() => _MoodTrackerAppState();
}

class _MoodTrackerAppState extends State<MoodTrackerApp> {
  int _selectedIndex = 0;
  final List<MoodEntry> _moodEntries = [];
  String _currentQuote = 'Сегодняшний день — это подарок жизни.';

  // Список экранов
  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    // Инициализируем экраны с передачей данных
    _screens.addAll([
      MainScreen(
        onSaveMood: _addMoodEntry,
        currentQuote: _currentQuote,
        onNewQuote: _updateQuote,
      ),
      StatisticsScreen(
        moodEntries: _moodEntries,
        onGoBack: () {
          setState(() {
            _selectedIndex = 0;
          });
        },
      ),
    ]);
  }

  void _addMoodEntry(int moodLevel, String note) {
    setState(() {
      _moodEntries.add(MoodEntry(
        date: DateTime.now(),
        moodLevel: moodLevel,
        note: note.isNotEmpty ? note : null,
      ));
    });

    // Показать уведомление
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Настроение сохранено!'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {},
        ),
      ),
    );
  }

  void _updateQuote() {
    setState(() {
      _currentQuote = _getRandomQuote();
    });
  }

  String _getRandomQuote() {
    final quotes = [
      'Сегодняшний день — это подарок жизни.',
      'Каждый день — это новая возможность.',
      'Улыбнись, и мир улыбнется тебе в ответ.',
      'Не откладывай на завтра то, что можно сделать сегодня.',
      'Маленькие шаги приводят к большим изменениям.',
    ];
    return quotes[DateTime.now().millisecond % quotes.length];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Статистика',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple,
        onTap: _onItemTapped,
      ),
    );
  }
}