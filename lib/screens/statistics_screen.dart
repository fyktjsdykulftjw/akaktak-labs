import 'package:flutter/material.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📊 Статистика настроения'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'График за неделю:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 20),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'График будет здесь',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            const Text(
              'Последние заметки:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: const [
                  _NoteItem(day: 'Пн', text: 'Отличный день!', mood: '😄'),
                  _NoteItem(day: 'Вт', text: 'Устал на работе', mood: '😐'),
                  _NoteItem(day: 'Ср', text: 'Встреча с друзьями', mood: '😄'),
                  _NoteItem(day: 'Чт', text: 'Дождливый день', mood: '😢'),
                  _NoteItem(day: 'Пт', text: 'Закончил проект', mood: '🙂'),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Вернуться на главную'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoteItem extends StatelessWidget {
  final String day;
  final String text;
  final String mood;
  
  const _NoteItem({
    required this.day,
    required this.text,
    required this.mood,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.deepPurple[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                day,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text),
                const SizedBox(height: 4),
                Text(mood, style: const TextStyle(fontSize: 20)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
