import 'dart:ui';

import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> with SuperAppConn {
  AppCubit() : super(AppInitial());

  // Future getLanguage() async {
  //   var languageLocal = await AppSP.get(AppSP.languageLocale);
  //   if (!Utils.isNullOrEmpty(languageLocal)) {
  //     emit(state.copyWith(locale: Locale(languageLocal)));
  //     onChangeLanguage(Locale(languageLocal));
  //   } else {
  //     onChangeLanguage(LanguageType.vietnamese.locale);
  //   }
  // }

  // void init(BuildContext context) async {
  //   await getLanguage();
  //   //WidgetUtils.configLoading(AppImage.icLogo(size: 100));
  // }

  // void changeThemeMode(AppThemeMode themeMode) {
  //   emit(state.copyWith(themeMode: themeMode));
  // }

  // void switchThemeMode() {
  //   if (state.themeMode == AppThemeMode.light) {
  //     emit(state.copyWith(
  //       themeMode: AppThemeMode.dark,
  //       theme: const AppTheme(AppThemeMode.dark),
  //     ));
  //   } else {
  //     emit(state.copyWith(
  //       themeMode: AppThemeMode.light,
  //       theme: const AppTheme(AppThemeMode.light),
  //     ));
  //   }
  // }

  // void changeUserInfo(UserInformationEntity userInfo) {
  //   emit(state.copyWith(userInfo: userInfo));
  // }

  // Future<void> requestCountUnread() async {
  //   int countUnread = await _notiUseCase.requestCountUnread();
  //   emit(state.copyWith(unReadNoti: countUnread));
  // }

  // /// Change Language
  // Future<void> onChangeLanguage(Locale? lang) async {
  //   await AppSP.remove(AppSP.languageLocale);
  //   await AppSP.set(AppSP.languageLocale, lang?.languageCode);
  //   AppSession().setLanguage(lang?.languageCode ?? 'vi');
  //   switchThemeMode();
  //   emit(state.copyWith(locale: lang));
  // }

  @override
  onEvent(MiniAppEvent event, [data]) async {
    switch (event) {
      default:
    }
  }
}
