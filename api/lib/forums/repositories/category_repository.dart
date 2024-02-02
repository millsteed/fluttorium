import 'package:postgres/postgres.dart';
import 'package:shared/shared.dart';

class CategoryRepository {
  CategoryRepository({required this.database});

  final Connection database;

  static const table = 'categories';

  static Category rowToItem(Map<String, dynamic> data) {
    return Category(
      id: data['id'] as String,
      sortOrder: data['sort_order'] as int,
      title: data['title'] as String,
    );
  }

  Future<List<Category>> getCategories() async {
    final result = await database.execute(
      Sql.named('SELECT * FROM $table ORDER BY sort_order'),
    );
    return result.map((row) => row.toColumnMap()).map(rowToItem).toList();
  }
}
