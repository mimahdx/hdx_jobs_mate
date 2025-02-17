import 'package:equatable/equatable.dart';
import '../../../domain/entities/earning.dart';

abstract class EarningState extends Equatable {
  const EarningState();

  @override
  List<Object?> get props => [];
}

class EarningInitial extends EarningState {}

class EarningLoading extends EarningState {}

class EarningListLoaded extends EarningState {
  final List<Earning> earnings;

  const EarningListLoaded(this.earnings);

  @override
  List<Object> get props => [earnings];
}

class EarningLoaded extends EarningState {
  final Earning earning;

  const EarningLoaded(this.earning);

  @override
  List<Object> get props => [earning];
}

class EarningAdded extends EarningState {
  final Earning earning;

  const EarningAdded(this.earning);

  @override
  List<Object> get props => [earning];
}

class EarningUpdated extends EarningState {
  final Earning earning;

  const EarningUpdated(this.earning);

  @override
  List<Object> get props => [earning];
}

class DashboardSummaryLoaded extends EarningState {
  final Map<String, dynamic> summary;

  const DashboardSummaryLoaded(this.summary);

  @override
  List<Object> get props => [summary];
}

class EarningError extends EarningState {
  final String message;

  const EarningError(this.message);

  @override
  List<Object> get props => [message];
}