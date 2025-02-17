import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../entities/earning.dart';
import '../../repositories/earning_repository.dart';

class GetEarningsByDateRange {
  final EarningRepository repository;

  GetEarningsByDateRange({required this.repository});

  Future<Either<Failure, List<Earning>>> call({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    return await repository.getEarningsByDateRange(
      startDate: startDate,
      endDate: endDate,
    );
  }
}