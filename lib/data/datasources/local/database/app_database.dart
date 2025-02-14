// lib/data/datasources/local/database/app_database.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static const String dbName = 'finance_tracker.db';
  static const int dbVersion = 1;

  // Table Names
  static const String categoryTable = 'categories';
  static const String savingTable = 'savings';

  // Common Columns
  static const String columnId = 'id';
  static const String columnCreatedAt = 'created_at';
  static const String columnUpdatedAt = 'updated_at';
  static const String columnSyncStatus = 'sync_status';

  // Category Table Columns
  static const String columnCategoryName = 'name';
  static const String columnCategoryType = 'type';
  static const String columnCategoryDescription = 'description';

  // Saving Table Columns
  static const String columnSavingCategoryId = 'category_id';
  static const String columnSavingAmount = 'amount';
  static const String columnSavingDate = 'transaction_date';
  static const String columnSavingNote = 'note';

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
    // Create Categories table
    await db.execute('''
      CREATE TABLE ${AppDatabase.categoryTable} (
        ${AppDatabase.columnId} TEXT PRIMARY KEY,
        ${AppDatabase.columnCategoryName} TEXT NOT NULL,
        ${AppDatabase.columnCategoryType} TEXT NOT NULL,
        ${AppDatabase.columnCategoryDescription} TEXT,
        ${AppDatabase.columnCreatedAt} INTEGER NOT NULL,
        ${AppDatabase.columnUpdatedAt} INTEGER NOT NULL,
        ${AppDatabase.columnSyncStatus} TEXT NOT NULL
      )
    ''');

    // Create Savings table
    await db.execute('''
      CREATE TABLE ${AppDatabase.savingTable} (
        ${AppDatabase.columnId} TEXT PRIMARY KEY,
        ${AppDatabase.columnSavingCategoryId} TEXT NOT NULL,
        ${AppDatabase.columnSavingAmount} REAL NOT NULL,
        ${AppDatabase.columnSavingDate} INTEGER NOT NULL,
        ${AppDatabase.columnSavingNote} TEXT,
        ${AppDatabase.columnCreatedAt} INTEGER NOT NULL,
        ${AppDatabase.columnUpdatedAt} INTEGER NOT NULL,
        ${AppDatabase.columnSyncStatus} TEXT NOT NULL,
        FOREIGN KEY (${AppDatabase.columnSavingCategoryId}) 
          REFERENCES ${AppDatabase.categoryTable} (${AppDatabase.columnId})
          ON DELETE CASCADE
      )
    ''');

    // Create indexes
    await db.execute(
        'CREATE INDEX idx_saving_date ON ${AppDatabase.savingTable} (${AppDatabase.columnSavingDate})');
    await db.execute(
        'CREATE INDEX idx_category_name ON ${AppDatabase.categoryTable} (${AppDatabase.columnCategoryName})');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades here
  }
}
