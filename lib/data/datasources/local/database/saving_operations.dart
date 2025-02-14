import 'app_database.dart';

// Extension for Saving operations
extension SavingOperations on AppDatabase {
  Future<String> insertSaving({
    required String categoryId,
    required double amount,
    required DateTime date,
    String? note,
  }) async {
    final db = await database;
    final String id = DateTime.now().millisecondsSinceEpoch.toString();
    final int now = DateTime.now().millisecondsSinceEpoch;

    await db.insert(AppDatabase.savingTable, {
      AppDatabase.columnId: id,
      AppDatabase.columnSavingCategoryId: categoryId,
      AppDatabase.columnSavingAmount: amount,
      AppDatabase.columnSavingDate: date.millisecondsSinceEpoch,
      AppDatabase.columnSavingNote: note,
      AppDatabase.columnCreatedAt: now,
      AppDatabase.columnUpdatedAt: now,
      AppDatabase.columnSyncStatus: 'pending'
    });

    return id;
  }

  Future<int> updateSaving({
    required String id,
    required String categoryId,
    required double amount,
    required DateTime date,
    String? note,
  }) async {
    final db = await database;
    final int now = DateTime.now().millisecondsSinceEpoch;

    return await db.update(
      AppDatabase.savingTable,
      {
        AppDatabase.columnSavingCategoryId: categoryId,
        AppDatabase.columnSavingAmount: amount,
        AppDatabase.columnSavingDate: date.millisecondsSinceEpoch,
        AppDatabase.columnSavingNote: note,
        AppDatabase.columnUpdatedAt: now,
        AppDatabase.columnSyncStatus: 'pending'
      },
      where: '${AppDatabase.columnId} = ?',
      whereArgs: [id],
    );
  }

  Future<Map<String, dynamic>?> getSavingById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query(
      AppDatabase.savingTable,
      where: '${AppDatabase.columnId} = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (results.isEmpty) {
      return null;
    }
    return results.first;
  }

  Future<List<Map<String, dynamic>>> getSavings({
    DateTime? startDate,
    DateTime? endDate,
    String? categoryId,
  }) async {
    final db = await database;
    String whereClause = '';
    List<dynamic> whereArgs = [];

    if (startDate != null || endDate != null || categoryId != null) {
      List<String> conditions = [];

      if (startDate != null) {
        conditions.add('${AppDatabase.columnSavingDate} >= ?');
        whereArgs.add(startDate.millisecondsSinceEpoch);
      }

      if (endDate != null) {
        conditions.add('${AppDatabase.columnSavingDate} <= ?');
        whereArgs.add(endDate.millisecondsSinceEpoch);
      }

      if (categoryId != null) {
        conditions.add('${AppDatabase.columnSavingCategoryId} = ?');
        whereArgs.add(categoryId);
      }

      whereClause = conditions.join(' AND ');
    }

    return db.query(
      AppDatabase.savingTable,
      where: whereClause.isEmpty ? null : whereClause,
      whereArgs: whereArgs.isEmpty ? null : whereArgs,
      orderBy: '${AppDatabase.columnSavingDate} DESC',
    );
  }

  Future<Map<String, dynamic>> getDashboardSummary() async {
    final db = await database;
    final now = DateTime.now();

    // Get current balance (excluding future transactions)
    final currentBalanceResult = await db.rawQuery('''
      SELECT SUM(${AppDatabase.columnSavingAmount}) as total
      FROM ${AppDatabase.savingTable}
      WHERE ${AppDatabase.columnSavingDate} <= ?
    ''', [now.millisecondsSinceEpoch]);

    // Get future transactions
    final futureTransactions = await db.rawQuery('''
      SELECT 
        ${AppDatabase.columnSavingAmount} as amount,
        ${AppDatabase.columnSavingDate} as date,
        ${AppDatabase.columnSavingNote} as note,
        c.${AppDatabase.columnCategoryName} as category_name
      FROM ${AppDatabase.savingTable} s
      JOIN ${AppDatabase.categoryTable} c ON s.${AppDatabase.columnSavingCategoryId} = c.${AppDatabase.columnId}
      WHERE ${AppDatabase.columnSavingDate} > ?
      ORDER BY ${AppDatabase.columnSavingDate} ASC
    ''', [now.millisecondsSinceEpoch]);

    // Get summary by category
    final categorySummary = await db.rawQuery('''
      SELECT 
        c.${AppDatabase.columnCategoryName} as category,
        SUM(s.${AppDatabase.columnSavingAmount}) as total
      FROM ${AppDatabase.savingTable} s
      JOIN ${AppDatabase.categoryTable} c ON s.${AppDatabase.columnSavingCategoryId} = c.${AppDatabase.columnId}
      WHERE s.${AppDatabase.columnSavingDate} <= ?
      GROUP BY c.${AppDatabase.columnId}
      ORDER BY total DESC
    ''', [now.millisecondsSinceEpoch]);

    return {
      'currentBalance': currentBalanceResult.first['total'] ?? 0.0,
      'futureTransactions': futureTransactions,
      'categorySummary': categorySummary,
    };
  }
}