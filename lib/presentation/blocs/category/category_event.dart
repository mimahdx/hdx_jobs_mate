import 'package:equatable/equatable.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

class GetCategoryListEvent extends CategoryEvent {}

class AddCategoryEvent extends CategoryEvent {
  final String name;
  final String type;
  final String? description;

  const AddCategoryEvent({
    required this.name,
    required this.type,
    this.description,
  });

  @override
  List<Object?> get props => [name, type, description];
}

class UpdateCategoryEvent extends CategoryEvent {
  final String id;
  final String name;
  final String type;
  final String? description;

  const UpdateCategoryEvent({
    required this.id,
    required this.name,
    required this.type,
    this.description,
  });

  @override
  List<Object?> get props => [id, name, type, description];
}

class DeleteCategoryEvent extends CategoryEvent {
  final String id;

  const DeleteCategoryEvent({required this.id});

  @override
  List<Object> get props => [id];
}
