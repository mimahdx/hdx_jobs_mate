import 'package:dartz/dartz.dart';
import '../../repositories/category_repository.dart';
import '../../../core/errors/failures.dart';
import '../../entities/category.dart';

class GetCategoryList {
  final CategoryRepository repository;

  GetCategoryList({required this.repository});

  Future<Either<Failure, List<Category>>> call() async {
    return await repository.getCategories();
  }
}