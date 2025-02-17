import 'package:dartz/dartz.dart';
import '../entities/job.dart';
import '../../core/errors/failures.dart';

abstract class JobRepository {
  Future<Either<Failure, List<Job>>> getJobs({
    String? site,
    String? searchTerm,
  });

  Future<Either<Failure, List<Job>>> getJobsBySite(String site);

  Future<Either<Failure, Job>> getJobById(String id);

  Future<Either<Failure, Job>> addJob({
    required String name,
    required String link,
    required String site,
    String? redirectUrl,
    String? description,
    required int status
  });

  Future<Either<Failure, Job>> updateJob({
    required String id,
    required String name,
    required String link,
    required String site,
    String? redirectUrl,
    String? description,
    required int status
  });

  Future<Either<Failure, bool>> deleteJob(String id);
}