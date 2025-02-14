import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String id;
  final String name;
  final String type;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Category({
    required this.id,
    required this.name,
    required this.type,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    type,
    description,
    createdAt,
    updatedAt,
  ];
}