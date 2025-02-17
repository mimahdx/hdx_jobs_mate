import 'package:equatable/equatable.dart';

abstract class JobSearchEvent extends Equatable {
  const JobSearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchJobsEvent extends JobSearchEvent {
  final String query;
  final String location;
  final int page;

  const SearchJobsEvent({
    required this.query,
    required this.location,
    this.page = 1,
  });

  @override
  List<Object> get props => [query, location, page];
}

class LoadMoreJobsEvent extends JobSearchEvent {
  final String query;
  final String location;
  final int page;

  const LoadMoreJobsEvent({
    required this.query,
    required this.location,
    required this.page,
  });

  @override
  List<Object> get props => [query, location, page];
}

class RefreshJobSearchEvent extends JobSearchEvent {
  final String query;
  final String location;

  const RefreshJobSearchEvent({
    required this.query,
    required this.location,
  });

  @override
  List<Object> get props => [query, location];
}

class ClearJobSearchEvent extends JobSearchEvent {
  const ClearJobSearchEvent();

  @override
  List<Object> get props => [];
}

class UpdateSearchFiltersEvent extends JobSearchEvent {
  final String? salary;
  final String? jobType;
  final String? experience;
  final String? postedDate;

  const UpdateSearchFiltersEvent({
    this.salary,
    this.jobType,
    this.experience,
    this.postedDate,
  });

  @override
  List<Object?> get props => [salary, jobType, experience, postedDate];
}