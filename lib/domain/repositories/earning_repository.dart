import 'package:dartz/dartz.dart';
import '../entities/earning.dart';
import '../../core/errors/failures.dart';

abstract class EarningRepository {
  Future<Either<Failure, List<Earning>>> getEarnings({
    DateTime? startDate,
    DateTime? endDate,
    String? jobId,
  });

  Future<Either<Failure, List<Earning>>> getEarningsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<Either<Failure, Earning>> getEarningById(String id);

  Future<Either<Failure, Earning>> addEarning({
    required String jobId,
    required double amount,
    required DateTime date,
    String? note,
    required int status,
  });

  Future<Either<Failure, Earning>> updateEarning({
    required String id,
    required String jobId,
    required double amount,
    required DateTime date,
    String? note,
    required int status,
  });

  Future<Either<Failure, Map<String, dynamic>>> getDashboardSummary();

  Future<Either<Failure, List<Earning>>> getEarningsByStatus({
    required int status,
    DateTime? startDate,
    DateTime? endDate,
    String? jobId,
  });
}