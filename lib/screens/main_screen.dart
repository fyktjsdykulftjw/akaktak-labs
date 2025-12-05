import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Трекер настроения'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            const Text(
              'Как вы себя чувствуете сегодня?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                _MoodButton(emoji: '😢', label: 'Грустно'),
                _MoodButton(emoji: '😐', label: 'Нормально'),
                _MoodButton(emoji: '😄', label: 'Отлично'),
              ],
            ),
            
            const SizedBox(height: 40),
            const TextField(
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Заметка (необязательно)',
                border: OutlineInputBorder(),
                hintText: 'Почему вы так себя чувствуете?',
              ),
            ),
            
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.deepPurple,
                ),
                child: const Text(
                  'СОХРАНИТЬ НАСТРОЕНИЕ',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            
            const SizedBox(height: 50),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.deepPurple[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                children: [
                  Text(
                    '💬 Цитата дня',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Сегодняшний день — это подарок жизни.',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            OutlinedButton(
              onPressed: null,
              child: const Text('📊 Посмотреть статистику'),
            ),
          ],
        ),
      ),
    );
  }
}

class _MoodButton extends StatelessWidget {
  final String emoji;
  final String label;
  
  const _MoodButton({
    required this.emoji,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(35),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 10,
              ),
            ],
          ),
          child: Center(
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 32),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }
}
