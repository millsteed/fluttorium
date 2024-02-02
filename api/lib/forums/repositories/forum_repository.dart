import 'package:postgres/postgres.dart';
import 'package:shared/shared.dart';

class ForumRepository {
  ForumRepository({required this.database});

  final Connection database;

  static const table = 'forums';

  static Forum rowToItem(Map<String, dynamic> data) {
    return Forum(
      id: data['id'] as String,
      categoryId: data['category_id'] as String,
      sortOrder: data['sort_order'] as int,
      title: data['title'] as String,
    );
  }

  Future<List<Forum>> getForums() async {
    final result = await database.execute(
      Sql.named('SELECT * FROM $table ORDER BY sort_order'),
    );
    return result.map((row) => row.toColumnMap()).map(rowToItem).toList();
  }

  Future<Forum?> getForum(String forumId) async {
    final result = await database.execute(
      Sql.named('SELECT * FROM $table WHERE id = @id'),
      parameters: {'id': forumId},
    );
    return result.map((row) => row.toColumnMap()).map(rowToItem).singleOrNull;
  }
}
