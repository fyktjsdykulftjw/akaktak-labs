import '../../models/quote.dart';
import '../services/api_service.dart';
import '../services/database_service.dart';

class QuoteRepository {
  final ApiService _apiService;
  final DatabaseService _databaseService;
  Quote? _cachedQuote;

  QuoteRepository({
    required ApiService apiService,
    required DatabaseService databaseService,
  })  : _apiService = apiService,
        _databaseService = databaseService;

  Future<Quote> getDailyQuote() async {
    try {
      final quote = await _apiService.getRandomQuote();
      _cachedQuote = quote;
      return quote;
    } catch (e) {
      return Quote(
        text: 'Сегодняшний день — это подарок жизни.',
        author: 'Неизвестный автор',
      );
    }
  }

  Future<Map<String, dynamic>?> getWeatherForCity(String city) async {
    try {
      return await _apiService.getWeather(city);
    } catch (e) {
      return null;
    }
  }
}
