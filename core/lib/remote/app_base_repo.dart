part of '../core.dart';

bool noNeedToken(String path, List<String> list) {
  bool isNoNeedToken = false;

  for (var item in list) {
    if (path.contains(item)) {
      isNoNeedToken = true;
      break;
    }
  }

  return isNoNeedToken;
}

void logRequest(RequestOptions options) {
  Log.i('### Request Log ###');
  Log.i('URL: ${options.uri}');
  Log.i('Method: ${options.method}');
  Log.i('Headers: ${options.headers}');
  if (options.data is! FormData) {
    Log.i('Request: ${jsonEncode(options.data)}');
  }
  Log.i('### End Request Log ###');
}

void logResponse(Response response) {
  Log.i('### Response Log ###');
  Log.i('Status Code: ${response.statusCode}');
  Log.i('Status Message: ${response.statusMessage}');
  Log.i('Response: ${jsonEncode(response.data)}');
  Log.i('### End Response Log ###');
}

abstract class AppBaseRepo {
  @protected
  _DioHelper get _helper => _DioHelper.getInstance(
        whiteAuthList: whiteAuthList,
        onRequest: onRequest,
        onResponse: onResponse,
        onError: onError,
        accessToken: accessToken,
      );

  @protected
  _DioHelperLogin get _helperLogin => _DioHelperLogin.getInstance(
        whiteAuthList: whiteAuthList,
        onRequest: onRequest,
        onResponse: onResponse,
        onError: onError,
        accessToken: accessToken,
      );

  @protected
  _DioHelperHrmNoti get _helperHrmNoti => _DioHelperHrmNoti.getInstance(
        whiteAuthList: whiteAuthList,
        onRequest: onRequest,
        onResponse: onResponse,
        onError: onError,
        accessToken: accessToken,
      );

  @protected
  Dio get dio => _helper.dio;

  Future<Response> get({required String path, data, Map<String, dynamic>? queries}) async {
    return _helper.get(
      path,
      data: data,
      queryParameters: queries,
    );
  }

  Future<Response> getHrmNoti({required String path, data, Map<String, dynamic>? queries}) async {
    return _helperHrmNoti.get(
      path,
      data: data,
      queryParameters: queries,
    );
  }

  Future<Response> post(
      {required String path, body, Map<String, dynamic>? queries, Options? options}) async {
    return _helper.post(
      path,
      body,
      queryParameters: queries,
      options: options,
    );
  }

  Future<Response> postLogin(
      {required String path, body, Map<String, dynamic>? queries, Options? options}) async {
    return _helperLogin.post(
      path,
      body,
      queryParameters: queries,
      options: options,
    );
  }

  Future<Response> postHrmNoti(
      {required String path, body, Map<String, dynamic>? queries, Options? options}) async {
    return _helperHrmNoti.post(
      path,
      body,
      queryParameters: queries,
      options: options,
    );
  }

  @protected
  List<String> get whiteAuthList;

  @protected
  Future<String> get accessToken;

  @protected
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    return handler.next(options);
  }

  @protected
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    return handler.next(response);
  }

  @protected
  void onError(DioException e, ErrorInterceptorHandler handler) {
    return handler.next(e);
  }
}

class _DioHelper {
  static const int _connectTimeout = 30;
  static const int _receiveTimeout = 30;
  static const int _sendTimeout = 30;

  final _dio = Dio(
    BaseOptions(
      baseUrl: Environments.getUrl(),
      connectTimeout: const Duration(seconds: _connectTimeout),
      receiveTimeout: const Duration(seconds: _receiveTimeout),
      sendTimeout: const Duration(seconds: _sendTimeout),
    ),
  );
  final List<String> whiteAuthList;
  final void Function(RequestOptions, RequestInterceptorHandler)? onRequest;
  final void Function(Response<dynamic>, ResponseInterceptorHandler)? onResponse;
  final void Function(DioException, ErrorInterceptorHandler)? onError;
  final Future<String> accessToken;
  var options = Options(contentType: Headers.jsonContentType, responseType: ResponseType.json);

