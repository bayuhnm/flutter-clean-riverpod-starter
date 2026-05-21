import '../entities/post_entity.dart';

abstract class HomeRepository {
  /// Ambil daftar random dog images.
  Future<List<DogImageEntity>> getRandomDogImages();
}
