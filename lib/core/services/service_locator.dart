import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../features/task_management/data/repositories/task_repository_impl.dart';
import '../../features/task_management/domain/repositories/task_repository.dart';
import '../../features/task_management/domain/usecases/create_task.dart';
import '../../features/task_management/domain/usecases/delete_task.dart';
import '../../features/task_management/domain/usecases/get_tasks.dart';
import '../../features/task_management/domain/usecases/get_tasks_by_priority.dart';
import '../../features/task_management/domain/usecases/search_tasks.dart';
import '../../features/task_management/domain/usecases/toggle_task_completion.dart';
import '../../features/task_management/domain/usecases/update_task.dart';
import '../../features/task_management/presentation/bloc/task_bloc.dart';
import 'hive_adapters.dart';
import 'hive_service.dart';
import 'hive_service_impl.dart';

/// Service Locator instance for dependency injection
final sl = GetIt.instance;

/// Initialize all dependencies
Future<void> initDependencies() async {
  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive adapters
  await registerHiveAdapters();

  // Register core services
  await _registerCoreServices();

  // Register repositories
  await _registerRepositories();

  // Register use cases
  await _registerUseCases();

  // Register BLoCs
  await _registerBLoCs();
}

/// Register core services
Future<void> _registerCoreServices() async {
  // Register HiveService
  sl.registerSingleton<HiveService>(HiveServiceImpl());

  // TODO: Register NotificationService when implemented
  // sl.registerSingleton<NotificationService>(NotificationServiceImpl());
}

/// Register repositories
Future<void> _registerRepositories() async {
  // Register TaskRepository
  sl.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(hiveService: sl()),
  );
}

/// Register use cases
Future<void> _registerUseCases() async {
  // Register GetTasks use case
  sl.registerLazySingleton<GetTasks>(() => GetTasks(sl()));

  // Register CreateTask use case
  sl.registerLazySingleton<CreateTask>(() => CreateTask(sl()));

  // Register UpdateTask use case
  sl.registerLazySingleton<UpdateTask>(() => UpdateTask(sl()));

  // Register DeleteTask use case
  sl.registerLazySingleton<DeleteTask>(() => DeleteTask(sl()));

  // Register ToggleTaskCompletion use case
  sl.registerLazySingleton<ToggleTaskCompletion>(
    () => ToggleTaskCompletion(sl()),
  );

  // Register SearchTasks use case
  sl.registerLazySingleton<SearchTasks>(() => SearchTasks(sl()));

  // Register GetTasksByPriority use case
  sl.registerLazySingleton<GetTasksByPriority>(() => GetTasksByPriority(sl()));
}

/// Register BLoCs
Future<void> _registerBLoCs() async {
  // Register TaskBloc
  sl.registerFactory<TaskBloc>(
    () => TaskBloc(
      getTasks: sl(),
      createTask: sl(),
      updateTask: sl(),
      deleteTask: sl(),
      toggleTaskCompletion: sl(),
      searchTasks: sl(),
      getTasksByPriority: sl(),
    ),
  );
}
