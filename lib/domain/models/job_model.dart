import '../entities/job.dart';
import '../../data/datasources/local/database/app_database.dart';

class JobModel extends Job {
  final String syncStatus;

  const JobModel({
    required super.id,
    required super.name,
    required super.link,
    required super.site,
    super.redirectUrl,
    super.description,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
    required this.syncStatus,
  });

  factory JobModel.fromMap(Map<String, dynamic> map) {
    return JobModel(
      id: map[AppDatabase.columnId] as String,
      name: map[AppDatabase.columnJobName] as String,
      link: map[AppDatabase.columnJobLink] as String,
      site: map[AppDatabase.columnJobSite] as String,
      redirectUrl: map[AppDatabase.columnJobRedirectUrl] as String?,
      description: map[AppDatabase.columnJobDescription] as String?,
      status: map[AppDatabase.columnStatus] as int,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map[AppDatabase.columnCreatedAt] as int,
      ),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        map[AppDatabase.columnUpdatedAt] as int,
      ),
      syncStatus: map[AppDatabase.columnSyncStatus] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      AppDatabase.columnId: id,
      AppDatabase.columnJobName: name,
      AppDatabase.columnJobLink: link,
      AppDatabase.columnJobSite: site,
      AppDatabase.columnJobRedirectUrl: redirectUrl,
      AppDatabase.columnJobDescription: description,
      AppDatabase.columnStatus: status,
      AppDatabase.columnCreatedAt: createdAt.millisecondsSinceEpoch,
      AppDatabase.columnUpdatedAt: updatedAt.millisecondsSinceEpoch,
      AppDatabase.columnSyncStatus: syncStatus,
    };
  }

  Job toEntity() => Job(
    id: id,
    name: name,
    link: link,
    site: site,
    redirectUrl: redirectUrl,
    description: description,
    status: status,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  JobModel copyWith({
    String? id,
    String? name,
    String? link,
    String? site,
    String? redirectUrl,
    String? description,
    int? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? syncStatus,
  }) {
    return JobModel(
      id: id ?? this.id,
      name: name ?? this.name,
      link: link ?? this.link,
      site: site ?? this.site,
      redirectUrl: redirectUrl ?? this.redirectUrl,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }
}