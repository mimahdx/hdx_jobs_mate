import 'package:equatable/equatable.dart';

class JobListing extends Equatable {
  final String id;
  final String title;
  final String company;
  final String location;
  final String salary;
  final DateTime postedDate;
  final String description;
  final String url;
  final String source;
  final Map<String, dynamic>? additionalInfo;

  const JobListing({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.salary,
    required this.postedDate,
    required this.description,
    required this.url,
    required this.source,
    this.additionalInfo,
  });

  factory JobListing.fromJson(Map<String, dynamic> json) {
    return JobListing(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      company: json['company'] ?? '',
      location: json['location'] ?? '',
      salary: json['salary'] ?? '',
      postedDate: DateTime.parse(json['posted_date'] ?? DateTime.now().toIso8601String()),
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      source: json['source'] ?? '',
      additionalInfo: json['additional_info'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'company': company,
      'location': location,
      'salary': salary,
      'posted_date': postedDate.toIso8601String(),
      'description': description,
      'url': url,
      'source': source,
      'additional_info': additionalInfo,
    };
  }

  JobListing copyWith({
    String? id,
    String? title,
    String? company,
    String? location,
    String? salary,
    DateTime? postedDate,
    String? description,
    String? url,
    String? source,
    Map<String, dynamic>? additionalInfo,
  }) {
    return JobListing(
      id: id ?? this.id,
      title: title ?? this.title,
      company: company ?? this.company,
      location: location ?? this.location,
      salary: salary ?? this.salary,
      postedDate: postedDate ?? this.postedDate,
      description: description ?? this.description,
      url: url ?? this.url,
      source: source ?? this.source,
      additionalInfo: additionalInfo ?? this.additionalInfo,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    company,
    location,
    salary,
    postedDate,
    description,
    url,
    source,
    additionalInfo,
  ];
}