import 'package:equatable/equatable.dart';

abstract class SavingEvent extends Equatable {
  const SavingEvent();

  @override
  List<Object?> get props => [];
}

class GetSavingListEvent extends SavingEvent {}

class AddSavingEvent extends SavingEvent {
  final String categoryId;
  final double amount;
  final DateTime date;
  final String? note;

  const AddSavingEvent({
    required this.categoryId,
    required this.amount,
    required this.date,
    this.note,
  });

  @override
  List<Object?> get props => [categoryId, amount, date, note];
}

class UpdateSavingEvent extends SavingEvent {
  final String id;
  final String categoryId;
  final double amount;
  final DateTime date;
  final String? note;

  const UpdateSavingEvent({
    required this.id,
    required this.categoryId,
    required this.amount,
    required this.date,
    this.note,
  });

  @override
  List<Object?> get props => [id, categoryId, amount, date, note];
}
