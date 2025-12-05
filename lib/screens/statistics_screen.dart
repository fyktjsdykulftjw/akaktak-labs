import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/statistics_view_model.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StatisticsViewModel>().loadStatistics();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<StatisticsViewModel>();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('📊 Статистика настроения'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: () async {
          await viewModel.loadStatistics();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Общая статистика
              _buildStatsCards(viewModel),

              const SizedBox(height: 30),
              const Text(
                'График за неделю:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),
              _buildWeeklyChart(viewModel),

              const SizedBox(height: 40),
              const Text(
                'Распределение настроений:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),
              _buildMoodDistribution(viewModel),

              const SizedBox(height: 40),
              const Text(
                'Последние записи:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),
              viewModel.monthlyEntries.isEmpty
                  ? _buildEmptyState()
                  : _buildRecentEntries(viewModel),

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

  Widget _buildStatsCards(StatisticsViewModel viewModel) {
    final weeklyAvg = viewModel.getAverageMood(viewModel.weeklyEntries);
    final totalEntries = viewModel.getTotalEntriesCount();
    final mostCommon = viewModel.getMostCommonMood(viewModel.monthlyEntries);

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Среднее за неделю',
            weeklyAvg.toStringAsFixed(1),
            Icons.trending_up,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Всего записей',
            totalEntries.toString(),
            Icons.list,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Чаще всего',
            mostCommon.split(' ')[0], // только эмодзи
            Icons.star,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: Colors.deepPurple, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyChart(StatisticsViewModel viewModel) {
    final chartData = viewModel.getChartData();

    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
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
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: chartData.map((data) {
                final height = (data['average'] as double) * 20;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 25,
                      height: height.clamp(0, 150),
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
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      data['day'] as String,
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      (data['average'] as double).toStringAsFixed(1),
                      style: const TextStyle(fontSize: 10),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Среднее настроение по дням недели',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodDistribution(StatisticsViewModel viewModel) {
    final distribution = viewModel.getMoodDistribution(viewModel.monthlyEntries);
    final total = distribution.values.reduce((a, b) => a + b);

    if (total == 0) {
      return const Center(
        child: Text('Нет данных для отображения'),
      );
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            for (final entry in distribution.entries)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Text(
                      _getMoodEmoji(entry.key),
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_getMoodLabel(entry.key)),
                          const SizedBox(height: 4),
                          LinearProgressIndicator(
                            value: total > 0 ? entry.value / total : 0,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _getMoodColor(entry.key),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${entry.value} (${total > 0 ? ((entry.value / total) * 100).toStringAsFixed(0) : 0}%)',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _getMoodEmoji(int level) {
    switch (level) {
      case 1: return '😢';
      case 2: return '😕';
      case 3: return '😐';
      case 4: return '🙂';
      case 5: return '😄';
      default: return '😐';
    }
  }

  String _getMoodLabel(int level) {
    switch (level) {
      case 1: return 'Грустно';
      case 2: return 'Так себе';
      case 3: return 'Нормально';
      case 4: return 'Хорошо';
      case 5: return 'Отлично';
      default: return 'Неизвестно';
    }
  }

  Color _getMoodColor(int level) {
    switch (level) {
      case 1: return Colors.blue;
      case 2: return Colors.green;
      case 3: return Colors.orange;
      case 4: return Colors.yellow[700]!;
      case 5: return Colors.pink;
      default: return Colors.grey;
    }
  }

  Widget _buildRecentEntries(StatisticsViewModel viewModel) {
    final recentEntries = viewModel.monthlyEntries.take(10).toList();

    return Column(
      children: recentEntries.map((entry) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _getMoodColor(entry.moodLevel).withOpacity(0.2),
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
          ),
        );
      }).toList(),
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
        ],
      ),
    );
  }
}