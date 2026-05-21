import '../../domain/entities/post_entity.dart';

/// Response wrapper dari Dog CEO API:
/// { "message": ["url1","url2",...], "status": "success" }
class DogImagesResponseModel {
  final List<String> imageUrls;
  final String status;

  const DogImagesResponseModel({
    required this.imageUrls,
    required this.status,
  });

  factory DogImagesResponseModel.fromJson(Map<String, dynamic> json) {
    final messages = json['message'];
    List<String> urls;
    if (messages is List) {
      urls = messages.map((e) => e.toString()).toList();
    } else {
      urls = [];
    }
    return DogImagesResponseModel(
      imageUrls: urls,
      status: json['status'] as String? ?? '',
    );
  }

  /// Konversi setiap URL ke domain entity.
  /// URL format: https://images.dog.ceo/breeds/hound-afghan/n02116738_1.jpg
  List<DogImageEntity> toEntities() {
    return imageUrls.map((url) {
      final parts = _parseBreedFromUrl(url);
      return DogImageEntity(
        imageUrl: url,
        breed: parts.$1,
        subBreed: parts.$2,
      );
    }).toList();
  }

  /// Parse breed & sub-breed dari segment URL.
  (String, String) _parseBreedFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      // path: /breeds/hound-afghan/image.jpg
      final segments = uri.pathSegments;
      // segments[0]='breeds', segments[1]='hound-afghan', segments[2]='file'
      if (segments.length >= 2) {
        final breedSegment = segments[1]; // e.g. "hound-afghan"
        final parts = breedSegment.split('-');
        if (parts.length >= 2) {
          return (parts[0], parts.sublist(1).join(' '));
        }
        return (parts[0], '');
      }
    } catch (_) {}
    return ('dog', '');
  }
}
