import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/quote.dart';

class RemoteDataSource {
  final http.Client client;
  
  RemoteDataSource({required this.client});

  Future<Quote> fetchRandomQuote() async {
    try {
      // Заглушка для LR6 - возвращаем тестовую цитату
      // В реальном приложении здесь будет запрос к API
      return Quote(
        text: 'Сегодняшний день — это подарок жизни.',
        author: 'Неизвестный автор',
      );
    } catch (e) {
      return Quote(
        text: 'Ошибка загрузки цитаты. Попробуйте позже.',
        author: 'Система',
      );
    }
  }

  Future<Map<String, dynamic>?> fetchWeather(String city) async {
    // Заглушка для LR6
    print('Fetching weather for city: $city');
    return {
      'weather': [{'description': 'ясно', 'icon': '01d'}],
      'main': {'temp': 20.5},
      'name': city,
    };
  }
}
