import 'package:flutter/material.dart';
import '../../../domain/entities/job.dart';
import '../../../core/utils/currency_formatter.dart';

class RecentlyAddedEarnings extends StatelessWidget {
  final List<Map<String, dynamic>> earnings;
  final List<Job> jobs;

  const RecentlyAddedEarnings({
    super.key,
    required this.earnings,
    required this.jobs,
  });

  String _getJobName(String jobId) {
    final job = jobs.firstWhere(
          (job) => job.id == jobId,
      orElse: () => Job(
        id: '',
        name: 'Unknown Job',
        link: '',
        site: 'Unknown',
        status: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
    return '${job.name} (${job.site})';
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'Recent Earnings',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: earnings.length > 5 ? 5 : earnings.length,
          itemBuilder: (context, index) {
            final earning = earnings[index];
            final date = DateTime.fromMillisecondsSinceEpoch(earning['date'] as int);

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  child: const Icon(Icons.attach_money),
                ),
                title: Text(_getJobName(earning['job_id'] as String)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_formatDate(date)),
                    if (earning['note'] != null)
                      Text(
                        earning['note'] as String,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
                trailing: Text(
                  CurrencyFormatter.format(earning['amount'] as double),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}