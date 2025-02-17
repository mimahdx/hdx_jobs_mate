import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../domain/entities/job_listing.dart';

class CareerJetApiService {
  static const String baseUrl = 'api.careerjet.com';
  static const String rapidApiKey = 'YOUR_RAPID_API_KEY'; // Much cheaper plan available
  static const String rapidApiHost = 'careerjet-api.p.rapidapi.com';

  Future<List<JobListing>> searchJobs({
    required String query,
    required String location,
    int page = 1,
  }) async {
    try {
      final queryParams = {
        'keywords': query,
        'location': location,
        'page': page.toString(),
        'contracttype': 'PERMANENT',
        'contractperiod': 'FULLTIME',
      };

      final uri = Uri.https(baseUrl, '/search', queryParams);

      final response = await http.get(
        uri,
        headers: {
          'X-RapidAPI-Key': rapidApiKey,
          'X-RapidAPI-Host': rapidApiHost,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final jobs = data['jobs'] as List<dynamic>;

        return jobs.map<JobListing>((job) {
          return JobListing(
            id: job['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
            title: job['title'] ?? 'No Title',
            company: job['company'] ?? 'Unknown Company',
            location: job['locations'] ?? 'Location not specified',
            salary: job['salary'] ?? 'Salary not specified',
            postedDate: DateTime.parse(job['date']),
            description: job['description'] ?? '',
            url: job['url'] ?? '', source: job['source'] ?? '',
          );
        }).toList();
      } else {
        throw Exception('Failed to load jobs: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching jobs: $e');
    }
  }
}

// Extension method to help with error handling
extension JobListingExtension on List<JobListing> {
  List<JobListing> filterValidListings() {
    return where((job) =>
    job.title.isNotEmpty &&
        job.company.isNotEmpty &&
        job.url.isNotEmpty
    ).toList();
  }
}

// Cache manager to reduce API calls
class JobCacheManager {
  static final Map<String, CachedJobSearch> _cache = {};

  static Future<List<JobListing>> getJobs({
    required String query,
    required String location,
    required Future<List<JobListing>> Function() fetcher,
  }) async {
    final key = '${query}_${location}';
    final now = DateTime.now();

    if (_cache.containsKey(key)) {
      final cached = _cache[key]!;
      if (now.difference(cached.timestamp) < const Duration(minutes: 15)) {
        return cached.jobs;
      }
    }

    final jobs = await fetcher();
    _cache[key] = CachedJobSearch(
      jobs: jobs,
      timestamp: now,
    );

    return jobs;
  }
}

class CachedJobSearch {
  final List<JobListing> jobs;
  final DateTime timestamp;

  CachedJobSearch({
    required this.jobs,
    required this.timestamp,
  });
}