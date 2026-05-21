import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/dio_client.dart';
import '../models/post_model.dart';

abstract class HomeRemoteDatasource {
  Future<DogImagesResponseModel> getRandomDogImages();
}

class HomeRemoteDatasourceImpl implements HomeRemoteDatasource {
  final DioClient _dioClient;

  const HomeRemoteDatasourceImpl(this._dioClient);

  @override
  Future<DogImagesResponseModel> getRandomDogImages() async {
    final response = await _dioClient.get<Map<String, dynamic>>(
      ApiConstants.randomImages,
    );

    final data = response.data;
    if (data == null) {
      throw const ServerException(message: 'No data received from server.');
    }

    return DogImagesResponseModel.fromJson(data);
  }
}

final homeRemoteDatasourceProvider = Provider<HomeRemoteDatasource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return HomeRemoteDatasourceImpl(dioClient);
});
