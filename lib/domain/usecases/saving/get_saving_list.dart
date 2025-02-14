import 'package:dartz/dartz.dart';
import '../../repositories/saving_repository.dart';
import '../../../core/errors/failures.dart';
import '../../entities/saving.dart';

class GetSavingList {
  final SavingRepository repository;

  GetSavingList({required this.repository});

  Future<Either<Failure, List<Saving>>> call() async {
    return await repository.getSavingList();
  }
}