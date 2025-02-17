import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/job/job_bloc.dart';
import '../../blocs/job/job_event.dart';
import '../../blocs/job/job_state.dart';
import '../../widgets/common/loading_overlay.dart';

class AddJobPage extends StatefulWidget {
  const AddJobPage({super.key});

  @override
  State<AddJobPage> createState() => _AddJobPageState();
}

class _AddJobPageState extends State<AddJobPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _linkController = TextEditingController();
  final _redirectUrlController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _customPlatformController = TextEditingController();
  String? _selectedSite;
  int _selectedStatus = 0;
  bool _isLoading = false;

  // Common freelance platforms
  final List<String> _platforms = [
    'Upwork',
    'Fiverr',
    'Freelancer',
    'Toptal',
    'PeoplePerHour',
    'Other'
  ];

  // Job status map with descriptions
  final Map<int, String> _jobStatuses = {
    0: 'Saved',
    1: 'Applying',
    2: 'Interview',
    3: 'Ongoing',
    4: 'Ended',
    5: 'Rejected by Me',
    6: 'Rejected by Employer',
    7: 'Offer Received',
    8: 'Withdrawn',
    9: 'No Response',
    10: 'Position Filled'
  };

  @override
  void dispose() {
    _nameController.dispose();
    _linkController.dispose();
    _redirectUrlController.dispose();
    _descriptionController.dispose();
    _customPlatformController.dispose();
    super.dispose();
  }

  bool _isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.isAbsolute;
    } catch (e) {
      return false;
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    // Use custom platform value if "Other" is selected
    final platform = _selectedSite == 'Other'
        ? _customPlatformController.text
        : _selectedSite!;

    context.read<JobBloc>().add(
      AddJobEvent(
        name: _nameController.text,
        link: _linkController.text,
        site: platform,
        status: _selectedStatus,
        redirectUrl: _redirectUrlController.text.isEmpty
            ? null
            : _redirectUrlController.text,
        description: _descriptionController.text.isEmpty
            ? null
            : _descriptionController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<JobBloc, JobState>(
      listener: (context, state) {
        if (state is JobError) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
        if (state is JobAdded) {
          Navigator.of(context).pop(true);
        }
      },
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: const Text('Add New Job'),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Job Title',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.work),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a job title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedSite,
                      decoration: const InputDecoration(
                        labelText: 'Platform',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.business),
                      ),
                      items: _platforms.map((platform) {
                        return DropdownMenuItem(
                          value: platform,
                          child: Text(platform),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedSite = value;
                          // Clear custom platform when switching away from "Other"
                          if (value != 'Other') {
                            _customPlatformController.clear();
                          }
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a platform';
                        }
                        return null;
                      },
                    ),
                    if (_selectedSite == 'Other') ...[
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _customPlatformController,
                        decoration: const InputDecoration(
                          labelText: 'Enter Platform Name',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.edit),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the platform name';
                          }
                          return null;
                        },
                      ),
                    ],
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      value: _selectedStatus,
                      decoration: const InputDecoration(
                        labelText: 'Status',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.timeline),
                      ),
                      items: _jobStatuses.entries.map((entry) {
                        return DropdownMenuItem(
                          value: entry.key,
                          child: Text(entry.value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedStatus = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _linkController,
                      decoration: const InputDecoration(
                        labelText: 'Job URL',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.link),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the job URL';
                        }
                        if (!_isValidUrl(value)) {
                          return 'Please enter a valid URL';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _redirectUrlController,
                      decoration: const InputDecoration(
                        labelText: 'Redirect URL (Optional)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.shortcut),
                      ),
                      validator: (value) {
                        if (value != null && value.isNotEmpty && !_isValidUrl(value)) {
                          return 'Please enter a valid URL';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description (Optional)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.description),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _submitForm,
                      icon: const Icon(Icons.add),
                      label: const Text('Add Job'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading)
            const LoadingOverlay(
              message: 'Adding job...',
            ),
        ],
      ),
    );
  }
}