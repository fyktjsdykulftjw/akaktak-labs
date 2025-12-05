import '../data_sources/remote_data_source.dart';
import '../../models/quote.dart';

class ApiService {
  final RemoteDataSource _remoteDataSource;

  ApiService({required RemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  Future<Quote> getRandomQuote() async {
    return await _remoteDataSource.fetchRandomQuote();
  }

  Future<Map<String, dynamic>?> getWeather(String city) async {
    return await _remoteDataSource.fetchWeather(city);
  }
}