  _DioHelper._({
    required this.whiteAuthList,
    required this.accessToken,
    this.onRequest,
    this.onResponse,
    this.onError,
  }) {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        options.headers["Accept-Language"] = AppSP.get(AppSP.languageLocale) ?? 'vi';

        final token = await accessToken;

        if (!Utils.isNullOrEmpty(token) && !noNeedToken(options.path, whiteAuthList)) {
          options.headers['Authorization'] = "Bearer $token";
        }

        if (options.data is FormData) {
          options.contentType = Headers.multipartFormDataContentType;
        }

        logRequest(options);

        if (onRequest != null) {
          return onRequest!(options, handler);
        }

        return handler.next(options);
      },
      onResponse: (response, handler) {
        logResponse(response);

        if (onResponse != null) {
          return onResponse!(response, handler);
        }

        return handler.next(response);
      },
      onError: (e, handler) async {
        if (e.response != null) {
          logResponse(e.response!);
        }

        if (onError != null) {
          return onError!(e, handler);
        }

        return handler.next(e);
      },
    ));
  }

  factory _DioHelper.getInstance({
    required List<String> whiteAuthList,
    void Function(RequestOptions, RequestInterceptorHandler)? onRequest,
    void Function(Response<dynamic>, ResponseInterceptorHandler)? onResponse,
    void Function(DioException, ErrorInterceptorHandler)? onError,
    required Future<String> accessToken,
  }) =>
      _DioHelper._(
        whiteAuthList: whiteAuthList,
        onRequest: onRequest,
        onResponse: onResponse,
        onError: onError,
        accessToken: accessToken,
      );

  Dio get dio => _dio;

  Future<Response> get(
    path, {
    data,
    Options? options,
    Map<String, dynamic>? queryParameters,
  }) async {
    var res = await _dio.get(
      path,
      options: options ?? this.options,
      data: data,
      queryParameters: queryParameters,
    );
    return res;
  }

  Future<Response> post(
    path,
    body, {
    Options? options,
    Map<String, dynamic>? queryParameters,
  }) async {
    var res = await _dio.post(
      path,
      data: body,
      options: options ?? this.options,
      queryParameters: queryParameters,
    );
    return res;
  }
}

class _DioHelperLogin {
  static const int _connectTimeout = 30;
  static const int _receiveTimeout = 30;
  static const int _sendTimeout = 30;

  final _dio = Dio(
    BaseOptions(
      baseUrl: "http://172.31.2.120:8080/",
      connectTimeout: const Duration(seconds: _connectTimeout),
      receiveTimeout: const Duration(seconds: _receiveTimeout),
      sendTimeout: const Duration(seconds: _sendTimeout),
    ),
  );
  final List<String> whiteAuthList;
  final void Function(RequestOptions, RequestInterceptorHandler)? onRequest;
  final void Function(Response<dynamic>, ResponseInterceptorHandler)? onResponse;
  final void Function(DioException, ErrorInterceptorHandler)? onError;
  final Future<String> accessToken;
  var options = Options(contentType: Headers.jsonContentType, responseType: ResponseType.json);

  _DioHelperLogin._({
    required this.whiteAuthList,
    required this.accessToken,
    this.onRequest,
    this.onResponse,
    this.onError,
  }) {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        options.headers["Accept-Language"] = AppSP.get(AppSP.languageLocale) ?? 'vi';

        final token = await accessToken;

        if (!Utils.isNullOrEmpty(token) && !noNeedToken(options.path, whiteAuthList)) {
          options.headers['Authorization'] = "Bearer $token";
        }

        if (options.data is FormData) {
          options.contentType = Headers.multipartFormDataContentType;
        }

        logRequest(options);

        if (onRequest != null) {
          return onRequest!(options, handler);
        }

        return handler.next(options);
      },
      onResponse: (response, handler) {
        logResponse(response);

        if (onResponse != null) {
          return onResponse!(response, handler);
        }

        return handler.next(response);
      },
      onError: (e, handler) async {
        if (e.response != null) {
          logResponse(e.response!);
        }

        if (onError != null) {
          return onError!(e, handler);
        }

        return handler.next(e);
      },
    ));
  }

  factory _DioHelperLogin.getInstance({
    required List<String> whiteAuthList,
    void Function(RequestOptions, RequestInterceptorHandler)? onRequest,
    void Function(Response<dynamic>, ResponseInterceptorHandler)? onResponse,
    void Function(DioException, ErrorInterceptorHandler)? onError,
    required Future<String> accessToken,
  }) =>
      _DioHelperLogin._(
        whiteAuthList: whiteAuthList,
        onRequest: onRequest,
        onResponse: onResponse,
        onError: onError,
        accessToken: accessToken,
      );

  Dio get dio => _dio;

  Future<Response> get(
    path, {
    data,
    Options? options,
    Map<String, dynamic>? queryParameters,
  }) async {
    var res = await _dio.get(
      path,
      options: options ?? this.options,
      data: data,
      queryParameters: queryParameters,
    );
    return res;
  }

  Future<Response> post(
    path,
    body, {
    Options? options,
    Map<String, dynamic>? queryParameters,
  }) async {
    var res = await _dio.post(
      path,
      data: body,
      options: options ?? this.options,
      queryParameters: queryParameters,
    );
    return res;
  }
}

