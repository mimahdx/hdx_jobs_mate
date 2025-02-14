import 'package:dartz/dartz.dart';
import '../../repositories/category_repository.dart';
import '../../../core/errors/failures.dart';
import '../../entities/category.dart';

class UpdateCategory {
  final CategoryRepository repository;

  UpdateCategory({required this.repository});

  Future<Either<Failure, Category>> call({
    required String id,
    required String name,
    required String type,
    String? description,
  }) async {
    return await repository.updateCategory(
      id: id,
      name: name,
      type: type,
      description: description,
    );
  }
}