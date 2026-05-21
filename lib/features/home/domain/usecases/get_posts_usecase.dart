import '../entities/post_entity.dart';
import '../repositories/home_repository.dart';

/// Use case for fetching posts.
/// Single responsibility: orchestrates the call to HomeRepository.
class GetPostsUseCase {
  final HomeRepository _repository;

  const GetPostsUseCase(this._repository);

  /// Executes the use case.
  Future<List<PostEntity>> call() async {
    return _repository.getPosts();
  }
}
