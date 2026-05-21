import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/usecases/get_posts_usecase.dart';

// ─── State ────────────────────────────────────────────────────────────────────

enum HomeStatus { initial, loading, success, empty, error }

class HomeState extends Equatable {
  final HomeStatus status;
  final List<DogImageEntity> images;
  final String? errorMessage;

  const HomeState({
    this.status = HomeStatus.initial,
    this.images = const [],
    this.errorMessage,
  });

  bool get isInitial => status == HomeStatus.initial;
  bool get isLoading => status == HomeStatus.loading;
  bool get isSuccess => status == HomeStatus.success;
  bool get isEmpty => status == HomeStatus.empty;
  bool get hasError => status == HomeStatus.error;

  HomeState copyWith({
    HomeStatus? status,
    List<DogImageEntity>? images,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      images: images ?? this.images,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, images, errorMessage];
}

// ─── UseCase Provider ─────────────────────────────────────────────────────────

final getDogImagesUseCaseProvider = Provider<GetDogImagesUseCase>((ref) {
  final repository = ref.watch(homeRepositoryProvider);
  return GetDogImagesUseCase(repository);
});

// ─── Notifier ─────────────────────────────────────────────────────────────────

class HomeNotifier extends StateNotifier<HomeState> {
  final GetDogImagesUseCase _useCase;

  HomeNotifier(this._useCase) : super(const HomeState()) {
    fetchImages();
  }

  Future<void> fetchImages() async {
    state = state.copyWith(status: HomeStatus.loading, errorMessage: null);
    try {
      final images = await _useCase();
      if (images.isEmpty) {
        state = state.copyWith(status: HomeStatus.empty, images: []);
      } else {
        state = state.copyWith(status: HomeStatus.success, images: images);
      }
    } on Exception catch (e) {
      state = state.copyWith(
        status: HomeStatus.error,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<void> refresh() => fetchImages();
}

final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  final useCase = ref.watch(getDogImagesUseCaseProvider);
  return HomeNotifier(useCase);
});
