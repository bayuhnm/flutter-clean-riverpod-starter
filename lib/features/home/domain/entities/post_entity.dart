import 'package:equatable/equatable.dart';

/// Domain entity untuk satu item dog image.
/// Tidak bergantung pada layer data sama sekali.
class DogImageEntity extends Equatable {
  final String imageUrl;
  final String breed;
  final String subBreed;

  const DogImageEntity({
    required this.imageUrl,
    required this.breed,
    required this.subBreed,
  });

  /// Nama tampilan: "Golden Retriever" dari URL
  String get displayName {
    final name = subBreed.isNotEmpty ? '$subBreed $breed' : breed;
    return name
        .split(' ')
        .map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : w)
        .join(' ');
  }

  @override
  List<Object?> get props => [imageUrl, breed, subBreed];
}
