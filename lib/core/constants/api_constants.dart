abstract class ApiConstants {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Endpoints
  static const String posts = '/posts';
}
