import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../domain/entities/job.dart';

class RecentlyAddedJobs extends StatelessWidget {
  final List<Job> jobs;

  const RecentlyAddedJobs({
    super.key,
    required this.jobs,
  });

  Future<void> _openJobLink(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    }

    return '${date.day}/${date.month}/${date.year}';
  }

  Color _getSiteColor(String site) {
    switch (site.toLowerCase()) {
      case 'upwork':
        return Colors.green;
      case 'fiverr':
        return Colors.green[700]!;
      case 'freelancer':
        return Colors.blue;
      case 'toptal':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final recentJobs = jobs.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'Recent Jobs',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: recentJobs.length,
          itemBuilder: (context, index) {
            final job = recentJobs[index];

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: _getSiteColor(job.site).withValues(alpha: 0.1),
                  child: Text(
                    job.site[0].toUpperCase(),
                    style: TextStyle(
                      color: _getSiteColor(job.site),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  job.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(job.site),
                    Text(
                      _formatDate(job.createdAt),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.open_in_new),
                  onPressed: () => _openJobLink(job.link),
                  tooltip: 'Open job link',
                ),
                onTap: () {
                  // Show job details in a bottom sheet or new page
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            job.name,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Platform: ${job.site}',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          if (job.description != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              job.description!,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => _openJobLink(job.link),
                            child: const Text('Open Job Link'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}