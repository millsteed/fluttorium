import 'package:json_annotation/json_annotation.dart';
import 'package:shared/src/json.dart';
import 'package:shared/src/users/models/user.dart';

part 'session.g.dart';

@JsonSerializable()
class Session {
  Session({
    required this.id,
    required this.token,
    required this.user,
  });

  factory Session.fromJson(Json json) => _$SessionFromJson(json);

  final String id;
  final String token;
  final User user;

  Json toJson() => _$SessionToJson(this);
}
