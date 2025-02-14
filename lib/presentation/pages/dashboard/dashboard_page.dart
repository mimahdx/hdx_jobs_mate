// lib/presentation/pages/dashboard/dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/category/category_event.dart';
import '../../blocs/category/category_state.dart';
import '../../blocs/saving/saving_bloc.dart';
import '../../blocs/category/category_bloc.dart';
import '../../blocs/saving/saving_event.dart';
import '../../blocs/saving/saving_state.dart';
import '../../widgets/dashboard/total_balance_card.dart';
import '../../widgets/dashboard/recently_added_list.dart';
import '../savings/add_saving_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _refreshData() async {
    context.read<SavingBloc>().add(GetSavingListEvent());
    context.read<CategoryBloc>().add(GetCategoryListEvent());
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.savings_outlined,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 24),
            const Text(
              'Start Tracking Your Finances',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Record your first transaction to begin tracking your financial journey',
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
                    builder: (_) => const AddSavingPage(),
                  ),
                );
                if (result == true && mounted) {
                  _refreshData();
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('Record Transaction'),
            ),
            const SizedBox(height: 24),
            const Text(
              'Your data is stored only on your device and can be synced across your devices with your permission.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const AddSavingPage(),
                ),
              );
              if (result == true && mounted) {
                _refreshData();
              }
            },
          ),
          const SizedBox(width: 8), // Add some padding at the end
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: BlocBuilder<SavingBloc, SavingState>(
          builder: (context, savingState) {
            return BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, categoryState) {
                if (savingState is SavingLoading || categoryState is CategoryLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (savingState is SavingError) {
                  return Center(child: Text(savingState.message));
                }

                if (categoryState is CategoryError) {
                  return Center(child: Text(categoryState.message));
                }

                if (savingState is SavingListLoaded && categoryState is CategoryListLoaded) {
                  final savings = savingState.savings;
                  final categories = categoryState.categories;

                  if (savings.isEmpty) {
                    return _buildEmptyState();
                  }

                  final totalBalance = savings.fold<double>(
                    0,
                        (sum, saving) => sum + saving.amount,
                  );

                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TotalBalanceCard(totalBalance: totalBalance),
                        ),
                        RecentlyAddedList(
                          transactions: savings,
                          categories: categories,
                        ),
                      ],
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            );
          },
        ),
      ),
    );
  }
}