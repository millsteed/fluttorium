import 'package:api/core/generate_id.dart';
import 'package:api/users/repositories/user_repository.dart';
import 'package:postgres/postgres.dart';
import 'package:shared/shared.dart';

class PostRepository {
  PostRepository({required this.database});

  final Connection database;

  static const table = 'posts';

  static Post rowToItem(Map<String, dynamic> data) {
    return Post(
      id: data['id'] as String,
      threadId: data['thread_id'] as String,
      createdAt: data['created_at'] as DateTime,
      username: data['username'] as String,
      message: data['message'] as String,
    );
  }

  Future<List<Post>> getPosts(String threadId) async {
    const users = UserRepository.table;
    final result = await database.execute(
      Sql.named(
        'SELECT * FROM $table '
        'JOIN $users ON user_id = $users.id '
        'WHERE thread_id = @thread_id '
        'ORDER BY $table.created_at',
      ),
      parameters: {'thread_id': threadId},
    );
    return result.map((row) => row.toColumnMap()).map(rowToItem).toList();
  }

  Future<Post> createPost(
    String threadId,
    User user,
    String message,
  ) async {
    final id = generateId();
    final now = DateTime.now();
    await database.execute(
      Sql.named(
        'INSERT INTO $table '
        '(id, thread_id, user_id, created_at, updated_at, message) '
        'VALUES '
        '(@id, @thread_id, @user_id, @created_at, @updated_at, @message)',
      ),
      parameters: {
        'id': id,
        'thread_id': threadId,
        'user_id': user.id,
        'created_at': now,
        'updated_at': now,
        'message': message,
      },
    );
    return Post(
      id: id,
      threadId: threadId,
      createdAt: now,
      username: user.username,
      message: message,
    );
  }
}
