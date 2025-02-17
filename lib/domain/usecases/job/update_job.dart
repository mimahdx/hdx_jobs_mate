import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/job.dart';
import '../../repositories/job_repository.dart';

class UpdateJob {
  final JobRepository repository;

  UpdateJob({required this.repository});

  Future<Either<Failure, Job>> call({
    required String id,
    required String name,
    required String link,
    required String site,
    String? redirectUrl,
    String? description,
    required status
  }) async {
    return await repository.updateJob(
      id: id,
      name: name,
      link: link,
      site: site,
      redirectUrl: redirectUrl,
      description: description,
      status: status
    );
  }
}