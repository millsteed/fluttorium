import 'dart:convert';
import 'dart:typed_data';

import 'package:api/core/generate_id.dart';
import 'package:pointycastle/key_derivators/argon2.dart';
import 'package:pointycastle/pointycastle.dart';
import 'package:postgres/postgres.dart';
import 'package:shared/shared.dart';

class UserRepository {
  UserRepository({required this.database});

  final Connection database;

  static const table = 'users';

  static User rowToItem(Map<String, dynamic> data) {
    return User(
      id: data['id'] as String,
      username: data['username'] as String,
    );
  }

  Future<User?> getUserWithUsername(String username) async {
    final result = await database.execute(
      Sql.named('SELECT * FROM $table WHERE username = @username'),
      parameters: {'username': username},
    );
    return result.map((row) => row.toColumnMap()).map(rowToItem).singleOrNull;
  }

  Future<User?> getUserWithCredentials(String username, String password) async {
    final result = await database.runTx((database) async {
      final result = await database.execute(
        Sql.named('SELECT salt FROM $table WHERE username = @username'),
        parameters: {'username': username},
      );
      final salt = result.single.single! as String;
      return database.execute(
        Sql.named(
          'SELECT * FROM $table '
          'WHERE username = @username AND password = @password',
        ),
        parameters: {
          'username': username,
          'password': _hashPassword(password, salt),
        },
      );
    });
    return result.map((row) => row.toColumnMap()).map(rowToItem).singleOrNull;
  }

  Future<User> createUser(String username, String password) async {
    final id = generateId();
    final now = DateTime.now();
    final salt = generateId(32);
    await database.execute(
      Sql.named(
        'INSERT INTO $table '
        '(id, created_at, updated_at, username, password, salt) '
        'VALUES '
        '(@id, @created_at, @updated_at, @username, @password, @salt)',
      ),
      parameters: {
        'id': id,
        'created_at': now,
        'updated_at': now,
        'username': username,
        'password': _hashPassword(password, salt),
        'salt': salt,
      },
    );
    return User(id: id, username: username);
  }

  String _hashPassword(String password, String salt) {
    final derivator = Argon2BytesGenerator()
      ..init(
        Argon2Parameters(
          Argon2Parameters.DEFAULT_TYPE,
          base64Decode(salt),
          desiredKeyLength: 24,
        ),
      );
    return base64Encode(
      derivator.process(Uint8List.fromList(password.codeUnits)),
    );
  }
}
