import 'package:equatable/equatable.dart';

abstract class EarningEvent extends Equatable {
  const EarningEvent();

  @override
  List<Object?> get props => [];
}

class GetEarningsEvent extends EarningEvent {
  final DateTime? startDate;
  final DateTime? endDate;
  final String? jobId;

  const GetEarningsEvent({
    this.startDate,
    this.endDate,
    this.jobId,
  });

  @override
  List<Object?> get props => [startDate, endDate, jobId];
}

class GetEarningsByDateRangeEvent extends EarningEvent {
  final DateTime startDate;
  final DateTime endDate;

  const GetEarningsByDateRangeEvent({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object> get props => [startDate, endDate];
}

class GetEarningEvent extends EarningEvent {
  final String id;

  const GetEarningEvent({required this.id});

  @override
  List<Object> get props => [id];
}

class AddEarningEvent extends EarningEvent {
  final String jobId;
  final double amount;
  final DateTime date;
  final String? note;
  final int status;

  const AddEarningEvent({
    required this.jobId,
    required this.amount,
    required this.date,
    this.note,
    required this.status,
  });

  @override
  List<Object?> get props => [jobId, amount, date, note, status];
}

class UpdateEarningEvent extends EarningEvent {
  final String id;
  final String jobId;
  final double amount;
  final DateTime date;
  final String? note;
  final int status;

  const UpdateEarningEvent({
    required this.id,
    required this.jobId,
    required this.amount,
    required this.date,
    this.note,
    required this.status,
  });

  @override
  List<Object?> get props => [id, jobId, amount, date, note, status];
}

class GetDashboardSummaryEvent extends EarningEvent {}