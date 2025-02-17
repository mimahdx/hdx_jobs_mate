import '../entities/job_listing.dart';

abstract class JobSearchRepository {
  Future<List<JobListing>> searchJobs({
    required String query,
    required String location,
    int page = 1,
    Map<String, String?>? filters,
  });

  Future<JobListing> getJobDetails(String id);
  Future<void> saveJob(String jobId);
  Future<void> unsaveJob(String jobId);
  Future<List<JobListing>> getSavedJobs();
  Future<void> trackJobView(String jobId);
}