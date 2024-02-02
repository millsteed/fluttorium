import 'package:json_annotation/json_annotation.dart';
import 'package:shared/src/json.dart';

part 'post.g.dart';

@JsonSerializable()
class Post {
  Post({
    required this.id,
    required this.threadId,
    required this.createdAt,
    required this.username,
    required this.message,
  });

  factory Post.fromJson(Json json) => _$PostFromJson(json);

  final String id;
  final String threadId;
  final DateTime createdAt;
  final String username;
  final String message;

  Json toJson() => _$PostToJson(this);
}
