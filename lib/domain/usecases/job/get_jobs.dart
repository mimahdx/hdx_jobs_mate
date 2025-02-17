import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/job.dart';
import '../../repositories/job_repository.dart';

class GetJobs {
  final JobRepository repository;

  GetJobs({required this.repository});

  Future<Either<Failure, List<Job>>> call({
    String? site,
    String? searchTerm,
  }) async {
    return await repository.getJobs(
      site: site,
      searchTerm: searchTerm,
    );
  }
}