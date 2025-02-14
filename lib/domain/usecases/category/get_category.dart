import 'package:dartz/dartz.dart';
import '../../repositories/category_repository.dart';
import '../../../core/errors/failures.dart';
import '../../entities/category.dart';

class GetCategory {
  final CategoryRepository repository;

  GetCategory({required this.repository});

  Future<Either<Failure, Category>> call({
    required String id,
  }) async {
    return await repository.getCategoryById(id);
  }
}