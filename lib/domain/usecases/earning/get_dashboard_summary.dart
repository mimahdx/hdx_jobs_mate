import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../repositories/earning_repository.dart';


class GetDashboardSummary {
  final EarningRepository repository;

  GetDashboardSummary({required this.repository});

  Future<Either<Failure, Map<String, dynamic>>> call() async {
    return await repository.getDashboardSummary();
  }
}