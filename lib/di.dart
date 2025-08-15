import 'dart:io';

import 'package:core/core.dart';
import 'package:crm_gt/data/repositories/attachments/attachment_repo_impl.dart';
import 'package:crm_gt/data/repositories/authentication/login_repo_impl.dart';
import 'package:crm_gt/data/repositories/authentication/logout_repo_impl.dart';
import 'package:crm_gt/data/repositories/authentication/profile_repo_impl.dart';
import 'package:crm_gt/data/repositories/home/home_repo_impl.dart';
import 'package:crm_gt/data/repositories/messege/messege_repo_impl.dart';
import 'package:crm_gt/data/repositories/notifications/notifications_repo_impl.dart';
import 'package:crm_gt/data/repositories/progress/progress_repo_impl.dart';
import 'package:crm_gt/domains/repositories/authentication/login_repo.dart';
import 'package:crm_gt/domains/usecases/attachments/attachments_usecase.dart';
import 'package:crm_gt/domains/usecases/authentication/login_usecase.dart';
import 'package:crm_gt/domains/usecases/authentication/logout_usecase.dart';
import 'package:crm_gt/domains/usecases/authentication/profile_usecase.dart';
import 'package:crm_gt/domains/usecases/home/home_usecase.dart';
import 'package:crm_gt/domains/usecases/messege/messege_usecase.dart';
import 'package:crm_gt/domains/usecases/notifications/notification_usecase.dart';
import 'package:crm_gt/domains/usecases/progress/progress_usecase.dart';
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

    _registerRepositories();
    _registerUserCase();
  }

  static void _registerRepositories() {
    getIt.registerLazySingleton<LoginRepo>(() => LoginRepoImpl());
    getIt.registerLazySingleton(() => HomeRepoImpl());
    getIt.registerLazySingleton(() => MessegeRepoImpl());
    getIt.registerLazySingleton(() => LogoutRepoImpl());
    getIt.registerLazySingleton(() => NotificationsRepoIml());
    getIt.registerLazySingleton(() => ProfileRepoImpl());
    getIt.registerLazySingleton(() => AttachMentRepoImpl());
    getIt.registerLazySingleton(() => ProgressRepoImpl());
  }

  static void _registerUserCase() {
    getIt.registerSingleton(HomeUsecase(getIt<HomeRepoImpl>()));
    getIt.registerSingleton(MessegeUseCase(getIt<MessegeRepoImpl>()));
    getIt.registerSingleton(LoginUsecase(getIt<LoginRepo>()));
    getIt.registerSingleton(LogoutUsecase(getIt<LogoutRepoImpl>()));
    getIt.registerSingleton(NotificationsUsecase(getIt<NotificationsRepoIml>()));
    getIt.registerSingleton(ProfileUsecase(getIt<ProfileRepoImpl>()));
    getIt.registerSingleton(AttachmentsUsecase(getIt<AttachMentRepoImpl>()));
    getIt.registerSingleton(ProgressUsecase(getIt<ProgressRepoImpl>()));
  }
}
