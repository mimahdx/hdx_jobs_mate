import 'package:dartz/dartz.dart';
import 'package:hdx_savings_tracker/data/datasources/local/database/category_operations.dart';
import '../datasources/local/database/app_database.dart';
import '../../domain/repositories/category_repository.dart';
import '../../domain/entities/category.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';
import '../../core/network/network_info.dart';
import '../../domain/models/category_model.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final AppDatabase localDatabase;
  final NetworkInfo networkInfo;

  CategoryRepositoryImpl({
    required this.localDatabase,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    try {
      final categoryMaps = await localDatabase.getCategories();
      final categories = categoryMaps
          .map((map) => CategoryModel.fromMap(map).toEntity())
          .toList();
      return Right(categories);
    } on DatabaseException {
      return Left(DatabaseFailure());
    } catch (e) {
      return Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, Category>> getCategoryById(String id) async {
    try {
      final categoryMap = await localDatabase.getCategoryById(id);
      if (categoryMap == null) {
        return Left(NotFoundFailure());
      }
      return Right(CategoryModel.fromMap(categoryMap).toEntity());
    } on DatabaseException {
      return Left(DatabaseFailure());
    } catch (e) {
      return Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, Category>> addCategory({
    required String name,
    required String type,
    String? description,
  }) async {
    try {
      final id = await localDatabase.insertCategory(
        name: name,
        type: type,
        description: description,
      );
      final categoryMap = await localDatabase.getCategoryById(id);
      if (categoryMap == null) {
        return Left(DatabaseFailure());
      }
      return Right(CategoryModel.fromMap(categoryMap).toEntity());
    } on DatabaseException {
      return Left(DatabaseFailure());
    } catch (e) {
      return Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, Category>> updateCategory({
    required String id,
    required String name,
    required String type,
    String? description,
  }) async {
    try {
      final result = await localDatabase.updateCategory(
        id: id,
        name: name,
        type: type,
        description: description,
      );
      if (result == 0) {
        return Left(NotFoundFailure());
      }
      final categoryMap = await localDatabase.getCategoryById(id);
      if (categoryMap == null) {
        return Left(DatabaseFailure());
      }
      return Right(CategoryModel.fromMap(categoryMap).toEntity());
    } on DatabaseException {
      return Left(DatabaseFailure());
    } catch (e) {
      return Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteCategory(String id) async {
    try {
      final result = await localDatabase.deleteCategory(id);
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