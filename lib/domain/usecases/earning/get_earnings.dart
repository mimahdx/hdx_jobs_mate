import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../entities/earning.dart';
import '../../repositories/earning_repository.dart';

class GetEarnings {
  final EarningRepository repository;

  GetEarnings({required this.repository});

  Future<Either<Failure, List<Earning>>> call({
    DateTime? startDate,
    DateTime? endDate,
    String? jobId,
  }) async {
    return await repository.getEarnings(
      startDate: startDate,
      endDate: endDate,
      jobId: jobId,
    );
  }
}