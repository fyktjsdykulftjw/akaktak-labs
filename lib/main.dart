// Файл создан для LR6. Для работы требуется Flutter SDK.
// Архитектура реализована по рекомендациям Flutter:
// - Разделение на UI (view, viewModel) и Data (repository, service)
// - Локальное хранение через SQLite (заглушки)
// - Работа с HTTP API (заглушки)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

// Data Sources
import 'data/data_sources/local_data_source.dart';
import 'data/data_sources/remote_data_source.dart';

// Services
import 'data/services/database_service.dart';
import 'data/services/api_service.dart';

// Repositories
import 'data/repositories/mood_repository.dart';
import 'data/repositories/quote_repository.dart';

// View Models
import 'view_models/main_view_model.dart';
import 'view_models/statistics_view_model.dart';

// Screens
import 'screens/main_screen.dart';
import 'screens/statistics_screen.dart';

void main() {
  // Заглушка для LR6 - в реальном приложении здесь будет runApp()
  print('Mood Tracker App (LR6)');
  print('Архитектура реализована по Clean Architecture');
  print('Для запуска требуется Flutter SDK');
}

// Оригинальный код оставлен для демонстрации архитектуры
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<LocalDataSource>(
          create: (_) => LocalDataSource(),
        ),
        Provider<RemoteDataSource>(
          create: (_) => RemoteDataSource(client: http.Client()),
        ),
        Provider<DatabaseService>(
          create: (context) => DatabaseService(
            localDataSource: context.read<LocalDataSource>(),
          ),
        ),
        Provider<ApiService>(
          create: (context) => ApiService(
            remoteDataSource: context.read<RemoteDataSource>(),
          ),
        ),
        Provider<MoodRepository>(
          create: (context) => MoodRepository(
            databaseService: context.read<DatabaseService>(),
          ),
        ),
        Provider<QuoteRepository>(
          create: (context) => QuoteRepository(
            apiService: context.read<ApiService>(),
            databaseService: context.read<DatabaseService>(),
          ),
        ),
        ChangeNotifierProvider<MainViewModel>(
          create: (context) => MainViewModel(
            moodRepository: context.read<MoodRepository>(),
            quoteRepository: context.read<QuoteRepository>(),
          )..initialize(),
        ),
        ChangeNotifierProvider<StatisticsViewModel>(
          create: (context) => StatisticsViewModel(
            moodRepository: context.read<MoodRepository>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Mood Tracker',
        home: const HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const MainScreen(),
    const StatisticsScreen(),
  ];

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
        items: const [
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
        onTap: _onItemTapped,
      ),
    );
  }
}
