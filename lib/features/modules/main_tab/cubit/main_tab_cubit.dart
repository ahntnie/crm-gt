import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';


part 'main_tab_state.dart';

class MainTabCubit extends Cubit<MainTabState> {
  MainTabCubit() : super(MainTabInitial());

  //final notiUseCase = getIt.get<NotificationUseCase>();

  Future<void> getInit({required BuildContext context}) async {
    // final token = await FirebaseMessaging.instance.getToken();
    // final dataNoti = await notiUseCase.requestRegisterTokenFireBase(token);
    // final notiCount = await notiUseCase.requestCountUnread();
    // emit(state.copyWith(
    //     deviceId: dataNoti.deviceId,
    //     deviceToken: dataNoti.deviceToken,
    //     userId: dataNoti.userId,
    //     notiUnRead: notiCount.toString()));
  }

  void changeIndex(int index) {
    emit(state.copyWith(currentIndex: index, isActiveFAB: false));
  }

  void switchAdd() {
    emit(state.copyWith(isActiveFAB: true, currentIndex: 4));
  }

  void changeCount(int count) {
    emit(state.copyWith(notiUnRead: count.toString()));
  }
}
