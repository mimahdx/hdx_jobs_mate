import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/job/job_bloc.dart';
import '../../blocs/job/job_event.dart';
import '../../blocs/job/job_state.dart';
import '../../blocs/earning/earning_bloc.dart';
import '../../blocs/earning/earning_event.dart';
import '../../blocs/earning/earning_state.dart';
import '../../../domain/entities/job.dart';
import '../../widgets/common/loading_overlay.dart';

class AddEarningPage extends StatefulWidget {
  const AddEarningPage({super.key});

  @override
  State<AddEarningPage> createState() => _AddEarningPageState();
}

class _AddEarningPageState extends State<AddEarningPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedJobId;
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    context.read<JobBloc>().add(const GetJobsEvent());
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate() || _selectedJobId == null) {
      return;
    }

    setState(() => _isLoading = true);

    final amount = double.parse(_amountController.text);

    context.read<EarningBloc>().add(
      AddEarningEvent(
        jobId: _selectedJobId!,
        amount: amount,
        date: _selectedDate,
        note: _noteController.text.isEmpty ? null : _noteController.text,
        status: 0
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Record Earning'),
          ),
          body: BlocListener<EarningBloc, EarningState>(
            listener: (context, state) {
              if (state is EarningError) {
                setState(() => _isLoading = false);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
              if (state is EarningAdded) {
                Navigator.of(context).pop(true);
              }
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    BlocBuilder<JobBloc, JobState>(
                      builder: (context, state) {
                        if (state is JobLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (state is JobError) {
                          return Center(
                            child: Text(state.message),
                          );
                        }

                        if (state is JobListLoaded) {
                          final jobs = state.jobs;

                          if (jobs.isEmpty) {
                            return const Card(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  'Please add a job first before recording earnings.',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          }

                          return DropdownButtonFormField<String>(
                            value: _selectedJobId,
                            decoration: const InputDecoration(
                              labelText: 'Select Job',
                              border: OutlineInputBorder(),
                            ),
                            items: jobs.map((Job job) {
                              return DropdownMenuItem<String>(
                                value: job.id,
                                child: Text('${job.name} (${job.site})'),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                _selectedJobId = value;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a job';
                              }
                              return null;
                            },
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _amountController,
                      decoration: const InputDecoration(
                        labelText: 'Amount',
                        border: OutlineInputBorder(),
                        prefixText: '\$',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an amount';
                        }
                        final amount = double.tryParse(value);
                        if (amount == null || amount <= 0) {
                          return 'Please enter a valid amount';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: _selectDate,
                      child: AbsorbPointer(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Date',
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          controller: TextEditingController(
                            text: _formatDate(_selectedDate),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _noteController,
                      decoration: const InputDecoration(
                        labelText: 'Note (Optional)',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('Save Earning'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (_isLoading) const LoadingOverlay(),
      ],
    );
  }
}