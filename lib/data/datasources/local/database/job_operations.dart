import 'app_database.dart';

// Extension for Job operations
extension JobOperations on AppDatabase {
  Future<String> insertJob({
    required String name,
    required String link,
    required String site,
    String? redirectUrl,
    String? description,
    required int status,
  }) async {
    final db = await database;
    final String id = DateTime.now().millisecondsSinceEpoch.toString();
    final int now = DateTime.now().millisecondsSinceEpoch;

    await db.insert(AppDatabase.jobsTable, {
      AppDatabase.columnId: id,
      AppDatabase.columnJobName: name,
      AppDatabase.columnJobLink: link,
      AppDatabase.columnJobSite: site,
      AppDatabase.columnJobRedirectUrl: redirectUrl,
      AppDatabase.columnJobDescription: description,
      AppDatabase.columnCreatedAt: now,
      AppDatabase.columnUpdatedAt: now,
      AppDatabase.columnSyncStatus: 'pending',
      AppDatabase.columnStatus: status
    });

    return id;
  }

  Future<int> updateJob({
    required String id,
    required String name,
    required String link,
    required String site,
    String? redirectUrl,
    String? description,
    required int status,
  }) async {
    final db = await database;
    final int now = DateTime.now().millisecondsSinceEpoch;

    return await db.update(
      AppDatabase.jobsTable,
      {
        AppDatabase.columnJobName: name,
        AppDatabase.columnJobLink: link,
        AppDatabase.columnJobSite: site,
        AppDatabase.columnJobRedirectUrl: redirectUrl,
        AppDatabase.columnJobDescription: description,
        AppDatabase.columnUpdatedAt: now,
        AppDatabase.columnSyncStatus: 'pending',
        AppDatabase.columnStatus: status
      },
      where: '${AppDatabase.columnId} = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteJob(String id) async {
    final db = await database;
    return await db.delete(
      AppDatabase.jobsTable,
      where: '${AppDatabase.columnId} = ?',
      whereArgs: [id],
    );
  }

  Future<Map<String, dynamic>?> getJobById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query(
      AppDatabase.jobsTable,
      where: '${AppDatabase.columnId} = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (results.isEmpty) {
      return null;
    }
    return results.first;
  }

  Future<List<Map<String, dynamic>>> getJobs({
    String? site,
    String? searchTerm,
  }) async {
    final db = await database;
    String? whereClause;
    List<dynamic> whereArgs = [];

    if (site != null && searchTerm != null) {
      whereClause = '${AppDatabase.columnJobSite} = ? AND ${AppDatabase.columnJobName} LIKE ?';
      whereArgs = [site, '%$searchTerm%'];
    } else if (site != null) {
      whereClause = '${AppDatabase.columnJobSite} = ?';
      whereArgs = [site];
    } else if (searchTerm != null) {
      whereClause = '${AppDatabase.columnJobName} LIKE ?';
      whereArgs = ['%$searchTerm%'];
    }

    return db.query(
      AppDatabase.jobsTable,
      where: whereClause,
      whereArgs: whereArgs,
      orderBy: '${AppDatabase.columnCreatedAt} DESC',
    );
  }

  Future<List<Map<String, dynamic>>> getJobsBySite(String site) async {
    final db = await database;
    return db.query(
      AppDatabase.jobsTable,
      where: '${AppDatabase.columnJobSite} = ?',
      whereArgs: [site],
      orderBy: '${AppDatabase.columnCreatedAt} DESC',
    );
  }

  Future<List<Map<String, dynamic>>> getJobsByStatus({
    required int status,
    String? site,
    String? searchTerm,
  }) async {
    final db = await database;
    List<String> conditions = ['${AppDatabase.columnStatus} = ?'];
    List<dynamic> whereArgs = [status];

    if (site != null) {
      conditions.add('${AppDatabase.columnJobSite} = ?');
      whereArgs.add(site);
    }

    if (searchTerm != null) {
      conditions.add('${AppDatabase.columnJobName} LIKE ?');
      whereArgs.add('%$searchTerm%');
    }

    String whereClause = conditions.join(' AND ');

    return db.query(
      AppDatabase.jobsTable,
      where: whereClause,
      whereArgs: whereArgs,
      orderBy: '${AppDatabase.columnCreatedAt} DESC',
    );
  }
}