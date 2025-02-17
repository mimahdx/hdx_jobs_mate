import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../entities/earning.dart';
import '../../repositories/earning_repository.dart';

class AddEarning {
  final EarningRepository repository;

  AddEarning({required this.repository});

  Future<Either<Failure, Earning>> call({
    required String jobId,
    required double amount,
    required DateTime date,
    String? note,
    required int status,
  }) async {
    return await repository.addEarning(
      jobId: jobId,
      amount: amount,
      date: date,
      note: note,
      status: status
    );
  }
}