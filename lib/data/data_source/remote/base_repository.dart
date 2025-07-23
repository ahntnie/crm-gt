import 'package:core/core.dart';
import 'package:crm_gt/data/data_source/remote/api_endpoints.dart';
import 'package:crm_gt/data/data_source/remote/error_handler.dart';
import 'package:dio/dio.dart';


class BaseRepository extends AppBaseRepo {
  @override
  Future<String> get accessToken async {
    final tokenData = await AppSecureStorage.getToken();

    return tokenData?.accessToken ?? '';
  }

  @override
  List<String> get whiteAuthList => [ApiEndpoints.login];

  @override
  void onError(DioException e, ErrorInterceptorHandler handler) async {
    if ((e.response?.statusCode == 401) &&
        //e.requestOptions.path != ApiEndpoints.refreshToken &&
        e.requestOptions.path != ApiEndpoints.login) {
      // bool isSuccess = await refreshToken();

      // if (isSuccess) {
      //   return handler.resolve(await dio.fetch(e.requestOptions));
      // }
    }

    final isBlocked = ErrorHandler().loadError(e);

    if (isBlocked) {
      return handler.reject(e);
    }

    super.onError(e, handler);
  }
}
