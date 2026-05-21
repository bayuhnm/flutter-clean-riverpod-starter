import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_datasource.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDatasource _remoteDatasource;

  const HomeRepositoryImpl(this._remoteDatasource);

  @override
  Future<List<DogImageEntity>> getRandomDogImages() async {
    try {
      final responseModel = await _remoteDatasource.getRandomDogImages();
      return responseModel.toEntities();
    } on ServerException catch (e) {
      AppLogger.error('ServerException in HomeRepository', error: e);
      throw ServerFailure(message: e.message);
    } on NetworkException catch (e) {
      AppLogger.error('NetworkException in HomeRepository', error: e);
      throw NetworkFailure(message: e.message);
    } catch (e) {
      AppLogger.error('Unknown error in HomeRepository', error: e);
      throw UnknownFailure(message: 'Unexpected error: ${e.toString()}');
    }
  }
}

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  final datasource = ref.watch(homeRemoteDatasourceProvider);
  return HomeRepositoryImpl(datasource);
});
