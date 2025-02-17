import 'package:dartz/dartz.dart';
import '../../data/datasources/local/database/earning_operations.dart';
import '../../domain/repositories/earning_repository.dart';
import '../../domain/entities/earning.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';
import '../../core/network/network_info.dart';
import '../../domain/models/earning_model.dart';
import '../datasources/local/database/app_database.dart';

class EarningRepositoryImpl implements EarningRepository {
  final AppDatabase localDatabase;
  final NetworkInfo networkInfo;

  EarningRepositoryImpl({
    required this.localDatabase,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Earning>>> getEarnings({
    DateTime? startDate,
    DateTime? endDate,
    String? jobId,
  }) async {
    try {
      final earningMaps = await localDatabase.getEarnings(
        startDate: startDate,
        endDate: endDate,
        jobId: jobId,
      );
      final earnings = earningMaps
          .map((map) => EarningModel.fromMap(map).toEntity())
          .toList();
      return Right(earnings);
    } on DatabaseException {
      return Left(DatabaseFailure());
    } catch (e) {
      return Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, Earning>> getEarningById(String id) async {
    try {
      final earningMap = await localDatabase.getEarningById(id);
      if (earningMap == null) {
        return Left(NotFoundFailure());
      }
      return Right(EarningModel.fromMap(earningMap).toEntity());
    } on DatabaseException {
      return Left(DatabaseFailure());
    } catch (e) {
      return Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, Earning>> addEarning({
    required String jobId,
    required double amount,
    required DateTime date,
    String? note,
    required int status,
  }) async {
    try {
      final id = await localDatabase.insertEarning(
        jobId: jobId,
        amount: amount,
        date: date,
        note: note,
        status: status
      );
      final earningMap = await localDatabase.getEarningById(id);
      if (earningMap == null) {
        return Left(DatabaseFailure());
      }
      return Right(EarningModel.fromMap(earningMap).toEntity());
    } on DatabaseException {
      return Left(DatabaseFailure());
    } catch (e) {
      return Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, Earning>> updateEarning({
    required String id,
    required String jobId,
    required double amount,
    required DateTime date,
    String? note,
    required int status,
  }) async {
    try {
      final result = await localDatabase.updateEarning(
        id: id,
        jobId: jobId,
        amount: amount,
        date: date,
        note: note,
        status: status
      );
      if (result == 0) {
        return Left(NotFoundFailure());
      }
      final earningMap = await localDatabase.getEarningById(id);
      if (earningMap == null) {
        return Left(DatabaseFailure());
      }
      return Right(EarningModel.fromMap(earningMap).toEntity());
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

  @override
  Future<Either<Failure, List<Earning>>> getEarningsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final earningMaps = await localDatabase.getEarnings(
        startDate: startDate,
        endDate: endDate,
      );
      final earnings = earningMaps
          .map((map) => EarningModel.fromMap(map).toEntity())
          .toList();
      return Right(earnings);
    } on DatabaseException {
      return Left(DatabaseFailure());
    } catch (e) {
      return Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, List<Earning>>> getEarningsByStatus({
    required int status,
    DateTime? startDate,
    DateTime? endDate,
    String? jobId,
  }) async {
    try {
      final earningMaps = await localDatabase.getEarningsByStatus(
        status: status,
        startDate: startDate,
        endDate: endDate,
        jobId: jobId
      );
      final earnings = earningMaps
          .map((map) => EarningModel.fromMap(map).toEntity())
          .toList();
      return Right(earnings);
    } on DatabaseException {
      return Left(DatabaseFailure());
    } catch (e) {
      return Left(UnexpectedFailure());
    }
  }
}