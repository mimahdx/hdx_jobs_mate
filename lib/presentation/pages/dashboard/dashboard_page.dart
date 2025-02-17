import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/job/job_event.dart';
import '../../blocs/job/job_state.dart';
import '../../blocs/earning/earning_bloc.dart';
import '../../blocs/job/job_bloc.dart';
import '../../blocs/earning/earning_event.dart';
import '../../blocs/earning/earning_state.dart';
import '../../blocs/jobs_search/job_search_bloc.dart';
import '../../blocs/jobs_search/job_search_event.dart';
import '../../blocs/jobs_search/job_search_state.dart';
import '../../widgets/dashboard/total_earnings_card.dart';
import '../../widgets/dashboard/recently_added_earnings.dart';
import '../../widgets/dashboard/recently_added_jobs.dart';
import '../earnings/add_earning_page.dart';
import '../jobs/add_job_page.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _refreshData();
    _setupScrollListener();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        final state = context.read<JobSearchBloc>().state;
        if (state is JobSearchLoaded && state.hasMore) {
          context.read<JobSearchBloc>().add(LoadMoreJobsEvent(
            query: state.currentQuery,
            location: state.currentLocation,
            page: state.currentPage + 1,
          ));
        }
      }
    });
  }

  Future<void> _refreshData() async {
    context.read<EarningBloc>().add(GetDashboardSummaryEvent());
    context.read<JobBloc>().add(const GetJobsEvent());
    // Initialize job search for virtual assistant positions
    context.read<JobSearchBloc>().add(SearchJobsEvent(
      query: 'virtual assistant',
      location: 'Philippines',
    ));
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.work_outline,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 24),
            const Text(
              'Start Tracking Your Job Earnings',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Add your first job to begin tracking your freelance income',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () async {
                final result = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const AddJobPage(),
                  ),
                );
                if (result == true && mounted) {
                  _refreshData();
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Job'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobListings() {
    return BlocBuilder<JobSearchBloc, JobSearchState>(
      builder: (context, state) {
        if (state is JobSearchInitial || state is JobSearchLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is JobSearchError) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text('Error: ${state.message}'),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _refreshData,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is JobSearchEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('No jobs found matching your criteria.'),
          );
        }

        if (state is JobSearchLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Available Virtual Assistant Jobs',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (state.hasMore)
                      TextButton(
                        onPressed: () {
                          // Navigate to full job search page
                        },
                        child: const Text('See All'),
                      ),
                  ],
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.jobs.length + (state.hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == state.jobs.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final job = state.jobs[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: InkWell(
                      onTap: () async {
                        final url = Uri.parse(job.url);
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    job.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.bookmark_border),
                                  onPressed: () {
                                    // Implement save job functionality
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              job.company,
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              job.location,
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                            if (job.salary.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text(
                                job.salary,
                                style: TextStyle(
                                  color: Colors.green[700],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HDX Jobs Mate'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              final route = MaterialPageRoute(
                builder: (_) => value == 'earning'
                    ? const AddEarningPage()
                    : const AddJobPage(),
              );
              final result = await Navigator.of(context).push(route);
              if (result == true && mounted) {
                _refreshData();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'earning',
                child: Text('Add Earning'),
              ),
              const PopupMenuItem(
                value: 'job',
                child: Text('Add Job'),
              ),
            ],
            icon: const Icon(Icons.add),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              BlocBuilder<EarningBloc, EarningState>(
                builder: (context, earningState) {
                  return BlocBuilder<JobBloc, JobState>(
                    builder: (context, jobState) {
                      if (earningState is EarningLoading ||
                          jobState is JobLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (earningState is EarningError) {
                        return Center(child: Text(earningState.message));
                      }

                      if (jobState is JobError) {
                        return Center(child: Text(jobState.message));
                      }

                      if (earningState is DashboardSummaryLoaded &&
                          jobState is JobListLoaded) {
                        final summary = earningState.summary;
                        final jobs = jobState.jobs;

                        if (jobs.isEmpty) {
                          return _buildEmptyState();
                        }

                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: TotalEarningsCard(
                                totalEarnings:
                                summary['totalEarnings'] as double,
                                siteSummary: summary['siteSummary']
                                as List<Map<String, dynamic>>,
                              ),
                            ),
                            if (summary['futureEarnings'] != null)
                              RecentlyAddedEarnings(
                                earnings: summary['futureEarnings']
                                as List<Map<String, dynamic>>,
                                jobs: jobs,
                              ),
                            const SizedBox(height: 16),
                            RecentlyAddedJobs(jobs: jobs),
                            const SizedBox(height: 16),
                            _buildJobListings(),
                            const SizedBox(height: 24),
                          ],
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}