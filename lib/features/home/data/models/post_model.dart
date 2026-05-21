import '../../domain/entities/post_entity.dart';

/// Data model responsible for JSON serialization/deserialization.
/// Separated from [PostEntity] to keep domain layer clean.
class PostModel {
  final int userId;
  final int id;
  final String title;
  final String body;

  const PostModel({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      userId: json['userId'] as int,
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'body': body,
    };
  }

  /// Maps this model to a domain [PostEntity].
  PostEntity toEntity() {
    return PostEntity(
      userId: userId,
      id: id,
      title: title,
      body: body,
    );
  }

  @override
  String toString() {
    return 'PostModel(userId: $userId, id: $id, title: $title)';
  }
}
