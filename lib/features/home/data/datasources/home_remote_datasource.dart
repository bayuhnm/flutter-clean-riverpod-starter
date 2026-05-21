import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/dio_client.dart';
import '../models/post_model.dart';

/// Abstract contract for the home remote data source.
abstract class HomeRemoteDatasource {
  Future<List<PostModel>> getPosts();
}

/// Concrete implementation using [DioClient].
class HomeRemoteDatasourceImpl implements HomeRemoteDatasource {
  final DioClient _dioClient;

  const HomeRemoteDatasourceImpl(this._dioClient);

  @override
  Future<List<PostModel>> getPosts() async {
    final response = await _dioClient.get<List<dynamic>>(ApiConstants.posts);

    final data = response.data;

    if (data == null) {
      throw const ServerException(message: 'No data received from server.');
    }

    return data
        .map((json) => PostModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}

/// Provider for [HomeRemoteDatasource].
final homeRemoteDatasourceProvider = Provider<HomeRemoteDatasource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return HomeRemoteDatasourceImpl(dioClient);
});
