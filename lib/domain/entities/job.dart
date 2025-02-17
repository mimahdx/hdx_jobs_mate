import 'package:equatable/equatable.dart';

class Job extends Equatable {
  final String id;
  final String name;
  final String link;
  final String site;
  final String? redirectUrl;
  final String? description;
  final int status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Job({
    required this.id,
    required this.name,
    required this.link,
    required this.site,
    this.redirectUrl,
    this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    link,
    site,
    redirectUrl,
    description,
    status,
    createdAt,
    updatedAt,
  ];
}