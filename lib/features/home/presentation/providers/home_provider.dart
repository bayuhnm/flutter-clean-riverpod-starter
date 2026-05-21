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
  final List<PostEntity> posts;
  final String? errorMessage;

  const HomeState({
    this.status = HomeStatus.initial,
    this.posts = const [],
    this.errorMessage,
  });

  bool get isInitial => status == HomeStatus.initial;
  bool get isLoading => status == HomeStatus.loading;
  bool get isSuccess => status == HomeStatus.success;
  bool get isEmpty => status == HomeStatus.empty;
  bool get hasError => status == HomeStatus.error;

  HomeState copyWith({
    HomeStatus? status,
    List<PostEntity>? posts,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, posts, errorMessage];
}

// ─── Provider ─────────────────────────────────────────────────────────────────

/// Provider for [GetPostsUseCase].
final getPostsUseCaseProvider = Provider<GetPostsUseCase>((ref) {
  final repository = ref.watch(homeRepositoryProvider);
  return GetPostsUseCase(repository);
});

/// StateNotifier that manages [HomeState].
class HomeNotifier extends StateNotifier<HomeState> {
  final GetPostsUseCase _getPostsUseCase;

  HomeNotifier(this._getPostsUseCase) : super(const HomeState()) {
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    state = state.copyWith(status: HomeStatus.loading, errorMessage: null);

    try {
      final posts = await _getPostsUseCase();

      if (posts.isEmpty) {
        state = state.copyWith(status: HomeStatus.empty, posts: []);
      } else {
        state = state.copyWith(status: HomeStatus.success, posts: posts);
      }
    } on Exception catch (e) {
      state = state.copyWith(
        status: HomeStatus.error,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<void> refresh() => fetchPosts();
}

/// Provider for [HomeNotifier].
final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  final useCase = ref.watch(getPostsUseCaseProvider);
  return HomeNotifier(useCase);
});
