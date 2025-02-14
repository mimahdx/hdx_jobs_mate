import 'package:dartz/dartz.dart';
import '../entities/saving.dart';
import '../../core/errors/failures.dart';

abstract class SavingRepository {
  Future<Either<Failure, List<Saving>>> getSavingList();
  Future<Either<Failure, Saving>> getSavingById(String id);
  Future<Either<Failure, Saving>> addSaving({
    required String categoryId,
    required double amount,
    required DateTime date,
    String? note,
  });
  Future<Either<Failure, Saving>> updateSaving({
    required String id,
    required String categoryId,
    required double amount,
    required DateTime date,
    String? note,
  });
  Future<Either<Failure, Map<String, dynamic>>> getDashboardSummary();
}