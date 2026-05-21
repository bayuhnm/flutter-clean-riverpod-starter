# Flutter Clean Riverpod Starter

Production-ready Flutter starter project menggunakan **Clean Architecture** dan **Riverpod** sebagai state management.

## 🏗️ Tech Stack

| Kategori         | Package            |
| ---------------- | ------------------ |
| State Management | `flutter_riverpod` |
| HTTP Client      | `dio`              |
| Routing          | `go_router`        |
| Equality         | `equatable`        |

---

## 📂 Struktur Folder

```
lib/
├── main.dart
├── app/
│   ├── app.dart
│   ├── router/
│   │   ├── app_router.dart
│   │   └── route_names.dart
│   └── theme/
│       └── app_theme.dart
├── core/
│   ├── constants/
│   │   └── api_constants.dart
│   ├── error/
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── network/
│   │   ├── dio_client.dart
│   │   └── api_service.dart
│   └── utils/
│       └── logger.dart
└── features/
    ├── splash/
    │   └── presentation/
    │       └── pages/
    │           └── splash_page.dart
    └── home/
        ├── data/
        │   ├── datasources/
        │   │   └── home_remote_datasource.dart
        │   ├── models/
        │   │   └── post_model.dart
        │   └── repositories/
        │       └── home_repository_impl.dart
        ├── domain/
        │   ├── entities/
        │   │   └── post_entity.dart
        │   ├── repositories/
        │   │   └── home_repository.dart
        │   └── usecases/
        │       └── get_posts_usecase.dart
        └── presentation/
            ├── providers/
            │   └── home_provider.dart
            ├── pages/
            │   └── home_page.dart
            └── widgets/
                └── post_card.dart
```

---

## 🚀 Cara Menjalankan

```bash
# 1. Install dependencies
flutter pub get

# 2. Jalankan aplikasi
flutter run
```

> Tidak perlu `flutter pub run build_runner build` untuk starter ini karena kita tidak menggunakan code generation (`freezed` / `json_serializable`). Model ditulis manual untuk kesederhanaan dan keterbacaan.

---

## 🔄 Flow Aplikasi

```
main.dart
  └── ProviderScope
        └── App (MaterialApp.router)
              └── SplashPage (2 detik)
                    └── HomePage
                          └── homeProvider (StateNotifier)
                                └── GetPostsUseCase
                                      └── HomeRepository
                                            └── HomeRemoteDatasource
                                                  └── DioClient
                                                        └── GET /posts
```

---

## ➕ Cara Menambah Fitur Baru

Ikuti pola yang sama. Contoh: tambah fitur **Detail Post**.

### 1. Domain Layer

```dart
// features/detail/domain/entities/detail_entity.dart
class DetailEntity extends Equatable { ... }

// features/detail/domain/repositories/detail_repository.dart
abstract class DetailRepository {
  Future<DetailEntity> getPostDetail(int id);
}

// features/detail/domain/usecases/get_post_detail_usecase.dart
class GetPostDetailUseCase {
  final DetailRepository _repository;
  Future<DetailEntity> call(int id) => _repository.getPostDetail(id);
}
```

### 2. Data Layer

```dart
// features/detail/data/models/detail_model.dart
class DetailModel {
  factory DetailModel.fromJson(Map<String, dynamic> json) { ... }
  DetailEntity toEntity() { ... }
}

// features/detail/data/datasources/detail_remote_datasource.dart
class DetailRemoteDatasourceImpl implements DetailRemoteDatasource {
  Future<DetailModel> getPostDetail(int id) async {
    final response = await _dioClient.get('/posts/$id');
    return DetailModel.fromJson(response.data);
  }
}

// features/detail/data/repositories/detail_repository_impl.dart
class DetailRepositoryImpl implements DetailRepository { ... }
```

### 3. Presentation Layer

```dart
// features/detail/presentation/providers/detail_provider.dart
class DetailNotifier extends StateNotifier<DetailState> {
  Future<void> fetchDetail(int id) async { ... }
}

final detailProvider = StateNotifierProvider.family<DetailNotifier, DetailState, int>(
  (ref, id) => DetailNotifier(ref.watch(getPostDetailUseCaseProvider))..fetchDetail(id),
);

// features/detail/presentation/pages/detail_page.dart
class DetailPage extends ConsumerWidget { ... }
```

### 4. Tambahkan Route

```dart
// app/router/app_router.dart
GoRoute(
  path: '/detail/:id',
  builder: (context, state) {
    final id = int.parse(state.pathParameters['id']!);
    return DetailPage(postId: id);
  },
),
```

---

## 🏛️ Prinsip Arsitektur

| Prinsip                    | Implementasi                                                        |
| -------------------------- | ------------------------------------------------------------------- |
| **Separation of Concerns** | Domain tidak tahu soal UI/Network. UI tidak tahu soal implementasi. |
| **Dependency Inversion**   | Repository dan Datasource menggunakan abstraksi (abstract class).   |
| **Single Responsibility**  | UseCase hanya bertugas mengeksekusi satu operasi bisnis.            |
| **Testability**            | Semua layer bisa di-mock secara terpisah.                           |
| **No setState untuk API**  | Semua state API dikelola oleh Riverpod `StateNotifier`.             |

---

## 🧪 Testing

Struktur ini mendukung unit test di setiap layer:

```bash
flutter test
```

- `HomeNotifier` bisa ditest dengan mock `GetPostsUseCase`
- `HomeRepositoryImpl` bisa ditest dengan mock `HomeRemoteDatasource`
- `GetPostsUseCase` bisa ditest dengan mock `HomeRepository`
