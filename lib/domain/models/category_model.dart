import '../entities/category.dart';
import '../../data/datasources/local/database/app_database.dart';

class CategoryModel extends Category {
  final String syncStatus;

  const CategoryModel({
    required super.id,
    required super.name,
    required super.type,
    super.description,
    required super.createdAt,
    required super.updatedAt,
    required this.syncStatus,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map[AppDatabase.columnId] as String,
      name: map[AppDatabase.columnCategoryName] as String,
      type: map[AppDatabase.columnCategoryType] as String,
      description: map[AppDatabase.columnCategoryDescription] as String?,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map[AppDatabase.columnCreatedAt] as int,
      ),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        map[AppDatabase.columnUpdatedAt] as int,
      ),
      syncStatus: map[AppDatabase.columnSyncStatus] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      AppDatabase.columnId: id,
      AppDatabase.columnCategoryName: name,
      AppDatabase.columnCategoryType: type,
      AppDatabase.columnCategoryDescription: description,
      AppDatabase.columnCreatedAt: createdAt.millisecondsSinceEpoch,
      AppDatabase.columnUpdatedAt: updatedAt.millisecondsSinceEpoch,
      AppDatabase.columnSyncStatus: syncStatus,
    };
  }

  Category toEntity() => Category(
    id: id,
    name: name,
    type: type,
    description: description,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  CategoryModel copyWith({
    String? id,
    String? name,
    String? type,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? syncStatus,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }
}
