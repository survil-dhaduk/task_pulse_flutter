import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/services/service_locator.dart';
import 'features/task_management/presentation/bloc/task_bloc.dart';
import 'features/task_management/presentation/pages/task_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies
  await initDependencies();

  runApp(const TaskPulseApp());
}

class TaskPulseApp extends StatelessWidget {
  const TaskPulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskPulse',
      // Light theme
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      // Dark theme
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      // Use system theme mode to automatically switch between light and dark
      themeMode: ThemeMode.system,
      home: MultiBlocProvider(
        providers: [
          BlocProvider<TaskBloc>(create: (context) => sl<TaskBloc>()),
        ],
        child: const TaskListScreen(),
      ),
    );
  }
}
