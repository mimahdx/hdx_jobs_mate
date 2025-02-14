// lib/presentation/pages/savings/add_saving_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/category.dart';
import '../../blocs/category/category_bloc.dart';
import '../../blocs/category/category_event.dart';
import '../../blocs/category/category_state.dart';
import '../../blocs/saving/saving_bloc.dart';
import '../../blocs/saving/saving_event.dart';
import '../../blocs/saving/saving_state.dart';

class AddSavingPage extends StatefulWidget {
  const AddSavingPage({super.key});

  @override
  State<AddSavingPage> createState() => _AddSavingPageState();
}

class _AddSavingPageState extends State<AddSavingPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  Category? _selectedCategory;

  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(GetCategoryListEvent());
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _showAddCategoryDialog() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    String? selectedType;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Category'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Category Name',
                hintText: 'e.g., Salary, Investments',
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedType,
              decoration: const InputDecoration(
                labelText: 'Type',
              ),
              items: const [
                DropdownMenuItem(value: 'income', child: Text('Income')),
                DropdownMenuItem(value: 'expense', child: Text('Expense')),
                DropdownMenuItem(value: 'savings', child: Text('Savings')),
              ],
              onChanged: (value) {
                selectedType = value;
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (Optional)',
                hintText: 'Add some details about this category',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty && selectedType != null) {
                context.read<CategoryBloc>().add(
                  AddCategoryEvent(
                    name: nameController.text.trim(),
                    type: selectedType!,
                    description: descriptionController.text.trim(),
                  ),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SavingBloc, SavingState>(
          listener: (context, state) {
            if (state is SavingAdded) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Transaction added successfully')),
              );
              Navigator.of(context).pop(true); // Return true on success
            } else if (state is SavingError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
        ),
        BlocListener<CategoryBloc, CategoryState>(
          listener: (context, state) {
            if (state is CategoryAdded) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Category added successfully')),
              );
              context.read<CategoryBloc>().add(GetCategoryListEvent());
            } else if (state is CategoryError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Transaction'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BlocBuilder<CategoryBloc, CategoryState>(
                  builder: (context, state) {
                    if (state is CategoryListLoaded) {
                      if (state.categories.isEmpty) {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                const Text(
                                  'No categories found',
                                  style: TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: _showAddCategoryDialog,
                                  child: const Text('Create First Category'),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return DropdownButtonFormField<Category>(
                        value: _selectedCategory,
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(),
                        ),
                        items: state.categories.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category.name),
                          );
                        }).toList(),
                        onChanged: (Category? newValue) {
                          setState(() {
                            _selectedCategory = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a category';
                          }
                          return null;
                        },
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Amount',
                          border: OutlineInputBorder(),
                          prefixText: '\$ ',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an amount';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      onPressed: () => _selectDate(context),
                      icon: const Icon(Icons.calendar_today),
                    ),
                    Text(
                      '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _noteController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Note (Optional)',
                    border: OutlineInputBorder(),
                    hintText: 'Add a note about this transaction',
                  ),
                ),
                const SizedBox(height: 24),
                BlocBuilder<SavingBloc, SavingState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: state is SavingLoading
                          ? null
                          : () {
                        if (_formKey.currentState?.validate() ?? false) {
                          final amount = double.tryParse(_amountController.text);
                          if (amount != null && _selectedCategory != null) {
                            context.read<SavingBloc>().add(
                              AddSavingEvent(
                                categoryId: _selectedCategory!.id,
                                amount: amount,
                                date: _selectedDate,
                                note: _noteController.text.trim(),
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: state is SavingLoading
                          ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                          : const Text('Save Transaction'),
                    );
                  },
                ),
                const SizedBox(height: 16),
                if (context.watch<CategoryBloc>().state is CategoryListLoaded)
                  TextButton(
                    onPressed: _showAddCategoryDialog,
                    child: const Text('+ Add New Category'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}