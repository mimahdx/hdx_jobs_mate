import 'package:equatable/equatable.dart';

class Earning extends Equatable {
  final String id;
  final String jobId;
  final double amount;
  final DateTime date;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int status;

  const Earning({
    required this.id,
    required this.jobId,
    required this.amount,
    required this.date,
    this.note,
    required this.status,
    required this.createdAt,
    required this.updatedAt
  });

  @override
  List<Object?> get props => [
    id,
    jobId,
    amount,
    date,
    note,
    status,
    createdAt,
    updatedAt,
  ];
}