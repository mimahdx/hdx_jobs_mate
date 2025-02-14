import 'package:dartz/dartz.dart';
import 'package:hdx_savings_tracker/data/datasources/local/database/saving_operations.dart';
import '../../domain/repositories/saving_repository.dart';
import '../../domain/entities/saving.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';
import '../../core/network/network_info.dart';
import '../../domain/models/saving_model.dart';
import '../datasources/local/database/app_database.dart';

class SavingRepositoryImpl implements SavingRepository {
  final AppDatabase localDatabase;
  final NetworkInfo networkInfo;

  SavingRepositoryImpl({
    required this.localDatabase,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Saving>>> getSavingList() async {
    try {
      final savingMaps = await localDatabase.getSavings();
      final savings = savingMaps
          .map((map) => SavingModel.fromMap(map).toEntity())
          .toList();
      return Right(savings);
    } on DatabaseException {
      return Left(DatabaseFailure());
    } catch (e) {
      return Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, Saving>> getSavingById(String id) async {
    try {
      final savingMap = await localDatabase.getSavingById(id);
      if (savingMap == null) {
        return Left(NotFoundFailure());
      }
      return Right(SavingModel.fromMap(savingMap).toEntity());
    } on DatabaseException {
      return Left(DatabaseFailure());
    } catch (e) {
      return Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, Saving>> addSaving({
    required String categoryId,
    required double amount,
    required DateTime date,
    String? note,
  }) async {
    try {
      final id = await localDatabase.insertSaving(
        categoryId: categoryId,
        amount: amount,
        date: date,
        note: note,
      );
      final savingMap = await localDatabase.getSavingById(id);
      if (savingMap == null) {
        return Left(DatabaseFailure());
      }
      return Right(SavingModel.fromMap(savingMap).toEntity());
    } on DatabaseException {
      return Left(DatabaseFailure());
    } catch (e) {
      return Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, Saving>> updateSaving({
    required String id,
    required String categoryId,
    required double amount,
    required DateTime date,
    String? note,
  }) async {
    try {
      final result = await localDatabase.updateSaving(
        id: id,
        categoryId: categoryId,
        amount: amount,
        date: date,
        note: note,
      );
      if (result == 0) {
        return Left(NotFoundFailure());
      }
      final savingMap = await localDatabase.getSavingById(id);
      if (savingMap == null) {
        return Left(DatabaseFailure());
      }
      return Right(SavingModel.fromMap(savingMap).toEntity());
    } on DatabaseException {
      return Left(DatabaseFailure());
    } catch (e) {
      return Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getDashboardSummary() async {
    try {
      final summary = await localDatabase.getDashboardSummary();
      return Right(summary);
    } on DatabaseException {
      return Left(DatabaseFailure());
    } catch (e) {
      return Left(UnexpectedFailure());
    }
  }
}