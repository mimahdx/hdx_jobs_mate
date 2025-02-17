import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../entities/earning.dart';
import '../../repositories/earning_repository.dart';

class GetEarning {
  final EarningRepository repository;

  GetEarning({required this.repository});

  Future<Either<Failure, Earning>> call({
    required String id,
  }) async {
    return await repository.getEarningById(id);
  }
}