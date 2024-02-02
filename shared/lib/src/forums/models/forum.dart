import 'package:json_annotation/json_annotation.dart';
import 'package:shared/src/json.dart';

part 'forum.g.dart';

@JsonSerializable()
class Forum {
  Forum({
    required this.id,
    required this.categoryId,
    required this.sortOrder,
    required this.title,
  });

  factory Forum.fromJson(Json json) => _$ForumFromJson(json);

  final String id;
  final String categoryId;
  final int sortOrder;
  final String title;

  Json toJson() => _$ForumToJson(this);
}
