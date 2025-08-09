/// Application string constants
///
/// This file contains all hardcoded strings used throughout the application
/// to provide a centralized place for string management and internationalization.
class AppStrings {
  // Private constructor to prevent instantiation
  AppStrings._();

  // App Information
  static const String appName = 'TaskPulse';
  static const String appTitle = 'TaskPulse';

  // General UI Text
  static const String retry = 'Retry';
  static const String cancel = 'Cancel';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const String clear = 'Clear';
  static const String error = 'Error';
  static const String all = 'All';
  static const String pending = 'Pending';
  static const String completed = 'Completed';
  static const String overdue = 'OVERDUE';

  // Tooltips
  static const String filterTooltip = 'Filter';
  static const String sortTooltip = 'Sort';
  static const String clearTooltip = 'Clear';

  // Task Management
  static const String noTasksYet = 'No tasks yet';
  static const String noTasksAvailable = 'No tasks available';
  static const String createFirstTaskHint =
      'Tap the + button to create your first task';
  static const String searchTasks = 'Search tasks...';

  // Task Form
  static const String createTask = 'Create Task';
  static const String editTask = 'Edit Task';
  static const String updateTask = 'Update Task';
  static const String title = 'Title';
  static const String description = 'Description';
  static const String priority = 'Priority';
  static const String dueDateAndTime = 'Due Date & Time';

  // Form Placeholders and Hints
  static const String enterTaskTitle = 'Enter task title';
  static const String enterTaskDescription = 'Enter task description';

  // Form Validation Messages
  static const String pleaseEnterTitle = 'Please enter a title';
  static const String pleaseEnterDescription = 'Please enter a description';

  // Task Success Messages
  static const String taskCreatedSuccessfully = 'Task created successfully!';
  static const String taskUpdatedSuccessfully = 'Task updated successfully!';

  // Search Results
  static String searchResults(String query, int count) =>
      "Search: '$query' — $count result(s)";

  // Delete Confirmation
  static String deleteTaskConfirmation(String taskTitle) =>
      'Are you sure you want to delete "$taskTitle"?';
  static const String deleteTaskTitle = 'Delete Task';

  // Priority Labels
  static const String lowPriority = 'Low';
  static const String mediumPriority = 'Medium';
  static const String highPriority = 'High';

  // Sort Options
  static const String dueDateAscending = 'Due date ↑';
  static const String dueDateDescending = 'Due date ↓';
  static const String priorityHighToLow = 'Priority high → low';
  static const String priorityLowToHigh = 'Priority low → high';

  // Date Formatting
  static String todayAt(String time) => 'Today at $time';
  static String tomorrowAt(String time) => 'Tomorrow at $time';

  // Progress Indicators
  static const String creatingTask = 'Creating task...';
  static const String updatingTask = 'Updating task...';
  static const String deletingTask = 'Deleting task...';
  static const String searchingTasks = 'Searching tasks...';
  static const String togglingCompletion = 'Toggling completion...';
  static const String filteringByPriority = 'Filtering by priority...';
  static const String filtering = 'Filtering...';

  // Sort and Filter Hints
  static const String sortedDueDateAsc = 'sorted: due date ↑';
  static const String sortedDueDateDesc = 'sorted: due date ↓';
  static const String sortedPriorityHighToLow = 'sorted: priority high → low';
  static const String sortedPriorityLowToHigh = 'sorted: priority low → high';
  static String filterHint(String filterName) => 'filter: $filterName';

  // Error Messages with Dynamic Content
  static String errorMessage(String message) => 'Error: $message';

  // Notification Constants
  static const String taskChannel = 'task_channel';
  static const String taskNotifications = 'Task Notifications';
  static const String taskNotificationDescription =
      'Notifications for task reminders';

  // Database Constants
  static const String tasksBoxName = 'tasks';

  // Error Messages
  static const String taskNotFound = 'Task not found';

  // Debug Messages
  static String timezoneInitialized(String timeZone) =>
      'Timezone initialized: $timeZone';
  static String notificationServiceSkipped(String error) =>
      'NotificationService.initialize skipped: $error';
  static String notificationPermissionSkipped(String error) =>
      'Notification permission request skipped: $error';

  // Hint Messages
  static const String sortedByDueDate = 'sorted by due date';
  static const String filteredCompleted = 'filtered: completed';
  static const String filteredPending = 'filtered: pending';
  static const String filteredAll = 'filtered: all';

  // Android Notification Icon
  static const String androidNotificationIcon = '@mipmap/ic_launcher';
}
