abstract class ApiConstants {
  static const String baseUrl = 'https://dog.ceo/api';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Endpoints
  // GET /breeds/list/all        → semua breed
  // GET /breed/{breed}/images   → gambar per breed
  // GET /breeds/image/random/12 → random images
  static const String allBreeds = '/breeds/list/all';
  static const String randomImages = '/breeds/image/random/12';
  static String breedImages(String breed) => '/breed/$breed/images';
}
