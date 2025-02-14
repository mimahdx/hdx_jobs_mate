import 'package:dartz/dartz.dart';
import '../../repositories/category_repository.dart';
import '../../../core/errors/failures.dart';

class DeleteCategory {
  final CategoryRepository repository;

  DeleteCategory({required this.repository});

  Future<Either<Failure, bool>> call({
    required String id,
  }) async {
    return await repository.deleteCategory(id);
  }
}