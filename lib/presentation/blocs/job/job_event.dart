import 'package:equatable/equatable.dart';

abstract class JobEvent extends Equatable {
  const JobEvent();

  @override
  List<Object?> get props => [];
}

class GetJobsEvent extends JobEvent {
  final String? site;
  final String? searchTerm;

  const GetJobsEvent({
    this.site,
    this.searchTerm,
  });

  @override
  List<Object?> get props => [site, searchTerm];
}

class GetJobsBySiteEvent extends JobEvent {
  final String site;

  const GetJobsBySiteEvent({required this.site});

  @override
  List<Object> get props => [site];
}

class GetJobEvent extends JobEvent {
  final String id;

  const GetJobEvent({required this.id});

  @override
  List<Object> get props => [id];
}

class AddJobEvent extends JobEvent {
  final String name;
  final String link;
  final String site;
  final String? redirectUrl;
  final String? description;
  final int status;

  const AddJobEvent({
    required this.name,
    required this.link,
    required this.site,
    this.redirectUrl,
    this.description,
    required this.status,
  });

  @override
  List<Object?> get props => [name, link, site, redirectUrl, description, status];
}

class UpdateJobEvent extends JobEvent {
  final String id;
  final String name;
  final String link;
  final String site;
  final String? redirectUrl;
  final String? description;
  final int status;

  const UpdateJobEvent({
    required this.id,
    required this.name,
    required this.link,
    required this.site,
    this.redirectUrl,
    this.description,
    required this.status,
  });

  @override
  List<Object?> get props => [id, name, link, site, redirectUrl, description, status];
}

class DeleteJobEvent extends JobEvent {
  final String id;

  const DeleteJobEvent({required this.id});

  @override
  List<Object> get props => [id];
}