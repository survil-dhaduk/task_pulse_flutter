import 'package:hive_flutter/hive_flutter.dart';

import '../../features/task_management/data/models/priority_model.dart';
import '../../features/task_management/data/models/task_model.dart';

/// Register Hive adapters for data models
Future<void> registerHiveAdapters() async {
  // Register PriorityModel adapter
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(PriorityModelAdapter());
  }

  // Register TaskModel adapter
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(TaskModelAdapter());
  }
}
