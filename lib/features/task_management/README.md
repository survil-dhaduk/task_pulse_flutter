# Task Management Feature

This feature implements task management functionality using Clean Architecture principles.

## Structure

### Domain Layer (`domain/`)
- `entities/` - Core business objects (Task entity)
- `repositories/` - Repository interfaces
- `usecases/` - Business logic and use cases

### Data Layer (`data/`)
- `models/` - Data models and DTOs
- `datasources/` - Data sources (local/remote)
- `repositories/` - Repository implementations

### Presentation Layer (`presentation/`)
- `bloc/` - BLoC state management
- `pages/` - Screen implementations
- `widgets/` - Reusable UI components
