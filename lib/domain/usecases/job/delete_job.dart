import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../repositories/job_repository.dart';

class DeleteJob {
  final JobRepository repository;

  DeleteJob({required this.repository});

  Future<Either<Failure, bool>> call({
    required String id,
  }) async {
    return await repository.deleteJob(id);
  }
}