class _DioHelperHrmNoti {
  static const int _connectTimeout = 30;
  static const int _receiveTimeout = 30;
  static const int _sendTimeout = 30;

  final _dio = Dio(
    BaseOptions(
      baseUrl: Environments.getUrlHrmNoti(),
      connectTimeout: const Duration(seconds: _connectTimeout),
      receiveTimeout: const Duration(seconds: _receiveTimeout),
      sendTimeout: const Duration(seconds: _sendTimeout),
    ),
  );
  final List<String> whiteAuthList;
  final void Function(RequestOptions, RequestInterceptorHandler)? onRequest;
  final void Function(Response<dynamic>, ResponseInterceptorHandler)? onResponse;
  final void Function(DioException, ErrorInterceptorHandler)? onError;
  final Future<String> accessToken;
  var options = Options(contentType: Headers.jsonContentType, responseType: ResponseType.json);

  _DioHelperHrmNoti._({
    required this.whiteAuthList,
    required this.accessToken,
    this.onRequest,
    this.onResponse,
    this.onError,
  }) {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        options.headers["Accept-Language"] = AppSP.get(AppSP.languageLocale) ?? 'vi';

        final token = await accessToken;

        if (!Utils.isNullOrEmpty(token) && !noNeedToken(options.path, whiteAuthList)) {
          options.headers['Authorization'] = "Bearer $token";
        }

        if (options.data is FormData) {
          options.contentType = Headers.multipartFormDataContentType;
        }

        logRequest(options);

        if (onRequest != null) {
          return onRequest!(options, handler);
        }

        return handler.next(options);
      },
      onResponse: (response, handler) {
        logResponse(response);

        if (onResponse != null) {
          return onResponse!(response, handler);
        }

        return handler.next(response);
      },
      onError: (e, handler) async {
        if (e.response != null) {
          logResponse(e.response!);
        }

        if (onError != null) {
          return onError!(e, handler);
        }

        return handler.next(e);
      },
    ));
  }

  factory _DioHelperHrmNoti.getInstance({
    required List<String> whiteAuthList,
    void Function(RequestOptions, RequestInterceptorHandler)? onRequest,
    void Function(Response<dynamic>, ResponseInterceptorHandler)? onResponse,
    void Function(DioException, ErrorInterceptorHandler)? onError,
    required Future<String> accessToken,
  }) =>
      _DioHelperHrmNoti._(
        whiteAuthList: whiteAuthList,
        onRequest: onRequest,
        onResponse: onResponse,
        onError: onError,
        accessToken: accessToken,
      );

  Dio get dio => _dio;

  Future<Response> get(
    path, {
    data,
    Options? options,
    Map<String, dynamic>? queryParameters,
  }) async {
    var res = await _dio.get(
      path,
      options: options ?? this.options,
      data: data,
      queryParameters: queryParameters,
    );
    return res;
  }

  Future<Response> post(
    path,
    body, {
    Options? options,
    Map<String, dynamic>? queryParameters,
  }) async {
    var res = await _dio.post(
      path,
      data: body,
      options: options ?? this.options,
      queryParameters: queryParameters,
    );
    return res;
  }
}
