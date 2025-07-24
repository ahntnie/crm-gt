import 'dart:io';

import 'package:core/core.dart';
import 'package:crm_gt/data/repositories/authentication/login_repo_impl.dart';
import 'package:crm_gt/data/repositories/home/home_repo_impl.dart';
import 'package:crm_gt/data/repositories/message/message_repo_impl.dart';
import 'package:crm_gt/domains/usecases/authentication/login_usecase.dart';
import 'package:crm_gt/domains/usecases/home/home_usecase.dart';
import 'package:crm_gt/domains/usecases/message/message_usecase.dart';
import 'package:device_info_plus/device_info_plus.dart';

final class DependencyInjection {
  static Future<void> init() async {
    await Di().init();
    final deviceInfoPlugin = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final androidDeviceInfo = await deviceInfoPlugin.androidInfo;
      getIt.registerSingleton(androidDeviceInfo);
    }

    if (Platform.isIOS) {
      final iOSDeviceInfo = await deviceInfoPlugin.iosInfo;
      getIt.registerSingleton(iOSDeviceInfo);
    }

    _registerUserCase();
  }

  static _registerUserCase() {
    getIt.registerSingleton(HomeUsecase(HomeRepoImpl()));
    getIt.registerSingleton(MessageUseCase(MessageRepoImpl()));
    getIt.registerSingleton(LoginUsecase(LoginRepoImpl()));
  }
}
