// lib/di/injection_container.dart

import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:http/http.dart' as http;

// Core
import '../core/network/network_info.dart';
import '../data/datasources/local/shared_prefs/first_launch_manager.dart';

// Database
import '../data/datasources/local/database/app_database.dart';

// Repositories
import '../domain/repositories/job_repository.dart';
import '../domain/repositories/earning_repository.dart';
import '../domain/repositories/job_search_repository.dart';
import '../data/repositories/job_repository_impl.dart';
import '../data/repositories/earning_repository_impl.dart';
import '../data/repositories/job_search_repository_impl.dart';

// Use cases - Job
import '../domain/usecases/job/get_jobs.dart';
import '../domain/usecases/job/get_jobs_by_site.dart';
import '../domain/usecases/job/get_job.dart';
import '../domain/usecases/job/add_job.dart';
import '../domain/usecases/job/update_job.dart';
import '../domain/usecases/job/delete_job.dart';

// Use cases - Earning
import '../domain/usecases/earning/get_earnings.dart';
import '../domain/usecases/earning/get_earnings_by_date_range.dart';
import '../domain/usecases/earning/get_earning.dart';
import '../domain/usecases/earning/add_earning.dart';
import '../domain/usecases/earning/update_earning.dart';
import '../domain/usecases/earning/get_dashboard_summary.dart';

// Blocs
import '../presentation/blocs/job/job_bloc.dart';
import '../presentation/blocs/earning/earning_bloc.dart';
import '../presentation/blocs/jobs_search/job_search_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());

  //! Core
  sl.registerLazySingleton<NetworkInfo>(
        () => NetworkInfoImpl(connectionChecker: sl()),
  );

  // First Launch Manager
  sl.registerLazySingleton<FirstLaunchManager>(
        () => FirstLaunchManager(sharedPreferences: sl()),
  );

  // Database
  sl.registerSingleton<AppDatabase>(AppDatabase());

  //! Repositories
  sl.registerLazySingleton<JobRepository>(
        () => JobRepositoryImpl(
      localDatabase: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton<EarningRepository>(
        () => EarningRepositoryImpl(
      localDatabase: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton<JobSearchRepository>(
        () => JobSearchRepositoryImpl(
      client: sl(),
      sharedPreferences: sl(),
      networkInfo: sl(),
    ),
  );

  //! Use Cases - Job
  sl.registerLazySingleton(() => GetJobs(repository: sl()));
  sl.registerLazySingleton(() => GetJobsBySite(repository: sl()));
  sl.registerLazySingleton(() => GetJob(repository: sl()));
  sl.registerLazySingleton(() => AddJob(repository: sl()));
  sl.registerLazySingleton(() => UpdateJob(repository: sl()));
  sl.registerLazySingleton(() => DeleteJob(repository: sl()));

  //! Use Cases - Earning
  sl.registerLazySingleton(() => GetEarnings(repository: sl()));
  sl.registerLazySingleton(() => GetEarningsByDateRange(repository: sl()));
  sl.registerLazySingleton(() => GetEarning(repository: sl()));
  sl.registerLazySingleton(() => AddEarning(repository: sl()));
  sl.registerLazySingleton(() => UpdateEarning(repository: sl()));
  sl.registerLazySingleton(() => GetDashboardSummary(repository: sl()));

  //! Blocs
  sl.registerFactory(
        () => JobBloc(
      getJobs: sl(),
      getJobsBySite: sl(),
      getJob: sl(),
      addJob: sl(),
      updateJob: sl(),
      deleteJob: sl(),
    ),
  );

  sl.registerFactory(
        () => EarningBloc(
      getEarnings: sl(),
      getEarningsByDateRange: sl(),
      getEarning: sl(),
      addEarning: sl(),
      updateEarning: sl(),
      getDashboardSummary: sl(),
    ),
  );

  sl.registerFactory(
        () => JobSearchBloc(
      repository: sl(),
    ),
  );
}