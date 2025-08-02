import 'package:equatable/equatable.dart';

/// Base class for all failures in the application
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

/// Failure for database operations
class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
}

/// Failure for network operations
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// Failure for server operations
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Failure for cache operations
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Failure for validation errors
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}
