import 'app_database.dart';

// Extension for Earnings operations
extension EarningOperations on AppDatabase {
  Future<String> insertEarning({
    required String jobId,
    required double amount,
    required DateTime date,
    String? note,
    required int status,
  }) async {
    final db = await database;
    final String id = DateTime.now().millisecondsSinceEpoch.toString();
    final int now = DateTime.now().millisecondsSinceEpoch;

    await db.insert(AppDatabase.earningsTable, {
      AppDatabase.columnId: id,
      AppDatabase.columnEarningJobId: jobId,
      AppDatabase.columnEarningAmount: amount,
      AppDatabase.columnEarningDate: date.millisecondsSinceEpoch,
      AppDatabase.columnEarningNote: note,
      AppDatabase.columnCreatedAt: now,
      AppDatabase.columnUpdatedAt: now,
      AppDatabase.columnSyncStatus: 'pending',
      AppDatabase.columnStatus: status,
    });

    return id;
  }

  Future<int> updateEarning({
    required String id,
    required String jobId,
    required double amount,
    required DateTime date,
    String? note,
    required int status,
  }) async {
    final db = await database;
    final int now = DateTime.now().millisecondsSinceEpoch;

    return await db.update(
      AppDatabase.earningsTable,
      {
        AppDatabase.columnEarningJobId: jobId,
        AppDatabase.columnEarningAmount: amount,
        AppDatabase.columnEarningDate: date.millisecondsSinceEpoch,
        AppDatabase.columnEarningNote: note,
        AppDatabase.columnUpdatedAt: now,
        AppDatabase.columnSyncStatus: 'pending',
        AppDatabase.columnStatus: status,
      },
      where: '${AppDatabase.columnId} = ?',
      whereArgs: [id],
    );
  }

  Future<Map<String, dynamic>?> getEarningById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query(
      AppDatabase.earningsTable,
      where: '${AppDatabase.columnId} = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (results.isEmpty) {
      return null;
    }
    return results.first;
  }

  Future<List<Map<String, dynamic>>> getEarnings({
    DateTime? startDate,
    DateTime? endDate,
    String? jobId,
  }) async {
    final db = await database;
    String whereClause = '';
    List<dynamic> whereArgs = [];

    if (startDate != null || endDate != null || jobId != null) {
      List<String> conditions = [];

      if (startDate != null) {
        conditions.add('${AppDatabase.columnEarningDate} >= ?');
        whereArgs.add(startDate.millisecondsSinceEpoch);
      }

      if (endDate != null) {
        conditions.add('${AppDatabase.columnEarningDate} <= ?');
        whereArgs.add(endDate.millisecondsSinceEpoch);
      }

      if (jobId != null) {
        conditions.add('${AppDatabase.columnEarningJobId} = ?');
        whereArgs.add(jobId);
      }

      whereClause = conditions.join(' AND ');
    }

    return db.query(
      AppDatabase.earningsTable,
      where: whereClause.isEmpty ? null : whereClause,
      whereArgs: whereArgs.isEmpty ? null : whereArgs,
      orderBy: '${AppDatabase.columnEarningDate} DESC',
    );
  }

  Future<Map<String, dynamic>> getDashboardSummary() async {
    final db = await database;
    final now = DateTime.now();

    // Get total earnings (excluding future transactions)
    final totalEarningsResult = await db.rawQuery('''
      SELECT SUM(${AppDatabase.columnEarningAmount}) as total
      FROM ${AppDatabase.earningsTable}
      WHERE ${AppDatabase.columnEarningDate} <= ?
    ''', [now.millisecondsSinceEpoch]);

    // Get future earnings
    final futureEarnings = await db.rawQuery('''
      SELECT 
        ${AppDatabase.columnEarningAmount} as amount,
        ${AppDatabase.columnEarningDate} as date,
        ${AppDatabase.columnEarningNote} as note,
        j.${AppDatabase.columnJobName} as job_name,
        j.${AppDatabase.columnJobSite} as job_site
      FROM ${AppDatabase.earningsTable} e
      JOIN ${AppDatabase.jobsTable} j ON e.${AppDatabase.columnEarningJobId} = j.${AppDatabase.columnId}
      WHERE ${AppDatabase.columnEarningDate} > ?
      ORDER BY ${AppDatabase.columnEarningDate} ASC
    ''', [now.millisecondsSinceEpoch]);

    // Get summary by job site
    final siteSummary = await db.rawQuery('''
      SELECT 
        j.${AppDatabase.columnJobSite} as site,
        SUM(e.${AppDatabase.columnEarningAmount}) as total,
        COUNT(DISTINCT j.${AppDatabase.columnId}) as job_count
      FROM ${AppDatabase.earningsTable} e
      JOIN ${AppDatabase.jobsTable} j ON e.${AppDatabase.columnEarningJobId} = j.${AppDatabase.columnId}
      WHERE e.${AppDatabase.columnEarningDate} <= ?
      GROUP BY j.${AppDatabase.columnJobSite}
      ORDER BY total DESC
    ''', [now.millisecondsSinceEpoch]);

    // Get summary by individual job
    final jobSummary = await db.rawQuery('''
      SELECT 
        j.${AppDatabase.columnJobName} as job_name,
        j.${AppDatabase.columnJobSite} as site,
        SUM(e.${AppDatabase.columnEarningAmount}) as total
      FROM ${AppDatabase.earningsTable} e
      JOIN ${AppDatabase.jobsTable} j ON e.${AppDatabase.columnEarningJobId} = j.${AppDatabase.columnId}
      WHERE e.${AppDatabase.columnEarningDate} <= ?
      GROUP BY j.${AppDatabase.columnId}
      ORDER BY total DESC
    ''', [now.millisecondsSinceEpoch]);

    return {
      'totalEarnings': totalEarningsResult.first['total'] ?? 0.0,
      'futureEarnings': futureEarnings,
      'siteSummary': siteSummary,
      'jobSummary': jobSummary,
    };
  }

  Future<List<Map<String, dynamic>>> getEarningsByStatus({
    required int status,
    DateTime? startDate,
    DateTime? endDate,
    String? jobId,
  }) async {
    final db = await database;
    List<String> conditions = ['${AppDatabase.columnStatus} = ?'];
    List<dynamic> whereArgs = [status];

    if (startDate != null) {
      conditions.add('${AppDatabase.columnEarningDate} >= ?');
      whereArgs.add(startDate.millisecondsSinceEpoch);
    }

    if (endDate != null) {
      conditions.add('${AppDatabase.columnEarningDate} <= ?');
      whereArgs.add(endDate.millisecondsSinceEpoch);
    }

    if (jobId != null) {
      conditions.add('${AppDatabase.columnEarningJobId} = ?');
      whereArgs.add(jobId);
    }

    String whereClause = conditions.join(' AND ');

    return db.query(
      AppDatabase.earningsTable,
      where: whereClause,
      whereArgs: whereArgs,
      orderBy: '${AppDatabase.columnEarningDate} DESC',
    );
  }
}