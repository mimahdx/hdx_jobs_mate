import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/job.dart';
import '../../repositories/job_repository.dart';

class GetJob {
  final JobRepository repository;

  GetJob({required this.repository});

  Future<Either<Failure, Job>> call({
    required String id,
  }) async {
    return await repository.getJobById(id);
  }
}