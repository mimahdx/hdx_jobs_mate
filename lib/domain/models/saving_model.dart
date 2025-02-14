import '../entities/saving.dart';
import '../../data/datasources/local/database/app_database.dart';

class SavingModel extends Saving {
  final String syncStatus;

  const SavingModel({
    required super.id,
    required super.categoryId,
    required super.amount,
    required super.date,
    super.note,
    required super.createdAt,
    required super.updatedAt,
    required this.syncStatus,
  });

  factory SavingModel.fromMap(Map<String, dynamic> map) {
    return SavingModel(
      id: map[AppDatabase.columnId] as String,
      categoryId: map[AppDatabase.columnSavingCategoryId] as String,
      amount: map[AppDatabase.columnSavingAmount] as double,
      date: DateTime.fromMillisecondsSinceEpoch(
        map[AppDatabase.columnSavingDate] as int,
      ),
      note: map[AppDatabase.columnSavingNote] as String?,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map[AppDatabase.columnCreatedAt] as int,
      ),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        map[AppDatabase.columnUpdatedAt] as int,
      ),
      syncStatus: map[AppDatabase.columnSyncStatus] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      AppDatabase.columnId: id,
      AppDatabase.columnSavingCategoryId: categoryId,
      AppDatabase.columnSavingAmount: amount,
      AppDatabase.columnSavingDate: date.millisecondsSinceEpoch,
      AppDatabase.columnSavingNote: note,
      AppDatabase.columnCreatedAt: createdAt.millisecondsSinceEpoch,
      AppDatabase.columnUpdatedAt: updatedAt.millisecondsSinceEpoch,
      AppDatabase.columnSyncStatus: syncStatus,
    };
  }

  Saving toEntity() => Saving(
    id: id,
    categoryId: categoryId,
    amount: amount,
    date: date,
    note: note,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  SavingModel copyWith({
    String? id,
    String? categoryId,
    double? amount,
    DateTime? date,
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? syncStatus,
  }) {
    return SavingModel(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }
}