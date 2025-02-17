import '../entities/earning.dart';
import '../../data/datasources/local/database/app_database.dart';

class EarningModel extends Earning {
  final String syncStatus;

  const EarningModel({
    required super.id,
    required super.jobId,
    required super.amount,
    required super.date,
    super.note,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
    required this.syncStatus,
  });

  factory EarningModel.fromMap(Map<String, dynamic> map) {
    return EarningModel(
      id: map[AppDatabase.columnId] as String,
      jobId: map[AppDatabase.columnEarningJobId] as String,
      amount: map[AppDatabase.columnEarningAmount] as double,
      date: DateTime.fromMillisecondsSinceEpoch(
        map[AppDatabase.columnEarningDate] as int,
      ),
      note: map[AppDatabase.columnEarningNote] as String?,
      status: map[AppDatabase.columnStatus] as int,
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
      AppDatabase.columnEarningJobId: jobId,
      AppDatabase.columnEarningAmount: amount,
      AppDatabase.columnEarningDate: date.millisecondsSinceEpoch,
      AppDatabase.columnEarningNote: note,
      AppDatabase.columnStatus: status,
      AppDatabase.columnCreatedAt: createdAt.millisecondsSinceEpoch,
      AppDatabase.columnUpdatedAt: updatedAt.millisecondsSinceEpoch,
      AppDatabase.columnSyncStatus: syncStatus,
    };
  }

  Earning toEntity() => Earning(
    id: id,
    jobId: jobId,
    amount: amount,
    date: date,
    note: note,
    status: status,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  EarningModel copyWith({
    String? id,
    String? jobId,
    double? amount,
    DateTime? date,
    String? note,
    int? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? syncStatus,
  }) {
    return EarningModel(
      id: id ?? this.id,
      jobId: jobId ?? this.jobId,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      note: note ?? this.note,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }
}