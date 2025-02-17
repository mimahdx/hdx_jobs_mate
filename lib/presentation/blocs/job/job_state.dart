import 'package:equatable/equatable.dart';
import '../../../domain/entities/job.dart';

abstract class JobState extends Equatable {
  const JobState();

  @override
  List<Object?> get props => [];
}

class JobInitial extends JobState {}

class JobLoading extends JobState {}

class JobListLoaded extends JobState {
  final List<Job> jobs;

  const JobListLoaded(this.jobs);

  @override
  List<Object> get props => [jobs];
}

class JobLoaded extends JobState {
  final Job job;

  const JobLoaded(this.job);

  @override
  List<Object> get props => [job];
}

class JobAdded extends JobState {
  final Job job;

  const JobAdded(this.job);

  @override
  List<Object> get props => [job];
}

class JobUpdated extends JobState {
  final Job job;

  const JobUpdated(this.job);

  @override
  List<Object> get props => [job];
}

class JobDeleted extends JobState {
  final String id;

  const JobDeleted(this.id);

  @override
  List<Object> get props => [id];
}

class JobError extends JobState {
  final String message;

  const JobError(this.message);

  @override
  List<Object> get props => [message];
}