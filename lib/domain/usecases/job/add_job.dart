import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/job.dart';
import '../../repositories/job_repository.dart';

class AddJob {
  final JobRepository repository;

  AddJob({required this.repository});

  Future<Either<Failure, Job>> call({
    required String name,
    required String link,
    required String site,
    String? redirectUrl,
    String? description,
    required int status
  }) async {
    return await repository.addJob(
      name: name,
      link: link,
      site: site,
      redirectUrl: redirectUrl,
      description: description,
      status: status,
    );
  }
}