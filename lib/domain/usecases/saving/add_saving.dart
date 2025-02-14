import 'package:dartz/dartz.dart';
import '../../repositories/saving_repository.dart';
import '../../../core/errors/failures.dart';
import '../../entities/saving.dart';

class AddSaving {
  final SavingRepository repository;

  AddSaving({required this.repository});

  Future<Either<Failure, Saving>> call({
    required String categoryId,
    required double amount,
    required DateTime date,
    String? note,
  }) async {
    return await repository.addSaving(
      categoryId: categoryId,
      amount: amount,
      date: date,
      note: note,
    );
  }
}