import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/job.dart';
import '../../repositories/job_repository.dart';

class GetJobsBySite {
  final JobRepository repository;

  GetJobsBySite({required this.repository});

  Future<Either<Failure, List<Job>>> call({
    required String site,
  }) async {
    return await repository.getJobsBySite(site);
  }
}