/// Exception thrown when a server operation fails
class ServerException implements Exception {
  final String? message;
  final int? statusCode;

  ServerException([this.message, this.statusCode]);

  @override
  String toString() => 'ServerException: $message (Status Code: $statusCode)';
}

/// Exception thrown when a database operation fails
class DatabaseException implements Exception {
  final String? message;
  final String? operation;

  DatabaseException([this.message, this.operation]);

  @override
  String toString() => 'DatabaseException: $message (Operation: $operation)';
}

/// Exception thrown when network connectivity is unavailable
class NetworkException implements Exception {
  final String? message;

  NetworkException([this.message]);

  @override
  String toString() => 'NetworkException: $message';
}

/// Exception thrown when data validation fails
class ValidationException implements Exception {
  final String? message;
  final Map<String, List<String>>? errors;

  ValidationException([this.message, this.errors]);

  @override
  String toString() => 'ValidationException: $message ${errors != null ? '(Errors: $errors)' : ''}';
}

/// Exception thrown when a requested resource is not found
class NotFoundException implements Exception {
  final String? message;
  final String? resourceType;
  final String? resourceId;

  NotFoundException([this.message, this.resourceType, this.resourceId]);

  @override
  String toString() => 'NotFoundException: $message (Resource: $resourceType, ID: $resourceId)';
}

/// Exception thrown when cache operations fail
class CacheException implements Exception {
  final String? message;
  final String? operation;

  CacheException([this.message, this.operation]);

  @override
  String toString() => 'CacheException: $message (Operation: $operation)';
}

/// Exception thrown when sync operations fail
class SyncException implements Exception {
  final String? message;
  final String? syncOperation;
  final DateTime? timestamp;

  SyncException([this.message, this.syncOperation, this.timestamp]);

  @override
  String toString() => 'SyncException: $message (Operation: $syncOperation, Time: $timestamp)';
}

/// Exception thrown when format conversion fails
class FormatException implements Exception {
  final String? message;
  final String? expectedFormat;
  final String? receivedValue;

  FormatException([this.message, this.expectedFormat, this.receivedValue]);

  @override
  String toString() => 'FormatException: $message (Expected: $expectedFormat, Received: $receivedValue)';
}