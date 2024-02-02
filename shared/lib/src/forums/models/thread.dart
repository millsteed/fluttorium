import 'package:json_annotation/json_annotation.dart';
import 'package:shared/src/json.dart';

part 'thread.g.dart';

@JsonSerializable()
class Thread {
  Thread({
    required this.id,
    required this.forumId,
    required this.title,
  });

  factory Thread.fromJson(Json json) => _$ThreadFromJson(json);

  final String id;
  final String forumId;
  final String title;

  Json toJson() => _$ThreadToJson(this);
}
