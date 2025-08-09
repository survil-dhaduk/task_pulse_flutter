# Task Pulse 📋

[![CI/CD](https://github.com/username/task_pulse/workflows/Android%20CI/CD/badge.svg)](https://github.com/username/task_pulse/actions)
[![codecov](https://codecov.io/gh/username/task_pulse/branch/master/graph/badge.svg)](https://codecov.io/gh/username/task_pulse)
[![Flutter Version](https://img.shields.io/badge/Flutter-3.24.0-blue.svg)](https://flutter.dev/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

A modern, feature-rich task management application built with Flutter using Clean Architecture principles. Task Pulse helps users organize their daily tasks with an intuitive interface, local notifications, and powerful filtering capabilities.

## ✨ Features

### Core Functionality
- **📝 Task Management**: Create, edit, delete, and organize tasks
- **🎯 Priority System**: High, Medium, Low priority levels with visual indicators
- **✅ Status Tracking**: Track task completion with toggle functionality
- **📅 Due Date Management**: Set and manage task deadlines
- **🔍 Search & Filter**: Find tasks by title, description, or priority
- **📱 Local Notifications**: Get reminded about upcoming tasks

### User Experience
- **🌓 Dark/Light Mode**: Automatic theme switching based on system settings
- **📱 Responsive Design**: Optimized for all screen sizes and orientations
- **🎨 Material Design 3**: Modern UI with Material You design principles
- **👆 Intuitive Interactions**: Swipe actions for quick task management
- **🔄 Real-time Updates**: Instant UI updates with efficient state management

### Technical Features
- **💾 Local Storage**: Efficient data persistence with Hive database
- **🏗️ Clean Architecture**: Maintainable and testable code structure
- **🔄 State Management**: Robust state handling with BLoC pattern
- **🧪 Comprehensive Testing**: Unit, widget, and integration tests
- **⚡ Performance Optimized**: Smooth animations and efficient rendering

## 🚀 Getting Started

### Prerequisites

Before running this project, ensure you have:
- Flutter SDK (3.24.0 or later)
- Dart SDK (3.5.0 or later)
- Android Studio / VS Code with Flutter extensions
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/username/task_pulse.git
   cd task_pulse
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate required files**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the application**
   ```bash
   flutter run
   ```

### Building for Production

#### Android
```bash
# APK
flutter build apk --release

# App Bundle (recommended for Play Store)
flutter build appbundle --release
```

#### iOS
```bash
flutter build ios --release
```

## 📱 Screenshots

Task Pulse offers a modern, intuitive interface with Material Design 3 principles. Here are some key screens showcasing the app's features:

### 🌟 Main Interface & Task Management

<table>
  <tr>
    <td align="center">
      <img src="screenshots/task list screen with task.png" width="200" alt="Task List Screen with Tasks"/><br/>
      <sub><b>📋 Task List Screen</b></sub><br/>
      <sub>Main interface showing tasks with priority indicators</sub>
    </td>
    <td align="center">
      <img src="screenshots/create:edit task screen .png" width="200" alt="Create and Edit Task Screen"/><br/>
      <sub><b>✏️ Create/Edit Task</b></sub><br/>
      <sub>Comprehensive task creation and editing interface</sub>
    </td>
    <td align="center">
      <img src="screenshots/mark task as done list task screen.png" width="200" alt="Mark Task as Done"/><br/>
      <sub><b>✅ Task Completion</b></sub><br/>
      <sub>Easy task completion with visual feedback</sub>
    </td>
  </tr>
</table>

### 🎯 Task Actions & Management

<table>
  <tr>
    <td align="center">
      <img src="screenshots/task delete and edit button option.png" width="200" alt="Task Delete and Edit Options"/><br/>
      <sub><b>⚙️ Task Actions</b></sub><br/>
      <sub>Quick access to edit and delete task options</sub>
    </td>
    <td align="center">
      <img src="screenshots/delete task alert dialog.png" width="200" alt="Delete Task Confirmation"/><br/>
      <sub><b>🗑️ Delete Confirmation</b></sub><br/>
      <sub>Safety dialog for task deletion confirmation</sub>
    </td>
    <td align="center">
      <img src="screenshots/date and priority shorting option.png" width="200" alt="Date and Priority Sorting"/><br/>
      <sub><b>📅 Date & Priority Sort</b></sub><br/>
      <sub>Sorting options by date and priority levels</sub>
    </td>
  </tr>
</table>

### 🎨 Themes & Filtering

<table>
  <tr>
    <td align="center">
      <img src="screenshots/light theme with empty task screen.png" width="200" alt="Light Theme Empty Screen"/><br/>
      <sub><b>☀️ Light Theme</b></sub><br/>
      <sub>Clean, bright interface with empty state</sub>
    </td>
    <td align="center">
      <img src="screenshots/darktheme empty screen.png" width="200" alt="Dark Theme Empty Screen"/><br/>
      <sub><b>🌙 Dark Theme</b></sub><br/>
      <sub>Modern dark mode with empty state design</sub>
    </td>
    <td align="center">
      <img src="screenshots/task type shortin option.png" width="200" alt="Task Type Sorting Options"/><br/>
      <sub><b>🔍 Task Type Filter</b></sub><br/>
      <sub>Advanced filtering and sorting by task type</sub>
    </td>
  </tr>
</table>

### ✨ Key Highlights

- **🌓 Adaptive Theming**: Beautiful light and dark mode themes
- **📱 Responsive Design**: Optimized for all screen sizes and orientations
- **⚡ Intuitive Actions**: Quick edit, delete, and completion actions
- **🔔 Smart Notifications**: Contextual reminders and alerts
- **📊 Advanced Sorting**: Sort by date, priority, and task type
- **🎯 Priority Management**: Visual priority system for better organization

## 🏗️ Architecture

Task Pulse follows **Clean Architecture** principles with clear separation of concerns:

```
├── lib/
│   ├── core/                 # Shared utilities and services
│   │   ├── services/         # Core application services
│   │   ├── utils/            # Utility functions
│   │   └── errors/           # Error definitions
│   ├── features/
│   │   └── task_management/  # Task management feature
│   │       ├── data/         # Data layer (repositories, models, data sources)
│   │       ├── domain/       # Business logic (entities, use cases, interfaces)
│   │       └── presentation/ # UI layer (screens, widgets, BLoC)
│   └── main.dart            # Application entry point
```

### Key Components

- **🎯 BLoC Pattern**: Predictable state management
- **💉 Dependency Injection**: Clean dependency management with GetIt
- **🗄️ Local Storage**: Efficient data persistence with Hive
- **🔔 Notifications**: Local notifications with flutter_local_notifications
- **🧪 Testing**: Comprehensive test coverage with proper mocking

For detailed architecture documentation, see [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).

## 🧪 Testing

The project maintains high test coverage across all layers:

- **Unit Tests**: Business logic and data layer testing
- **Widget Tests**: UI component behavior validation
- **BLoC Tests**: State management verification
- **Integration Tests**: End-to-end user flow testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test categories
flutter test test/features/task_management/domain/  # Unit tests
flutter test test/features/task_management/presentation/  # Widget tests
```

For detailed testing information, see [docs/TESTING.md](docs/TESTING.md).

## 🛠️ Development

### Project Structure

```
task_pulse/
├── lib/                     # Source code
├── test/                    # Test files
├── docs/                    # Documentation
├── screenshots/             # UI screenshots
├── .github/workflows/       # CI/CD configuration
└── README.md               # This file
```

### Development Workflow

1. **Feature Development**: Follow Clean Architecture layers
2. **Testing**: Write tests for each layer
3. **Code Quality**: Use `flutter analyze` and `dart format`
4. **Git Workflow**: Feature branches with descriptive commits

For detailed development guidelines, see [docs/DEVELOPMENT.md](docs/DEVELOPMENT.md).

## 📦 Dependencies

### Core Dependencies
- **flutter_bloc**: State management
- **get_it**: Dependency injection
- **hive**: Local database
- **dartz**: Functional programming utilities
- **equatable**: Value object comparisons

### UI Dependencies
- **flutter_slidable**: Swipe actions
- **flutter_local_notifications**: Local notifications

### Development Dependencies
- **bloc_test**: BLoC testing utilities
- **mockito**: Mocking framework
- **build_runner**: Code generation

## 🔄 CI/CD

The project includes GitHub Actions workflows for:
- **🧪 Automated Testing**: Unit, widget, and integration tests
- **📦 Build Automation**: APK and App Bundle generation
- **📊 Coverage Reporting**: Code coverage analysis
- **🔍 Code Quality**: Static analysis and linting

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines

- Follow Clean Architecture principles
- Write comprehensive tests
- Use conventional commit messages
- Maintain code quality standards
- Update documentation as needed

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

If you have any questions or need help:

- 📧 Email: survildhaduk@gmail.com
- 🐛 Issues: [GitHub Issues](https://github.com/survil-dhaduk/task_pulse/issues)
- 📖 Documentation: [docs/](docs/)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Material Design team for design guidelines
- Open source community for valuable packages

---

**Made with ❤️ using Flutter**
