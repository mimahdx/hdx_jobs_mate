
// lib/presentation/blocs/category/category_state.dart
import 'package:equatable/equatable.dart';
import '../../../domain/entities/category.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object?> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryListLoaded extends CategoryState {
  final List<Category> categories;

  const CategoryListLoaded(this.categories);

  @override
  List<Object> get props => [categories];
}

class CategoryAdded extends CategoryState {
  final Category category;

  const CategoryAdded(this.category);

  @override
  List<Object> get props => [category];
}

class CategoryUpdated extends CategoryState {
  final Category category;

  const CategoryUpdated(this.category);

  @override
  List<Object> get props => [category];
}

class CategoryDeleted extends CategoryState {
  final String id;

  const CategoryDeleted(this.id);

  @override
  List<Object> get props => [id];
}

class CategoryError extends CategoryState {
  final String message;

  const CategoryError(this.message);

  @override
  List<Object> get props => [message];
}