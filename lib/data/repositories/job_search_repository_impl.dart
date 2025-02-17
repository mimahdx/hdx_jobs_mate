import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/errors/exceptions.dart';
import '../../core/network/network_info.dart';
import '../../domain/repositories/job_search_repository.dart';
import '../../domain/entities/job_listing.dart';

class JobSearchRepositoryImpl implements JobSearchRepository {
  final http.Client client;
  final SharedPreferences sharedPreferences;
  final NetworkInfo networkInfo;

  static const String baseUrl = 'google.serper.dev';
  static const String apiPath = '/search';
  static const String savedJobsKey = 'saved_jobs';
  static const String cacheKey = 'cached_search_results';
  static const String lastFetchKey = 'last_fetch_time';
  static const String apiKey = 'dbf12b9632650deb2c6569d8e310a4e1c0f0b5a1';
  static const Duration cacheDuration = Duration(hours: 12);

  JobSearchRepositoryImpl({
    required this.client,
    required this.sharedPreferences,
    required this.networkInfo,
  });

  @override
  Future<List<JobListing>> searchJobs({
    required String query,
    required String location,
    int page = 1,
    Map<String, String?>? filters,
  }) async {
    if (!await networkInfo.isConnected) {
      throw ServerException('No internet connection');
    }

    try {
      // Check if we have cached results and if they're still valid
      final lastFetchTimeStr = sharedPreferences.getString(lastFetchKey);
      if (lastFetchTimeStr != null) {
        final lastFetchTime = DateTime.parse(lastFetchTimeStr);
        final currentTime = DateTime.now();
        final difference = currentTime.difference(lastFetchTime);

        if (difference < cacheDuration) {
          print('Using cached results (expires in ${cacheDuration.inMinutes - difference.inMinutes} minutes)');
          final cachedData = sharedPreferences.getString(cacheKey);
          if (cachedData != null) {
            final List<dynamic> decoded = json.decode(cachedData);
            return decoded
                .map((job) => JobListing.fromJson(job))
                .toList();
          }
        }
      }

      // If we don't have valid cached results, make the API call
      print('Cache expired or not found, fetching new results...');
      final uri = Uri.https(baseUrl, apiPath);

      // Print equivalent cURL command for debugging
      print('cURL command:');
      print('curl -X POST \'${uri.toString()}\' \\');
      print('-H \'X-API-KEY: $apiKey\' \\');
      print('-H \'Content-Type: application/json\' \\');
      print('-d \'{"q": "$query virtual assistant jobs in $location", "gl": "ph"}\'');

      final response = await client.post(
        uri,
        headers: {
          'X-API-KEY': apiKey,
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'q': '$query virtual assistant jobs in $location',
          'gl': 'ph',
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final organic = data['organic'] as List? ?? [];

        final jobs = organic.map((result) {
          final title = result['title'] ?? '';
          final link = result['link'] ?? '';
          final snippet = result['snippet'] ?? '';
          final date = _extractDate(snippet) ?? DateTime.now();

          return JobListing(
            id: link,
            title: _cleanTitle(title),
            company: _extractCompany(title, snippet),
            location: location,
            salary: _extractSalary(snippet) ?? '',
            postedDate: date,
            description: snippet,
            url: link,
            source: 'Serper',
          );
        }).where((job) =>
        job.title.isNotEmpty &&
            job.url.isNotEmpty &&
            !job.title.toLowerCase().contains('similar')
        ).toList();

        // Cache the results
        await _cacheResults(jobs);

        return jobs;
      } else {
        // If API call fails, try to use cached results even if expired
        print('API call failed, trying to use cached results...');
        final cachedData = sharedPreferences.getString(cacheKey);
        if (cachedData != null) {
          final List<dynamic> decoded = json.decode(cachedData);
          return decoded
              .map((job) => JobListing.fromJson(job))
              .toList();
        }
        throw ServerException('Failed to load jobs: ${response.statusCode}');
      }
    } catch (e) {
      // On error, try to use cached results even if expired
      print('Error occurred, trying to use cached results...');
      final cachedData = sharedPreferences.getString(cacheKey);
      if (cachedData != null) {
        final List<dynamic> decoded = json.decode(cachedData);
        return decoded
            .map((job) => JobListing.fromJson(job))
            .toList();
      }
      throw ServerException('Error fetching jobs: $e');
    }
  }

  Future<void> _cacheResults(List<JobListing> jobs) async {
    try {
      // Save the current time
      await sharedPreferences.setString(
        lastFetchKey,
        DateTime.now().toIso8601String(),
      );

      // Save the jobs
      await sharedPreferences.setString(
        cacheKey,
        json.encode(jobs.map((job) => job.toJson()).toList()),
      );

      print('Results cached successfully');
    } catch (e) {
      print('Failed to cache results: $e');
    }
  }

  String _cleanTitle(String title) {
    // Remove HTML tags and special characters
    return title
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&quot;', '"')
        .replaceAll('&amp;', '&')
        .trim();
  }

  String _extractCompany(String title, String snippet) {
    // Try to extract company name from title or snippet
    final companyRegex = RegExp(r'at\s+([^|,-]+)');
    final match = companyRegex.firstMatch(title) ?? companyRegex.firstMatch(snippet);
    return match?.group(1)?.trim() ?? 'Unknown Company';
  }

  String? _extractSalary(String snippet) {
    // Try to extract salary information from snippet
    final salaryRegex = RegExp(r'\b(?:PHP|₱|Php)\s*[\d,]+(?:\s*-\s*(?:PHP|₱|Php)\s*[\d,]+)?');
    final match = salaryRegex.firstMatch(snippet);
    return match?.group(0);
  }

  DateTime? _extractDate(String snippet) {
    // Try to extract date from snippet
    final dateRegex = RegExp(r'\b\d{1,2}\s+(?:days?|hours?|weeks?)\s+ago\b');
    final match = dateRegex.firstMatch(snippet);
    if (match != null) {
      final dateText = match.group(0) ?? '';
      final now = DateTime.now();

      if (dateText.contains('hour')) {
        final hours = int.tryParse(dateText.split(' ')[0]) ?? 0;
        return now.subtract(Duration(hours: hours));
      } else if (dateText.contains('day')) {
        final days = int.tryParse(dateText.split(' ')[0]) ?? 0;
        return now.subtract(Duration(days: days));
      } else if (dateText.contains('week')) {
        final weeks = int.tryParse(dateText.split(' ')[0]) ?? 0;
        return now.subtract(Duration(days: weeks * 7));
      }
    }
    return null;
  }

  @override
  Future<JobListing> getJobDetails(String id) async {
    if (!await networkInfo.isConnected) {
      throw ServerException('No internet connection');
    }

    try {
      // For Serper, we're using the URL as the ID
      // We could potentially scrape the job page for more details
      final savedJobs = await getSavedJobs();
      final savedJob = savedJobs.firstWhere(
            (job) => job.id == id,
        orElse: () => throw NotFoundException('Job not found'),
      );
      return savedJob;
    } catch (e) {
      throw ServerException('Error fetching job details: $e');
    }
  }

  @override
  Future<void> saveJob(String jobId) async {
    try {
      final savedJobs = await getSavedJobs();
      if (!savedJobs.any((job) => job.id == jobId)) {
        final jobDetails = await getJobDetails(jobId);
        final encodedJobs = json.encode([
          ...savedJobs.map((j) => j.toJson()),
          jobDetails.toJson(),
        ]);
        await sharedPreferences.setString(savedJobsKey, encodedJobs);
      }
    } catch (e) {
      throw CacheException('Failed to save job: $e');
    }
  }

  @override
  Future<void> unsaveJob(String jobId) async {
    try {
      final savedJobs = await getSavedJobs();
      final updatedJobs = savedJobs.where((job) => job.id != jobId).toList();
      final encodedJobs = json.encode(updatedJobs.map((j) => j.toJson()).toList());
      await sharedPreferences.setString(savedJobsKey, encodedJobs);
    } catch (e) {
      throw CacheException('Failed to unsave job: $e');
    }
  }

  @override
  Future<List<JobListing>> getSavedJobs() async {
    try {
      final savedJobsString = sharedPreferences.getString(savedJobsKey);
      if (savedJobsString == null) return [];

      final savedJobsList = json.decode(savedJobsString) as List;
      return savedJobsList
          .map((jobJson) => JobListing.fromJson(jobJson as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw CacheException('Failed to get saved jobs: $e');
    }
  }

  @override
  Future<void> trackJobView(String jobId) async {
    try {
      final viewedJobs = sharedPreferences.getStringList('viewed_jobs') ?? [];
      if (!viewedJobs.contains(jobId)) {
        viewedJobs.add(jobId);
        await sharedPreferences.setStringList('viewed_jobs', viewedJobs);
      }
    } catch (e) {
      print('Failed to track job view: $e');
    }
  }
}