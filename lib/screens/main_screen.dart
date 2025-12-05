import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/main_view_model.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int? _selectedMood;
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final List<Map<String, dynamic>> _moods = [
    {'level': 1, 'emoji': '😢', 'label': 'Грустно'},
    {'level': 2, 'emoji': '😕', 'label': 'Так себе'},
    {'level': 3, 'emoji': '😐', 'label': 'Нормально'},
    {'level': 4, 'emoji': '🙂', 'label': 'Хорошо'},
    {'level': 5, 'emoji': '😄', 'label': 'Отлично'},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<MainViewModel>();
      if (viewModel.city != null) {
        _cityController.text = viewModel.city!;
      }
    });
  }

  @override
  void dispose() {
    _noteController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void _saveMood() {
    if (_selectedMood == null) {
      _showSnackBar('Пожалуйста, выберите настроение');
      return;
    }

    final viewModel = context.read<MainViewModel>();
    viewModel.addMoodEntry(_selectedMood!, _noteController.text);

    // Сбросить форму
    setState(() {
      _selectedMood = null;
    });
    _noteController.clear();
  }

  void _updateCity() {
    if (_cityController.text.trim().isNotEmpty) {
      final viewModel = context.read<MainViewModel>();
      viewModel.updateCity(_cityController.text.trim());
      _showSnackBar('Город обновлен');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MainViewModel>();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.calendar_today, size: 20),
            const SizedBox(width: 8),
            Text(
              _getFormattedDate(),
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          if (viewModel.userName != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: Text(
                  'Привет, ${viewModel.userName}!',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
        ],
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Погода
              if (viewModel.weatherData != null)
                _buildWeatherCard(viewModel),

              const SizedBox(height: 20),
              const Text(
                'Как вы себя чувствуете\nсегодня?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 40),
              _buildMoodSelector(),

              const SizedBox(height: 40),
              _buildNoteInput(),

              const SizedBox(height: 30),
              _buildSaveButton(),

              const SizedBox(height: 50),
              _buildQuoteSection(viewModel),

              const SizedBox(height: 30),
              _buildCityInput(viewModel),

              if (viewModel.errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    viewModel.errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherCard(MainViewModel viewModel) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            if (viewModel.weatherIcon != null)
              Image.network(
                viewModel.weatherIcon!,
                width: 50,
                height: 50,
                errorBuilder: (_, __, ___) => const Icon(Icons.cloud, size: 40),
              ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Погода в ${viewModel.city ?? "вашем городе"}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  if (viewModel.weatherDescription != null)
                    Text(viewModel.weatherDescription!),
                  if (viewModel.temperature != null)
                    Text(
                      '${viewModel.temperature!.toStringAsFixed(1)}°C',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCityInput(MainViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.deepPurple[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Настройка города для погоды',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _cityController,
                  decoration: const InputDecoration(
                    hintText: 'Введите название города',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _updateCity,
                child: const Text('Сохранить'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Для получения погоды зарегистрируйтесь на openweathermap.org и добавьте API ключ',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

// Остальные методы (_buildMoodSelector, _buildNoteInput, _buildSaveButton, _buildQuoteSection)
// остаются такими же как в LR5, но используют viewModel
// ...
}