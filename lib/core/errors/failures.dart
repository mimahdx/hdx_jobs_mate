import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure([this.message = '']);

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error occurred']);
}

class DatabaseFailure extends Failure {
  const DatabaseFailure([super.message = 'Database error occurred']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network error occurred']);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Requested resource not found']);
}

class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Validation error occurred']);
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'Unexpected error occurred']);
}