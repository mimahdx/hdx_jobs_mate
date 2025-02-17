import 'package:equatable/equatable.dart';
import '../../../domain/entities/job_listing.dart';

abstract class JobSearchState extends Equatable {
  const JobSearchState();

  @override
  List<Object?> get props => [];
}

class JobSearchInitial extends JobSearchState {}

class JobSearchLoading extends JobSearchState {}

class JobSearchLoaded extends JobSearchState {
  final List<JobListing> jobs;
  final bool hasMore;
  final int currentPage;
  final String currentQuery;
  final String currentLocation;
  final Map<String, String?> filters;

  const JobSearchLoaded({
    required this.jobs,
    required this.hasMore,
    required this.currentPage,
    required this.currentQuery,
    required this.currentLocation,
    this.filters = const {},
  });

  JobSearchLoaded copyWith({
    List<JobListing>? jobs,
    bool? hasMore,
    int? currentPage,
    String? currentQuery,
    String? currentLocation,
    Map<String, String?>? filters,
  }) {
    return JobSearchLoaded(
      jobs: jobs ?? this.jobs,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      currentQuery: currentQuery ?? this.currentQuery,
      currentLocation: currentLocation ?? this.currentLocation,
      filters: filters ?? this.filters,
    );
  }

  @override
  List<Object?> get props => [
    jobs,
    hasMore,
    currentPage,
    currentQuery,
    currentLocation,
    filters,
  ];
}

class JobSearchLoadingMore extends JobSearchState {
  final List<JobListing> currentJobs;
  final String currentQuery;
  final String currentLocation;

  const JobSearchLoadingMore({
    required this.currentJobs,
    required this.currentQuery,
    required this.currentLocation,
  });

  @override
  List<Object> get props => [currentJobs, currentQuery, currentLocation];
}

class JobSearchRefreshing extends JobSearchState {
  final List<JobListing> currentJobs;

  const JobSearchRefreshing(this.currentJobs);

  @override
  List<Object> get props => [currentJobs];
}

class JobSearchError extends JobSearchState {
  final String message;
  final List<JobListing>? currentJobs;

  const JobSearchError(this.message, {this.currentJobs});

  @override
  List<Object?> get props => [message, currentJobs];
}

class JobSearchEmpty extends JobSearchState {
  final String query;
  final String location;

  const JobSearchEmpty({
    required this.query,
    required this.location,
  });

  @override
  List<Object> get props => [query, location];
}