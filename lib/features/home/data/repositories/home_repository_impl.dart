import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_datasource.dart';

/// Concrete implementation of [HomeRepository].
/// Bridges data layer (models) with domain layer (entities).
class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDatasource _remoteDatasource;

  const HomeRepositoryImpl(this._remoteDatasource);

  @override
  Future<List<PostEntity>> getPosts() async {
    try {
      final models = await _remoteDatasource.getPosts();
      // Map data models to domain entities
      return models.map((model) => model.toEntity()).toList();
    } on ServerException catch (e) {
      AppLogger.error('ServerException in HomeRepository', error: e);
      throw ServerFailure(message: e.message);
    } on NetworkException catch (e) {
      AppLogger.error('NetworkException in HomeRepository', error: e);
      throw NetworkFailure(message: e.message);
    } catch (e) {
      AppLogger.error('Unknown error in HomeRepository', error: e);
      throw UnknownFailure(message: 'An unexpected error occurred: ${e.toString()}');
    }
  }
}

/// Provider for [HomeRepository].
final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  final remoteDatasource = ref.watch(homeRemoteDatasourceProvider);
  return HomeRepositoryImpl(remoteDatasource);
});
