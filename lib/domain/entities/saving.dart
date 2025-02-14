import 'package:equatable/equatable.dart';

class Saving extends Equatable {
  final String id;
  final String categoryId;
  final double amount;
  final DateTime date;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Saving({
    required this.id,
    required this.categoryId,
    required this.amount,
    required this.date,
    this.note,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    categoryId,
    amount,
    date,
    note,
    createdAt,
    updatedAt,
  ];
}