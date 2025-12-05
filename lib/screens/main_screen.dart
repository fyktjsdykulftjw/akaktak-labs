import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  final Function(int, String) onSaveMood;
  final String currentQuote;
  final VoidCallback onNewQuote;

  const MainScreen({
    super.key,
    required this.onSaveMood,
    required this.currentQuote,
    required this.onNewQuote,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int? _selectedMood;
  final TextEditingController _noteController = TextEditingController();
  final List<Map<String, dynamic>> _moods = [
    {'level': 1, 'emoji': '😢', 'label': 'Грустно'},
    {'level': 2, 'emoji': '😕', 'label': 'Так себе'},
    {'level': 3, 'emoji': '😐', 'label': 'Нормально'},
    {'level': 4, 'emoji': '🙂', 'label': 'Хорошо'},
    {'level': 5, 'emoji': '😄', 'label': 'Отлично'},
  ];

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _saveMood() {
    if (_selectedMood == null) {
      _showSnackBar('Пожалуйста, выберите настроение');
      return;
    }

    widget.onSaveMood(_selectedMood!, _noteController.text);

    // Сбросить форму
    setState(() {
      _selectedMood = null;
    });
    _noteController.clear();
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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
              _buildQuoteSection(),
            ],
          ),
        ),
      ),
    );
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    final months = [
      'января', 'февраля', 'марта', 'апреля', 'мая', 'июня',
      'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'
    ];
    return '${now.day} ${months[now.month - 1]}';
  }

  Widget _buildMoodSelector() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _moods.map((mood) {
            final isSelected = _selectedMood == mood['level'];
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedMood = mood['level'] as int;
                });
              },
              child: Column(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.deepPurple[100] : Colors.white,
                      borderRadius: BorderRadius.circular(35),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                      border: isSelected
                          ? Border.all(color: Colors.deepPurple, width: 3)
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        mood['emoji'] as String,
                        style: const TextStyle(fontSize: 32),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    mood['label'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? Colors.deepPurple : Colors.grey[700],
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        if (_selectedMood != null)
          Text(
            'Выбрано: ${_moods.firstWhere((m) => m['level'] == _selectedMood)['label']}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
      ],
    );
  }

  Widget _buildNoteInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Добавьте заметку (необязательно)',
          style: TextStyle(
            color: Colors.black54,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: TextField(
            controller: _noteController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Почему вы так себя чувствуете?',
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _saveMood,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: const Text(
          'СОХРАНИТЬ НАСТРОЕНИЕ',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildQuoteSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.deepPurple[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.deepPurple.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.format_quote, color: Colors.deepPurple, size: 20),
              SizedBox(width: 8),
              Text(
                'Цитата дня',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            widget.currentQuote,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '— Неизвестный автор',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: widget.onNewQuote,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.deepPurple,
                side: const BorderSide(color: Colors.deepPurple),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Загрузить новую цитату'),
            ),
          ),
        ],
      ),
    );
  }
}