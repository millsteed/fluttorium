import 'package:api/core/generate_id.dart';
import 'package:api/users/repositories/user_repository.dart';
import 'package:postgres/postgres.dart' hide Session;
import 'package:shared/shared.dart';

class SessionRepository {
  SessionRepository({required this.database});

  final Connection database;

  static const table = 'sessions';

  static Session rowToItem(Map<String, dynamic> data) {
    return Session(
      id: data['id'] as String,
      token: data['token'] as String,
      user: UserRepository.rowToItem(data),
    );
  }

  Future<Session?> getSessionWithToken(String token) async {
    const users = UserRepository.table;
    final result = await database.execute(
      Sql.named(
        'SELECT * FROM $table '
        'JOIN $users ON user_id = $users.id '
        'WHERE token = @token',
      ),
      parameters: {'token': token},
    );
    return result.map((row) => row.toColumnMap()).map(rowToItem).singleOrNull;
  }

  Future<Session> createSession(User user) async {
    final id = generateId();
    final now = DateTime.now();
    final token = generateId(32);
    await database.execute(
      Sql.named(
        'INSERT INTO $table '
        '(id, created_at, updated_at, token, user_id) '
        'VALUES '
        '(@id, @created_at, @updated_at, @token, @user_id)',
      ),
      parameters: {
        'id': id,
        'created_at': now,
        'updated_at': now,
        'token': token,
        'user_id': user.id,
      },
    );
    return Session(id: id, token: token, user: user);
  }

  Future<void> deleteSession(Session session) async {
    await database.execute(
      Sql.named('DELETE FROM $table WHERE id = @id'),
      parameters: {'id': session.id},
    );
  }
}
