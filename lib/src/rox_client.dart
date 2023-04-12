
import 'package:rox_client/models/rox_client_options.dart';

abstract class RoxClient {
   Future<dynamic> get(
    String uri, {
    Map<String, dynamic>? queryParameters,
    RoxClientOptions? options,
  });

  Future<dynamic> post(
    String uri, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    RoxClientOptions? options,
  });

  Future<dynamic> put(
    String uri, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    RoxClientOptions? options,
  });
  
  Future<dynamic> patch(
    String uri, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    RoxClientOptions? options,
  });

  Future<dynamic> delete(
    String uri, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    RoxClientOptions? options,
  });
}