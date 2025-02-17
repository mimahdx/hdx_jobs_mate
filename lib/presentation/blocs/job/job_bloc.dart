import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/usecases/job/get_jobs.dart';
import '../../../../domain/usecases/job/get_jobs_by_site.dart';
import '../../../../domain/usecases/job/get_job.dart';
import '../../../../domain/usecases/job/add_job.dart';
import '../../../../domain/usecases/job/update_job.dart';
import '../../../../domain/usecases/job/delete_job.dart';
import 'job_event.dart';
import 'job_state.dart';

class JobBloc extends Bloc<JobEvent, JobState> {
  final GetJobs getJobs;
  final GetJobsBySite getJobsBySite;
  final GetJob getJob;
  final AddJob addJob;
  final UpdateJob updateJob;
  final DeleteJob deleteJob;

  JobBloc({
    required this.getJobs,
    required this.getJobsBySite,
    required this.getJob,
    required this.addJob,
    required this.updateJob,
    required this.deleteJob,
  }) : super(JobInitial()) {
    on<GetJobsEvent>(_onGetJobs);
    on<GetJobsBySiteEvent>(_onGetJobsBySite);
    on<GetJobEvent>(_onGetJob);
    on<AddJobEvent>(_onAddJob);
    on<UpdateJobEvent>(_onUpdateJob);
    on<DeleteJobEvent>(_onDeleteJob);
  }

  Future<void> _onGetJobs(
      GetJobsEvent event,
      Emitter<JobState> emit,
      ) async {
    emit(JobLoading());
    final result = await getJobs(
      site: event.site,
      searchTerm: event.searchTerm,
    );
    result.fold(
          (failure) => emit(JobError(failure.message)),
          (jobs) => emit(JobListLoaded(jobs)),
    );
  }

  Future<void> _onGetJobsBySite(
      GetJobsBySiteEvent event,
      Emitter<JobState> emit,
      ) async {
    emit(JobLoading());
    final result = await getJobsBySite(site: event.site);
    result.fold(
          (failure) => emit(JobError(failure.message)),
          (jobs) => emit(JobListLoaded(jobs)),
    );
  }

  Future<void> _onGetJob(
      GetJobEvent event,
      Emitter<JobState> emit,
      ) async {
    emit(JobLoading());
    final result = await getJob(id: event.id);
    result.fold(
          (failure) => emit(JobError(failure.message)),
          (job) => emit(JobLoaded(job)),
    );
  }

  Future<void> _onAddJob(
      AddJobEvent event,
      Emitter<JobState> emit,
      ) async {
    emit(JobLoading());
    final result = await addJob(
      name: event.name,
      link: event.link,
      site: event.site,
      redirectUrl: event.redirectUrl,
      description: event.description,
      status: event.status
    );
    result.fold(
          (failure) => emit(JobError(failure.message)),
          (job) => emit(JobAdded(job)),
    );
  }

  Future<void> _onUpdateJob(
      UpdateJobEvent event,
      Emitter<JobState> emit,
      ) async {
    emit(JobLoading());
    final result = await updateJob(
      id: event.id,
      name: event.name,
      link: event.link,
      site: event.site,
      redirectUrl: event.redirectUrl,
      description: event.description,
      status: event.status
    );
    result.fold(
          (failure) => emit(JobError(failure.message)),
          (job) => emit(JobUpdated(job)),
    );
  }

  Future<void> _onDeleteJob(
      DeleteJobEvent event,
      Emitter<JobState> emit,
      ) async {
    emit(JobLoading());
    final result = await deleteJob(id: event.id);
    result.fold(
          (failure) => emit(JobError(failure.message)),
          (_) => emit(JobDeleted(event.id)),
    );
  }
}