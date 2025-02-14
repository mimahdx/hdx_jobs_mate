import 'package:dartz/dartz.dart';
import '../../repositories/saving_repository.dart';
import '../../../core/errors/failures.dart';
import '../../entities/saving.dart';

class UpdateSaving {
  final SavingRepository repository;

  UpdateSaving({required this.repository});

  Future<Either<Failure, Saving>> call({
    required String id,
    required String categoryId,
    required double amount,
    required DateTime date,
    String? note,
  }) async {
    return await repository.updateSaving(
      id: id,
      categoryId: categoryId,
      amount: amount,
      date: date,
      note: note,
    );
  }
}