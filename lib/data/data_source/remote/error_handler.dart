import 'package:core/core.dart';
import 'package:crm_gt/features/routes.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';


class ErrorHandler {
  static ErrorHandler? _instance;

  factory ErrorHandler() {
    _instance ??= ErrorHandler._internal();
    return _instance!;
  }

  ErrorHandler._internal();

  bool loadError(DioException error) {
    WidgetUtils.dismissLoading();
    final context = AppNavigator.context;
    final t = Utils.languageOf(context);

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
       // showErrorDialog(title: t.connection_timeout);
        break;
      case DioExceptionType.badResponse:
        String msg = t.something_went_wrong;

        if (error.response?.statusCode == 502) {
         // showErrorDialog(title: msg);
          Log.e('Bad response from API server');
          break;
        }

        if (error.response?.data is String && !Utils.isNullOrEmpty(error.response?.data)) {
          msg = error.response?.data;
        }

        if (!Utils.isNullOrEmpty(error.response?.data['message'])) {
          msg = error.response?.data['message'];
        }

        // showErrorDialog(title: msg);
        break;
      case DioExceptionType.cancel:
        Log.e('Request to API server was cancelled');
        break;
      case DioExceptionType.connectionError:
        // showErrorDialog(
        //   title: t.connection_lost_desc,
        //   headerTitle: t.you_are_offline,
        //   errorImage: Padding(
        //     padding: const EdgeInsets.only(top: 22),
        //     child: AppSvg.icConnection(),
        //   ),
        // );
        return true;
      default:
        // showErrorDialog(title: t.something_went_wrong);
        break;
    }

    return false;
  }
}

final class ErrorType {
  ErrorType._();

  static const String accessDenied = "ACCESS_DENIED";
}
