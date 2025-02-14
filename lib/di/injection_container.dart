// lib/di/injection_container.dart

import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

// Core
import '../core/network/network_info.dart';
import '../data/datasources/local/shared_prefs/first_launch_manager.dart';

// Database
import '../data/datasources/local/database/app_database.dart';

// Repositories
import '../domain/repositories/saving_repository.dart';
import '../domain/repositories/category_repository.dart';
import '../data/repositories/saving_repository_impl.dart';
import '../data/repositories/category_repository_impl.dart';

// Use cases - Saving
import '../domain/usecases/saving/get_saving_list.dart';
import '../domain/usecases/saving/add_saving.dart';
import '../domain/usecases/saving/update_saving.dart';

// Use cases - Category
import '../domain/usecases/category/get_category_list.dart';
import '../domain/usecases/category/add_category.dart';
import '../domain/usecases/category/update_category.dart';
import '../domain/usecases/category/delete_category.dart';
import '../domain/usecases/category/get_category.dart';

// Blocs
import '../presentation/blocs/category/category_bloc.dart';
import '../presentation/blocs/saving/saving_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  // First Launch Manager
  sl.registerLazySingleton<FirstLaunchManager>(
        () => FirstLaunchManager(sharedPreferences: sl()),
  );

  // Database
  sl.registerSingleton<AppDatabase>(AppDatabase());

  // Network
  sl.registerLazySingleton(() => InternetConnectionChecker());

  //! Core
  sl.registerLazySingleton<NetworkInfo>(
        () => NetworkInfoImpl(connectionChecker: sl()),
  );

  //! Features - Category
  // Use cases
  sl.registerLazySingleton(() => GetCategoryList(repository: sl()));
  sl.registerLazySingleton(() => AddCategory(repository: sl()));
  sl.registerLazySingleton(() => UpdateCategory(repository: sl()));
  sl.registerLazySingleton(() => DeleteCategory(repository: sl()));
  sl.registerLazySingleton(() => GetCategory(repository: sl()));

  // Repository
  sl.registerLazySingleton<CategoryRepository>(
        () => CategoryRepositoryImpl(
      localDatabase: sl(),
      networkInfo: sl(),
    ),
  );

  //! Features - Saving
  // Use cases
  sl.registerLazySingleton(() => GetSavingList(repository: sl()));
  sl.registerLazySingleton(() => AddSaving(repository: sl()));
  sl.registerLazySingleton(() => UpdateSaving(repository: sl()));

  // Repository
  sl.registerLazySingleton<SavingRepository>(
        () => SavingRepositoryImpl(
      localDatabase: sl(),
      networkInfo: sl(),
    ),
  );

  //! Blocs
  sl.registerFactory(
        () => CategoryBloc(
      getCategoryList: sl(),
      addCategory: sl(),
      updateCategory: sl(),
      deleteCategory: sl(),
    ),
  );

  sl.registerFactory(
        () => SavingBloc(
      getSavingList: sl(),
      addSaving: sl(),
      updateSaving: sl(),
    ),
  );
}