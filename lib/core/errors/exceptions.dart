class ServerException implements Exception {
  final String? message;

  ServerException({this.message});

  @override
  String toString() => message ?? 'Server Exception';
}

class NotFoundException implements Exception {
  final String? message;

  NotFoundException({this.message});

  @override
  String toString() => message ?? 'Resource Not Found';
}

class CacheException implements Exception {
  final String? message;

  CacheException({this.message});

  @override
  String toString() => message ?? 'Cache Exception';
}

class AuthenticationException implements Exception {
  final String? message;

  AuthenticationException({this.message});

  @override
  String toString() => message ?? 'Authentication Failed';
}

class AuthorizationException implements Exception {
  final String? message;

  AuthorizationException({this.message});

  @override
  String toString() => message ?? 'Not Authorized';
}

class NetworkException implements Exception {
  final String? message;

  NetworkException({this.message});

  @override
  String toString() => message ?? 'Network Error';
}

class ValidationException implements Exception {
  final Map<String, List<String>> errors;

  ValidationException({required this.errors});

  @override
  String toString() {
    if (errors.isEmpty) return 'Validation Error';

    final errorMessages = errors.entries
        .map((entry) {
          final field = entry.key;
          final messages = entry.value.join(', ');
          return '$field: $messages';
        })
        .join('; ');

    return 'Validation Error: $errorMessages';
  }
}

class TimeoutException implements Exception {
  final String? message;
  final int? timeoutInSeconds;

  TimeoutException({this.message, this.timeoutInSeconds});

  @override
  String toString() {
    if (timeoutInSeconds != null) {
      return message ?? 'Operation timed out after $timeoutInSeconds seconds';
    }
    return message ?? 'Operation timed out';
  }
}

class DatabaseException implements Exception {
  final String? message;
  final String? code;

  DatabaseException({this.message, this.code});

  @override
  String toString() {
    if (code != null) {
      return message ?? 'Database error (code: $code)';
    }
    return message ?? 'Database error';
  }
}

class FormatException implements Exception {
  final String? message;

  FormatException({this.message});

  @override
  String toString() => message ?? 'Invalid data format';
}

class BusinessException implements Exception {
  final String? message;
  final String? code;

  BusinessException({this.message, this.code});

  @override
  String toString() {
    if (code != null) {
      return message ?? 'Business rule violation (code: $code)';
    }
    return message ?? 'Business rule violation';
  }
}
