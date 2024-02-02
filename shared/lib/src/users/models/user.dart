import 'package:json_annotation/json_annotation.dart';
import 'package:shared/src/json.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  User({
    required this.id,
    required this.username,
  });

  factory User.fromJson(Json json) => _$UserFromJson(json);

  final String id;
  final String username;

  Json toJson() => _$UserToJson(this);
}
