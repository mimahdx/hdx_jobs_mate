import 'package:dartz/dartz.dart';
import '../entities/category.dart';
import '../../core/errors/failures.dart';

abstract class CategoryRepository {
  Future<Either<Failure, List<Category>>> getCategories();
  Future<Either<Failure, Category>> getCategoryById(String id);
  Future<Either<Failure, Category>> addCategory({
    required String name,
    required String type,
    String? description,
  });
  Future<Either<Failure, Category>> updateCategory({
    required String id,
    required String name,
    required String type,
    String? description,
  });
  Future<Either<Failure, bool>> deleteCategory(String id);
}