import 'package:dio/dio.dart';
import 'package:rox_client/src/models/rox_client_options.dart';
import 'package:rox_client/src/dio_client.dart';
import 'package:rox_client/src/rox_client.dart';

class Auth implements RoxClient {
  static Auth? _instance;
  Auth._internal(
    this.getNewTokenUrl,
    this.getAccessToken,
    this.getRefreshToken,
    this.setAccessToken,
    this.onInvalidToken,
    this.dioClient,
    this.baseUrl,
    this.maxRetry,
  );

  final int maxRetry;
  final String baseUrl;
  static const Duration defaultTimeout = Duration(milliseconds: 5000);

  static Auth get instance {
    if (_instance == null) {
      throw Exception('Auth não foi inicializado');
    }
    return _instance!;
  }

  static void init({
    required String getNewTokenUrl,
    required Future<String> Function() getAccessToken,
    required Future<String> Function() getRefreshToken,
    required Future Function(String) setAccessToken,
    required Function onInvalidToken,
    required String baseUrl,
    int maxRetry = 3,
  }) {
    _instance = Auth._internal(
      getNewTokenUrl,
      getAccessToken,
      getRefreshToken,
      setAccessToken,
      onInvalidToken,
      DioClient(baseUrl, Dio()),
      baseUrl,
      maxRetry,
    );
  }

  final String getNewTokenUrl;

  /// Função que deve retornar o access token
  final Future<String> Function() getAccessToken;

  /// Função que deve retornar o refresh token
  final Future<String> Function() getRefreshToken;

  /// Função que é chamada quando um novo access token é gerado e deve armazenar este token de alguma forma
  final Future Function(String) setAccessToken;

  /// Função chamada quando o token não é válido e não é possível renová-lo
  final Function onInvalidToken;
  final DioClient dioClient;

  Future<String> _getAccessToken() async {
    try {
      String accessToken = await getAccessToken();
      return accessToken;
    } catch (e) {
      print('Erro ao obter accessToken: $e');
      rethrow;
    }
  }

  Future<String> _getRefreshToken() async {
    try {
      String refreshToken = await getRefreshToken();
      return refreshToken;
    } catch (e) {
      print('Erro ao obter refreshToken: $e');
      rethrow;
    }
  }

  Future refreshToken() async {
    try {
      String refreshToken = await _getRefreshToken();
      var response = await dioClient.get(getNewTokenUrl,
          options: RoxClientOptions(
            headers: {
              'authorization': 'Bearer $refreshToken',
            },
          ));
      await setAccessToken(response['accessToken']);
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<dynamic> get(
    String uri, {
    Map<String, dynamic>? queryParameters,
    RoxClientOptions? options,
    int retry = 0,
  }) async {
    try {
      var res = await dioClient.get(uri, options: options ?? await _getOptionsWithAccessToken(), queryParameters: queryParameters);
      return res;
    } on DioError catch (e) {
      if (retry < maxRetry && e.response?.statusCode == 403) {
        await refreshToken();
        return get(uri, retry: retry + 1);
      } else {
        rethrow;
      }
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
    int retry = 0,
  }) async {
    try {
      var res = await dioClient.post(uri, data: data, options: options ?? await _getOptionsWithAccessToken());
      return res;
    } on DioError catch (e) {
      if (retry < maxRetry && e.response?.statusCode == 403) {
        await refreshToken();
        return post(uri, data: data, retry: retry + 1);
      } else {
        rethrow;
      }
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
    int retry = 0,
  }) async {
    try {
      var res = await dioClient.put(uri, data: data, options: options ?? await _getOptionsWithAccessToken());
      return res;
    } on DioError catch (e) {
      if (retry < maxRetry && e.response?.statusCode == 403) {
        await refreshToken();
        return put(uri, data: data, retry: retry + 1);
      } else {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<RoxClientOptions> _getOptionsWithAccessToken() async {
    String accessToken = await _getAccessToken();
    return RoxClientOptions(
      headers: {
        'authorization': 'Bearer $accessToken',
      },
    );
  }
  
  @override
  Future<dynamic> delete(
    String uri, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    RoxClientOptions? options,
    int retry = 0,
  }) async {
    try {
      return dioClient.delete(uri, data: data, options: options ?? await _getOptionsWithAccessToken());
    } on DioError catch (e) {
      if (retry < maxRetry && e.response?.statusCode == 403) {
        await refreshToken();
        return delete(uri, data: data, retry: retry + 1);
      } else {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }
  
  @override
  Future patch(
    String uri, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    RoxClientOptions? options,
    int retry = 0,
  }) async {
    try {
      return dioClient.patch(uri, data: data, options: options ?? await _getOptionsWithAccessToken());
    } on DioError catch (e) {
      if (retry < maxRetry && e.response?.statusCode == 403) {
        await refreshToken();
        return patch(uri, data: data, retry: retry + 1);
      } else {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }
}
