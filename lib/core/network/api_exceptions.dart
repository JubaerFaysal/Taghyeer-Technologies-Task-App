class AppException implements Exception {
  final String message;
  final String? prefix;
  final int? statusCode;

  AppException(this.message, {this.prefix, this.statusCode});

  @override
  String toString() => '${prefix ?? ''}$message';
}

class NetworkException extends AppException {
  NetworkException(super.message) : super(prefix: 'Network Error: ');
}

class TimeoutException extends AppException {
  TimeoutException(super.message) : super(prefix: 'Timeout: ');
}

class ServerException extends AppException {
  ServerException(super.message, {super.statusCode})
    : super(prefix: 'Server Error: ');
}

class UnauthorizedException extends AppException {
  UnauthorizedException(super.message) : super(prefix: 'Unauthorized: ');
}

class BadRequestException extends AppException {
  BadRequestException(super.message) : super(prefix: 'Bad Request: ');
}

class NotFoundException extends AppException {
  NotFoundException(super.message) : super(prefix: 'Not Found: ');
}
