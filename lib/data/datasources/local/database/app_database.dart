// lib/data/datasources/local/database/app_database.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static const String dbName = 'finance_tracker.db';
  static const int dbVersion = 1;

  // Table Names
  static const String jobsTable = 'jobs';
  static const String earningsTable = 'earnings';

  // Common Columns
  static const String columnId = 'id';
  static const String columnCreatedAt = 'created_at';
  static const String columnUpdatedAt = 'updated_at';
  static const String columnSyncStatus = 'sync_status';
  static const String columnStatus = 'status';

  // Jobs Table Columns
  static const String columnJobName = 'name';
  static const String columnJobLink = 'link';
  static const String columnJobSite = 'site';
  static const String columnJobRedirectUrl = 'redirect_url';
  static const String columnJobDescription = 'description';

  // Earnings Table Columns
  static const String columnEarningJobId = 'job_id';
  static const String columnEarningAmount = 'amount';
  static const String columnEarningDate = 'transaction_date';
  static const String columnEarningNote = 'note';

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String databasesPath = await getDatabasesPath();
    final String path = join(databasesPath, AppDatabase.dbName);

    return await openDatabase(
      path,
      version: AppDatabase.dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create Jobs table
    await db.execute('''
      CREATE TABLE ${AppDatabase.jobsTable} (
        ${AppDatabase.columnId} TEXT PRIMARY KEY,
        ${AppDatabase.columnJobName} TEXT NOT NULL,
        ${AppDatabase.columnJobLink} TEXT NOT NULL,
        ${AppDatabase.columnJobSite} TEXT NOT NULL,
        ${AppDatabase.columnJobRedirectUrl} TEXT,
        ${AppDatabase.columnJobDescription} TEXT,
        ${AppDatabase.columnCreatedAt} INTEGER NOT NULL,
        ${AppDatabase.columnUpdatedAt} INTEGER NOT NULL,
        ${AppDatabase.columnSyncStatus} TEXT NOT NULL,
        ${AppDatabase.columnStatus} INTEGER NOT NULL
      )
    ''');

    // Create Earnings table
    await db.execute('''
      CREATE TABLE ${AppDatabase.earningsTable} (
        ${AppDatabase.columnId} TEXT PRIMARY KEY,
        ${AppDatabase.columnEarningJobId} TEXT NOT NULL,
        ${AppDatabase.columnEarningAmount} REAL NOT NULL,
        ${AppDatabase.columnEarningDate} INTEGER NOT NULL,
        ${AppDatabase.columnEarningNote} TEXT,
        ${AppDatabase.columnCreatedAt} INTEGER NOT NULL,
        ${AppDatabase.columnUpdatedAt} INTEGER NOT NULL,
        ${AppDatabase.columnSyncStatus} TEXT NOT NULL,
        ${AppDatabase.columnStatus} INTEGER NOT NULL,
        FOREIGN KEY (${AppDatabase.columnEarningJobId}) 
          REFERENCES ${AppDatabase.jobsTable} (${AppDatabase.columnId})
          ON DELETE CASCADE
      )
    ''');

    // Create indexes
    await db.execute(
        'CREATE INDEX idx_earning_date ON ${AppDatabase.earningsTable} (${AppDatabase.columnEarningDate})');
    await db.execute(
        'CREATE INDEX idx_job_name ON ${AppDatabase.jobsTable} (${AppDatabase.columnJobName})');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades here
  }
}