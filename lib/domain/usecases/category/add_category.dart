import 'package:dartz/dartz.dart';
import '../../repositories/category_repository.dart';
import '../../../core/errors/failures.dart';
import '../../entities/category.dart';

class AddCategory {
  final CategoryRepository repository;

  AddCategory({required this.repository});

  Future<Either<Failure, Category>> call({
    required String name,
    required String type,
    String? description,
  }) async {
    return await repository.addCategory(
      name: name,
      type: type,
      description: description,
    );
  }
}