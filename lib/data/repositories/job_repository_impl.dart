import 'package:dartz/dartz.dart';
import '../datasources/local/database/job_operations.dart';
import '../datasources/local/database/app_database.dart';
import '../../domain/repositories/job_repository.dart';
import '../../domain/entities/job.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';
import '../../core/network/network_info.dart';
import '../../domain/models/job_model.dart';

class JobRepositoryImpl implements JobRepository {
  final AppDatabase localDatabase;
  final NetworkInfo networkInfo;

  JobRepositoryImpl({
    required this.localDatabase,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Job>>> getJobs({
    String? site,
    String? searchTerm,
  }) async {
    try {
      final jobMaps = await localDatabase.getJobs(
        site: site,
        searchTerm: searchTerm,
      );
      final jobs = jobMaps
          .map((map) => JobModel.fromMap(map).toEntity())
          .toList();
      return Right(jobs);
    } on DatabaseException {
      return Left(DatabaseFailure());
    } catch (e) {
      return Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, List<Job>>> getJobsBySite(String site) async {
    try {
      final jobMaps = await localDatabase.getJobsBySite(site);
      final jobs = jobMaps
          .map((map) => JobModel.fromMap(map).toEntity())
          .toList();
      return Right(jobs);
    } on DatabaseException {
      return Left(DatabaseFailure());
    } catch (e) {
      return Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, Job>> getJobById(String id) async {
    try {
      final jobMap = await localDatabase.getJobById(id);
      if (jobMap == null) {
        return Left(NotFoundFailure());
      }
      return Right(JobModel.fromMap(jobMap).toEntity());
    } on DatabaseException {
      return Left(DatabaseFailure());
    } catch (e) {
      return Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, Job>> addJob({
    required String name,
    required String link,
    required String site,
    String? redirectUrl,
    String? description,
    required int status,
  }) async {
    try {
      final id = await localDatabase.insertJob(
        name: name,
        link: link,
        site: site,
        redirectUrl: redirectUrl,
        description: description,
        status: status,
      );

      final jobMap = await localDatabase.getJobById(id);
      if (jobMap == null) {
        return Left(DatabaseFailure());
      }
      return Right(JobModel.fromMap(jobMap).toEntity());
    } on DatabaseException {
      return Left(DatabaseFailure());
    } catch (e) {
      print(e);
      return Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, Job>> updateJob({
    required String id,
    required String name,
    required String link,
    required String site,
    String? redirectUrl,
    String? description,
    required int status,
  }) async {
    try {
      final result = await localDatabase.updateJob(
        id: id,
        name: name,
        link: link,
        site: site,
        redirectUrl: redirectUrl,
        description: description,
        status: status
      );
      if (result == 0) {
        return Left(NotFoundFailure());
      }
      final jobMap = await localDatabase.getJobById(id);
      if (jobMap == null) {
        return Left(DatabaseFailure());
      }
      return Right(JobModel.fromMap(jobMap).toEntity());
    } on DatabaseException {
      return Left(DatabaseFailure());
    } catch (e) {
      return Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteJob(String id) async {
    try {
      final result = await localDatabase.deleteJob(id);
      if (result == 0) {
        return Left(NotFoundFailure());
      }
      return const Right(true);
    } on DatabaseException {
      return Left(DatabaseFailure());
    } catch (e) {
      return Left(UnexpectedFailure());
    }
  }
}