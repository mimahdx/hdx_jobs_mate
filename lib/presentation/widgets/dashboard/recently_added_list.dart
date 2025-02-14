import 'package:flutter/material.dart';
import '../../../domain/entities/saving.dart';
import '../../../domain/entities/category.dart';

class RecentlyAddedList extends StatelessWidget {
  final List<Saving> transactions;
  final List<Category> categories;

  const RecentlyAddedList({
    super.key,
    required this.transactions,
    required this.categories,
  });

  String _getCategoryName(String categoryId) {
    return categories
        .firstWhere((cat) => cat.id == categoryId,
        orElse: () => Category(
            id: '',
            name: 'Unknown',
            type: '',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now()))
        .name;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Recently Added',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final transaction = transactions[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Text(
                  _getCategoryName(transaction.categoryId)[0],
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
              title: Text(_getCategoryName(transaction.categoryId)),
              subtitle: Text(
                transaction.date.toString().split(' ')[0],
              ),
              trailing: Text(
                '\$${transaction.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: transaction.amount >= 0
                      ? Colors.green
                      : Colors.red,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}