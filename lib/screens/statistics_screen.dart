import 'package:flutter/material.dart';
import '../models/mood_entry.dart';

class StatisticsScreen extends StatelessWidget {
  final List<MoodEntry> moodEntries;
  final VoidCallback onGoBack;

  const StatisticsScreen({
    super.key,
    required this.moodEntries,
    required this.onGoBack,
  });

  @override
  Widget build(BuildContext context) {
    // Группируем записи по дням (последние 7 дней)
    final lastWeekEntries = moodEntries.length > 7
        ? moodEntries.sublist(moodEntries.length - 7)
        : moodEntries;

    // Считаем среднее настроение за неделю
    final averageMood = lastWeekEntries.isEmpty
        ? 0
        : lastWeekEntries.map((e) => e.moodLevel).reduce((a, b) => a + b) / lastWeekEntries.length;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('📊 Статистика настроения'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onGoBack,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Статистика
            _buildStatsCard(averageMood),

            const SizedBox(height: 30),
            const Text(
              'График за неделю:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 20),
            _buildMoodChart(lastWeekEntries),

            const SizedBox(height: 40),
            const Text(
              'История настроений:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 20),
            moodEntries.isEmpty
                ? _buildEmptyState()
                : _buildMoodHistory(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard(double averageMood) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text(
                  moodEntries.length.toString(),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const Text(
                  'Всего записей',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  averageMood.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const Text(
                  'Среднее за неделю',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodChart(List<MoodEntry> entries) {
    if (entries.isEmpty) {
      return Container(
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
        child: const Center(
          child: Text(
            'Нет данных для графика',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return Container(
      height: 200,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(entries.length, (index) {
          final entry = entries[index];
          final heightPercentage = entry.moodLevel / 5.0;
          return _buildChartColumn(
            index + 1,
            heightPercentage,
            entry.emoji,
            entry.formattedDate,
          );
        }),
      ),
    );
  }

  Widget _buildChartColumn(int index, double heightPercentage, String emoji, String date) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 30,
          height: 120 * heightPercentage,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.deepPurple.withOpacity(0.8),
                Colors.deepPurple,
              ],
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'День $index',
          style: const TextStyle(
            fontSize: 10,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(emoji, style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        children: [
          const Icon(
            Icons.insert_chart_outlined,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 20),
          const Text(
            'Пока нет записей о настроении',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Добавьте своё первое настроение на главном экране',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: onGoBack,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
            ),
            child: const Text('Добавить настроение'),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodHistory() {
    // Берем последние 10 записей
    final recentEntries = moodEntries.length > 10
        ? moodEntries.sublist(moodEntries.length - 10).reversed.toList()
        : moodEntries.reversed.toList();

    return Column(
      children: recentEntries.map((entry) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.deepPurple[100],
              child: Text(
                entry.emoji,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            title: Text(entry.moodName),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.formattedDate),
                if (entry.note != null && entry.note!.isNotEmpty)
                  Text(
                    entry.note!,
                    style: const TextStyle(fontStyle: FontStyle.italic),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
          ),
        );
      }).toList(),
    );
  }
}