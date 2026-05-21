import '../entities/post_entity.dart';
import '../repositories/home_repository.dart';

/// Use case: ambil random dog images dari repository.
class GetDogImagesUseCase {
  final HomeRepository _repository;

  const GetDogImagesUseCase(this._repository);

  Future<List<DogImageEntity>> call() async {
    return _repository.getRandomDogImages();
  }
}
