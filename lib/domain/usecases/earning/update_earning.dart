import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../entities/earning.dart';
import '../../repositories/earning_repository.dart';

class UpdateEarning {
  final EarningRepository repository;

  UpdateEarning({required this.repository});

  Future<Either<Failure, Earning>> call({
    required String id,
    required String jobId,
    required double amount,
    required DateTime date,
    String? note,
    required int status,
  }) async {
    return await repository.updateEarning(
      id: id,
      jobId: jobId,
      amount: amount,
      date: date,
      note: note,
      status: status
    );
  }
}