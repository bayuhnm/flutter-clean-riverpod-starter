import '../entities/post_entity.dart';

/// Abstract contract for the home repository.
/// Domain layer only depends on this abstraction, not on any implementation.
abstract class HomeRepository {
  /// Fetches list of posts from the data source.
  /// Throws [Failure] on error.
  Future<List<PostEntity>> getPosts();
}
