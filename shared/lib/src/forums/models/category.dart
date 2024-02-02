import 'package:json_annotation/json_annotation.dart';
import 'package:shared/src/json.dart';

part 'category.g.dart';

@JsonSerializable()
class Category {
  Category({
    required this.id,
    required this.sortOrder,
    required this.title,
  });

  factory Category.fromJson(Json json) => _$CategoryFromJson(json);

  final String id;
  final int sortOrder;
  final String title;

  Json toJson() => _$CategoryToJson(this);
}
