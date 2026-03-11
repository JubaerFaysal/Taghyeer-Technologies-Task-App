import 'dart:io';

import 'package:dio/dio.dart';

import 'api_exceptions.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {'Content-Type': 'application/json'},
      ),
    );
  }

  Future<dynamic> get(String url, {Map<String, String>? headers}) async {
    try {
      final response = await _dio.get(
        url,
        options: headers != null ? Options(headers: headers) : null,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<dynamic> post(
    String url, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    try {
      final response = await _dio.post(
        url,
        data: body,
        options: headers != null ? Options(headers: headers) : null,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  AppException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException('Request timed out. Please try again.');
      case DioExceptionType.connectionError:
        return NetworkException(
          'No internet connection. Please check your network.',
        );
      case DioExceptionType.badResponse:
        return _handleBadResponse(error.response);
      case DioExceptionType.cancel:
        return AppException('Request was cancelled.');
      default:
        if (error.error is SocketException) {
          return NetworkException(
            'No internet connection. Please check your network.',
          );
        }
        return AppException('An unexpected error occurred. Please try again.');
    }
  }

  AppException _handleBadResponse(Response? response) {
    if (response == null) {
      return AppException('No response from server.');
    }

    final data = response.data;
    final message = data is Map ? data['message'] ?? '' : '';

    switch (response.statusCode) {
      case 400:
        return BadRequestException(
          message.isNotEmpty ? message : 'Bad request',
        );
      case 401:
        return UnauthorizedException(
          message.isNotEmpty ? message : 'Invalid credentials',
        );
      case 404:
        return NotFoundException('Resource not found');
      default:
        final code = response.statusCode ?? 0;
        if (code >= 500) {
          return ServerException(
            'Server error. Please try again later.',
            statusCode: code,
          );
        }
        return AppException(
          'Unexpected error occurred ($code)',
          statusCode: code,
        );
    }
  }
}
