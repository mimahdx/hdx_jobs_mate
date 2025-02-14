import 'package:equatable/equatable.dart';
import '../../../domain/entities/saving.dart';

abstract class SavingState extends Equatable {
  const SavingState();

  @override
  List<Object?> get props => [];
}

class SavingInitial extends SavingState {}

class SavingLoading extends SavingState {}

class SavingListLoaded extends SavingState {
  final List<Saving> savings;

  const SavingListLoaded(this.savings);

  @override
  List<Object> get props => [savings];
}

class SavingAdded extends SavingState {
  final Saving saving;

  const SavingAdded(this.saving);

  @override
  List<Object> get props => [saving];
}

class SavingUpdated extends SavingState {
  final Saving saving;

  const SavingUpdated(this.saving);

  @override
  List<Object> get props => [saving];
}

class SavingError extends SavingState {
  final String message;

  const SavingError(this.message);

  @override
  List<Object> get props => [message];
}