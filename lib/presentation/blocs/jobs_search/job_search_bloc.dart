import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/job_search_repository.dart';
import 'job_search_event.dart';
import 'job_search_state.dart';

class JobSearchBloc extends Bloc<JobSearchEvent, JobSearchState> {
  final JobSearchRepository repository;
  static var pageSize = 20;

  JobSearchBloc({
    required this.repository,
  }) : super(JobSearchInitial()) {
    on<SearchJobsEvent>(_onSearchJobs);
    on<LoadMoreJobsEvent>(_onLoadMoreJobs);
    on<RefreshJobSearchEvent>(_onRefreshJobSearch);
    on<ClearJobSearchEvent>(_onClearJobSearch);
    on<UpdateSearchFiltersEvent>(_onUpdateSearchFilters);
  }

  Future<void> _onSearchJobs(
      SearchJobsEvent event,
      Emitter<JobSearchState> emit,
      ) async {
    try {
      emit(JobSearchLoading());

      final result = await repository.searchJobs(
        query: event.query,
        location: event.location,
        page: event.page,
      );

      if (result.isEmpty) {
        emit(JobSearchEmpty(
          query: event.query,
          location: event.location,
        ));
        return;
      }

      emit(JobSearchLoaded(
        jobs: result,
        hasMore: result.length >= pageSize,
        currentPage: event.page,
        currentQuery: event.query,
        currentLocation: event.location,
      ));
    } catch (e) {
      emit(JobSearchError(e.toString()));
    }
  }

  Future<void> _onLoadMoreJobs(
      LoadMoreJobsEvent event,
      Emitter<JobSearchState> emit,
      ) async {
    try {
      if (state is JobSearchLoaded) {
        final currentState = state as JobSearchLoaded;

        emit(JobSearchLoadingMore(
          currentJobs: currentState.jobs,
          currentQuery: currentState.currentQuery,
          currentLocation: currentState.currentLocation,
        ));

        final newJobs = await repository.searchJobs(
          query: event.query,
          location: event.location,
          page: event.page,
          filters: currentState.filters,
        );

        emit(currentState.copyWith(
          jobs: [...currentState.jobs, ...newJobs],
          hasMore: newJobs.length >= pageSize,
          currentPage: event.page,
        ));
      }
    } catch (e) {
      emit(JobSearchError(
        e.toString(),
        currentJobs: state is JobSearchLoaded
            ? (state as JobSearchLoaded).jobs
            : null,
      ));
    }
  }

  Future<void> _onRefreshJobSearch(
      RefreshJobSearchEvent event,
      Emitter<JobSearchState> emit,
      ) async {
    try {
      if (state is JobSearchLoaded) {
        final currentState = state as JobSearchLoaded;
        emit(JobSearchRefreshing(currentState.jobs));

        final freshJobs = await repository.searchJobs(
          query: event.query,
          location: event.location,
          page: 1,
          filters: currentState.filters,
        );

        if (freshJobs.isEmpty) {
          emit(JobSearchEmpty(
            query: event.query,
            location: event.location,
          ));
          return;
        }

        emit(JobSearchLoaded(
          jobs: freshJobs,
          hasMore: freshJobs.length >= pageSize,
          currentPage: 1,
          currentQuery: event.query,
          currentLocation: event.location,
          filters: currentState.filters,
        ));
      } else {
        add(SearchJobsEvent(
          query: event.query,
          location: event.location,
        ));
      }
    } catch (e) {
      emit(JobSearchError(
        e.toString(),
        currentJobs: state is JobSearchLoaded
            ? (state as JobSearchLoaded).jobs
            : null,
      ));
    }
  }

  void _onClearJobSearch(
      ClearJobSearchEvent event,
      Emitter<JobSearchState> emit,
      ) {
    emit(JobSearchInitial());
  }

  Future<void> _onUpdateSearchFilters(
      UpdateSearchFiltersEvent event,
      Emitter<JobSearchState> emit,
      ) async {
    if (state is JobSearchLoaded) {
      final currentState = state as JobSearchLoaded;

      final newFilters = Map<String, String?>.from(currentState.filters);
      if (event.salary != null) newFilters['salary'] = event.salary;
      if (event.jobType != null) newFilters['jobType'] = event.jobType;
      if (event.experience != null) newFilters['experience'] = event.experience;
      if (event.postedDate != null) newFilters['postedDate'] = event.postedDate;

      try {
        emit(JobSearchLoading());

        final jobs = await repository.searchJobs(
          query: currentState.currentQuery,
          location: currentState.currentLocation,
          page: 1,
          filters: newFilters,
        );

        if (jobs.isEmpty) {
          emit(JobSearchEmpty(
            query: currentState.currentQuery,
            location: currentState.currentLocation,
          ));
          return;
        }

        emit(JobSearchLoaded(
          jobs: jobs,
          hasMore: jobs.length >= pageSize,
          currentPage: 1,
          currentQuery: currentState.currentQuery,
          currentLocation: currentState.currentLocation,
          filters: newFilters,
        ));
      } catch (e) {
        emit(JobSearchError(e.toString()));
      }
    }
  }
}