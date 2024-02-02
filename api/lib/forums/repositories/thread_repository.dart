import 'package:api/core/generate_id.dart';
import 'package:postgres/postgres.dart';
import 'package:shared/shared.dart';

class ThreadRepository {
  ThreadRepository({required this.database});

  final Connection database;

  static const table = 'threads';

  static Thread rowToItem(Map<String, dynamic> data) {
    return Thread(
      id: data['id'] as String,
      forumId: data['forum_id'] as String,
      title: data['title'] as String,
    );
  }

  Future<List<Thread>> getThreads(String forumId) async {
    final result = await database.execute(
      Sql.named(
        'SELECT * FROM $table WHERE forum_id = @forum_id '
        'ORDER BY created_at DESC',
      ),
      parameters: {'forum_id': forumId},
    );
    return result.map((row) => row.toColumnMap()).map(rowToItem).toList();
  }

  Future<Thread?> getThread(String threadId) async {
    final result = await database.execute(
      Sql.named('SELECT * FROM $table WHERE id = @id'),
      parameters: {'id': threadId},
    );
    return result.map((row) => row.toColumnMap()).map(rowToItem).singleOrNull;
  }

  Future<Thread> createThread(
    String forumId,
    String userId,
    String title,
  ) async {
    final id = generateId();
    final now = DateTime.now();
    await database.execute(
      Sql.named(
        'INSERT INTO $table '
        '(id, forum_id, user_id, created_at, updated_at, title) '
        'VALUES '
        '(@id, @forum_id, @user_id, @created_at, @updated_at, @title)',
      ),
      parameters: {
        'id': id,
        'forum_id': forumId,
        'user_id': userId,
        'created_at': now,
        'updated_at': now,
        'title': title,
      },
    );
    return Thread(id: id, forumId: forumId, title: title);
  }
}
