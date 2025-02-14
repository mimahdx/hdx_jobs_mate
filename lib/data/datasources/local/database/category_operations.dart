import 'app_database.dart';

// Extension for Category operations
extension CategoryOperations on AppDatabase {
  Future<String> insertCategory({
    required String name,
    required String type,
    String? description,
  }) async {
    final db = await database;
    final String id = DateTime.now().millisecondsSinceEpoch.toString();
    final int now = DateTime.now().millisecondsSinceEpoch;

    await db.insert(AppDatabase.categoryTable, {
      AppDatabase.columnId: id,
      AppDatabase.columnCategoryName: name,
      AppDatabase.columnCategoryType: type,
      AppDatabase.columnCategoryDescription: description,
      AppDatabase.columnCreatedAt: now,
      AppDatabase.columnUpdatedAt: now,
      AppDatabase.columnSyncStatus: 'pending'
    });

    return id;
  }

  Future<int> updateCategory({
    required String id,
    required String name,
    required String type,
    String? description,
  }) async {
    final db = await database;
    final int now = DateTime.now().millisecondsSinceEpoch;

    return await db.update(
      AppDatabase.categoryTable,
      {
        AppDatabase.columnCategoryName: name,
        AppDatabase.columnCategoryType: type,
        AppDatabase.columnCategoryDescription: description,
        AppDatabase.columnUpdatedAt: now,
        AppDatabase.columnSyncStatus: 'pending'
      },
      where: '${AppDatabase.columnId} = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteCategory(String id) async {
    final db = await database;
    return await db.delete(
      AppDatabase.categoryTable,
      where: '${AppDatabase.columnId} = ?',
      whereArgs: [id],
    );
  }

  Future<Map<String, dynamic>?> getCategoryById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query(
      AppDatabase.categoryTable,
      where: '${AppDatabase.columnId} = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (results.isEmpty) {
      return null;
    }
    return results.first;
  }

  Future<List<Map<String, dynamic>>> getCategories() async {
    final db = await database;
    return db.query(AppDatabase.categoryTable, orderBy: AppDatabase.columnCategoryName);
  }
}
