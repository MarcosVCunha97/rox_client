import 'dart:io';

import 'package:dio/dio.dart';
import 'package:rox_client/src/models/rox_client_options.dart';
import 'package:rox_client/src/rox_client.dart';

// const _defaultConnectTimeout = Duration.millisecondsPerMinute;
// const _defaultReceiveTimeout = Duration.millisecondsPerMinute;

class DioClient implements RoxClient {
  final String baseUrl;

  late Dio _dio;

  final List<Interceptor>? interceptors;
  final bool logEnabled;

  DioClient(
    this.baseUrl,
    Dio? dio, {
    this.interceptors,
    /// The default value is false.
    this.logEnabled = false,
    /// The timeout for opening a connection. The default value is 10 seconds.
    Duration connectTimeout = const Duration(seconds: 10),
  }) {
    _dio = dio ?? Dio();
    _dio
      ..options.baseUrl = baseUrl
      ..options.connectTimeout = connectTimeout
      ..options.receiveTimeout = connectTimeout
      ..httpClientAdapter
      ..options.headers = {'Content-Type': 'application/json; charset=UTF-8'};
    if (interceptors?.isNotEmpty ?? false) {
      _dio.interceptors.addAll(interceptors!);
    }
    if (logEnabled) {
      _dio.interceptors.add(LogInterceptor(
        requestHeader: false,
        responseHeader: false,
        request: false
      ));
    }
  }

  @override
  Future<dynamic> get(
    String uri, {
    Map<String, dynamic>? queryParameters,
    RoxClientOptions? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var response = await _dio.get(
        uri,
        queryParameters: queryParameters,
        options: _mapOptions(options),
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw const FormatException('Unable to process the data');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> post(
    String uri, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    RoxClientOptions? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var response = await _dio.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: _mapOptions(options),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } on FormatException catch (_) {
      throw const FormatException('Unable to process the data');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> put(
    String uri, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    RoxClientOptions? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var response = await _dio.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: _mapOptions(options),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } on FormatException catch (_) {
      throw const FormatException('Unable to process the data');
    } catch (e) {
      rethrow;
    }
  }
  
  @override
  Future<dynamic> patch(
    String uri, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    RoxClientOptions? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var response = await _dio.patch(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: _mapOptions(options),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } on FormatException catch (_) {
      throw const FormatException('Unable to process the data');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> delete(
    String uri, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    RoxClientOptions? options,
    CancelToken? cancelToken,
  }) async {
    try {
      var response = await _dio.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: _mapOptions(options),
        cancelToken: cancelToken,
      );
      return response.data;
    } on FormatException catch (_) {
      throw const FormatException('Unable to process the data');
    } catch (e) {
      rethrow;
    }
  }

  Options? _mapOptions(RoxClientOptions? roxClientOptions){
    if (roxClientOptions == null) {
      return null;
    }
    return Options(
      headers: roxClientOptions.headers,
      receiveTimeout: roxClientOptions.receiveTimeout,
      sendTimeout: roxClientOptions.sendTimeout,
    );
  }

}